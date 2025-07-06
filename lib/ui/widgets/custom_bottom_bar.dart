import 'package:flutter/material.dart';

typedef ItemBuilder = Widget Function(
    BuildContext context, int index, FloatingNavbarItem items);

class FloatingNavbar extends StatefulWidget {
  final List<FloatingNavbarItem> items;
  final int currentIndex;
  final void Function(int val) onTap;
  final Color selectedBackgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color backgroundColor;
  final double fontSize;
  final double iconSize;
  final double itemBorderRadius;
  final double borderRadius;
  final ItemBuilder itemBuilder;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double width;
  final double elevation;

  FloatingNavbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    ItemBuilder? itemBuilder,
    this.backgroundColor = Colors.black,
    this.selectedBackgroundColor = Colors.white,
    this.selectedItemColor = Colors.black,
    this.iconSize = 24.0,
    this.fontSize = 11.0,
    this.borderRadius = 8,
    this.itemBorderRadius = 8,
    this.unselectedItemColor = Colors.white,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.width = double.infinity,
    this.elevation = 0.0,
  })  : assert(items.length > 1),
        assert(items.length <= 5),
        assert(currentIndex <= items.length),
        assert(width > 50),
        itemBuilder = itemBuilder ??
            _defaultItemBuilder(
              unselectedItemColor: unselectedItemColor,
              selectedItemColor: selectedItemColor,
              borderRadius: borderRadius,
              fontSize: fontSize,
              width: width,
              backgroundColor: backgroundColor,
              currentIndex: currentIndex,
              iconSize: iconSize,
              itemBorderRadius: itemBorderRadius,
              items: items,
              onTap: onTap,
              selectedBackgroundColor: selectedBackgroundColor,
            );

  @override
  // ignore: library_private_types_in_public_api
  _FloatingNavbarState createState() => _FloatingNavbarState();
}

class _FloatingNavbarState extends State<FloatingNavbar> {
  List<FloatingNavbarItem> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: widget.elevation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: widget.padding,
            margin: widget.margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.backgroundColor,
            ),
            width: widget.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: items
                    .asMap()
                    .map((i, f) {
                      return MapEntry(i, widget.itemBuilder(context, i, f));
                    })
                    .values
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

ItemBuilder _defaultItemBuilder({
  required Function(int val) onTap,
  List<FloatingNavbarItem>? items,
  int? currentIndex,
  Color? selectedBackgroundColor,
  Color? selectedItemColor,
  Color? unselectedItemColor,
  Color? backgroundColor,
  double width = double.infinity,
  double? fontSize,
  double? iconSize,
  double? itemBorderRadius,
  double? borderRadius,
}) {
  return (BuildContext context, int index, FloatingNavbarItem item) => Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(itemBorderRadius ?? 0),
            child: Container(
              width: width.isFinite
                  ? (width / items!.length - 8)
                  : MediaQuery.of(context).size.width / items!.length - 24,
              padding: EdgeInsets.symmetric(
                  horizontal: 2, vertical: item.title != null ? 4 : 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  item.customWidget == null
                      ? Icon(
                          item.icon,
                          color: currentIndex == index
                              ? selectedItemColor
                              : unselectedItemColor,
                          size: iconSize,
                        )
                      : item.customWidget!,
                  if (item.title != null)
                    Text(
                      '${item.title}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: currentIndex == index
                            ? selectedItemColor
                            : unselectedItemColor,
                        fontSize: fontSize,
                        fontWeight: currentIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}

class FloatingNavbarItem {
  final String? title;
  final IconData? icon;
  final Widget? customWidget;

  FloatingNavbarItem({
    this.icon,
    this.title,
    this.customWidget,
  }) : assert(icon != null || customWidget != null);
}
