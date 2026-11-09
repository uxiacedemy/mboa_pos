import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/product.dart';
import '../../domain/models/cart_item.dart';

enum SyncStatus { synced, pending, offline, conflict }

class SyncStatusNotifier extends Notifier<SyncStatus> {
  @override
  SyncStatus build() => SyncStatus.synced;

  void markPending() => state = SyncStatus.pending;
}

final syncStatusProvider = NotifierProvider<SyncStatusNotifier, SyncStatus>(
  SyncStatusNotifier.new,
);

final productsProvider = Provider<List<Product>>((ref) => dummyProducts);

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
        (sum, item) => sum + item.subtotalFCFA,
      );
});

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(
        0,
        (sum, item) => sum + item.quantity,
      );
});
