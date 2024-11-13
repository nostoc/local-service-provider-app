import 'package:flutter/material.dart';
import 'package:local_service_provider_app/data/onboarding_data.dart';
import 'package:local_service_provider_app/screens/auth/handyman/handyman_signup.dart';
import 'package:local_service_provider_app/screens/auth/visitor/visitor_signup.dart';

import 'package:local_service_provider_app/screens/onboarding/shared_onboarding_screen.dart';
import 'package:local_service_provider_app/screens/onboarding/splash_screen.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  //page controller
  final PageController _controller = PageController();
  bool showSignupScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                //Onboarding screens
                PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      showSignupScreen = index == 3;
                    });
                  },
                  children: [
                    const SplashScreen(),
                    SharedOnboardingScreen(
                      title: OnboardingData.onBoardingDataList[0].title,
                      description:
                          OnboardingData.onBoardingDataList[0].description,
                      imageUrl: OnboardingData.onBoardingDataList[0].imageUrl,
                    ),
                    SharedOnboardingScreen(
                      title: OnboardingData.onBoardingDataList[1].title,
                      description:
                          OnboardingData.onBoardingDataList[1].description,
                      imageUrl: OnboardingData.onBoardingDataList[1].imageUrl,
                    ),
                    SharedOnboardingScreen(
                      title: OnboardingData.onBoardingDataList[2].title,
                      description:
                          OnboardingData.onBoardingDataList[2].description,
                      imageUrl: OnboardingData.onBoardingDataList[2].imageUrl,
                    ),
                  ],
                ),

                //page indicator
                Container(
                  alignment: const Alignment(0, 0.66),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: const WormEffect(
                        activeDotColor: blackColor,
                        dotColor: Color(0xFFC9C9C9)),
                  ),
                ),

                //navigation buttons

                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: !showSignupScreen
                        ? GestureDetector(
                            onTap: () {
                              _controller.animateToPage(
                                  _controller.page!.toInt() + 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            },
                            child: showSignupScreen
                                ? const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomButton(
                                        buttonText:
                                            "I’m looking for a Handy Man",
                                        buttonColor: whiteColor,
                                        buttonTextColor: mainTextColor,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomButton(
                                        buttonText: "I’m looking for work",
                                        buttonColor: mainTextColor,
                                        buttonTextColor: whiteColor,
                                      )
                                    ],
                                  )
                                : const CustomButton(
                                    buttonText: "Next",
                                    buttonColor: mainTextColor,
                                    buttonTextColor: whiteColor,
                                  ),
                          )
                        : showSignupScreen
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const VisitorSignupScreen(),
                                        ),
                                      );
                                      //navigate to visitor signup screen
                                    },
                                    child: const CustomButton(
                                      buttonText: "I’m looking for a Handy Man",
                                      buttonColor: whiteColor,
                                      buttonTextColor: mainTextColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //navigate to handy man signup screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HandymanSignupScreen(),
                                        ),
                                      );
                                    },
                                    child: const CustomButton(
                                      buttonText: "I’m looking for work",
                                      buttonColor: mainTextColor,
                                      buttonTextColor: whiteColor,
                                    ),
                                  )
                                ],
                              )
                            : const CustomButton(
                                buttonText: "Next",
                                buttonColor: mainTextColor,
                                buttonTextColor: whiteColor,
                              ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
