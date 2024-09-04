import 'package:bmi_calc/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
        )
      ],
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('BMI Calculator'),
            ),
            body: const Column(
              children: [
                MetricsFormField(),
                AgeSlider(),
                GenderRadio(),
                CalculateButton(),
                ResultText(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MetricsFormField extends StatefulWidget {
  const MetricsFormField({super.key});

  @override
  State<MetricsFormField> createState() => _MetricsFormFieldState();
}

class _MetricsFormFieldState extends State<MetricsFormField> {
  @override
  Widget build(BuildContext context) {
    var dataState = context.watch<DataProvider>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            controller: dataState.weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Type your weight (in kg)',
            ),
            onChanged: (value) {
              setState(() {
                context.read<DataProvider>().preventNonFloatInput(
                  dataState.weightController,
                  value
                );
              });
            },
          ),
          TextFormField(
            controller: dataState.heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Type your height (in cm)',
            ),
            onChanged: (value) {
              setState(() {
                  context.read<DataProvider>().preventNonFloatInput(
                  dataState.heightController,
                  value
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class AgeSlider extends StatefulWidget {
  const AgeSlider({super.key});

  @override
  State<AgeSlider> createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgeSlider> {
  @override
  Widget build(BuildContext context) {
    var dataState = context.watch<DataProvider>();
    var ageValue = dataState.ageValue.toDouble();

    return Column(
      children: [
        Slider(
          value: ageValue,
          min: 1,
          max: 100,
          divisions: 99,
          label: ageValue.round().toString(),
          onChanged: (value) {
            setState(() {
              context.read<DataProvider>().toogleAgeValue(value.toString());
              context.read<DataProvider>().toogleAgeController();
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: TextField(
            controller: dataState.ageController,
            onChanged: (value) {
              setState(() {
                if (value != '') {
                  context.read<DataProvider>().toogleAgeValue(value);
                }
              });
            },
          ),
        )
      ],
    );
  }
}

class GenderRadio extends StatefulWidget {
  const GenderRadio({super.key});

  @override
  State<GenderRadio> createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  @override
  Widget build(BuildContext context) {
    var dataState = context.watch<DataProvider>();

    return Column(
      children: [
        RadioListTile<Gender>(
          value: Gender.male,
          groupValue: dataState.genderValue,
          onChanged: (selectedGender) {
            setState(() {
              context.read<DataProvider>().changeGenderValue(Gender.male);
            });
          },
          title: const Text("Male"),
        ),

        RadioListTile<Gender>(
          value: Gender.female,
          groupValue: dataState.genderValue,
          onChanged: (Gender? selectedGender) {
            setState(() {
              context.read<DataProvider>().changeGenderValue(Gender.female);
            });
          },
          title: const Text("Female"),
        )
      ],
    );
  }
}

class CalculateButton extends StatefulWidget {
  const CalculateButton({super.key});

  @override
  State<CalculateButton> createState() => _CalculateButtonState();
}

class _CalculateButtonState extends State<CalculateButton> {
  @override
  Widget build(BuildContext context) {
    var dataState = context.watch<DataProvider>();
    return TextButton(
      onPressed: () {
        setState(() {
          context.read<DataProvider>().calculateBmiValue(
            weightValue: dataState.weightValue, 
            heightValue: dataState.heightValue
          );
        });
      },
      child: const Text('Calculate'),
    );
  }
}

class ResultText extends StatefulWidget {
  const ResultText({super.key});

  @override
  State<ResultText> createState() => _ResultTextState();
}

class _ResultTextState extends State<ResultText> {
  @override
  Widget build(BuildContext context) {
    var dataState = context.watch<DataProvider>();
    
    if (dataState.bmiValue == null) {
      return const SizedBox();
    } else {
      return Column(
        children: [
          Text('BMI ${dataState.bmiValue?.toStringAsFixed(2)}'),
        ],
      );
    }
  }
}