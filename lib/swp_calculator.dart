import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/ads_function.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';

import 'calculat_screen.dart';

class SWPCalculator extends StatefulWidget {
  @override
  _SWPCalculatorState createState() => _SWPCalculatorState();
}

class _SWPCalculatorState extends State<SWPCalculator> {
  final _totalInvestmentController = TextEditingController();
  final _withdrawalPerMonthController = TextEditingController();
  final _returnRateController = TextEditingController();
  final _periodController = TextEditingController();

  double _finalBalance = 0;
  double _totalWithdrawal = 0;
  double _estimatedReturns = 0;
  String _duration = '';

  void _calculateSWP() {
    double totalInvestment = double.tryParse(_totalInvestmentController.text) ?? 0;
    double withdrawalPerMonth = double.tryParse(_withdrawalPerMonthController.text) ?? 0;
    double returnRate = double.tryParse(_returnRateController.text) ?? 0;
    int period = int.tryParse(_periodController.text) ?? 0;

    double monthlyRate = (returnRate / 100) / 12;
    double balance = totalInvestment;
    double totalWithdrawal = 0;
    double totalReturns = 0;
    int months = 0;

    while (balance > 0 && months < period * 12) {
      balance = balance * (1 + monthlyRate) - withdrawalPerMonth;
      totalReturns += balance * monthlyRate;
      totalWithdrawal += withdrawalPerMonth;
      months++;
    }

    setState(() {
      _finalBalance = balance < 0 ? 0 : balance;
      _totalWithdrawal = totalWithdrawal;
      _estimatedReturns = totalReturns;
      _duration = "${(months / 12).floor()} years and ${months % 12} months";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onPopInterstitialAds(context: context);
        log('POP');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('SWP Calculator'),
        ),
        bottomNavigationBar: Ads.manageNative(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _totalInvestmentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Investment',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _withdrawalPerMonthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Withdrawal Per Month',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _returnRateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Exp. Return Rate (%)',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _periodController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Period (Years)',
                ),
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: commonButton(title: 'Calculate', onTap: _calculateSWP)),
                  Expanded(
                    child: commonButton(
                        title: 'Reset',
                        onTap: () {
                          _totalInvestmentController.clear();
                          _withdrawalPerMonthController.clear();
                          _returnRateController.clear();
                          _periodController.clear();
                          setState(() {
                            _finalBalance = 0;
                            _totalWithdrawal = 0;
                            _estimatedReturns = 0;
                            _duration = '';
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                'Final Balance: $_finalBalance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Total Withdrawal: $_totalWithdrawal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Estimated Returns: $_estimatedReturns',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Your Withdrawal will last for $_duration.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
