import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_function.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';
import 'package:flutter_sip_calculator/calculat_screen.dart';

class PPFCalculatorScreen extends StatefulWidget {
  @override
  _PPFCalculatorScreenState createState() => _PPFCalculatorScreenState();
}

class _PPFCalculatorScreenState extends State<PPFCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _investmentController = TextEditingController();
  TextEditingController _interestController = TextEditingController();
  TextEditingController _periodController = TextEditingController();

  String _frequency = 'Yearly';
  double _totalInvestment = 0;
  double _totalInterest = 0;
  double _maturityAmount = 0;

  void _calculatePPF() {
    if (_formKey.currentState!.validate()) {
      double investment = double.parse(_investmentController.text);
      double interestRate = double.parse(_interestController.text) / 100;
      int period = int.parse(_periodController.text);

      double amount = investment;
      for (int i = 0; i < period; i++) {
        amount = amount * (1 + interestRate) + investment;
      }

      setState(() {
        _totalInvestment = investment * period;
        _totalInterest = amount - _totalInvestment;
        _maturityAmount = amount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onPopInterstitialAds(context: context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('PPF Calculator'),
        ),
        bottomNavigationBar: Ads.manageNative(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: _frequency,
                  onChanged: (String? newValue) {
                    setState(() {
                      _frequency = newValue!;
                    });
                  },
                  items: <String>['Yearly', 'Monthly'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                  ),
                ),
                TextFormField(
                  controller: _investmentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Investment'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an investment amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _interestController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Interest %'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an interest rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _periodController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Period (Years)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a period';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: commonButton(title: "Calculate", onTap: _calculatePPF)),
                    Expanded(
                      child: commonButton(
                        title: "Reset",
                        onTap: () {
                          _formKey.currentState?.reset();
                          setState(() {
                            _periodController.clear();
                            _interestController.clear();
                            _investmentController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_maturityAmount > 0) ...[
                  Text('Total Investment: ₹$_totalInvestment'),
                  Text('Total Interest: ₹$_totalInterest'),
                  Text('Maturity Amount: ₹$_maturityAmount'),
                  SizedBox(height: 20),
                  // PieChart(
                  //   data: [
                  //     PieChartData('Total Investment', _totalInvestment),
                  //     PieChartData('Total Interest', _totalInterest),
                  //   ],
                  // ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class PieChart extends StatelessWidget {
//   final List<PieChartData> data;
//
//   PieChart({required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<PieChartData, String>> series = [
//       charts.Series(
//         id: "PPF",
//         data: data,
//         domainFn: (PieChartData series, _) => series.label,
//         measureFn: (PieChartData series, _) => series.value,
//         colorFn: (PieChartData series, _) =>
//         charts.MaterialPalette.blue.shadeDefault,
//         labelAccessorFn: (PieChartData row, _) => '${row.label}: ₹${row.value}',
//       )
//     ];
//
//     return Container(
//       height: 200,
//       child: charts.PieChart<String>(series,
//           animate: true, defaultRenderer: charts.ArcRendererConfig(arcWidth: 60)),
//     );
//   }
// }
//
// class PieChartData {
//   final String label;
//   final double value;
//
//   PieChartData(this.label, this.value);
// }
