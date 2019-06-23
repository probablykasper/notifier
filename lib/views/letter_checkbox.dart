import 'package:flutter/material.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomCheckboxModel extends Model {
  bool _value = false;

  bool get value => _value;

  CustomCheckboxModel({bool value}) {
    _value = value;
  }

  void toggle() {
    _value = !_value;
    notifyListeners();
  }
}

class LetterCheckbox extends StatelessWidget {
  final bool value;
  final String text;
  final ValueChanged<bool> onChanged;

  LetterCheckbox({this.value, this.onChanged, this.text});

  @override
  Widget build(context) {
    final themeModel = ScopedModel.of<ThemeModel>(context);
    return ScopedModel<CustomCheckboxModel>(
      model: CustomCheckboxModel(value: value),
      child: ScopedModelDescendant<CustomCheckboxModel>(
        builder: (context, child, model) {
          print('${model.value}');
          return Padding(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {
                model.toggle();
                onChanged(model.value);
              },
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment(0.0, 0.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: !themeModel.darkMode && model.value == false ? null : Colors.white,
                  ),
                ),
                decoration: new BoxDecoration(
                  color: model.value == true ? themeModel.checkboxEnabledColor : Colors.transparent,
                  border: Border.all(
                    color: model.value == true
                        ? themeModel.checkboxEnabledColor
                        : themeModel.checkboxDisabledColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          );
          // return Checkbox(
          //   value: model.value,
          //   onChanged: this.onChanged,
          // );
        },
      ),
    );
  }
}
