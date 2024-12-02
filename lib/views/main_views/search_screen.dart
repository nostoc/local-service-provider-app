import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/utils/functions.dart';
import 'package:local_service_provider_app/views/handyman/handy_man_profile_view.dart';
import 'package:local_service_provider_app/widgets/reusable_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _locationController = TextEditingController();
  final List<String> jobCategories = [
    "Air Conditioning",
    "Architect",
    "Carpenter",
    "CCTV",
    "Ceiling",
    "Chair Weavers",
    "Cleaners",
    "Contractor",
    "Curtains",
    "Electrician",
    "Gully Bowser",
    "Landscaper",
    "Mason",
    "Movers",
    "Painter",
    "Pest Control",
    "Plumber",
    "Rent Tools",
    "Solar Panel Fixing",
    "Stones/Sand/Soil",
    "Tile",
    "Vehicle Repairing"
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
        matchedHandymen = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['handyManId'] = doc.id; // Add the document ID to the data
          return data;
        }).toList();
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
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Center(
          child:  Text(
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
                              color: whiteColor,
                              elevation: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius:
                                      30, // Slightly smaller radius for balance
                                  backgroundImage: NetworkImage(
                                    handyman['handyManImageUrl'],
                                  ),
                                ),
                                title: Text(
                                  handyman['handyManName'] ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight:
                                        FontWeight.bold, // Bold for emphasis
                                    color: mainTextColor,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      handyman['handyManPhone'] ?? 'No Phone',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors
                                            .grey, // Lighter color for phone
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      handyman['handyManAddress'] ??
                                          'No Address',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                isThreeLine: true,
                                contentPadding:
                                    EdgeInsets.zero, // Remove extra padding
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HandymanProfileView(
                                        handymanId: handyman[
                                            'handyManId'], // Pass the document ID
                                      ),
                                    ),
                                  );
                                },
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
