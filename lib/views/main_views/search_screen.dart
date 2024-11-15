import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/utils/functions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> jobCategories = [
    'Mason',
    'Carpenter',
    'Plumber',
    'Electrician',
    'Painter',
    'Landscaper',
  ];
  String? selectedLocation;
  final List<String> locations = ['Colombo', 'Gampaha', 'Kandy', 'Galle'];

  List<Map<String, dynamic>> matchedHandymen = [];
  bool isLoading = false;

  Future<void> _searchHandymen() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a category to search')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Query queryRef = FirebaseFirestore.instance
          .collection('handymen')
          .where('handyManJobTitle', isEqualTo: query);

      if (selectedLocation != null && selectedLocation!.isNotEmpty) {
        queryRef =
            queryRef.where('handyManAddress', isEqualTo: selectedLocation);
      }

      final querySnapshot = await queryRef.get();
      setState(() {
        matchedHandymen = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      if (mounted) {
        UtilFuctions().showSnackBar(context, "Error searching Handy Man ");
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
            // Search Field with Auto-suggestion
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                fillColor: whiteColor,
                filled: true,
                labelText: 'Search by Category',
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
                hintText: 'Enter job category (e.g., Plumber)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchHandymen,
                ),
              ),
              onChanged: (value) {
                // Update auto-suggestion based on typed text
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: jobCategories
                  .where((category) => category
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .map(
                    (category) => GestureDetector(
                      onTap: () {
                        setState(() => _searchController.text = category);
                      },
                      child: Chip(
                        label: Text(
                          category,
                          style: const TextStyle(color: Colors.black),
                        ),
                        backgroundColor: whiteColor,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            // Location Dropdown
            DropdownButtonFormField<String>(
              value: selectedLocation,
              items: locations
                  .map(
                    (location) => DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedLocation = value);
              },
              decoration: InputDecoration(
                focusedBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: mainTextColor),
                ),
                labelStyle: const TextStyle(
                  color: mainTextColor,
                ),
                fillColor: whiteColor,
                filled: true,
                labelText: "Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: mainTextColor,
                  size: 20,
                ),
              ),
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
