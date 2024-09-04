import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

enum Gender {
  male,
  female
}

class DataProvider extends ChangeNotifier {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  double weightValue;
  double heightValue;
  int ageValue;
  Gender? genderValue;
  double? bmiValue;

  DataProvider({
    this.weightValue = 0.0,
    this.heightValue = 0.0,
    this.ageValue = 20,
    this.genderValue = Gender.male,
  });

  void preventNonFloatInput(
    TextEditingController controller,
    String value 
  ) {
    if (!isFloat(value)) {
      controller.text = '';
    }
  }

  void toogleAgeValue(String value) {
    if (!isFloat(value)) {
      return;
    }

    double newAgeValue = double.parse(value);

    if (newAgeValue < 1) {
      ageValue = 1;
    } else if (newAgeValue > 100) {
      ageValue = 100;
    } else {
      ageValue = newAgeValue.toInt();
    }
    notifyListeners();
  }

  void toogleAgeController() {
    ageController.text = ageValue.toString();
  }

  void changeGenderValue(Gender? value) {
    genderValue = value;
    notifyListeners();
  }

  void calculateBmiValue({
    required weightValue,
    required heightValue,
  }) {
    weightValue = double.parse(weightController.text);
    heightValue = double.parse(heightController.text)*0.01;

    bmiValue = (weightValue / (heightValue*heightValue));
    notifyListeners();
  }

  Widget showBmiCalculation() {
    // print(bmiValue);
    if (bmiValue == null) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          Text('BMI $bmiValue'),
        ],
      );
    }
  }

}