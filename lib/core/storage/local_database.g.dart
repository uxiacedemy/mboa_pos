// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceXAFMeta =
      const VerificationMeta('priceXAF');
  @override
  late final GeneratedColumn<int> priceXAF = GeneratedColumn<int>(
      'price_x_a_f', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stockQtyMeta =
      const VerificationMeta('stockQty');
  @override
  late final GeneratedColumn<int> stockQty = GeneratedColumn<int>(
      'stock_qty', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        organizationId,
        productId,
        name,
        nameEn,
        priceXAF,
        category,
        stockQty,
        barcode,
        imageUrl
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(Insertable<CachedProduct> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('price_x_a_f')) {
      context.handle(_priceXAFMeta,
          priceXAF.isAcceptableOrUnknown(data['price_x_a_f']!, _priceXAFMeta));
    } else if (isInserting) {
      context.missing(_priceXAFMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('stock_qty')) {
      context.handle(_stockQtyMeta,
          stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta));
    } else if (isInserting) {
      context.missing(_stockQtyMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {organizationId, productId};
  @override
  CachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProduct(
      organizationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      priceXAF: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}price_x_a_f'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      stockQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_qty'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProduct extends DataClass implements Insertable<CachedProduct> {
  final String organizationId;
  final String productId;
  final String name;
  final String nameEn;
  final int priceXAF;
  final String category;
  final int stockQty;
  final String? barcode;
  final String? imageUrl;
  const CachedProduct(
      {required this.organizationId,
      required this.productId,
      required this.name,
      required this.nameEn,
      required this.priceXAF,
      required this.category,
      required this.stockQty,
      this.barcode,
      this.imageUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['organization_id'] = Variable<String>(organizationId);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    map['name_en'] = Variable<String>(nameEn);
    map['price_x_a_f'] = Variable<int>(priceXAF);
    map['category'] = Variable<String>(category);
    map['stock_qty'] = Variable<int>(stockQty);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      organizationId: Value(organizationId),
      productId: Value(productId),
      name: Value(name),
      nameEn: Value(nameEn),
      priceXAF: Value(priceXAF),
      category: Value(category),
      stockQty: Value(stockQty),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
    );
  }

  factory CachedProduct.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProduct(
      organizationId: serializer.fromJson<String>(json['organizationId']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      priceXAF: serializer.fromJson<int>(json['priceXAF']),
      category: serializer.fromJson<String>(json['category']),
      stockQty: serializer.fromJson<int>(json['stockQty']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'organizationId': serializer.toJson<String>(organizationId),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String>(nameEn),
      'priceXAF': serializer.toJson<int>(priceXAF),
      'category': serializer.toJson<String>(category),
      'stockQty': serializer.toJson<int>(stockQty),
      'barcode': serializer.toJson<String?>(barcode),
      'imageUrl': serializer.toJson<String?>(imageUrl),
    };
  }

  CachedProduct copyWith(
          {String? organizationId,
          String? productId,
          String? name,
          String? nameEn,
          int? priceXAF,
          String? category,
          int? stockQty,
          Value<String?> barcode = const Value.absent(),
          Value<String?> imageUrl = const Value.absent()}) =>
      CachedProduct(
        organizationId: organizationId ?? this.organizationId,
        productId: productId ?? this.productId,
        name: name ?? this.name,
        nameEn: nameEn ?? this.nameEn,
        priceXAF: priceXAF ?? this.priceXAF,
        category: category ?? this.category,
        stockQty: stockQty ?? this.stockQty,
        barcode: barcode.present ? barcode.value : this.barcode,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
      );
  CachedProduct copyWithCompanion(CachedProductsCompanion data) {
    return CachedProduct(
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      priceXAF: data.priceXAF.present ? data.priceXAF.value : this.priceXAF,
      category: data.category.present ? data.category.value : this.category,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProduct(')
          ..write('organizationId: $organizationId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('priceXAF: $priceXAF, ')
          ..write('category: $category, ')
          ..write('stockQty: $stockQty, ')
          ..write('barcode: $barcode, ')
          ..write('imageUrl: $imageUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(organizationId, productId, name, nameEn,
      priceXAF, category, stockQty, barcode, imageUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProduct &&
          other.organizationId == this.organizationId &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.priceXAF == this.priceXAF &&
          other.category == this.category &&
          other.stockQty == this.stockQty &&
          other.barcode == this.barcode &&
          other.imageUrl == this.imageUrl);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProduct> {
  final Value<String> organizationId;
  final Value<String> productId;
  final Value<String> name;
  final Value<String> nameEn;
  final Value<int> priceXAF;
  final Value<String> category;
  final Value<int> stockQty;
  final Value<String?> barcode;
  final Value<String?> imageUrl;
  final Value<int> rowid;
  const CachedProductsCompanion({
    this.organizationId = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.priceXAF = const Value.absent(),
    this.category = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.barcode = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    required String organizationId,
    required String productId,
    required String name,
    required String nameEn,
    required int priceXAF,
    required String category,
    required int stockQty,
    this.barcode = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : organizationId = Value(organizationId),
        productId = Value(productId),
        name = Value(name),
        nameEn = Value(nameEn),
        priceXAF = Value(priceXAF),
        category = Value(category),
        stockQty = Value(stockQty);
  static Insertable<CachedProduct> custom({
    Expression<String>? organizationId,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<int>? priceXAF,
    Expression<String>? category,
    Expression<int>? stockQty,
    Expression<String>? barcode,
    Expression<String>? imageUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (organizationId != null) 'organization_id': organizationId,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (priceXAF != null) 'price_x_a_f': priceXAF,
      if (category != null) 'category': category,
      if (stockQty != null) 'stock_qty': stockQty,
      if (barcode != null) 'barcode': barcode,
      if (imageUrl != null) 'image_url': imageUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedProductsCompanion copyWith(
      {Value<String>? organizationId,
      Value<String>? productId,
      Value<String>? name,
      Value<String>? nameEn,
      Value<int>? priceXAF,
      Value<String>? category,
      Value<int>? stockQty,
      Value<String?>? barcode,
      Value<String?>? imageUrl,
      Value<int>? rowid}) {
    return CachedProductsCompanion(
      organizationId: organizationId ?? this.organizationId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      priceXAF: priceXAF ?? this.priceXAF,
      category: category ?? this.category,
      stockQty: stockQty ?? this.stockQty,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (priceXAF.present) {
      map['price_x_a_f'] = Variable<int>(priceXAF.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<int>(stockQty.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('organizationId: $organizationId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('priceXAF: $priceXAF, ')
          ..write('category: $category, ')
          ..write('stockQty: $stockQty, ')
          ..write('barcode: $barcode, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckoutOutboxTable extends CheckoutOutbox
    with TableInfo<$CheckoutOutboxTable, CheckoutOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckoutOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _checkoutIdMeta =
      const VerificationMeta('checkoutId');
  @override
  late final GeneratedColumn<String> checkoutId = GeneratedColumn<String>(
      'checkout_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorIdMeta =
      const VerificationMeta('actorId');
  @override
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
      'actor_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requestFingerprintMeta =
      const VerificationMeta('requestFingerprint');
  @override
  late final GeneratedColumn<String> requestFingerprint =
      GeneratedColumn<String>('request_fingerprint', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _queuedAtMillisMeta =
      const VerificationMeta('queuedAtMillis');
  @override
  late final GeneratedColumn<int> queuedAtMillis = GeneratedColumn<int>(
      'queued_at_millis', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        checkoutId,
        organizationId,
        actorId,
        deviceId,
        requestFingerprint,
        payloadJson,
        queuedAtMillis,
        status,
        lastError
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checkout_outbox';
  @override
  VerificationContext validateIntegrity(Insertable<CheckoutOutboxData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('checkout_id')) {
      context.handle(
          _checkoutIdMeta,
          checkoutId.isAcceptableOrUnknown(
              data['checkout_id']!, _checkoutIdMeta));
    } else if (isInserting) {
      context.missing(_checkoutIdMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('actor_id')) {
      context.handle(_actorIdMeta,
          actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta));
    } else if (isInserting) {
      context.missing(_actorIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('request_fingerprint')) {
      context.handle(
          _requestFingerprintMeta,
          requestFingerprint.isAcceptableOrUnknown(
              data['request_fingerprint']!, _requestFingerprintMeta));
    } else if (isInserting) {
      context.missing(_requestFingerprintMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('queued_at_millis')) {
      context.handle(
          _queuedAtMillisMeta,
          queuedAtMillis.isAcceptableOrUnknown(
              data['queued_at_millis']!, _queuedAtMillisMeta));
    } else if (isInserting) {
      context.missing(_queuedAtMillisMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {checkoutId};
  @override
  CheckoutOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckoutOutboxData(
      checkoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checkout_id'])!,
      organizationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_id'])!,
      actorId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      requestFingerprint: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}request_fingerprint'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      queuedAtMillis: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}queued_at_millis'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
    );
  }

  @override
  $CheckoutOutboxTable createAlias(String alias) {
    return $CheckoutOutboxTable(attachedDatabase, alias);
  }
}

class CheckoutOutboxData extends DataClass
    implements Insertable<CheckoutOutboxData> {
  final String checkoutId;
  final String organizationId;
  final String actorId;
  final String deviceId;
  final String requestFingerprint;
  final String payloadJson;
  final int queuedAtMillis;
  final String status;
  final String? lastError;
  const CheckoutOutboxData(
      {required this.checkoutId,
      required this.organizationId,
      required this.actorId,
      required this.deviceId,
      required this.requestFingerprint,
      required this.payloadJson,
      required this.queuedAtMillis,
      required this.status,
      this.lastError});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['checkout_id'] = Variable<String>(checkoutId);
    map['organization_id'] = Variable<String>(organizationId);
    map['actor_id'] = Variable<String>(actorId);
    map['device_id'] = Variable<String>(deviceId);
    map['request_fingerprint'] = Variable<String>(requestFingerprint);
    map['payload_json'] = Variable<String>(payloadJson);
    map['queued_at_millis'] = Variable<int>(queuedAtMillis);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  CheckoutOutboxCompanion toCompanion(bool nullToAbsent) {
    return CheckoutOutboxCompanion(
      checkoutId: Value(checkoutId),
      organizationId: Value(organizationId),
      actorId: Value(actorId),
      deviceId: Value(deviceId),
      requestFingerprint: Value(requestFingerprint),
      payloadJson: Value(payloadJson),
      queuedAtMillis: Value(queuedAtMillis),
      status: Value(status),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory CheckoutOutboxData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckoutOutboxData(
      checkoutId: serializer.fromJson<String>(json['checkoutId']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      actorId: serializer.fromJson<String>(json['actorId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      requestFingerprint:
          serializer.fromJson<String>(json['requestFingerprint']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      queuedAtMillis: serializer.fromJson<int>(json['queuedAtMillis']),
      status: serializer.fromJson<String>(json['status']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'checkoutId': serializer.toJson<String>(checkoutId),
      'organizationId': serializer.toJson<String>(organizationId),
      'actorId': serializer.toJson<String>(actorId),
      'deviceId': serializer.toJson<String>(deviceId),
      'requestFingerprint': serializer.toJson<String>(requestFingerprint),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'queuedAtMillis': serializer.toJson<int>(queuedAtMillis),
      'status': serializer.toJson<String>(status),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  CheckoutOutboxData copyWith(
          {String? checkoutId,
          String? organizationId,
          String? actorId,
          String? deviceId,
          String? requestFingerprint,
          String? payloadJson,
          int? queuedAtMillis,
          String? status,
          Value<String?> lastError = const Value.absent()}) =>
      CheckoutOutboxData(
        checkoutId: checkoutId ?? this.checkoutId,
        organizationId: organizationId ?? this.organizationId,
        actorId: actorId ?? this.actorId,
        deviceId: deviceId ?? this.deviceId,
        requestFingerprint: requestFingerprint ?? this.requestFingerprint,
        payloadJson: payloadJson ?? this.payloadJson,
        queuedAtMillis: queuedAtMillis ?? this.queuedAtMillis,
        status: status ?? this.status,
        lastError: lastError.present ? lastError.value : this.lastError,
      );
  CheckoutOutboxData copyWithCompanion(CheckoutOutboxCompanion data) {
    return CheckoutOutboxData(
      checkoutId:
          data.checkoutId.present ? data.checkoutId.value : this.checkoutId,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      requestFingerprint: data.requestFingerprint.present
          ? data.requestFingerprint.value
          : this.requestFingerprint,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      queuedAtMillis: data.queuedAtMillis.present
          ? data.queuedAtMillis.value
          : this.queuedAtMillis,
      status: data.status.present ? data.status.value : this.status,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckoutOutboxData(')
          ..write('checkoutId: $checkoutId, ')
          ..write('organizationId: $organizationId, ')
          ..write('actorId: $actorId, ')
          ..write('deviceId: $deviceId, ')
          ..write('requestFingerprint: $requestFingerprint, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('queuedAtMillis: $queuedAtMillis, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(checkoutId, organizationId, actorId, deviceId,
      requestFingerprint, payloadJson, queuedAtMillis, status, lastError);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckoutOutboxData &&
          other.checkoutId == this.checkoutId &&
          other.organizationId == this.organizationId &&
          other.actorId == this.actorId &&
          other.deviceId == this.deviceId &&
          other.requestFingerprint == this.requestFingerprint &&
          other.payloadJson == this.payloadJson &&
          other.queuedAtMillis == this.queuedAtMillis &&
          other.status == this.status &&
          other.lastError == this.lastError);
}

class CheckoutOutboxCompanion extends UpdateCompanion<CheckoutOutboxData> {
  final Value<String> checkoutId;
  final Value<String> organizationId;
  final Value<String> actorId;
  final Value<String> deviceId;
  final Value<String> requestFingerprint;
  final Value<String> payloadJson;
  final Value<int> queuedAtMillis;
  final Value<String> status;
  final Value<String?> lastError;
  final Value<int> rowid;
  const CheckoutOutboxCompanion({
    this.checkoutId = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.actorId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.requestFingerprint = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.queuedAtMillis = const Value.absent(),
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckoutOutboxCompanion.insert({
    required String checkoutId,
    required String organizationId,
    required String actorId,
    required String deviceId,
    required String requestFingerprint,
    required String payloadJson,
    required int queuedAtMillis,
    this.status = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : checkoutId = Value(checkoutId),
        organizationId = Value(organizationId),
        actorId = Value(actorId),
        deviceId = Value(deviceId),
        requestFingerprint = Value(requestFingerprint),
        payloadJson = Value(payloadJson),
        queuedAtMillis = Value(queuedAtMillis);
  static Insertable<CheckoutOutboxData> custom({
    Expression<String>? checkoutId,
    Expression<String>? organizationId,
    Expression<String>? actorId,
    Expression<String>? deviceId,
    Expression<String>? requestFingerprint,
    Expression<String>? payloadJson,
    Expression<int>? queuedAtMillis,
    Expression<String>? status,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (checkoutId != null) 'checkout_id': checkoutId,
      if (organizationId != null) 'organization_id': organizationId,
      if (actorId != null) 'actor_id': actorId,
      if (deviceId != null) 'device_id': deviceId,
      if (requestFingerprint != null) 'request_fingerprint': requestFingerprint,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (queuedAtMillis != null) 'queued_at_millis': queuedAtMillis,
      if (status != null) 'status': status,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckoutOutboxCompanion copyWith(
      {Value<String>? checkoutId,
      Value<String>? organizationId,
      Value<String>? actorId,
      Value<String>? deviceId,
      Value<String>? requestFingerprint,
      Value<String>? payloadJson,
      Value<int>? queuedAtMillis,
      Value<String>? status,
      Value<String?>? lastError,
      Value<int>? rowid}) {
    return CheckoutOutboxCompanion(
      checkoutId: checkoutId ?? this.checkoutId,
      organizationId: organizationId ?? this.organizationId,
      actorId: actorId ?? this.actorId,
      deviceId: deviceId ?? this.deviceId,
      requestFingerprint: requestFingerprint ?? this.requestFingerprint,
      payloadJson: payloadJson ?? this.payloadJson,
      queuedAtMillis: queuedAtMillis ?? this.queuedAtMillis,
      status: status ?? this.status,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (checkoutId.present) {
      map['checkout_id'] = Variable<String>(checkoutId.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (requestFingerprint.present) {
      map['request_fingerprint'] = Variable<String>(requestFingerprint.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (queuedAtMillis.present) {
      map['queued_at_millis'] = Variable<int>(queuedAtMillis.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckoutOutboxCompanion(')
          ..write('checkoutId: $checkoutId, ')
          ..write('organizationId: $organizationId, ')
          ..write('actorId: $actorId, ')
          ..write('deviceId: $deviceId, ')
          ..write('requestFingerprint: $requestFingerprint, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('queuedAtMillis: $queuedAtMillis, ')
          ..write('status: $status, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalReceiptsTable extends LocalReceipts
    with TableInfo<$LocalReceiptsTable, LocalReceipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _checkoutIdMeta =
      const VerificationMeta('checkoutId');
  @override
  late final GeneratedColumn<String> checkoutId = GeneratedColumn<String>(
      'checkout_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receiptNumberMeta =
      const VerificationMeta('receiptNumber');
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
      'receipt_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receiptJsonMeta =
      const VerificationMeta('receiptJson');
  @override
  late final GeneratedColumn<String> receiptJson = GeneratedColumn<String>(
      'receipt_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [checkoutId, receiptNumber, organizationId, receiptJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_receipts';
  @override
  VerificationContext validateIntegrity(Insertable<LocalReceipt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('checkout_id')) {
      context.handle(
          _checkoutIdMeta,
          checkoutId.isAcceptableOrUnknown(
              data['checkout_id']!, _checkoutIdMeta));
    } else if (isInserting) {
      context.missing(_checkoutIdMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
          _receiptNumberMeta,
          receiptNumber.isAcceptableOrUnknown(
              data['receipt_number']!, _receiptNumberMeta));
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('receipt_json')) {
      context.handle(
          _receiptJsonMeta,
          receiptJson.isAcceptableOrUnknown(
              data['receipt_json']!, _receiptJsonMeta));
    } else if (isInserting) {
      context.missing(_receiptJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {checkoutId};
  @override
  LocalReceipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalReceipt(
      checkoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checkout_id'])!,
      receiptNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_number'])!,
      organizationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_id'])!,
      receiptJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_json'])!,
    );
  }

  @override
  $LocalReceiptsTable createAlias(String alias) {
    return $LocalReceiptsTable(attachedDatabase, alias);
  }
}

class LocalReceipt extends DataClass implements Insertable<LocalReceipt> {
  final String checkoutId;
  final String receiptNumber;
  final String organizationId;
  final String receiptJson;
  const LocalReceipt(
      {required this.checkoutId,
      required this.receiptNumber,
      required this.organizationId,
      required this.receiptJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['checkout_id'] = Variable<String>(checkoutId);
    map['receipt_number'] = Variable<String>(receiptNumber);
    map['organization_id'] = Variable<String>(organizationId);
    map['receipt_json'] = Variable<String>(receiptJson);
    return map;
  }

  LocalReceiptsCompanion toCompanion(bool nullToAbsent) {
    return LocalReceiptsCompanion(
      checkoutId: Value(checkoutId),
      receiptNumber: Value(receiptNumber),
      organizationId: Value(organizationId),
      receiptJson: Value(receiptJson),
    );
  }

  factory LocalReceipt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalReceipt(
      checkoutId: serializer.fromJson<String>(json['checkoutId']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      receiptJson: serializer.fromJson<String>(json['receiptJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'checkoutId': serializer.toJson<String>(checkoutId),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'organizationId': serializer.toJson<String>(organizationId),
      'receiptJson': serializer.toJson<String>(receiptJson),
    };
  }

  LocalReceipt copyWith(
          {String? checkoutId,
          String? receiptNumber,
          String? organizationId,
          String? receiptJson}) =>
      LocalReceipt(
        checkoutId: checkoutId ?? this.checkoutId,
        receiptNumber: receiptNumber ?? this.receiptNumber,
        organizationId: organizationId ?? this.organizationId,
        receiptJson: receiptJson ?? this.receiptJson,
      );
  LocalReceipt copyWithCompanion(LocalReceiptsCompanion data) {
    return LocalReceipt(
      checkoutId:
          data.checkoutId.present ? data.checkoutId.value : this.checkoutId,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      receiptJson:
          data.receiptJson.present ? data.receiptJson.value : this.receiptJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalReceipt(')
          ..write('checkoutId: $checkoutId, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('organizationId: $organizationId, ')
          ..write('receiptJson: $receiptJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(checkoutId, receiptNumber, organizationId, receiptJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalReceipt &&
          other.checkoutId == this.checkoutId &&
          other.receiptNumber == this.receiptNumber &&
          other.organizationId == this.organizationId &&
          other.receiptJson == this.receiptJson);
}

class LocalReceiptsCompanion extends UpdateCompanion<LocalReceipt> {
  final Value<String> checkoutId;
  final Value<String> receiptNumber;
  final Value<String> organizationId;
  final Value<String> receiptJson;
  final Value<int> rowid;
  const LocalReceiptsCompanion({
    this.checkoutId = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.receiptJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalReceiptsCompanion.insert({
    required String checkoutId,
    required String receiptNumber,
    required String organizationId,
    required String receiptJson,
    this.rowid = const Value.absent(),
  })  : checkoutId = Value(checkoutId),
        receiptNumber = Value(receiptNumber),
        organizationId = Value(organizationId),
        receiptJson = Value(receiptJson);
  static Insertable<LocalReceipt> custom({
    Expression<String>? checkoutId,
    Expression<String>? receiptNumber,
    Expression<String>? organizationId,
    Expression<String>? receiptJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (checkoutId != null) 'checkout_id': checkoutId,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (organizationId != null) 'organization_id': organizationId,
      if (receiptJson != null) 'receipt_json': receiptJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalReceiptsCompanion copyWith(
      {Value<String>? checkoutId,
      Value<String>? receiptNumber,
      Value<String>? organizationId,
      Value<String>? receiptJson,
      Value<int>? rowid}) {
    return LocalReceiptsCompanion(
      checkoutId: checkoutId ?? this.checkoutId,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      organizationId: organizationId ?? this.organizationId,
      receiptJson: receiptJson ?? this.receiptJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (checkoutId.present) {
      map['checkout_id'] = Variable<String>(checkoutId.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (receiptJson.present) {
      map['receipt_json'] = Variable<String>(receiptJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalReceiptsCompanion(')
          ..write('checkoutId: $checkoutId, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('organizationId: $organizationId, ')
          ..write('receiptJson: $receiptJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalStockMovementsTable extends LocalStockMovements
    with TableInfo<$LocalStockMovementsTable, LocalStockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _movementIdMeta =
      const VerificationMeta('movementId');
  @override
  late final GeneratedColumn<String> movementId = GeneratedColumn<String>(
      'movement_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _movementJsonMeta =
      const VerificationMeta('movementJson');
  @override
  late final GeneratedColumn<String> movementJson = GeneratedColumn<String>(
      'movement_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  @override
  List<GeneratedColumn> get $columns =>
      [movementId, organizationId, movementJson, syncStatus];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_stock_movements';
  @override
  VerificationContext validateIntegrity(Insertable<LocalStockMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('movement_id')) {
      context.handle(
          _movementIdMeta,
          movementId.isAcceptableOrUnknown(
              data['movement_id']!, _movementIdMeta));
    } else if (isInserting) {
      context.missing(_movementIdMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    }
    if (data.containsKey('movement_json')) {
      context.handle(
          _movementJsonMeta,
          movementJson.isAcceptableOrUnknown(
              data['movement_json']!, _movementJsonMeta));
    } else if (isInserting) {
      context.missing(_movementJsonMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movementId};
  @override
  LocalStockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStockMovement(
      movementId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}movement_id'])!,
      organizationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}organization_id']),
      movementJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}movement_json'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
    );
  }

  @override
  $LocalStockMovementsTable createAlias(String alias) {
    return $LocalStockMovementsTable(attachedDatabase, alias);
  }
}

class LocalStockMovement extends DataClass
    implements Insertable<LocalStockMovement> {
  final String movementId;
  final String? organizationId;
  final String movementJson;
  final String syncStatus;
  const LocalStockMovement(
      {required this.movementId,
      this.organizationId,
      required this.movementJson,
      required this.syncStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['movement_id'] = Variable<String>(movementId);
    if (!nullToAbsent || organizationId != null) {
      map['organization_id'] = Variable<String>(organizationId);
    }
    map['movement_json'] = Variable<String>(movementJson);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  LocalStockMovementsCompanion toCompanion(bool nullToAbsent) {
    return LocalStockMovementsCompanion(
      movementId: Value(movementId),
      organizationId: organizationId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationId),
      movementJson: Value(movementJson),
      syncStatus: Value(syncStatus),
    );
  }

  factory LocalStockMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStockMovement(
      movementId: serializer.fromJson<String>(json['movementId']),
      organizationId: serializer.fromJson<String?>(json['organizationId']),
      movementJson: serializer.fromJson<String>(json['movementJson']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'movementId': serializer.toJson<String>(movementId),
      'organizationId': serializer.toJson<String?>(organizationId),
      'movementJson': serializer.toJson<String>(movementJson),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  LocalStockMovement copyWith(
          {String? movementId,
          Value<String?> organizationId = const Value.absent(),
          String? movementJson,
          String? syncStatus}) =>
      LocalStockMovement(
        movementId: movementId ?? this.movementId,
        organizationId:
            organizationId.present ? organizationId.value : this.organizationId,
        movementJson: movementJson ?? this.movementJson,
        syncStatus: syncStatus ?? this.syncStatus,
      );
  LocalStockMovement copyWithCompanion(LocalStockMovementsCompanion data) {
    return LocalStockMovement(
      movementId:
          data.movementId.present ? data.movementId.value : this.movementId,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      movementJson: data.movementJson.present
          ? data.movementJson.value
          : this.movementJson,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalStockMovement(')
          ..write('movementId: $movementId, ')
          ..write('organizationId: $organizationId, ')
          ..write('movementJson: $movementJson, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(movementId, organizationId, movementJson, syncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStockMovement &&
          other.movementId == this.movementId &&
          other.organizationId == this.organizationId &&
          other.movementJson == this.movementJson &&
          other.syncStatus == this.syncStatus);
}

class LocalStockMovementsCompanion extends UpdateCompanion<LocalStockMovement> {
  final Value<String> movementId;
  final Value<String?> organizationId;
  final Value<String> movementJson;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const LocalStockMovementsCompanion({
    this.movementId = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.movementJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStockMovementsCompanion.insert({
    required String movementId,
    this.organizationId = const Value.absent(),
    required String movementJson,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : movementId = Value(movementId),
        movementJson = Value(movementJson);
  static Insertable<LocalStockMovement> custom({
    Expression<String>? movementId,
    Expression<String>? organizationId,
    Expression<String>? movementJson,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (movementId != null) 'movement_id': movementId,
      if (organizationId != null) 'organization_id': organizationId,
      if (movementJson != null) 'movement_json': movementJson,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStockMovementsCompanion copyWith(
      {Value<String>? movementId,
      Value<String?>? organizationId,
      Value<String>? movementJson,
      Value<String>? syncStatus,
      Value<int>? rowid}) {
    return LocalStockMovementsCompanion(
      movementId: movementId ?? this.movementId,
      organizationId: organizationId ?? this.organizationId,
      movementJson: movementJson ?? this.movementJson,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (movementId.present) {
      map['movement_id'] = Variable<String>(movementId.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (movementJson.present) {
      map['movement_json'] = Variable<String>(movementJson.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStockMovementsCompanion(')
          ..write('movementId: $movementId, ')
          ..write('organizationId: $organizationId, ')
          ..write('movementJson: $movementJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedOrganizationSettingsTable extends CachedOrganizationSettings
    with
        TableInfo<$CachedOrganizationSettingsTable, CachedOrganizationSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedOrganizationSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _settingsJsonMeta =
      const VerificationMeta('settingsJson');
  @override
  late final GeneratedColumn<String> settingsJson = GeneratedColumn<String>(
      'settings_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [organizationId, settingsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_organization_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<CachedOrganizationSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('settings_json')) {
      context.handle(
          _settingsJsonMeta,
          settingsJson.isAcceptableOrUnknown(
              data['settings_json']!, _settingsJsonMeta));
    } else if (isInserting) {
      context.missing(_settingsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {organizationId};
  @override
  CachedOrganizationSetting map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedOrganizationSetting(
      organizationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_id'])!,
      settingsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}settings_json'])!,
    );
  }

  @override
  $CachedOrganizationSettingsTable createAlias(String alias) {
    return $CachedOrganizationSettingsTable(attachedDatabase, alias);
  }
}

class CachedOrganizationSetting extends DataClass
    implements Insertable<CachedOrganizationSetting> {
  final String organizationId;
  final String settingsJson;
  const CachedOrganizationSetting(
      {required this.organizationId, required this.settingsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['organization_id'] = Variable<String>(organizationId);
    map['settings_json'] = Variable<String>(settingsJson);
    return map;
  }

  CachedOrganizationSettingsCompanion toCompanion(bool nullToAbsent) {
    return CachedOrganizationSettingsCompanion(
      organizationId: Value(organizationId),
      settingsJson: Value(settingsJson),
    );
  }

  factory CachedOrganizationSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedOrganizationSetting(
      organizationId: serializer.fromJson<String>(json['organizationId']),
      settingsJson: serializer.fromJson<String>(json['settingsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'organizationId': serializer.toJson<String>(organizationId),
      'settingsJson': serializer.toJson<String>(settingsJson),
    };
  }

  CachedOrganizationSetting copyWith(
          {String? organizationId, String? settingsJson}) =>
      CachedOrganizationSetting(
        organizationId: organizationId ?? this.organizationId,
        settingsJson: settingsJson ?? this.settingsJson,
      );
  CachedOrganizationSetting copyWithCompanion(
      CachedOrganizationSettingsCompanion data) {
    return CachedOrganizationSetting(
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      settingsJson: data.settingsJson.present
          ? data.settingsJson.value
          : this.settingsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedOrganizationSetting(')
          ..write('organizationId: $organizationId, ')
          ..write('settingsJson: $settingsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(organizationId, settingsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedOrganizationSetting &&
          other.organizationId == this.organizationId &&
          other.settingsJson == this.settingsJson);
}

class CachedOrganizationSettingsCompanion
    extends UpdateCompanion<CachedOrganizationSetting> {
  final Value<String> organizationId;
  final Value<String> settingsJson;
  final Value<int> rowid;
  const CachedOrganizationSettingsCompanion({
    this.organizationId = const Value.absent(),
    this.settingsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedOrganizationSettingsCompanion.insert({
    required String organizationId,
    required String settingsJson,
    this.rowid = const Value.absent(),
  })  : organizationId = Value(organizationId),
        settingsJson = Value(settingsJson);
  static Insertable<CachedOrganizationSetting> custom({
    Expression<String>? organizationId,
    Expression<String>? settingsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (organizationId != null) 'organization_id': organizationId,
      if (settingsJson != null) 'settings_json': settingsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedOrganizationSettingsCompanion copyWith(
      {Value<String>? organizationId,
      Value<String>? settingsJson,
      Value<int>? rowid}) {
    return CachedOrganizationSettingsCompanion(
      organizationId: organizationId ?? this.organizationId,
      settingsJson: settingsJson ?? this.settingsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (settingsJson.present) {
      map['settings_json'] = Variable<String>(settingsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedOrganizationSettingsCompanion(')
          ..write('organizationId: $organizationId, ')
          ..write('settingsJson: $settingsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  late final $CheckoutOutboxTable checkoutOutbox = $CheckoutOutboxTable(this);
  late final $LocalReceiptsTable localReceipts = $LocalReceiptsTable(this);
  late final $LocalStockMovementsTable localStockMovements =
      $LocalStockMovementsTable(this);
  late final $CachedOrganizationSettingsTable cachedOrganizationSettings =
      $CachedOrganizationSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        cachedProducts,
        checkoutOutbox,
        localReceipts,
        localStockMovements,
        cachedOrganizationSettings
      ];
}

typedef $$CachedProductsTableCreateCompanionBuilder = CachedProductsCompanion
    Function({
  required String organizationId,
  required String productId,
  required String name,
  required String nameEn,
  required int priceXAF,
  required String category,
  required int stockQty,
  Value<String?> barcode,
  Value<String?> imageUrl,
  Value<int> rowid,
});
typedef $$CachedProductsTableUpdateCompanionBuilder = CachedProductsCompanion
    Function({
  Value<String> organizationId,
  Value<String> productId,
  Value<String> name,
  Value<String> nameEn,
  Value<int> priceXAF,
  Value<String> category,
  Value<int> stockQty,
  Value<String?> barcode,
  Value<String?> imageUrl,
  Value<int> rowid,
});

class $$CachedProductsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priceXAF => $composableBuilder(
      column: $table.priceXAF, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockQty => $composableBuilder(
      column: $table.stockQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priceXAF => $composableBuilder(
      column: $table.priceXAF, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockQty => $composableBuilder(
      column: $table.stockQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<int> get priceXAF =>
      $composableBuilder(column: $table.priceXAF, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);
}

class $$CachedProductsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $CachedProductsTable,
    CachedProduct,
    $$CachedProductsTableFilterComposer,
    $$CachedProductsTableOrderingComposer,
    $$CachedProductsTableAnnotationComposer,
    $$CachedProductsTableCreateCompanionBuilder,
    $$CachedProductsTableUpdateCompanionBuilder,
    (
      CachedProduct,
      BaseReferences<_$LocalDatabase, $CachedProductsTable, CachedProduct>
    ),
    CachedProduct,
    PrefetchHooks Function()> {
  $$CachedProductsTableTableManager(
      _$LocalDatabase db, $CachedProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> organizationId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<int> priceXAF = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> stockQty = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedProductsCompanion(
            organizationId: organizationId,
            productId: productId,
            name: name,
            nameEn: nameEn,
            priceXAF: priceXAF,
            category: category,
            stockQty: stockQty,
            barcode: barcode,
            imageUrl: imageUrl,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String organizationId,
            required String productId,
            required String name,
            required String nameEn,
            required int priceXAF,
            required String category,
            required int stockQty,
            Value<String?> barcode = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedProductsCompanion.insert(
            organizationId: organizationId,
            productId: productId,
            name: name,
            nameEn: nameEn,
            priceXAF: priceXAF,
            category: category,
            stockQty: stockQty,
            barcode: barcode,
            imageUrl: imageUrl,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedProductsTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $CachedProductsTable,
    CachedProduct,
    $$CachedProductsTableFilterComposer,
    $$CachedProductsTableOrderingComposer,
    $$CachedProductsTableAnnotationComposer,
    $$CachedProductsTableCreateCompanionBuilder,
    $$CachedProductsTableUpdateCompanionBuilder,
    (
      CachedProduct,
      BaseReferences<_$LocalDatabase, $CachedProductsTable, CachedProduct>
    ),
    CachedProduct,
    PrefetchHooks Function()>;
typedef $$CheckoutOutboxTableCreateCompanionBuilder = CheckoutOutboxCompanion
    Function({
  required String checkoutId,
  required String organizationId,
  required String actorId,
  required String deviceId,
  required String requestFingerprint,
  required String payloadJson,
  required int queuedAtMillis,
  Value<String> status,
  Value<String?> lastError,
  Value<int> rowid,
});
typedef $$CheckoutOutboxTableUpdateCompanionBuilder = CheckoutOutboxCompanion
    Function({
  Value<String> checkoutId,
  Value<String> organizationId,
  Value<String> actorId,
  Value<String> deviceId,
  Value<String> requestFingerprint,
  Value<String> payloadJson,
  Value<int> queuedAtMillis,
  Value<String> status,
  Value<String?> lastError,
  Value<int> rowid,
});

class $$CheckoutOutboxTableFilterComposer
    extends Composer<_$LocalDatabase, $CheckoutOutboxTable> {
  $$CheckoutOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get checkoutId => $composableBuilder(
      column: $table.checkoutId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actorId => $composableBuilder(
      column: $table.actorId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get requestFingerprint => $composableBuilder(
      column: $table.requestFingerprint,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get queuedAtMillis => $composableBuilder(
      column: $table.queuedAtMillis,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));
}

class $$CheckoutOutboxTableOrderingComposer
    extends Composer<_$LocalDatabase, $CheckoutOutboxTable> {
  $$CheckoutOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get checkoutId => $composableBuilder(
      column: $table.checkoutId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actorId => $composableBuilder(
      column: $table.actorId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get requestFingerprint => $composableBuilder(
      column: $table.requestFingerprint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get queuedAtMillis => $composableBuilder(
      column: $table.queuedAtMillis,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));
}

class $$CheckoutOutboxTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CheckoutOutboxTable> {
  $$CheckoutOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get checkoutId => $composableBuilder(
      column: $table.checkoutId, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get requestFingerprint => $composableBuilder(
      column: $table.requestFingerprint, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<int> get queuedAtMillis => $composableBuilder(
      column: $table.queuedAtMillis, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$CheckoutOutboxTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $CheckoutOutboxTable,
    CheckoutOutboxData,
    $$CheckoutOutboxTableFilterComposer,
    $$CheckoutOutboxTableOrderingComposer,
    $$CheckoutOutboxTableAnnotationComposer,
    $$CheckoutOutboxTableCreateCompanionBuilder,
    $$CheckoutOutboxTableUpdateCompanionBuilder,
    (
      CheckoutOutboxData,
      BaseReferences<_$LocalDatabase, $CheckoutOutboxTable, CheckoutOutboxData>
    ),
    CheckoutOutboxData,
    PrefetchHooks Function()> {
  $$CheckoutOutboxTableTableManager(
      _$LocalDatabase db, $CheckoutOutboxTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckoutOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckoutOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckoutOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> checkoutId = const Value.absent(),
            Value<String> organizationId = const Value.absent(),
            Value<String> actorId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> requestFingerprint = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<int> queuedAtMillis = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CheckoutOutboxCompanion(
            checkoutId: checkoutId,
            organizationId: organizationId,
            actorId: actorId,
            deviceId: deviceId,
            requestFingerprint: requestFingerprint,
            payloadJson: payloadJson,
            queuedAtMillis: queuedAtMillis,
            status: status,
            lastError: lastError,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String checkoutId,
            required String organizationId,
            required String actorId,
            required String deviceId,
            required String requestFingerprint,
            required String payloadJson,
            required int queuedAtMillis,
            Value<String> status = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CheckoutOutboxCompanion.insert(
            checkoutId: checkoutId,
            organizationId: organizationId,
            actorId: actorId,
            deviceId: deviceId,
            requestFingerprint: requestFingerprint,
            payloadJson: payloadJson,
            queuedAtMillis: queuedAtMillis,
            status: status,
            lastError: lastError,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CheckoutOutboxTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $CheckoutOutboxTable,
    CheckoutOutboxData,
    $$CheckoutOutboxTableFilterComposer,
    $$CheckoutOutboxTableOrderingComposer,
    $$CheckoutOutboxTableAnnotationComposer,
    $$CheckoutOutboxTableCreateCompanionBuilder,
    $$CheckoutOutboxTableUpdateCompanionBuilder,
    (
      CheckoutOutboxData,
      BaseReferences<_$LocalDatabase, $CheckoutOutboxTable, CheckoutOutboxData>
    ),
    CheckoutOutboxData,
    PrefetchHooks Function()>;
typedef $$LocalReceiptsTableCreateCompanionBuilder = LocalReceiptsCompanion
    Function({
  required String checkoutId,
  required String receiptNumber,
  required String organizationId,
  required String receiptJson,
  Value<int> rowid,
});
typedef $$LocalReceiptsTableUpdateCompanionBuilder = LocalReceiptsCompanion
    Function({
  Value<String> checkoutId,
  Value<String> receiptNumber,
  Value<String> organizationId,
  Value<String> receiptJson,
  Value<int> rowid,
});

class $$LocalReceiptsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalReceiptsTable> {
  $$LocalReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get checkoutId => $composableBuilder(
      column: $table.checkoutId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptJson => $composableBuilder(
      column: $table.receiptJson, builder: (column) => ColumnFilters(column));
}

class $$LocalReceiptsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalReceiptsTable> {
  $$LocalReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get checkoutId => $composableBuilder(
      column: $table.checkoutId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptJson => $composableBuilder(
      column: $table.receiptJson, builder: (column) => ColumnOrderings(column));
}

class $$LocalReceiptsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalReceiptsTable> {
  $$LocalReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get checkoutId => $composableBuilder(
      column: $table.checkoutId, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get receiptJson => $composableBuilder(
      column: $table.receiptJson, builder: (column) => column);
}

class $$LocalReceiptsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $LocalReceiptsTable,
    LocalReceipt,
    $$LocalReceiptsTableFilterComposer,
    $$LocalReceiptsTableOrderingComposer,
    $$LocalReceiptsTableAnnotationComposer,
    $$LocalReceiptsTableCreateCompanionBuilder,
    $$LocalReceiptsTableUpdateCompanionBuilder,
    (
      LocalReceipt,
      BaseReferences<_$LocalDatabase, $LocalReceiptsTable, LocalReceipt>
    ),
    LocalReceipt,
    PrefetchHooks Function()> {
  $$LocalReceiptsTableTableManager(
      _$LocalDatabase db, $LocalReceiptsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> checkoutId = const Value.absent(),
            Value<String> receiptNumber = const Value.absent(),
            Value<String> organizationId = const Value.absent(),
            Value<String> receiptJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalReceiptsCompanion(
            checkoutId: checkoutId,
            receiptNumber: receiptNumber,
            organizationId: organizationId,
            receiptJson: receiptJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String checkoutId,
            required String receiptNumber,
            required String organizationId,
            required String receiptJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalReceiptsCompanion.insert(
            checkoutId: checkoutId,
            receiptNumber: receiptNumber,
            organizationId: organizationId,
            receiptJson: receiptJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalReceiptsTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $LocalReceiptsTable,
    LocalReceipt,
    $$LocalReceiptsTableFilterComposer,
    $$LocalReceiptsTableOrderingComposer,
    $$LocalReceiptsTableAnnotationComposer,
    $$LocalReceiptsTableCreateCompanionBuilder,
    $$LocalReceiptsTableUpdateCompanionBuilder,
    (
      LocalReceipt,
      BaseReferences<_$LocalDatabase, $LocalReceiptsTable, LocalReceipt>
    ),
    LocalReceipt,
    PrefetchHooks Function()>;
typedef $$LocalStockMovementsTableCreateCompanionBuilder
    = LocalStockMovementsCompanion Function({
  required String movementId,
  Value<String?> organizationId,
  required String movementJson,
  Value<String> syncStatus,
  Value<int> rowid,
});
typedef $$LocalStockMovementsTableUpdateCompanionBuilder
    = LocalStockMovementsCompanion Function({
  Value<String> movementId,
  Value<String?> organizationId,
  Value<String> movementJson,
  Value<String> syncStatus,
  Value<int> rowid,
});

class $$LocalStockMovementsTableFilterComposer
    extends Composer<_$LocalDatabase, $LocalStockMovementsTable> {
  $$LocalStockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get movementId => $composableBuilder(
      column: $table.movementId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get movementJson => $composableBuilder(
      column: $table.movementJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));
}

class $$LocalStockMovementsTableOrderingComposer
    extends Composer<_$LocalDatabase, $LocalStockMovementsTable> {
  $$LocalStockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get movementId => $composableBuilder(
      column: $table.movementId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get movementJson => $composableBuilder(
      column: $table.movementJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));
}

class $$LocalStockMovementsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $LocalStockMovementsTable> {
  $$LocalStockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get movementId => $composableBuilder(
      column: $table.movementId, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get movementJson => $composableBuilder(
      column: $table.movementJson, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);
}

class $$LocalStockMovementsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $LocalStockMovementsTable,
    LocalStockMovement,
    $$LocalStockMovementsTableFilterComposer,
    $$LocalStockMovementsTableOrderingComposer,
    $$LocalStockMovementsTableAnnotationComposer,
    $$LocalStockMovementsTableCreateCompanionBuilder,
    $$LocalStockMovementsTableUpdateCompanionBuilder,
    (
      LocalStockMovement,
      BaseReferences<_$LocalDatabase, $LocalStockMovementsTable,
          LocalStockMovement>
    ),
    LocalStockMovement,
    PrefetchHooks Function()> {
  $$LocalStockMovementsTableTableManager(
      _$LocalDatabase db, $LocalStockMovementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStockMovementsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStockMovementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> movementId = const Value.absent(),
            Value<String?> organizationId = const Value.absent(),
            Value<String> movementJson = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalStockMovementsCompanion(
            movementId: movementId,
            organizationId: organizationId,
            movementJson: movementJson,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String movementId,
            Value<String?> organizationId = const Value.absent(),
            required String movementJson,
            Value<String> syncStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalStockMovementsCompanion.insert(
            movementId: movementId,
            organizationId: organizationId,
            movementJson: movementJson,
            syncStatus: syncStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalStockMovementsTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $LocalStockMovementsTable,
    LocalStockMovement,
    $$LocalStockMovementsTableFilterComposer,
    $$LocalStockMovementsTableOrderingComposer,
    $$LocalStockMovementsTableAnnotationComposer,
    $$LocalStockMovementsTableCreateCompanionBuilder,
    $$LocalStockMovementsTableUpdateCompanionBuilder,
    (
      LocalStockMovement,
      BaseReferences<_$LocalDatabase, $LocalStockMovementsTable,
          LocalStockMovement>
    ),
    LocalStockMovement,
    PrefetchHooks Function()>;
typedef $$CachedOrganizationSettingsTableCreateCompanionBuilder
    = CachedOrganizationSettingsCompanion Function({
  required String organizationId,
  required String settingsJson,
  Value<int> rowid,
});
typedef $$CachedOrganizationSettingsTableUpdateCompanionBuilder
    = CachedOrganizationSettingsCompanion Function({
  Value<String> organizationId,
  Value<String> settingsJson,
  Value<int> rowid,
});

class $$CachedOrganizationSettingsTableFilterComposer
    extends Composer<_$LocalDatabase, $CachedOrganizationSettingsTable> {
  $$CachedOrganizationSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson, builder: (column) => ColumnFilters(column));
}

class $$CachedOrganizationSettingsTableOrderingComposer
    extends Composer<_$LocalDatabase, $CachedOrganizationSettingsTable> {
  $$CachedOrganizationSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson,
      builder: (column) => ColumnOrderings(column));
}

class $$CachedOrganizationSettingsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CachedOrganizationSettingsTable> {
  $$CachedOrganizationSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get settingsJson => $composableBuilder(
      column: $table.settingsJson, builder: (column) => column);
}

class $$CachedOrganizationSettingsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $CachedOrganizationSettingsTable,
    CachedOrganizationSetting,
    $$CachedOrganizationSettingsTableFilterComposer,
    $$CachedOrganizationSettingsTableOrderingComposer,
    $$CachedOrganizationSettingsTableAnnotationComposer,
    $$CachedOrganizationSettingsTableCreateCompanionBuilder,
    $$CachedOrganizationSettingsTableUpdateCompanionBuilder,
    (
      CachedOrganizationSetting,
      BaseReferences<_$LocalDatabase, $CachedOrganizationSettingsTable,
          CachedOrganizationSetting>
    ),
    CachedOrganizationSetting,
    PrefetchHooks Function()> {
  $$CachedOrganizationSettingsTableTableManager(
      _$LocalDatabase db, $CachedOrganizationSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedOrganizationSettingsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedOrganizationSettingsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedOrganizationSettingsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> organizationId = const Value.absent(),
            Value<String> settingsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedOrganizationSettingsCompanion(
            organizationId: organizationId,
            settingsJson: settingsJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String organizationId,
            required String settingsJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedOrganizationSettingsCompanion.insert(
            organizationId: organizationId,
            settingsJson: settingsJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedOrganizationSettingsTableProcessedTableManager
    = ProcessedTableManager<
        _$LocalDatabase,
        $CachedOrganizationSettingsTable,
        CachedOrganizationSetting,
        $$CachedOrganizationSettingsTableFilterComposer,
        $$CachedOrganizationSettingsTableOrderingComposer,
        $$CachedOrganizationSettingsTableAnnotationComposer,
        $$CachedOrganizationSettingsTableCreateCompanionBuilder,
        $$CachedOrganizationSettingsTableUpdateCompanionBuilder,
        (
          CachedOrganizationSetting,
          BaseReferences<_$LocalDatabase, $CachedOrganizationSettingsTable,
              CachedOrganizationSetting>
        ),
        CachedOrganizationSetting,
        PrefetchHooks Function()>;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
  $$CheckoutOutboxTableTableManager get checkoutOutbox =>
      $$CheckoutOutboxTableTableManager(_db, _db.checkoutOutbox);
  $$LocalReceiptsTableTableManager get localReceipts =>
      $$LocalReceiptsTableTableManager(_db, _db.localReceipts);
  $$LocalStockMovementsTableTableManager get localStockMovements =>
      $$LocalStockMovementsTableTableManager(_db, _db.localStockMovements);
  $$CachedOrganizationSettingsTableTableManager
      get cachedOrganizationSettings =>
          $$CachedOrganizationSettingsTableTableManager(
              _db, _db.cachedOrganizationSettings);
}
