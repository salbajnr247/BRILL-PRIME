// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:brill_prime/providers/toll_gate_provider.dart';
// import 'package:brill_prime/resources/constants/color_constants.dart';
// import 'package:brill_prime/resources/constants/font_constants.dart';
// import 'package:brill_prime/resources/constants/string_constants.dart';
// import 'package:brill_prime/ui/Widgets/custom_text.dart';
// import 'package:brill_prime/ui/consumer/toll_gates/available_toll_gate_screen.dart';
// import 'package:brill_prime/ui/widgets/components.dart';
// import 'package:brill_prime/ui/widgets/modals/pin_location_modal.dart';
// import 'package:brill_prime/utils/navigation_util.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../../resources/constants/image_constant.dart';
// import '../widgets/drawer_widget.dart';
//
// class ConsumerHomePage extends StatefulWidget {
//   const ConsumerHomePage({super.key});
//
//   @override
//   State<ConsumerHomePage> createState() => _ConsumerHomePageState();
// }
//
// class _ConsumerHomePageState extends State<ConsumerHomePage> {
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   final Completer<GoogleMapController> _controller = Completer();
//   static const LatLng _center = LatLng(10.2791, 11.1731);
//   void _onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);
//   }
//
//   bool locationPermissionVisibility = true;
//
//   @override
//   void initState() {
//     // pinLocationModal(context);
//     super.initState();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       key: _key,
//       drawer: SizedBox(
//           width: MediaQuery.of(context).size.width * 0.85,
//           child: const NavDrawer()),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//             onPressed: () {
//               log('map page check');
//               _key.currentState!.openDrawer();
//             },
//             icon: const Icon(Icons.menu)),
//         actions: [
//           // IconButton(
//           //     onPressed: (){
//           //       Get.to(()=> const ConsumerCartPage());
//           //     },
//           //     icon: const Icon(Icons.shopping_cart_outlined)
//           // )
//         ],
//       ),
//       body: SafeArea(
//           child: Stack(clipBehavior: Clip.none, children: [
//         GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition:
//                 const CameraPosition(target: _center, zoom: 11.0),
//             myLocationEnabled: true,
//             zoomControlsEnabled: true,
//             mapType: MapType.normal),
//         Consumer<TollGateProvider>(builder: (ctx, tollGateProvider, child) {
//           return Positioned(
//               bottom: Platform.isAndroid ? 10 : 0,
//               left: 25,
//               right: 25,
//               child: Column(
//                 children: [
//                   ActionButton(
//                       icon: orderFuelIcon,
//                       title: "Order Fuel  Delivery",
//                       isNetworkImage: false,
//                       bgColor: mainColor,
//                       onTap: () {
//                         debugPrint("Print Something");
//                       }),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ActionButton(
//                       icon: purchaseTollGateIcon,
//                       title: "Purchase Toll Ticket",
//                       isNetworkImage: false,
//                       bgColor: mainColor,
//                       onTap: () {
//                         tollGateProvider.getVendors(
//                             context: context, category: tollGateCategory);
//                         tollGateProvider.getCartDetails(context: context);
//                         navToWithScreenName(
//                             context: context,
//                             screen: const AvailableTollGateScreen());
//                       }),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ActionButton(
//                       icon: viewCommoditiesPlusIcon,
//                       isNetworkImage: false,
//                       title: "  View Commodities  ",
//                       bgColor: const Color.fromRGBO(1, 14, 66, 1),
//                       onTap: () {
//                         debugPrint("Print Something");
//                       }),
//                 ],
//               ));
//         })
//       ])),
//     );
//   }
// }
//
// class ActionButton extends StatelessWidget {
//   final String title;
//   final String icon;
//   final Color bgColor;
//   final bool isNetworkImage;
//   final VoidCallback onTap;
//   const ActionButton(
//       {super.key,
//       required this.icon,
//       required this.title,
//       required this.bgColor,
//       required this.onTap,
//       this.isNetworkImage = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Expanded(
//           child: CustomContainerButton(
//             onTap: onTap,
//             title: "",
//             borderRadius: 30,
//             widget: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 isNetworkImage
//                     ? Image.network(
//                         icon,
//                         height: 24,
//                         width: 20,
//                       )
//                     : Image.asset(
//                         icon,
//                         height: 24,
//                         width: 24,
//                       ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: BodyTextPrimaryWithLineHeight(
//                     text: title,
//                     textColor: white,
//                     fontWeight: mediumFont,
//                     fontSize: 20,
//                   ),
//                 )
//               ],
//             ),
//             bgColor: bgColor,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/toll_gates/available_toll_gate_screen.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/ui/widgets/modals/pin_location_modal.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resources/constants/image_constant.dart';
import '../widgets/drawer_widget.dart';

