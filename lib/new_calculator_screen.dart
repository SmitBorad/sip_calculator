import 'package:flutter/material.dart';
import 'package:flutter_sip_calculator/ads/on_pop_interstitial_ad.dart';
import 'package:flutter_sip_calculator/ads/on_tap_interstitial_ad.dart';
import 'package:flutter_sip_calculator/ppf_calculator.dart';
import 'package:flutter_sip_calculator/rd_calculator.dart';
import 'package:flutter_sip_calculator/stp_calculator.dart';
import 'package:flutter_sip_calculator/swp_calculator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'ads/ads_function.dart';
import 'calculat_screen.dart';
import 'fd_calculator.dart';
import 'interest_calculator.dart';

class NewCalculatorScreen extends StatefulWidget {
  const NewCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<NewCalculatorScreen> createState() => _NewCalculatorScreenState();
}

class _NewCalculatorScreenState extends State<NewCalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onPopInterstitialAds(context: context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Ads.manageNative(),
        appBar: AppBar(
          title: const Text('Calculators'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CalculatorSection(
                  title: 'SIP Calculators',
                  calculators: [
                    CalculatorItem(name: 'SIP Calculator', icon: Icons.calculate),
                    CalculatorItem(
                      name: 'SWP Calculator',
                      icon: Icons.calculate,
                      onTap: () {
                        detailsScreenOnTap(context, () {
                          Get.to(SWPCalculator());
                        });
                      },
                    ),
                    CalculatorItem(
                      name: 'STP Calculator',
                      icon: Icons.calculate,
                      onTap: () {
                        detailsScreenOnTap(context, () {
                          Get.to(STPCalculatorScreen());
                        });
                      },
                    ),
                    // CalculatorItem(name: 'History', icon: Icons.history),
                  ],
                ),
                const SizedBox(height: 20),
                CalculatorSection(
                  title: 'Banking Calculators',
                  calculators: [
                    CalculatorItem(
                      name: 'FD Calculator',
                      icon: Icons.calculate,
                      onTap: () {
                        detailsScreenOnTap(context, () {
                          Get.to(FDCalculatorScreen());
                        });
                      },
                    ),
                    CalculatorItem(
                      name: 'RD Calculator',
                      icon: Icons.calculate,
                      onTap: () {
                        detailsScreenOnTap(context, () {
                          Get.to(RDCalculatorScreen());
                        });
                      },
                    ),
                    CalculatorItem(
                      name: 'PPF Calculator',
                      icon: Icons.calculate,
                      onTap: () {
                        detailsScreenOnTap(context, () {
                          Get.to(PPFCalculatorScreen());
                        });
                      },
                    ),
                    // CalculatorItem(
                    //     name: 'Currency Conversion', icon: Icons.monetization_on),
                    CalculatorItem(
                      name: 'Simple & Compound Interest',
                      icon: Icons.money,
                      onTap: () {
                        detailsScreenOnTap(context, () {
                          Get.to(InterestCalculatorScreen());
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // CalculatorSection(
                //   title: 'Other Calculators',
                //   calculators: [
                //     CalculatorItem(name: 'GST Calculator', icon: Icons.calculate),
                //     CalculatorItem(
                //         name: 'Cash Note Calculator', icon: Icons.calculate),
                //     CalculatorItem(name: 'Amount to Word', icon: Icons.calculate),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorSection extends StatelessWidget {
  final String title;
  final int? crossCount;
  final List<CalculatorItem> calculators;

  CalculatorSection({required this.title, required this.calculators, this.crossCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossCount ?? 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: calculators.length,
              itemBuilder: (context, index) {
                return CalculatorButton(item: calculators[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorItem {
  final String name;
  final IconData icon;
  void Function()? onTap;

  CalculatorItem({required this.name, required this.icon, this.onTap});
}

class CalculatorButton extends StatelessWidget {
  final CalculatorItem item;

  const CalculatorButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return InkWell(
      onTap: item.onTap ??
          () {
            detailsScreenOnTap(context, () {
              Get.to(const CalculateScreen());
            });
          },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item.icon,
                size: 40,
                color: Color(0xff322E54),
              ),
              const SizedBox(height: 10),
              Text(
                item.name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Color(0xff322E54)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
