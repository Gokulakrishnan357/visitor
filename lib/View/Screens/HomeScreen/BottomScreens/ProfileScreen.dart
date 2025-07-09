import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visitor/View/Screens/HomeScreen/BottomScreens/LogScreen.dart';
import 'package:visitor/View/Screens/HomeScreen/BottomScreens/MemberScreen.dart';
import 'package:visitor/View/Screens/HomeScreen/BottomScreens/VisitorScreen/AddVisitorScreen.dart';
import '../../../../Components/Utills/TextformFiled.dart';
import '../HomeScreen.dart';
import '../SubScreens/BottomNavBar.dart';
import '../SubScreens/LogOutScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  File? _selectedImage;
  final TextEditingController nameController = TextEditingController(
    text: "dyson manufacturing Pvt Ltd",
  );
  final _formKey = GlobalKey<FormState>();

  final int _currentIndex = 3;

  void _onNavItemTapped(int index) {
    if (index == _currentIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = HomeScreen();
        break;
      case 1:
        nextScreen = LogScreen();
        break;
      case 2:
        nextScreen = MemberScreen();
        break;
      case 3:
        nextScreen = ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  Future<void> _pickImage() async {
    if (!isEditing) return;

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 101),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child:
                              _selectedImage != null
                                  ? Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.asset(
                                    'assets/Png/UserProfile.png',
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -20,
                      right: -100,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            'assets/Png/Edit_icon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                if (!isEditing)
                  Text(
                    nameController.text,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),

                if (isEditing)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: CustomTextFormField(
                      hintText: 'Enter profile name',
                      controller: nameController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z\s]'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                  ),

                const SizedBox(height: 20),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE4E4E4),
                  indent: 16,
                  endIndent: 16,
                ),
                const SizedBox(height: 30),

                if (!isEditing)
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD71920),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        showLogoutDialog(context);
                      },

                      child: Text(
                        'Logout',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                if (isEditing)
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C448E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isEditing = false;
                          });
                          // TODO: Submit profile data
                        }
                      },
                      child: Text(
                        'Submit',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
        onAddTap: () {
          print("Floating Add tapped");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddVisitorForm()),
          );
        },
      ),
    );
  }
}
