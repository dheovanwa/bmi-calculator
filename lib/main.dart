import 'package:flutter/material.dart';

enum Gender {
  male,
  female,
}

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Gender? gender;

  double weightValue = 0;
  double heightValue = 0;
  int? ageValue;
  double bmi = 0;
  String? category;


  void updateAge(double specifiedAgeValue) {
    setState(() {
      ageValue = specifiedAgeValue.toInt();
    });
  }

  void updateGender(Gender? selectedGender) {
    setState(() {
      gender = selectedGender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            MetricsFormField(controller: weightController, title: "Enter your weight in kilograms (numbers only)"),
            MetricsFormField(controller: heightController, title: "Enter your height in cm (numbers only)"),
            const Text("Age"),
            AgeSlider(controller: ageController, onChanged: updateAge,),
            GenderRadio(onChanged: updateGender),
            TextButton(
              onPressed: () {
                if (weightController.text == '') {
                  weightValue = 0.0;
                } else {
                  weightValue = double.parse(weightController.text);
                }
                if (heightController.text == '') {
                  heightValue = 0.0;
                } else {
                  heightValue = double.parse(heightController.text)*0.01;
                }

                setState(() {
                  bmi = weightValue / (heightValue * heightValue);

                  if (bmi < 18.5) {
                    category = 'Underweight';
                  } else if (bmi >= 18.5 && bmi < 25) {
                    category = 'Normal';
                  } else if (bmi >= 25 && bmi < 30) {
                    category = 'Overweight';
                  } else {
                    category = 'Obese';
                  }
                });

              },
              child: const Text("Calculate"),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BMI: ${bmi.toStringAsFixed(2)}'),
                  Text('Category: $category'),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

class MetricsFormField extends StatefulWidget {
  final String? title;
  final TextEditingController controller;

  const MetricsFormField({super.key, required this.controller, required this.title});

  @override
  State<MetricsFormField> createState() => _MetricsFormFieldState();
}

class _MetricsFormFieldState extends State<MetricsFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: widget.title,
        )
      ),
    );
  }
}

class AgeSlider extends StatefulWidget {
  final TextEditingController controller;
  // int value;
  final ValueChanged<double> onChanged;

  const AgeSlider({super.key, required this.controller, required this.onChanged});

  @override
  State<AgeSlider> createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgeSlider> {
  double ageValue = 1;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.controller.value = const TextEditingValue(text: '20');
    return Column(
      children: <Widget>[
        Slider(
          value: ageValue,
          min: 1,
          max: 100,
          divisions: 99,
          label: ageValue.round().toString(),
          onChanged: (value) {
            setState(() {
              ageValue = value;
              widget.controller.text = ageValue.toInt().toString();
            });
            widget.onChanged(ageValue);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: TextField(
            controller: widget.controller,
            onChanged: (value) {
          
            },
          ),
        )
      ],
    );
  }
}

class GenderRadio extends StatefulWidget {
  final ValueChanged<Gender?> onChanged;

  GenderRadio({super.key, required this.onChanged});

  @override
  State<GenderRadio> createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  Gender? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<Gender>(
          value: Gender.male,
          groupValue: value,
          onChanged: (Gender? selectedGender) {
            setState(() {
              value = selectedGender;
            });
            widget.onChanged(selectedGender);
          },
          title: const Text("Male"),
        ),

        RadioListTile<Gender>(
          value: Gender.female,
          groupValue: value,
          onChanged: (Gender? selectedGender) {
            setState(() {
              value = selectedGender;
            });
            widget.onChanged(selectedGender);
          },
          title: const Text("Female"),
        )
      ],
    );
  }
}
