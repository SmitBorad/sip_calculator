import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_function.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';
import 'package:intl/intl.dart';

import 'calculat_screen.dart';

class FDCalculatorScreen extends StatefulWidget {
  @override
  _FDCalculatorScreenState createState() => _FDCalculatorScreenState();
}

class _FDCalculatorScreenState extends State<FDCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  String? _selectedDepositType = 'Reinvestment/Cumulative';
  double? _maturityAmount;
  double? _totalInterest;
  String? _maturityDate;

  void _calculateFD() {
    if (_formKey.currentState!.validate()) {
      final double depositAmount = double.parse(_depositController.text);
      final double interestRate = double.parse(_interestController.text);
      final int period = int.parse(_periodController.text);

      double maturityAmount;
      if (_selectedDepositType == 'Reinvestment/Cumulative') {
        maturityAmount = depositAmount * pow((1 + (interestRate / 100) / 4), 4 * period);
      } else {
        maturityAmount = depositAmount + (depositAmount * (interestRate / 100) * period);
      }

      final double totalInterest = maturityAmount - depositAmount;

      // Calculate the maturity date
      DateTime now = DateTime.now();
      DateTime maturityDate = DateTime(now.year + period, now.month, now.day);
      String formattedMaturityDate = DateFormat('dd MMM yyyy').format(maturityDate);

      setState(() {
        _maturityAmount = maturityAmount;
        _totalInterest = totalInterest;
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
          title: Text('FD Calculator'),
        ),
        bottomNavigationBar: Ads.manageNative(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _depositController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Deposit Amount',
                    hintText: 'Ex: 100,000',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter deposit amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _interestController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Interest %',
                    hintText: 'Ex: 6.5',
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
                    hintText: 'Ex: 5',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter period';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedDepositType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDepositType = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Deposit Type',
                  ),
                  items: <String>[
                    'Reinvestment/Cumulative',
                    'Quarterly Payout',
                    'Monthly Payout',
                    'Short Term',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: commonButton(title: 'Calculate', onTap: _calculateFD)),
                    Expanded(
                      child: commonButton(
                          title: 'Reset',
                          onTap: () {
                            _formKey.currentState?.reset();
                            setState(() {
                              _maturityAmount = null;
                              _totalInterest = null;
                              _maturityDate = null;
                            });
                          }),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_maturityAmount != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maturity Amount: ₹${_maturityAmount!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Interest: ₹${_totalInterest!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Maturity Date: $_maturityDate',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
