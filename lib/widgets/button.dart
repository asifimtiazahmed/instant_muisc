import 'package:flutter/material.dart';

class ActiveButton extends StatelessWidget {
  ///This is a three-in-one button, toggle between [isActive] to go from
  /// active button to disabled button. Toggle between [isOutlined] to go
  /// from active type to outlined style button.
  const ActiveButton({
    required this.title,
    required this.onPressed,
    this.width = 0.0,
    this.isActive = true,
    this.isOutlined = false,
    this.backgroundColor = Colors.blue, //secondarySkyBlueColor,
    this.isCustomBgColor = false,
    this.customTextColor = Colors.amber, //primaryActiveTxtBtnColor,
    Key? key,
  }) : super(key: key);
  final String title;
  final onPressed;
  final double width;
  final bool isActive;
  final bool isOutlined;
  final bool isCustomBgColor;
  final backgroundColor;
  final customTextColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35.0),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: (isCustomBgColor)
              ? backgroundColor
              : (((isOutlined)
                  ? Colors.transparent
                  : ((isActive) ? customTextColor : Colors.grey))),
          border: (isOutlined)
              ? Border.all(color: customTextColor, width: 2)
              : null,
        ),

        width: (width == 0) ? MediaQuery.of(context).size.width * 0.70 : width,
        height: 50, //As per design specs
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: customTextColor),
            // paragraphTextStyle.copyWith(
            //   color: (isCustomBgColor)
            //       ? customTextColor
            //       : ((isOutlined)
            //       ? ((isActive)
            //       ? primaryActiveTxtBtnColor
            //       : inactiveTxtColor)
            //       : ((isActive) ? primaryActiveBgColor : inactiveTxtColor)),
          ),
        ),
      ),
    );
  }
}
