import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/utils/functions.dart';
import 'package:local_service_provider_app/widgets/reusable_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _locationController = TextEditingController();
  final List<String> jobCategories = [
     'Mason',
    'Carpenter',
    'Plumber',
    'Electrician',
    'Painter',
    'Landscaper',
    'Tile',
    'Air Conditioning',
    'Ceiling',
    'Vehicle Repairing',
    'Contractor',
    'Gully Bowser',
    'Architects',
    'Solar Panel fixing',
    'Curtains',
    'Pest COntrol',
    'Cleaners',
    'Chair Weavers',
    'Stones/Sand/Soil',
    'CCTV',
    'Movers',
    'Rent Tools',
  ];
  String? selectedCategory;

  List<Map<String, dynamic>> matchedHandymen = [];
  bool isLoading = false;

  Future<void> _searchHandymen() async {
    final category = selectedCategory; // Use selectedCategory
    final locationKeyword = _locationController.text.trim().toLowerCase();

    // Ensure category is selected
    if (category == null || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category to search')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Start with the basic query for the selected category
      Query queryRef = FirebaseFirestore.instance
          .collection('handymen')
          .where('handyManJobTitle', isEqualTo: category);

      // Apply location filter if provided
      if (locationKeyword.isNotEmpty) {
        queryRef = queryRef.where(
          'addressKeywords',
          arrayContains: locationKeyword,
        );
      }

      final querySnapshot = await queryRef.get();

      setState(() {
        matchedHandymen = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      if (mounted) {
        UtilFuctions().showSnackBar(context, "Error searching handymen: $e");
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Search Handymen",
            style: TextStyle(
              color: whiteColor,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: mainTextColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: jobCategories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value);
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: mainTextColor),
                ),
                labelStyle: const TextStyle(color: mainTextColor),
                fillColor: whiteColor,
                filled: true,
                labelText: "Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                prefixIcon: const Icon(
                  Icons.work,
                  color: mainTextColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Location Text Field (Optional)
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                fillColor: whiteColor,
                filled: true,
                labelText: 'Location (Optional)',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainTextColor),
                  borderRadius: BorderRadius.circular(22),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainTextColor),
                  borderRadius: BorderRadius.circular(22),
                ),
                labelStyle: const TextStyle(
                  fontSize: 18,
                  color: mainTextColor,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Enter location keyword (e.g., Colombo)',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: mainTextColor,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ReusableButton(
              buttonText: "Search",
              buttonColor: mainTextColor,
              buttonTextColor: whiteColor,
              width: double.infinity,
              onPressed: _searchHandymen,
            ),
            const SizedBox(height: 16),
            // Search Results
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : matchedHandymen.isEmpty
                      ? const Center(
                          child: Text('No results found'),
                        )
                      : ListView.builder(
                          itemCount: matchedHandymen.length,
                          itemBuilder: (context, index) {
                            final handyman = matchedHandymen[index];
                            return Card(
                              child: ListTile(
                                leading: handyman['handyManImageUrl'] != null
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          handyman['handyManImageUrl'],
                                        ),
                                      )
                                    : const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                                title:
                                    Text(handyman['handyManName'] ?? 'No Name'),
                                subtitle: Text(
                                    '${handyman['handyManJobTitle'] ?? 'No Job Title'}\n${handyman['handyManAddress'] ?? 'No Address'}'),
                                isThreeLine: true,
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
