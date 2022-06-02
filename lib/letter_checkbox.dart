import 'package:flutter/material.dart'
    show
        Alignment,
        AnimatedContainer,
        Border,
        BorderRadius,
        BoxDecoration,
        Color,
        Colors,
        Container,
        Curves,
        FontWeight,
        GestureDetector,
        Radius,
        StatelessWidget,
        Text,
        TextAlign,
        TextStyle,
        ValueChanged,
        Widget;

class LetterCheckbox extends StatelessWidget {
  final bool value;
  final String text;
  final ValueChanged<bool> toggle;
  final Color enabledColor;
  final Color disabledColor;

  const LetterCheckbox({
    required this.value,
    required this.toggle,
    required this.text,
    required this.enabledColor,
    required this.disabledColor,
  });

  @override
  Widget build(context) {
    int padding = 5;
    return GestureDetector(
      onTap: () {
        toggle(!value);
      },
      child: Container(
        width: 30 + padding * 2,
        height: 30 + padding * 2,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.ease,
          width: value == true ? 30 : 26,
          height: value == true ? 30 : 26,
          alignment: const Alignment(0.0, 0.0),
          decoration: BoxDecoration(
            border: value == true
                ? Border.all(color: enabledColor, width: 2.5)
                : Border.all(color: disabledColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(context) {
  //   final themeModel = ScopedModel.of<ThemeModel>(context);
  //   return ScopedModel<LetterCheckboxModel>(
  //     model: LetterCheckboxModel(value: value),
  //     child: ScopedModelDescendant<LetterCheckboxModel>(
  //       builder: (context, child, model) {
  //         double padding = 5;
  //         return GestureDetector(
  //           onTap: () {
  //             bool newValue = model.toggle();
  //             onChanged(newValue);
  //           },
  //           child: Container(
  //             width: 30 + padding * 2,
  //             height: 30 + padding * 2,
  //             color: Colors.transparent,
  //             alignment: Alignment.center,
  //             child: AnimatedContainer(
  //               duration: const Duration(milliseconds: 80),
  //               curve: Curves.ease,
  //               width: model.value == true ? 30 : 26,
  //               height: model.value == true ? 30 : 26,
  //               alignment: const Alignment(0.0, 0.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(
  //                   color: model.value == true
  //                       ? themeModel.checkboxEnabledColor
  //                       : themeModel.checkboxDisabledColor,
  //                   width: model.value == true ? 2.5 : 2,
  //                 ),
  //                 borderRadius: const BorderRadius.all(Radius.circular(50)),
  //               ),
  //               child: Text(
  //                 text,
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
