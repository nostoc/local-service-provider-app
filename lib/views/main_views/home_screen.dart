import 'package:flutter/material.dart';
import 'package:local_service_provider_app/views/main_views/list_screen.dart';
import '../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Map of categories and their respective image paths
  final Map<String, String> categoryImages = {
    'Mason': 'assets/images/mason.jpg',
    'Carpenter': 'assets/images/carpenter1.jpg',
    'Plumber': 'assets/images/plumber.jpg',
    'Electrician': 'assets/images/electrician.jpg',
    'Painter': 'assets/images/painter.jpg',
    'Landscaper': 'assets/images/landscaper.jpg',
    'Tile': 'assets/images/tile.jpg',
    'Air Conditioning': 'assets/images/airconditioning.jpg',
    'Ceiling': 'assets/images/ceiling.jpg',
    'Vehicle Repairing': 'assets/images/vehicle-repairing.jpg',
    'Contractor': 'assets/images/contractor.jpg',
    'Gully Bowser': 'assets/images/gully-bowser.jpg',
    'Architects': 'assets/images/architects.jpg',
    'Solar Panel fixing': 'assets/images/solarpanel.jpg',
    'Curtains': 'assets/images/curtains.jpg',
    'Pest COntrol': 'assets/images/pest-control.jpg',
    'Cleaners': 'assets/images/cleaners.jpg',
    'Chair Weavers': 'assets/images/chairweavers.jpg',
    'Stones/Sand/Soil': 'assets/images/stones-soil-sand.jpg',
    'CCTV': 'assets/images/cctv.jpg',
    'Movers': 'assets/images/movers.jpg',
    'Rent Tools': 'assets/images/rent-tools.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Categories",
            style: TextStyle(
              color: whiteColor,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: mainTextColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
          ),
          itemCount: categoryImages.length,
          itemBuilder: (context, index) {
            final category = categoryImages.keys.elementAt(index);
            final imagePath = categoryImages[category];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HandymenListScreen(category: category),
                  ),
                );
              },
              child: Card(
                borderOnForeground: true,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          imagePath!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: mainTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
