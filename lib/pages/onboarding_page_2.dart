import 'package:flutter/material.dart';
import 'package:local_service_provider_app/utils/colors.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Center(
                  child: CircleAvatar(
                    radius: 180,
                    backgroundImage: AssetImage("assets/images/handyman6.png"),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: 76,
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Your Trusted ",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Service Directory ",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Connect with reliable service providers nearby",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 30,
                    color: blackColor,
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
