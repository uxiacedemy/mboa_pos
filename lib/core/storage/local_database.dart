import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../features/sales/domain/models/product.dart';
import 'local_database_test_connection_native.dart'
    if (dart.library.html) 'local_database_test_connection_web.dart'
    as test_connection;

part 'local_database.g.dart';

class CachedProducts extends Table {
  TextColumn get organizationId => text()();
  TextColumn get productId => text()();
  TextColumn get name => text()();
  TextColumn get nameEn => text()();
  IntColumn get priceXAF => integer()();
  TextColumn get category => text()();
  IntColumn get stockQty => integer()();
  TextColumn get barcode => text().nullable()();
  TextColumn get imageUrl => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {organizationId, productId};
}

class CheckoutOutbox extends Table {
  TextColumn get checkoutId => text()();
  TextColumn get organizationId => text()();
  TextColumn get actorId => text()();
  TextColumn get deviceId => text()();
  TextColumn get requestFingerprint => text()();
  TextColumn get payloadJson => text()();
  IntColumn get queuedAtMillis => integer()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {checkoutId};
}

class LocalReceipts extends Table {
  TextColumn get checkoutId => text()();
  TextColumn get receiptNumber => text()();
  TextColumn get organizationId => text()();
  TextColumn get receiptJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {checkoutId};
}

class LocalStockMovements extends Table {
  TextColumn get movementId => text()();
  TextColumn get organizationId => text().nullable()();
  TextColumn get movementJson => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {movementId};
}

class CachedOrganizationSettings extends Table {
  TextColumn get organizationId => text()();
  TextColumn get settingsJson => text()();

  @override
  Set<Column<Object>> get primaryKey => {organizationId};
}

