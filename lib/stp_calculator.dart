import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_function.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';
import 'calculat_screen.dart';

class STPCalculatorScreen extends StatefulWidget {
  @override
  _STPCalculatorScreenState createState() => _STPCalculatorScreenState();
}

class _STPCalculatorScreenState extends State<STPCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _stpAmountController = TextEditingController();
  final TextEditingController _transferorController = TextEditingController();
  final TextEditingController _transfereeController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  double? _finalBalance;

  void _calculateSTP() {
    if (_formKey.currentState!.validate()) {
      final double investment = double.parse(_investmentController.text);
      final double stpAmount = double.parse(_stpAmountController.text);
      final double transferorRate = double.parse(_transferorController.text) / 100 / 12;
      final double transfereeRate = double.parse(_transfereeController.text) / 100 / 12;
      final int period = int.parse(_periodController.text) * 12;

      double transferorBalance = investment;
      double transfereeBalance = 0.0;

      for (int i = 0; i < period; i++) {
        transferorBalance = transferorBalance * (1 + transferorRate) - stpAmount;
        transfereeBalance = (transfereeBalance + stpAmount) * (1 + transfereeRate);
      }

      setState(() {
        _finalBalance = transfereeBalance;
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
          title: Text('STP Calculator'),
        ),
        bottomNavigationBar: Ads.manageNative(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _investmentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Investment Amount',
                    hintText: 'Ex: 1,00,000',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter investment amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stpAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'STP Amount',
                    hintText: 'Ex: 1000',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter STP amount';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _transferorController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Transferor Rate (%)',
                    hintText: 'Ex: 12',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter transferor rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _transfereeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Transferee Rate (%)',
                    hintText: 'Ex: 12',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter transferee rate';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _periodController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Period (Years)',
                    hintText: 'Ex: 10',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter period';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: commonButton(title: 'Calculate', onTap: _calculateSTP)),
                    Expanded(
                      child: commonButton(
                        title: 'Reset',
                        onTap: () {
                          _formKey.currentState?.reset();
                          setState(() {
                            _finalBalance = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_finalBalance != null)
                  Text(
                    'Final Balance: ₹${_finalBalance!.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
