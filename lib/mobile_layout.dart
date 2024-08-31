import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'home_screen.dart';

int selectType = 0;

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _returnRateController = TextEditingController();
  final TextEditingController _timePeriodController = TextEditingController();
  double _monthlyInvestment = 25000;
  double _expectedReturnRate = 12;
  double _timePeriod = 10;
  late double _investedAmount;
  late double _totalInvestment;
  late double _result;
  late double i;
  double _monthlyEmi = 0;
  double _principleAmount = 0;
  double _totalInterest = 0;
  double _totalAmount = 0;

  double calculateEMI() {
    print("_expectedReturnRate $_monthlyInvestment");
    double monthlyInterestRate = _expectedReturnRate / 1200;
    double numberOfMonths = _timePeriod * 12;
    _monthlyEmi = double.parse(
        ((_monthlyInvestment * monthlyInterestRate * pow(1 + monthlyInterestRate, numberOfMonths)) / (pow(1 + monthlyInterestRate, numberOfMonths) - 1)).toStringAsFixed(0));
    print("Emi $_monthlyEmi");
    _totalAmount = double.parse((numberOfMonths * _monthlyEmi).toStringAsFixed(0));
    print("_totalAmount $_totalAmount");
    _totalInterest = double.parse((_totalAmount - _monthlyInvestment).toStringAsFixed(0));
    print("_totalInterest $_totalInterest");
    _principleAmount = double.parse((_monthlyInvestment).toStringAsFixed(0));
    print("_principleAmount $_principleAmount");
    return _monthlyEmi;
  }

  cal(double value) {
    setState(() {
      _timePeriod = value;
      print("_timePeriod $value");
      _timePeriodController.text = _timePeriod.toStringAsFixed(0);
      _investedAmount = (_monthlyInvestment * 12) * _timePeriod;
      i = (_expectedReturnRate) / (12 * 100);
      _result = double.parse(((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));

      _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
      _totalInvestment.toStringAsFixed(0);
      print("_totalInvestment2 ${_totalInvestment}");
    });
  }

  lumCal() {
    _investedAmount = _monthlyInvestment;

    double getPer = (1 + (double.parse(_returnRateController.text) / 100));
    var getSqr = pow(getPer, _timePeriod);

    _totalInvestment = double.parse((_monthlyInvestment * getSqr).toStringAsFixed(0));
    print("_result ${_result}");

    _result = double.parse((_totalInvestment - _monthlyInvestment).toStringAsFixed(0));
  }

  @override
  void initState() {
    if (selectType == 0) {
      _controller.text = _monthlyInvestment.toString();
      _returnRateController.text = _expectedReturnRate.toString();
      _timePeriodController.text = _timePeriod.toString();

      _investedAmount = (_monthlyInvestment * 12) * _timePeriod;

      i = (_expectedReturnRate) / (12 * 100);

      _result = double.parse(((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));

      _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
    } else if (selectType == 1) {
      _controller.text = _monthlyInvestment.toString();
      _returnRateController.text = _expectedReturnRate.toString();
      _timePeriodController.text = _timePeriod.toString();

      _investedAmount = (_monthlyInvestment * 12) * _timePeriod;

      i = (_expectedReturnRate) / (12 * 100);

      _result = double.parse(((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));

      _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));

      lumCal();
    } else {
      _controller.text = _monthlyInvestment.toString();
      _returnRateController.text = _expectedReturnRate.toString();
      _timePeriodController.text = _timePeriod.toString();

      _investedAmount = (_monthlyInvestment * 12) * _timePeriod;

      i = (_expectedReturnRate) / (12 * 100);

      _result = double.parse(((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));

      _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));

      _monthlyInvestment = 1000000;
      _controller.text = _monthlyInvestment.toStringAsFixed(0);
      calculateEMI();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: const Color(0xff322E54),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          selectType == 0
                              ? "Sip Calculator"
                              : selectType == 1
                                  ? "Lumpsum Calculator"
                                  : "EMI Calculator",
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color(0xFF5367ff),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  'Estd. returns',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: const Color(0xFF98a4ff),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  'Invested amount',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 30,
                            annotations: [
                              GaugeAnnotation(
                                  widget: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    selectType == 2
                                        ? Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                const Text(
                                                  'Monthly EMI',
                                                  style: TextStyle(color: Colors.white54),
                                                ),
                                                Text(
                                                  NumberFormat.decimalPattern().format(_monthlyEmi).toString(),
                                                  // _investedAmount.toStringAsFixed(0),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white54,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            selectType == 2 ? 'Principal Amount' : 'Invested Amount',
                                            style: const TextStyle(color: Colors.white54),
                                          ),
                                          Text(
                                            NumberFormat.decimalPattern().format(selectType == 2 ? _principleAmount : _investedAmount).toString(),
                                            // _investedAmount.toStringAsFixed(0),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            selectType == 2 ? 'Total Interest' : 'Est. returns',
                                            style: const TextStyle(color: Colors.white54),
                                          ),
                                          Text(
                                            NumberFormat.decimalPattern().format(selectType == 2 ? _totalInterest : _result).toString(),
                                            // _result.toStringAsFixed(0),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            selectType == 2 ? 'Total Amount' : 'Total value',
                                            style: const TextStyle(color: Colors.white54),
                                          ),
                                          Text(
                                            NumberFormat.decimalPattern().format(selectType == 2 ? _totalAmount : _totalInvestment).toString(),
                                            // _totalInvestment.toStringAsFixed(0),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ],
                            useRangeColorForAxis: true,
                            startAngle: 270,
                            endAngle: 270,
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: const AxisLineStyle(thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15, color: Color(0xFF98a4ff)),
                            ranges: <GaugeRange>[
                              GaugeRange(startValue: 0, endValue: 17, color: const Color(0xFF98a4ff), sizeUnit: GaugeSizeUnit.factor, startWidth: 0.15, endWidth: 0.15),
                              GaugeRange(
                                  startValue: _expectedReturnRate, endValue: 30, sizeUnit: GaugeSizeUnit.factor, color: const Color(0xFF5367ff), startWidth: 0.15, endWidth: 0.15),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 1.75),
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)), color: Colors.white),
                  // height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          emiView == false
                              ? Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectType = 0;
                                          // GetAds.to.createInterstitialAd2();
                                          _investedAmount = (_monthlyInvestment * 12) * _timePeriod;

                                          i = (_expectedReturnRate) / (12 * 100);

                                          _result =
                                              double.parse(((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));

                                          _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
                                        });
                                      },
                                      child: Container(
                                        width: 100,
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                            color: selectType == 0 ? const Color(0xff322E54).withOpacity(0.8) : const Color(0xff322E54).withOpacity(0.5),
                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
                                        child: const Center(
                                          child: Text(
                                            'Sip',
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectType = 1;
                                          // GetAds.to.createInterstitialAd2();
                                          // GetAds.to.showInterstitialAd2();
                                          _investedAmount = _monthlyInvestment;

                                          double getPer = (1 + (double.parse(_returnRateController.text) / 100));
                                          var getSqr = pow(getPer, _timePeriod);

                                          _totalInvestment = double.parse((_monthlyInvestment * getSqr).toStringAsFixed(0));
                                          print("_result ${_result}");

                                          _result = double.parse((_totalInvestment - _monthlyInvestment).toStringAsFixed(0));
                                        });
                                      },
                                      child: Container(
                                        width: 100,
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                            color: selectType == 1 ? const Color(0xff322E54).withOpacity(0.8) : const Color(0xff322E54).withOpacity(0.5),
                                            borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
                                        child: const Center(
                                          child: Text(
                                            'Lumpsum',
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectType = 2;
                                      _monthlyInvestment = 1000000;
                                      _controller.text = _monthlyInvestment.toStringAsFixed(0);
                                      calculateEMI();
                                    });
                                  },
                                  child: Container(
                                    width: 200,
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                        color: selectType == 2 ? const Color(0xff322E54).withOpacity(0.8) : const Color(0xff322E54).withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Center(
                                      child: Text(
                                        'Emi',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Monthly Investment',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: TextFormField(
                                      controller: _controller,
                                      cursorColor: Colors.white,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        print("value $val");
                                        setState(() {
                                          _monthlyInvestment = double.parse(val);
                                          // _controller.text = _monthlyInvestment
                                          //     .toStringAsFixed(0);
                                          if (selectType == 0) {
                                            _investedAmount = (_monthlyInvestment * 12) * _timePeriod;
                                            i = (_expectedReturnRate) / (12 * 100);
                                            _result = double.parse(
                                                ((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));
                                            _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
                                          } else if (selectType == 1) {
                                            lumCal();
                                          } else {
                                            calculateEMI();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        fillColor: Color(0xffA27CCD),
                                        filled: true,
                                        contentPadding: EdgeInsets.only(left: 0),
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                      ),
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: SfSliderTheme(
                              data: SfSliderThemeData(
                                activeTrackHeight: 5,
                                inactiveTrackHeight: 5,
                                activeTrackColor: const Color(0xffA27CCD),
                                inactiveTrackColor: Colors.black12,
                                thumbColor: Colors.white,
                                trackCornerRadius: 0,
                                thumbRadius: 15,
                              ),
                              child: SfSlider(
                                  min: selectType == 2 ? 100000 : 500,
                                  max: selectType == 2 ? 10000000 : 100000,
                                  stepSize: selectType == 2 ? 10000 : 1.0,
                                  value: _monthlyInvestment,
                                  onChanged: (dynamic value) {
                                    print("value $value");
                                    setState(() {
                                      _monthlyInvestment = value;
                                      _controller.text = _monthlyInvestment.toStringAsFixed(0);
                                      if (selectType == 0) {
                                        _investedAmount = (_monthlyInvestment * 12) * _timePeriod;
                                        i = (_expectedReturnRate) / (12 * 100);
                                        _result =
                                            double.parse(((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));
                                        _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
                                      } else if (selectType == 1) {
                                        lumCal();
                                      } else {
                                        // _monthlyInvestment = 1000000;
                                        print("_expectedReturnRate ${_monthlyInvestment}");
                                        double monthlyInterestRate = _expectedReturnRate / 1200;
                                        double numberOfMonths = _timePeriod * 12;
                                        _monthlyEmi = double.parse(((_monthlyInvestment * monthlyInterestRate * pow(1 + monthlyInterestRate, numberOfMonths)) /
                                                (pow(1 + monthlyInterestRate, numberOfMonths) - 1))
                                            .toStringAsFixed(0));
                                        print("Emi $_monthlyEmi");
                                        _totalAmount = double.parse((numberOfMonths * _monthlyEmi).toStringAsFixed(0));
                                        print("_totalAmount $_totalAmount");
                                        _totalInterest = double.parse((_totalAmount - _monthlyInvestment).toStringAsFixed(0));
                                        print("_totalInterest $_totalInterest");
                                        _principleAmount = double.parse((_monthlyInvestment).toStringAsFixed(0));
                                        print("_principleAmount $_principleAmount");
                                      }
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Expected return rate (p.a)',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: TextFormField(
                                      controller: _returnRateController,
                                      cursorColor: Colors.white,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        setState(() {
                                          print("value $val");
                                          _expectedReturnRate = double.parse(val);
                                          // _returnRateController.text =
                                          //     _expectedReturnRate
                                          //         .toStringAsFixed(0);
                                          if (selectType == 0) {
                                            i = (_expectedReturnRate) / (12 * 100);
                                            _result = double.parse(
                                                ((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));
                                            _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
                                          } else if (selectType == 1) {
                                            lumCal();
                                          } else {
                                            calculateEMI();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        fillColor: Color(0xffA27CCD),
                                        filled: true,
                                        contentPadding: EdgeInsets.only(left: 30),
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                      ),
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: SfSliderTheme(
                              data: SfSliderThemeData(
                                activeTrackHeight: 5,
                                inactiveTrackHeight: 5,
                                activeTrackColor: const Color(0xffA27CCD),
                                inactiveTrackColor: Colors.black12,
                                thumbColor: Colors.white,
                                trackCornerRadius: 0,
                                thumbRadius: 15,
                              ),
                              child: SfSlider(
                                  min: 1,
                                  max: 30,
                                  stepSize: 1.0,
                                  value: _expectedReturnRate,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      print("value $value");
                                      _expectedReturnRate = value;
                                      _returnRateController.text = _expectedReturnRate.toStringAsFixed(0);
                                      if (selectType == 0) {
                                        i = (_expectedReturnRate) / (12 * 100);
                                        _result =
                                            double.parse(((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));
                                        _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
                                      } else if (selectType == 1) {
                                        lumCal();
                                      } else {
                                        calculateEMI();
                                      }
                                    });
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Time period',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: TextFormField(
                                      controller: _timePeriodController,
                                      cursorColor: Colors.white,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        setState(() {
                                          _timePeriod = double.parse(val);
                                          print("_timePeriod $val");
                                          // _timePeriodController.text =
                                          //     _timePeriod.toStringAsFixed(0);

                                          if (selectType == 0) {
                                            _investedAmount = (_monthlyInvestment * 12) * _timePeriod;
                                            i = (_expectedReturnRate) / (12 * 100);
                                            _result = double.parse(
                                                ((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));

                                            _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
                                            print("_totalInvestment ${_totalInvestment}");
                                            _totalInvestment.toStringAsFixed(0);
                                            print("_totalInvestment2 ${_totalInvestment}");
                                          } else if (selectType == 1) {
                                            lumCal();
                                          } else {
                                            calculateEMI();
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        fillColor: Color(0xffA27CCD),
                                        filled: true,
                                        contentPadding: EdgeInsets.only(left: 30),
                                        border: OutlineInputBorder(borderSide: BorderSide.none),
                                      ),
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: SfSliderTheme(
                              data: SfSliderThemeData(
                                activeTrackHeight: 5,
                                inactiveTrackHeight: 5,
                                activeTrackColor: const Color(0xffA27CCD),
                                inactiveTrackColor: Colors.black12,
                                thumbColor: Colors.white,
                                trackCornerRadius: 0,
                                thumbRadius: 15,
                              ),
                              child: SfSlider(
                                  min: 1,
                                  max: 30,
                                  value: _timePeriod,
                                  stepSize: 1.0,
                                  onChanged: (value) {
                                    setState(() {
                                      _timePeriod = value;
                                      print("_timePeriod $value");
                                      _timePeriodController.text = _timePeriod.toStringAsFixed(0);

                                      if (selectType == 0) {
                                        _investedAmount = (_monthlyInvestment * 12) * _timePeriod;
                                        i = (_expectedReturnRate) / (12 * 100);
                                        _result =
                                            double.parse(((_monthlyInvestment * (((pow((1 + i), (_timePeriod * 12))) - 1) / i) * (1 + i)) - _investedAmount).toStringAsFixed(0));

                                        _totalInvestment = double.parse((_investedAmount + _result).toStringAsFixed(0));
                                        print("_totalInvestment ${_totalInvestment}");
                                        _totalInvestment.toStringAsFixed(0);
                                        print("_totalInvestment2 ${_totalInvestment}");
                                      } else if (selectType == 1) {
                                        lumCal();
                                      } else {
                                        calculateEMI();
                                      }
                                    });
                                  }),
                            ),
                          ),
                          const SizedBox(height: 50),
                          selectType == 2
                              ? SizedBox(
                                  width: 350,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        const Text('Monthly EMI'),
                                        Text(
                                          NumberFormat.decimalPattern().format(_monthlyEmi).toString(),
                                          // _investedAmount.toStringAsFixed(0),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          SizedBox(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(selectType == 2 ? 'Principal Amount' : 'Invested Amount'),
                                  Text(
                                    NumberFormat.decimalPattern().format(selectType == 2 ? _principleAmount : _investedAmount).toString(),
                                    // _investedAmount.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // const Divider(
                          //   color: Color(0xffA27CCD),
                          //   endIndent: 50,
                          //   indent: 50,
                          // ),
                          SizedBox(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(selectType == 2 ? 'Total Interest' : 'Est. returns'),
                                  Text(
                                    NumberFormat.decimalPattern().format(selectType == 2 ? _totalInterest : _result).toString(),
                                    // _result.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: const Color(0xffA27CCD), borderRadius: BorderRadius.circular(5)),
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    selectType == 2 ? 'Total Amount' : 'Total value',
                                    style: const TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                  Text(
                                    NumberFormat.decimalPattern().format(selectType == 2 ? _totalAmount : _totalInvestment).toString(),
                                    // _totalInvestment.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
