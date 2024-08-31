import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';

import 'ads/ads_function.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({Key? key}) : super(key: key);

  @override
  _CalculateScreenState createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  final _monthlyInvestmentController = TextEditingController();
  final _returnRateController = TextEditingController();
  final _periodController = TextEditingController();

  double _totalInvestment = 0;
  double _estimatedReturns = 0;
  double _totalValue = 0;

  void _calculateSIP() {
    double monthlyInvestment = double.tryParse(_monthlyInvestmentController.text) ?? 0;
    double returnRate = double.tryParse(_returnRateController.text) ?? 0;
    int period = int.tryParse(_periodController.text) ?? 0;

    setState(() {
      _totalInvestment = monthlyInvestment * 12 * period;
      _estimatedReturns = _totalInvestment * returnRate / 100;
      _totalValue = _totalInvestment + _estimatedReturns;
    });
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
          title: const Text('SIP Calculator'),
        ),
        bottomNavigationBar: Ads.manageNative(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _monthlyInvestmentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Investment',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _returnRateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Exp. Return Rate (%)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _periodController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Period (Years)',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: commonButton(title: 'Calculate', onTap: _calculateSIP)),
                    Expanded(
                      child: commonButton(
                          title: 'Reset',
                          onTap: () {
                            _monthlyInvestmentController.clear();
                            _returnRateController.clear();
                            _periodController.clear();
                            setState(() {
                              _totalInvestment = 0;
                              _estimatedReturns = 0;
                              _totalValue = 0;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Total Investment: $_totalInvestment',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Estimated Returns: $_estimatedReturns',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total Value: $_totalValue',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                _buildPieChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.orange,
              value: _totalInvestment,
              title: '${(_totalInvestment / _totalValue * 100).toStringAsFixed(1)}%',
            ),
            PieChartSectionData(
              color: Colors.green,
              value: _estimatedReturns,
              title: '${(_estimatedReturns / _totalValue * 100).toStringAsFixed(1)}%',
            ),
          ],
        ),
      ),
    );
  }
}

Widget commonButton({required String title, required void Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: const Color(0xff322E54).withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    ),
  );
}
