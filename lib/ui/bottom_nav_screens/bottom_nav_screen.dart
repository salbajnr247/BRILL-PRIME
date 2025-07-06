import 'package:brill_prime/ui/bottom_nav_screens/profile/profile_screen.dart';
import 'package:brill_prime/ui/bottom_nav_screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/bottom_nav_provider.dart';
import '../../resources/constants/font_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../../resources/constants/styles_manager.dart';
import 'home/home_screen.dart';
import 'inbox/inbox_screen.dart';
import 'package:brill_prime/ui/favourites/favourites_screen.dart';
import 'package:brill_prime/ui/reviews/review_screen.dart';
import 'package:brill_prime/ui/notifications/notification_screen.dart';
import '../../ui/orders/order_management_screen.dart';
import '../../ui/payment_methods/payment_methods_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    InboxScreen(),
    ProfileScreen(),
    FavouritesScreen(),
    SearchScreen(),
    ReviewScreen(itemId: 'demo-product-id', itemType: 'product'),
    NotificationScreen(),
    OrderManagementScreen(),
    PaymentMethodsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Payments',
          ),
        ],
      ),
    );
  }
}
