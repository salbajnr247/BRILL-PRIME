// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../resources/constants/color_constants.dart';
// import 'components.dart';
//
// class StateSelectionDropdownWidget extends StatelessWidget {
//   final bool showAllStatesOption;
//   const StateSelectionDropdownWidget(
//       {Key? key, this.showAllStatesOption = false})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<StateAndCityProvider>(
//         builder: (ctx, stateCityProvider, child) {
//       return CustomDropdownWithLabelButton(
//         isRequired: false,
//         text: stateCityProvider.selectedState == null
//             ? "Select State"
//             : stateCityProvider.selectedState?.name,
//         label: "",
//         onTap: () async {
//           debugPrint(
//               stateCityProvider.statesToDisplayWithAllOption.length.toString());
//           if (stateCityProvider.listOfStates.isEmpty) {
//             stateCityProvider.getListOfStates();
//           }
//           if (showAllStatesOption) {
//             stateCityProvider.prepareStatesWithAllOption();
//             showStateSelectionModalWithAllOption(context);
//           } else {
//             showStateSelectionModal(context);
//           }
//         },
//         textColor:
//             stateCityProvider.selectedState == null ? hintTextColor : black,
//       );
//     });
//   }
// }
