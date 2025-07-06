import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../resources/constants/dimension_constants.dart';
import '../../../resources/constants/image_constant.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/label_widget.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  final sourceController = TextEditingController();
  final medicationAndRemarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const TopPadding(),
              const CustomAppbar(title: "Treatment"),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 23.h,
                      ),
                      SizedBox(
                        height: 21.h,
                      ),
                      const LabelWidget(label: "Type of vaccine"),
                      SizedBox(
                        height: 21.h,
                      ),
                      const LabelWidget(label: "Frequency"),
                      SizedBox(
                        height: 21.h,
                      ),
                      const LabelWidget(label: "Source"),
                      SizedBox(
                        height: 21.h,
                      ),
                      const LabelWidget(label: "Medication & remarks"),
                      SizedBox(
                        height: 21.h,
                      ),
                      SizedBox(
                        height: bottomPadding.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class CanineImageItem extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  final VoidCallback removeImage;
  const CanineImageItem(
      {super.key, this.image, required this.onTap, required this.removeImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: image == null
                ? const DecorationImage(image: AssetImage(canineImgEmptyState))
                : DecorationImage(image: FileImage(image!), fit: BoxFit.cover)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (image != null)
              Positioned(
                  right: -10,
                  top: -10,
                  child: InkWell(
                      onTap: removeImage,
                      child: SvgPicture.asset(removeCanineIcon)))
          ],
        ),
      ),
    );
  }
}