class ConsumerHomePage extends StatefulWidget {
  final LatLng currentLocation;
  const ConsumerHomePage({super.key, required this.currentLocation});

  @override
  State<ConsumerHomePage> createState() => _ConsumerHomePageState();
}

class _ConsumerHomePageState extends State<ConsumerHomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final Completer<GoogleMapController> _controller = Completer();
  // static const LatLng _center = LatLng();

  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  bool locationPermissionVisibility = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final sharedPrefs = await SharedPreferences.getInstance();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!context.mounted) return;
      bool hasShownPinLocation =
          sharedPrefs.getBool(hashShownPinLocationModal) ?? false;
      if (!hasShownPinLocation) {
        if (context.mounted) {
          await pinLocationModal(context);
        }
        markers.add(Marker(
          markerId: const MarkerId('currentLocation'),
          position: widget.currentLocation,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ));
      } else {
        await authProvider.updateUserCurrentLocation(getPlaceNameAfter: true);
        markers.add(Marker(
          markerId: const MarkerId('currentLocation'),
          position: widget.currentLocation,
          infoWindow: const InfoWindow(title: 'Your Location'),
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.future.then((controller) => controller.dispose());
    super.dispose();
  }

  Widget buildGoogleMap({required LatLng latLng}) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: latLng, zoom: 11.0),
      myLocationEnabled: Platform.isAndroid, // Avoid iOS simulator issues
      zoomControlsEnabled: true,
      mapType: MapType.normal,
      markers: markers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _key,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: const NavDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            log('Menu opened');
            _key.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              buildGoogleMap(
                  latLng: LatLng(widget.currentLocation.latitude,
                      widget.currentLocation.longitude)),
              Consumer<TollGateProvider>(
                builder: (ctx, tollGateProvider, child) {
                  return Positioned(
                    bottom: Platform.isAndroid ? 10 : 0,
                    left: 25,
                    right: 25,
                    child: Column(
                      children: [
                        ActionButton(
                          icon: orderFuelIcon,
                          title: "Order Fuel Delivery",
                          isNetworkImage: false,
                          bgColor: mainColor,
                          onTap: () {
                            debugPrint("Fuel Delivery clicked");
                          },
                        ),
                        const SizedBox(height: 20),
                        ActionButton(
                          icon: purchaseTollGateIcon,
                          title: "Purchase Toll Ticket",
                          isNetworkImage: false,
                          bgColor: mainColor,
                          onTap: () {
                            tollGateProvider.getVendors(
                                context: context, category: tollGateCategory);
                            tollGateProvider.getCartDetails(context: context);
                            navToWithScreenName(
                              context: context,
                              screen: const AvailableTollGateScreen(),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        ActionButton(
                          icon: viewCommoditiesPlusIcon,
                          isNetworkImage: false,
                          title: "View Commodities",
                          bgColor: const Color.fromRGBO(1, 14, 66, 1),
                          onTap: () {
                            debugPrint("View Commodities clicked");
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          );
        }),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final String icon;
  final Color bgColor;
  final bool isNetworkImage;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.bgColor,
    required this.onTap,
    this.isNetworkImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomContainerButton(
            onTap: onTap,
            title: "",
            borderRadius: 30,
            widget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isNetworkImage
                    ? Image.network(icon, height: 24, width: 20)
                    : Image.asset(icon, height: 24, width: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: BodyTextPrimaryWithLineHeight(
                    text: title,
                    textColor: white,
                    fontWeight: mediumFont,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            bgColor: bgColor,
          ),
        ),
      ],
    );
  }
}
