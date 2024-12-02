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
    'Air Conditioning': 'assets/images/airconditioning.jpg',
    'Architects': 'assets/images/architects.jpg',
    'Carpenter': 'assets/images/carpenter1.jpg',
    'Ceiling': 'assets/images/ceiling.jpg',
    'Chair Weavers': 'assets/images/chairweavers.jpg',
    'Cleaners': 'assets/images/cleaners.jpg',
    'Contractor': 'assets/images/contractor.jpg',
    'Curtains': 'assets/images/curtains.jpg',
    'CCTV': 'assets/images/cctv.jpg',
    'Electrician': 'assets/images/electrician.jpg',
    'Gully Bowser': 'assets/images/gully-bowser.jpg',
    'Landscaper': 'assets/images/landscaper.jpg',
    'Mason': 'assets/images/mason.jpg',
    'Movers': 'assets/images/movers.jpg',
    'Painter': 'assets/images/painter.jpg',
    'Pest COntrol': 'assets/images/pest-control.jpg',
    'Plumber': 'assets/images/plumber.jpg',
    'Rent Tools': 'assets/images/rent-tools.jpg',
    'Solar Panel fixing': 'assets/images/solarpanel.jpg',
    'Stones/Sand/Soil': 'assets/images/stones-soil-sand.jpg',
    'Tile': 'assets/images/tile.jpg',
    'Vehicle Repairing': 'assets/images/vehicle-repairing.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child:  Text(
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const SizedBox(height: 16.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset(
                              imagePath!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: mainTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
