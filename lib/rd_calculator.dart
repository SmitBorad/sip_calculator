import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_function.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';
import 'package:flutter_sip_calculator/calculat_screen.dart';
import 'package:intl/intl.dart';

class RDCalculatorScreen extends StatefulWidget {
  @override
  _RDCalculatorScreenState createState() => _RDCalculatorScreenState();
}

class _RDCalculatorScreenState extends State<RDCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _monthlyAmountController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  double? _totalInvestment;
  double? _totalInterest;
  double? _maturityAmount;
  String? _maturityDate;

  void _calculateRD() {
    if (_formKey.currentState!.validate()) {
      final double monthlyAmount = double.parse(_monthlyAmountController.text);
      final double interestRate = double.parse(_interestController.text) / 100;
      final int periodInYears = int.parse(_periodController.text);

      // Calculate total investment
      double totalInvestment = monthlyAmount * periodInYears * 12;

      // RD Maturity formula:
      // M = P * [ (1 + r/n) ^ nt – 1] / (1 – (1 + r/n) ^ (-1/3))
      // where:
      // P = monthly deposit
      // r = interest rate (in decimal)
      // n = number of compounding periods in a year (for simplicity, we'll assume 12 here)
      // t = number of years

      double n = 12.0; // compounding monthly
      double t = periodInYears.toDouble();
      double r = interestRate / n;

      double maturityAmount = monthlyAmount * ((pow((1 + r), n * t) - 1) / (1 - pow((1 + r), (-1 / 3))));

      double totalInterest = maturityAmount - totalInvestment;

      // Calculate the maturity date
      DateTime now = DateTime.now();
      DateTime maturityDate = DateTime(now.year + periodInYears, now.month, now.day);
      String formattedMaturityDate = DateFormat('dd MMM yyyy').format(maturityDate);

      setState(() {
        _totalInvestment = totalInvestment;
        _totalInterest = totalInterest;
        _maturityAmount = maturityAmount;
        _maturityDate = formattedMaturityDate;
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
          title: Text('Recurring Deposit Calculator'),
        ),
        bottomNavigationBar: Ads.manageNative(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _monthlyAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monthly Amount',
                    hintText: 'Ex: 10,000',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter monthly amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _interestController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Interest %',
                    hintText: 'Ex: 7',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter interest rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _periodController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Period (Years)',
                    hintText: 'Ex: 1',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter period';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: commonButton(
                      title: "Calculate",
                      onTap: _calculateRD,
                    )),
                    Expanded(
                      child: commonButton(
                        title: "Reset",
                        onTap: () {
                          _formKey.currentState?.reset();
                          setState(() {
                            _totalInvestment = null;
                            _totalInterest = null;
                            _maturityAmount = null;
                            _maturityDate = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_maturityAmount != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Investment: ₹${_totalInvestment!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Total Interest: ₹${_totalInterest!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Maturity Amount: ₹${_maturityAmount!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Maturity Date: $_maturityDate',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
