
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brill_prime/providers/cart_provider.dart';
import 'package:brill_prime/models/cart_item_model.dart';

void main() {
  group('CartProvider Tests', () {
    late CartProvider cartProvider;
    
    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      cartProvider = CartProvider();
      await Future.delayed(Duration(milliseconds: 100)); // Wait for initialization
    });

    group('Basic Cart Operations', () {
      test('should start with empty cart', () {
        expect(cartProvider.items, isEmpty);
        expect(cartProvider.itemCount, 0);
        expect(cartProvider.totalAmount, 0.0);
      });

      test('should add item to cart', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 2,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);

        expect(cartProvider.items.length, 1);
        expect(cartProvider.itemCount, 2);
        expect(cartProvider.totalAmount, 20.0);
        expect(cartProvider.isInCart('1'), true);
      });

      test('should update quantity when adding existing item', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.addItem(item);

        expect(cartProvider.items.length, 1);
        expect(cartProvider.items.first.quantity, 2);
        expect(cartProvider.totalAmount, 20.0);
      });

      test('should remove item from cart', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.removeItem('1');

        expect(cartProvider.items, isEmpty);
        expect(cartProvider.isInCart('1'), false);
      });

      test('should update item quantity', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.updateQuantity('1', 5);

        expect(cartProvider.items.first.quantity, 5);
        expect(cartProvider.totalAmount, 50.0);
      });

      test('should remove item when quantity updated to 0', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.updateQuantity('1', 0);

        expect(cartProvider.items, isEmpty);
      });

      test('should increase and decrease quantity', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.increaseQuantity('1');

        expect(cartProvider.items.first.quantity, 2);

        cartProvider.decreaseQuantity('1');
        expect(cartProvider.items.first.quantity, 1);

        cartProvider.decreaseQuantity('1');
        expect(cartProvider.items, isEmpty);
      });

      test('should clear entire cart', () {
        final item1 = CartItem(
          commodityId: '1',
          name: 'Test Item 1',
          price: 10.0,
          quantity: 1,
          image: 'test1.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor 1',
        );

        final item2 = CartItem(
          commodityId: '2',
          name: 'Test Item 2',
          price: 20.0,
          quantity: 1,
          image: 'test2.jpg',
          vendorId: 'vendor2',
          vendorName: 'Test Vendor 2',
        );

        cartProvider.addItem(item1);
        cartProvider.addItem(item2);
        cartProvider.clearCart();

        expect(cartProvider.items, isEmpty);
        expect(cartProvider.totalAmount, 0.0);
      });
    });

    group('Vendor Operations', () {
      test('should group items by vendor', () {
        final item1 = CartItem(
          commodityId: '1',
          name: 'Test Item 1',
          price: 10.0,
          quantity: 1,
          image: 'test1.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor 1',
        );

        final item2 = CartItem(
          commodityId: '2',
          name: 'Test Item 2',
          price: 20.0,
          quantity: 1,
          image: 'test2.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor 1',
        );

        final item3 = CartItem(
          commodityId: '3',
          name: 'Test Item 3',
          price: 30.0,
          quantity: 1,
          image: 'test3.jpg',
          vendorId: 'vendor2',
          vendorName: 'Test Vendor 2',
        );

        cartProvider.addItem(item1);
        cartProvider.addItem(item2);
        cartProvider.addItem(item3);

        final groupedItems = cartProvider.itemsByVendor;
        expect(groupedItems.keys.length, 2);
        expect(groupedItems['vendor1']?.length, 2);
        expect(groupedItems['vendor2']?.length, 1);
        expect(cartProvider.vendorCount, 2);
      });

      test('should calculate vendor total', () {
        final item1 = CartItem(
          commodityId: '1',
          name: 'Test Item 1',
          price: 10.0,
          quantity: 2,
          image: 'test1.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor 1',
        );

        final item2 = CartItem(
          commodityId: '2',
          name: 'Test Item 2',
          price: 20.0,
          quantity: 1,
          image: 'test2.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor 1',
        );

        cartProvider.addItem(item1);
        cartProvider.addItem(item2);

        expect(cartProvider.getVendorTotal('vendor1'), 40.0);
      });

      test('should clear vendor items', () {
        final item1 = CartItem(
          commodityId: '1',
          name: 'Test Item 1',
          price: 10.0,
          quantity: 1,
          image: 'test1.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor 1',
        );

        final item2 = CartItem(
          commodityId: '2',
          name: 'Test Item 2',
          price: 20.0,
          quantity: 1,
          image: 'test2.jpg',
          vendorId: 'vendor2',
          vendorName: 'Test Vendor 2',
        );

        cartProvider.addItem(item1);
        cartProvider.addItem(item2);
        cartProvider.clearVendorItems('vendor1');

        expect(cartProvider.items.length, 1);
        expect(cartProvider.items.first.vendorId, 'vendor2');
      });
    });

    group('Save for Later', () {
      test('should save item for later', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.saveForLater('1');

        expect(cartProvider.items, isEmpty);
        expect(cartProvider.savedItems.length, 1);
        expect(cartProvider.savedItems.first.commodityId, '1');
      });

      test('should move saved item back to cart', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.saveForLater('1');
        cartProvider.moveToCart('1');

        expect(cartProvider.savedItems, isEmpty);
        expect(cartProvider.items.length, 1);
        expect(cartProvider.items.first.commodityId, '1');
      });

      test('should remove saved item', () {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.saveForLater('1');
        cartProvider.removeSavedItem('1');

        expect(cartProvider.savedItems, isEmpty);
      });

      test('should clear all saved items', () {
        final item1 = CartItem(
          commodityId: '1',
          name: 'Test Item 1',
          price: 10.0,
          quantity: 1,
          image: 'test1.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor 1',
        );

        final item2 = CartItem(
          commodityId: '2',
          name: 'Test Item 2',
          price: 20.0,
          quantity: 1,
          image: 'test2.jpg',
          vendorId: 'vendor2',
          vendorName: 'Test Vendor 2',
        );

        cartProvider.addItem(item1);
        cartProvider.addItem(item2);
        cartProvider.saveForLater('1');
        cartProvider.saveForLater('2');
        cartProvider.clearSavedItems();

        expect(cartProvider.savedItems, isEmpty);
      });
    });

    group('Guest Checkout', () {
      test('should enable guest checkout', () {
        cartProvider.enableGuestCheckout();

        expect(cartProvider.isGuestCheckout, true);
        expect(cartProvider.cartSessionId, isNotNull);
      });

      test('should disable guest checkout', () {
        cartProvider.enableGuestCheckout();
        cartProvider.disableGuestCheckout();

        expect(cartProvider.isGuestCheckout, false);
        expect(cartProvider.cartSessionId, isNull);
      });

      test('should merge guest cart with user cart', () async {
        final item = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 10.0,
          quantity: 1,
          image: 'test.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor',
        );

        cartProvider.addItem(item);
        cartProvider.enableGuestCheckout();
        await cartProvider.mergeGuestCartWithUserCart();

        expect(cartProvider.isGuestCheckout, false);
        expect(cartProvider.cartSessionId, isNull);
        expect(cartProvider.items.length, 1);
      });
    });

    group('Cart Statistics', () {
      test('should return correct cart statistics', () {
        final item1 = CartItem(
          commodityId: '1',
          name: 'Test Item 1',
          price: 10.0,
          quantity: 2,
          image: 'test1.jpg',
          vendorId: 'vendor1',
          vendorName: 'Test Vendor 1',
        );

        final item2 = CartItem(
          commodityId: '2',
          name: 'Test Item 2',
          price: 20.0,
          quantity: 1,
          image: 'test2.jpg',
          vendorId: 'vendor2',
          vendorName: 'Test Vendor 2',
        );

        cartProvider.addItem(item1);
        cartProvider.addItem(item2);
        cartProvider.saveForLater('2');
        cartProvider.enableGuestCheckout();

        final stats = cartProvider.getCartStatistics();

        expect(stats['totalItems'], 2);
        expect(stats['totalValue'], 20.0);
        expect(stats['uniqueProducts'], 1);
        expect(stats['vendorCount'], 1);
        expect(stats['savedItemsCount'], 1);
        expect(stats['isGuestCheckout'], true);
        expect(stats['cartSessionId'], isNotNull);
      });
    });
  });
}
