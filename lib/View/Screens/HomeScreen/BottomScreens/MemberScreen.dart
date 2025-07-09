import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../HomeScreen.dart';
import '../SubScreens/BottomNavBar.dart';
import 'AddMemberScreen.dart';
import 'LogScreen.dart';
import 'ProfileScreen.dart';
import 'VisitorScreen/AddVisitorScreen.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final TextEditingController searchController = TextEditingController();
  final int _currentIndex = 2;

  final List<MemberModel> members = [
    MemberModel(name: "Arlene McCoy", role: "Receptionist", isActive: true),
    MemberModel(name: "Leslie Alexander", role: "Security", isActive: false),
    MemberModel(name: "Arlene McCoy", role: "Receptionist", isActive: true),
    MemberModel(name: "Arlene McCoy", role: "Receptionist", isActive: true),
    MemberModel(name: "Arlene McCoy", role: "Receptionist", isActive: true),
    MemberModel(name: "Arlene McCoy", role: "Receptionist", isActive: true),

  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: Colors.white,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search a log",
                  hintStyle: GoogleFonts.montserrat(),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF2F2F2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Member list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return MemberCard(member: member);
                },
              ),
            ),

            // Add member button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddMemberScreen()),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C448E),
                  minimumSize: const Size(320, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: Text(
                  "Add Member",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
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

class MemberModel {
  final String name;
  final String role;
  final bool isActive;

  MemberModel({required this.name, required this.role, required this.isActive});
}

class MemberCard extends StatelessWidget {
  final MemberModel member;

  const MemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 372,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 21,
            backgroundImage: AssetImage(
              "assets/Png/Member_Profile_Icon.png",
            ), // replace with actual image path
          ),
          const SizedBox(width: 12),

          // Name and Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  member.name,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  member.role,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: const Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color:
                  member.isActive
                      ? const Color(0xFF27AE60)
                      : const Color(0xFFD00416),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              member.isActive ? "Active" : "Deactivate",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
