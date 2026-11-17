import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/local_database.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/product.dart';
import '../../domain/models/cart_item.dart';

enum SyncStatus { synced, pending, offline, conflict }

class SyncStatusNotifier extends Notifier<SyncStatus> {
  @override
  SyncStatus build() => SyncStatus.synced;

  void markPending() => state = SyncStatus.pending;
  void markSynced() => state = SyncStatus.synced;
}

final syncStatusProvider = NotifierProvider<SyncStatusNotifier, SyncStatus>(
  SyncStatusNotifier.new,
);

final catalogProvider =
    AsyncNotifierProvider<CatalogNotifier, CatalogState>(CatalogNotifier.new);

class CatalogState {
  const CatalogState({
    required this.products,
    this.isRefreshing = false,
    this.syncError,
  });

  final List<Product> products;
  final bool isRefreshing;
  final Object? syncError;

  CatalogState copyWith({
    List<Product>? products,
    bool? isRefreshing,
    Object? syncError,
    bool clearError = false,
  }) =>
      CatalogState(
        products: products ?? this.products,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        syncError: clearError ? null : syncError ?? this.syncError,
      );
}

class CatalogNotifier extends AsyncNotifier<CatalogState> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  @override
  Future<CatalogState> build() async {
    ref.onDispose(() => _subscription?.cancel());
    final staff = ref.watch(authProvider).value;
    if (staff == null) return const CatalogState(products: []);

    final organizationId = staff.organizationId;
    final products = await localDatabase.productsFor(organizationId);
    _listenForUpdates(organizationId);
    return CatalogState(products: products);
  }

  Future<void> refresh() async {
    final staff = ref.read(authProvider).value;
    if (staff == null) return;
    final current = state.value ?? const CatalogState(products: []);
    state = AsyncData(current.copyWith(isRefreshing: true, clearError: true));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('organizations/${staff.organizationId}/products')
          .get()
          .timeout(const Duration(seconds: 10));
      await _saveSnapshot(staff.organizationId, snapshot.docs);
      state = AsyncData(CatalogState(
        products: await localDatabase.productsFor(staff.organizationId),
      ));
    } on Object catch (error) {
      state = AsyncData(current.copyWith(
        isRefreshing: false,
        syncError: error,
      ));
    }
  }

  void _listenForUpdates(String organizationId) {
    _subscription = FirebaseFirestore.instance
        .collection('organizations/$organizationId/products')
        .snapshots()
        .listen(
      (snapshot) => unawaited(_applySnapshot(organizationId, snapshot.docs)),
      onError: (Object error) {
        final current = state.value;
        if (current != null) {
          state = AsyncData(current.copyWith(
            isRefreshing: false,
            syncError: error,
          ));
        }
      },
    );
  }

  Future<void> _applySnapshot(
    String organizationId,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) async {
    try {
      await _saveSnapshot(organizationId, documents);
      state = AsyncData(CatalogState(
        products: await localDatabase.productsFor(organizationId),
      ));
    } on Object catch (error) {
      final current = state.value;
      if (current != null) {
        state = AsyncData(current.copyWith(
          isRefreshing: false,
          syncError: error,
        ));
      }
    }
  }

  Future<void> _saveSnapshot(
    String organizationId,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) =>
      localDatabase.cacheProducts(
        organizationId,
        documents
            .where((document) => document.data()['active'] != false)
            .map(Product.fromFirestore),
      );
}

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addProduct(Product product) {
    final idx = state.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      final updated = state[idx].copyWith(quantity: state[idx].quantity + 1);
      state = [
        ...state.sublist(0, idx),
        updated,
        ...state.sublist(idx + 1),
      ];
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      state = state.where((i) => i.product.id != productId).toList();
      return;
    }
    state = state
        .map((i) =>
            i.product.id == productId ? i.copyWith(quantity: quantity) : i)
        .toList();
  }

  void clearCart() => state = [];
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

final cartTotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(
        0,
        (total, item) => total + item.subtotalFCFA,
      );
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(
        0,
        (total, item) => total + item.quantity,
      );
});
