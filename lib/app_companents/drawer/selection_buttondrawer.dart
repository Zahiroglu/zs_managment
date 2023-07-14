import 'package:flutter/material.dart';
import 'package:zs_managment/app_companents/drawer/model_drawerItems.dart';
import 'package:zs_managment/customwidgets/CustomText.dart';
import 'package:zs_managment/sizeconfig/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';


class SelectionButton extends StatefulWidget {
  const SelectionButton({
    this.initialSelected = 0,
    required this.data,
    required this.onSelected,
    required this.isExpendet,

    Key? key,
  }) : super(key: key);

  final int initialSelected;
  final List<SelectionButtonData> data;
  final Function(int index, SelectionButtonData value) onSelected;
  final bool isExpendet;

  @override
  State<SelectionButton> createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.data.asMap().entries.map((e) {
        final index = e.key;
        final data = e.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: _Button(
            isExpendet: widget.isExpendet,
            selected: selected == index,
            onPressed: () {
              widget.onSelected(index, data);
              setState(() {
                selected = index;
              });
            },
            data: data,
          ),
        );
      }).toList(),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.selected,
    required this.data,
    required this.onPressed,
    required this.isExpendet,
    Key? key,
  }) : super(key: key);

  final bool isExpendet;
  final bool selected;
  final SelectionButtonData data;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (!selected)
          ? Colors.transparent
          : Colors.blue.withOpacity(0.4),
      borderRadius: BorderRadius.circular(5),
      child: isExpendet?Container(
        margin: const EdgeInsets.all(5),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(5),
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _icon((!selected) ? data.icon! : data.activeIcon!,context),
                const SizedBox(width: 5),
                isExpendet?_labelText(data.label!,context):const SizedBox(),
              ],
            ),
          ),
        ),
      ) :
      Tooltip(
        margin:  EdgeInsets.only(left: 10.w),
        textAlign: TextAlign.start,
        preferBelow: false,
        excludeFromSemantics: false,
        message: data.label,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _icon((!selected) ? data.icon! : data.activeIcon!,context),
          ),
        ),
      )

    );
  }

  Padding _icon(IconData iconData, BuildContext context) {
    bool isDark=Theme.of(context).brightness==Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Icon(
        size: 32,
        iconData,
        color: (!selected)
            ? isDark?Colors.white:Colors.black
            : isDark?Colors.black:Colors.white,
      ),
    );
  }

  Widget _labelText(String data,BuildContext context) {
    bool isDark=Theme.of(context).brightness==Brightness.dark;
    return CustomText(
      labeltext: data,
      color: (!selected)
          ? isDark?Colors.white:Colors.black
          : isDark?Colors.black:Colors.white,
      fontWeight: (selected)?FontWeight.w700: FontWeight.normal,
      latteSpacer: .8,
      fontsize: 16,
    );
  }

}
