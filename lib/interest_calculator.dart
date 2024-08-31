import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_function.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';
import 'dart:math';

import 'calculat_screen.dart';

class InterestCalculatorScreen extends StatefulWidget {
  @override
  _InterestCalculatorScreenState createState() => _InterestCalculatorScreenState();
}

class _InterestCalculatorScreenState extends State<InterestCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _interestController = TextEditingController();
  TextEditingController _periodController = TextEditingController();

  String _interestType = 'Simple';
  double _principalAmount = 0;
  double _interestAmount = 0;
  double _totalAmount = 0;

  void _calculateInterest() {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text);
      double rate = double.parse(_interestController.text) / 100;
      int period = int.parse(_periodController.text);

      if (_interestType == 'Simple') {
        // Simple Interest Calculation
        _interestAmount = amount * rate * period;
        _totalAmount = amount + _interestAmount;
      } else {
        // Compound Interest Calculation
        _totalAmount = amount * pow(1 + rate, period); // Correct usage of pow function
        _interestAmount = _totalAmount - amount;
      }

      setState(() {
        _principalAmount = amount;
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
          title: Text('Interest Calculator'),
        ),
        bottomNavigationBar: Ads.manageNative(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
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
                SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: const Text('Simple'),
                        contentPadding: EdgeInsets.zero,
                        leading: Radio<String>(
                          value: 'Simple',
                          groupValue: _interestType,
                          onChanged: (String? value) {
                            setState(() {
                              _interestType = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Compound'),
                        contentPadding: EdgeInsets.zero,
                        leading: Radio<String>(
                          value: 'Compound',
                          groupValue: _interestType,
                          onChanged: (String? value) {
                            setState(() {
                              _interestType = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: commonButton(title: "Calculate", onTap: _calculateInterest)),
                    Expanded(
                      child: commonButton(
                        title: "Reset",
                        onTap: () {
                          _formKey.currentState?.reset();
                          setState(() {
                            _periodController.clear();
                            _interestController.clear();
                            _amountController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                if (_totalAmount > 0) ...[
                  Text('Principal Amount: ₹${_principalAmount.toInt()}'),
                  Text('Interest Amount: ₹${_interestAmount.toStringAsFixed(2)}'),
                  Text('Total Amount: ₹${_totalAmount.toStringAsFixed(2)}'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