@DriftDatabase(
  tables: [
    CachedProducts,
    CheckoutOutbox,
    LocalReceipts,
    LocalStockMovements,
    CachedOrganizationSettings,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  LocalDatabase.forTesting() : super(test_connection.openTestingConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Product>> watchProducts(String organizationId) {
    final query = select(cachedProducts)
      ..where((row) => row.organizationId.equals(organizationId))
      ..orderBy([(row) => OrderingTerm.asc(row.name)]);
    return query.watch().map((rows) => rows.map(_toProduct).toList());
  }

  Future<List<Product>> productsFor(String organizationId) async {
    final query = select(cachedProducts)
      ..where((row) => row.organizationId.equals(organizationId))
      ..orderBy([(row) => OrderingTerm.asc(row.name)]);
    return (await query.get()).map(_toProduct).toList();
  }

  Future<void> cacheProducts(
    String organizationId,
    Iterable<Product> products,
  ) async {
    final incomingProducts = products.toList(growable: false);
    await transaction(() async {
      final pendingRows = await (select(checkoutOutbox)
            ..where((row) =>
                row.organizationId.equals(organizationId) &
                row.status.isIn(['pending', 'needsReview'])))
          .get();
      final reservedQuantities = <String, int>{};
      for (final row in pendingRows) {
        final payload = jsonDecode(row.payloadJson);
        if (payload is! Map || payload['lines'] is! List) {
          throw StateError('A pending checkout has invalid line data.');
        }
        for (final line in payload['lines'] as List) {
          if (line is! Map ||
              line['productId'] is! String ||
              line['quantity'] is! int ||
              (line['quantity'] as int) < 1) {
            throw StateError('A pending checkout contains an invalid line.');
          }
          final productId = line['productId'] as String;
          reservedQuantities.update(
            productId,
            (quantity) => quantity + (line['quantity'] as int),
            ifAbsent: () => line['quantity'] as int,
          );
        }
      }

      await (delete(cachedProducts)
            ..where((row) => row.organizationId.equals(organizationId)))
          .go();
      for (final product in incomingProducts) {
        final availableStock =
            (product.stockQty - (reservedQuantities[product.id] ?? 0))
                .clamp(0, product.stockQty)
                .toInt();
        await into(cachedProducts).insertOnConflictUpdate(
          CachedProductsCompanion.insert(
            organizationId: organizationId,
            productId: product.id,
            name: product.name,
            nameEn: product.nameEn,
            priceXAF: product.priceFCFA,
            category: product.category,
            stockQty: availableStock,
            barcode: Value(product.barcode),
            imageUrl: Value(product.imageUrl),
          ),
        );
      }
    });
  }

  Future<void> recordPendingCheckout({
    required String checkoutId,
    required String organizationId,
    required String actorId,
    required String deviceId,
    required String requestFingerprint,
    required Map<String, dynamic> payload,
    required Map<String, dynamic> receipt,
    required List<({String productId, int quantity})> lines,
    required List<Map<String, dynamic>> movements,
    required int queuedAtMillis,
  }) async {
    await transaction(() async {
      final existing = await (select(checkoutOutbox)
            ..where((row) => row.checkoutId.equals(checkoutId)))
          .getSingleOrNull();
      if (existing != null) {
        if (existing.requestFingerprint != requestFingerprint) {
          throw StateError('Checkout key was reused with different sale data.');
        }
        return;
      }

      for (final line in lines) {
        final product = await (select(cachedProducts)
              ..where((row) =>
                  row.organizationId.equals(organizationId) &
                  row.productId.equals(line.productId)))
            .getSingleOrNull();
        if (product == null) {
          throw StateError(
              'Product ${line.productId} is not available offline.');
        }
        if (line.quantity < 1 || product.stockQty < line.quantity) {
          throw StateError(
              'Insufficient locally available stock for ${line.productId}.');
        }
        await (update(cachedProducts)
              ..where((row) =>
                  row.organizationId.equals(organizationId) &
                  row.productId.equals(line.productId)))
            .write(CachedProductsCompanion(
          stockQty: Value(product.stockQty - line.quantity),
        ));
      }

      await into(checkoutOutbox).insert(
        CheckoutOutboxCompanion.insert(
          checkoutId: checkoutId,
          organizationId: organizationId,
          actorId: actorId,
          deviceId: deviceId,
          requestFingerprint: requestFingerprint,
          payloadJson: jsonEncode(payload),
          queuedAtMillis: queuedAtMillis,
        ),
      );
      await _upsertReceipt(checkoutId, organizationId, receipt);
      for (final movement in movements) {
        await _upsertMovement(movement);
      }
    });
  }

  Future<void> enqueuePendingCheckout({
    required String checkoutId,
    required String organizationId,
    required String actorId,
    required String deviceId,
    required String requestFingerprint,
    required Map<String, dynamic> payload,
    required int queuedAtMillis,
  }) async {
    final existing = await (select(checkoutOutbox)
          ..where((row) => row.checkoutId.equals(checkoutId)))
        .getSingleOrNull();
    if (existing != null) {
      if (existing.requestFingerprint != requestFingerprint) {
        throw StateError('Checkout key was reused with different sale data.');
      }
      return;
    }
    await into(checkoutOutbox).insert(
      CheckoutOutboxCompanion.insert(
        checkoutId: checkoutId,
        organizationId: organizationId,
        actorId: actorId,
        deviceId: deviceId,
        requestFingerprint: requestFingerprint,
        payloadJson: jsonEncode(payload),
        queuedAtMillis: queuedAtMillis,
      ),
    );
  }

  Future<List<CheckoutOutboxData>> pendingCheckouts({
    String? organizationId,
    String? actorId,
    String? deviceId,
  }) {
    final query = select(checkoutOutbox)
      ..where((row) {
        var predicate = row.status.equals('pending');
        if (organizationId != null) {
          predicate = predicate &
              row.organizationId.equals(organizationId) &
              row.actorId.equals(actorId ?? '') &
              row.deviceId.equals(deviceId ?? '');
        }
        return predicate;
      })
      ..orderBy([(row) => OrderingTerm.asc(row.queuedAtMillis)]);
    return query.get();
  }

  Future<void> completeCheckout({
    required String checkoutId,
    required String organizationId,
    required Map<String, dynamic> receipt,
    required List<Map<String, dynamic>> movements,
  }) async {
    await transaction(() async {
      await _upsertReceipt(checkoutId, organizationId, receipt);
      for (final movement in movements) {
        await _upsertMovement(movement);
      }
      await (delete(checkoutOutbox)
            ..where((row) => row.checkoutId.equals(checkoutId)))
          .go();
    });
  }

  Future<void> setCheckoutNeedsReview(String checkoutId, String error) =>
      (update(checkoutOutbox)
            ..where((row) => row.checkoutId.equals(checkoutId)))
          .write(CheckoutOutboxCompanion(
        status: const Value('needsReview'),
        lastError: Value(error),
      ));

  Future<void> removePendingCheckout(String checkoutId) =>
      (delete(checkoutOutbox)
            ..where((row) => row.checkoutId.equals(checkoutId)))
          .go();

  Future<void> saveReceipt(
    Map<String, dynamic> receipt, {
    String? checkoutId,
    String? organizationId,
  }) =>
      _upsertReceipt(
        checkoutId ?? receipt['receiptNumber'] as String,
        organizationId ?? receipt['organizationId'] as String? ?? '',
        receipt,
      );

  Future<List<Map<String, dynamic>>> storedReceipts() async {
    final rows = await select(localReceipts).get();
    return rows
        .map((row) => Map<String, dynamic>.from(
              jsonDecode(row.receiptJson) as Map,
            ))
        .toList(growable: false);
  }

  Future<void> saveStockMovements(
    List<Map<String, dynamic>> movements,
  ) async {
    await transaction(() async {
      for (final movement in movements) {
        await _upsertMovement(movement);
      }
    });
  }

  Future<List<Map<String, dynamic>>> stockMovements() async {
    final rows = await select(localStockMovements).get();
    return rows
        .map((row) => Map<String, dynamic>.from(
              jsonDecode(row.movementJson) as Map,
            ))
        .toList(growable: false);
  }

  Future<void> cacheSettings(
    String organizationId,
    Map<String, dynamic> settings,
  ) =>
      into(cachedOrganizationSettings).insertOnConflictUpdate(
        CachedOrganizationSettingsCompanion.insert(
          organizationId: organizationId,
          settingsJson: jsonEncode(settings),
        ),
      );

  Future<Map<String, dynamic>?> cachedSettings(String organizationId) async {
    final row = await (select(cachedOrganizationSettings)
          ..where((item) => item.organizationId.equals(organizationId)))
        .getSingleOrNull();
    if (row == null) return null;
    return Map<String, dynamic>.from(jsonDecode(row.settingsJson) as Map);
  }

  Future<void> _upsertReceipt(
    String checkoutId,
    String organizationId,
    Map<String, dynamic> receipt,
  ) =>
      into(localReceipts).insertOnConflictUpdate(
        LocalReceiptsCompanion.insert(
          checkoutId: checkoutId,
          receiptNumber: receipt['receiptNumber'] as String,
          organizationId: organizationId,
          receiptJson: jsonEncode(receipt),
        ),
      );

  Future<void> _upsertMovement(Map<String, dynamic> movement) =>
      into(localStockMovements).insertOnConflictUpdate(
        LocalStockMovementsCompanion.insert(
          movementId: movement['id'] as String,
          organizationId: Value(movement['organizationId'] as String?),
          movementJson: jsonEncode(movement),
          syncStatus: Value(movement['syncStatus'] as String? ?? 'pending'),
        ),
      );

  Product _toProduct(CachedProduct row) => Product(
        id: row.productId,
        name: row.name,
        nameEn: row.nameEn,
        priceFCFA: row.priceXAF,
        category: row.category,
        stockQty: row.stockQty,
        barcode: row.barcode,
        imageUrl: row.imageUrl,
      );
}

QueryExecutor _openConnection() {
  if (kIsWeb) {
    return driftDatabase(
      name: 'mboa_pos',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
  return driftDatabase(name: 'mboa_pos');
}

final localDatabase = LocalDatabase();
