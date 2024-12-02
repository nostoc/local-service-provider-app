import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:local_service_provider_app/services/handyman_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_service_provider_app/services/storage_service.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/utils/functions.dart';
import 'package:local_service_provider_app/widgets/custom_input.dart';
import 'package:local_service_provider_app/widgets/reusable_button.dart';

class HandymanProfileScreen extends StatefulWidget {
  const HandymanProfileScreen({super.key});

  @override
  State<HandymanProfileScreen> createState() => _HandymanProfileScreenState();
}

class _HandymanProfileScreenState extends State<HandymanProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _imageUrl = ""; // Placeholder for image URL
  bool _isLoading = false;
  File? _imageFile;

  final List<String> _jobCategories = [
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
  String? _selectedJobCategory;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      setState(() => _isLoading = true);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      try {
        _imageUrl = await HandymanStorageService().uploadImage(
          imageFile: _imageFile!,
          handymanId: user.uid,
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("handymen")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          setState(() {
            _nameController.text = data['handyManName'] ?? '';
            _phoneController.text = data['handyManPhone'] ?? '';
            _addressController.text = data['handyManAddress'] ?? '';
            _imageUrl = data['handyManImageUrl'] ?? '';
            _selectedJobCategory =
                data['handyManJobTitle']; // Correctly fetch Job Title
          });
        }
      }
    } catch (e) {
      if (mounted) {
        UtilFuctions().showSnackBar(context, "Error loading profile: $e");
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) return;
    await _uploadImage();

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await HandymanService().updateUserProfile(
        handyManId: user.uid,
        handyManName: _nameController.text.trim(),
        handyManPhone: _phoneController.text.trim(),
        handyManJobTitle: _selectedJobCategory ?? '',
        handyManImageUrl: _imageUrl, // Add image upload logic later
        handyManAddress: _addressController.text.trim(),
      );

      if (mounted) {
        UtilFuctions().showSnackBar(context, "Profile saved successfully");
      }
    } catch (e) {
      if (mounted) {
        UtilFuctions().showSnackBar(context, "Error saving profile: $e");
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

 

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
          
          backgroundColor: mainTextColor,
          title: const Center(
            child: Text(
              "Your Profile",
              style: TextStyle(
                color: whiteColor,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          )),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const SizedBox(height: 60),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : _imageUrl.isNotEmpty
                                      ? NetworkImage(_imageUrl)
                                      : const NetworkImage(
                                              'https://i.stack.imgur.com/l60Hf.png')
                                          as ImageProvider,
                              backgroundColor: Colors.grey[200],
                            ),
                            Positioned(
                              bottom: -10,
                              right: -6,
                              child: IconButton(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 30),
                          ReusableInput(
                            controller: _nameController,
                            labelText: "Name",
                            icon: Icons.person,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          ReusableInput(
                            controller: _phoneController,
                            labelText: "Phone",
                            icon: Icons.phone,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (!RegExp(r'^\d+$').hasMatch(value)) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          DropdownButtonFormField<String>(
                            value: _selectedJobCategory,
                            items: _jobCategories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedJobCategory = newValue!;
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: mainTextColor),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              labelStyle: const TextStyle(
                                  color: mainTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                              fillColor: whiteColor,
                              filled: true,
                              labelText: "Job Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              prefixIcon: const Icon(
                                Icons.work,
                                color: mainTextColor,
                                size: 20,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your job title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          ReusableInput(
                            controller: _addressController,
                            labelText: "Address",
                            icon: Icons.location_on,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 100),
                          ReusableButton(
                            buttonText: "Save Profile",
                            buttonColor: mainTextColor,
                            buttonTextColor: whiteColor,
                            width: double.infinity,
                            onPressed: _saveUserProfile,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
