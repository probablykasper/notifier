import 'package:flutter/material.dart';
import 'package:notifier/models/theme_model.dart';
import 'package:scoped_model/scoped_model.dart';

class LetterCheckboxModel extends Model {
  bool _value = false;

  bool get value => _value;
  LetterCheckboxModel({bool value}) {
    _value = value;
  }

  bool toggle() {
    _value = !_value;
    notifyListeners();
    return _value;
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
    return ScopedModel<LetterCheckboxModel>(
      model: LetterCheckboxModel(value: value),
      child: ScopedModelDescendant<LetterCheckboxModel>(
        builder: (context, child, model) {
          double padding = 5;
          return GestureDetector(
            onTap: () {
              bool newValue = model.toggle();
              onChanged(newValue);
            },
            child: Container(
              width: 30 + padding * 2,
              height: 30 + padding * 2,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 80),
                curve: Curves.ease,
                width: model.value == true ? 30 : 26,
                height: model.value == true ? 30 : 26,
                alignment: Alignment(0.0, 0.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                decoration: new BoxDecoration(
                  border: Border.all(
                    color: model.value == true
                        ? themeModel.checkboxEnabledColor
                        : themeModel.checkboxDisabledColor,
                    width: model.value == true ? 2.5 : 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
