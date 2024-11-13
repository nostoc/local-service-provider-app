import 'package:flutter/material.dart';
import 'package:local_service_provider_app/utils/colors.dart';

class SharedOnboardingScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  const SharedOnboardingScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: mainTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF434344),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
