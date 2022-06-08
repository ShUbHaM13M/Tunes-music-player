import "package:flutter/material.dart";

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    Key? key,
    this.iconSize = 24,
    this.backgroundColor,
    this.containerHeight = 70,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    required this.controller,
    this.curve = Curves.linear,
  })  : assert(items.length >= 2 && items.length <= 5),
        super(key: key);

  final TabController controller;
  final double iconSize;
  final Color? backgroundColor;
  final double containerHeight;
  final Duration animationDuration;
  final MainAxisAlignment mainAxisAlignment;
  final List<CustomBottombarItem> items;
  final Function(int index) onItemSelected;
  final Curve curve;

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        //? TODO: updating of the currentIndex is slow
        _currentIndex = widget.controller.index;
      });
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.backgroundColor ?? Theme.of(context).bottomAppBarColor;
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: widget.containerHeight,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            children: widget.items.map((item) {
              int index = widget.items.indexOf(item);
              return GestureDetector(
                onTap: () => widget.onItemSelected(index),
                child: _ItemWidget(
                  item: item,
                  iconSize: widget.iconSize,
                  isSelected: index == _currentIndex,
                  backgroundColor: bgColor,
                  animationDuration: widget.animationDuration,
                  curve: widget.curve,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final CustomBottombarItem item;
  final Color backgroundColor;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key? key,
    required this.item,
    required this.iconSize,
    required this.isSelected,
    required this.backgroundColor,
    required this.animationDuration,
    required this.curve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: animationDuration,
        width: isSelected ? 140 : 50,
        height: double.maxFinite,
        curve: curve,
        decoration: BoxDecoration(
          color:
              isSelected ? item.activeColor.withOpacity(0.2) : backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            width: isSelected ? 130 : 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconTheme(
                  data: IconThemeData(
                    size: iconSize,
                    color: isSelected
                        ? item.activeColor.withOpacity(1)
                        : item.inactiveColor ?? item.activeColor,
                  ),
                  child: item.icon,
                ),
                if (isSelected)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          color: item.activeColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: item.textAlign,
                        child: Text(item.title),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottombarItem {
  CustomBottombarItem({
    required this.icon,
    required this.title,
    this.activeColor = Colors.blue,
    this.inactiveColor,
    this.textAlign = TextAlign.center,
  });

  final Widget icon;
  final String title;
  final Color activeColor;
  final Color? inactiveColor;
  final TextAlign? textAlign;
}
