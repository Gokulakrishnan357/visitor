import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../Components/Utills/CommonSearchBar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Configuration/Graphql_Config.dart';
import '../../../Controller/VisitorController.dart';
import '../../../Model/VisitorModel.dart';
import '../../../Service/GraphqlService/Graphql_Service.dart';
import 'BottomScreens/LogScreen.dart';
import 'BottomScreens/MemberScreen.dart';
import 'BottomScreens/ProfileScreen.dart';
import 'BottomScreens/VisitorScreen/AddVisitorScreen.dart';
import 'SubScreens/BottomNavBar.dart';
import 'SubScreens/VisitorCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;
  final TextEditingController searchController = TextEditingController();

  final Color activeColor = const Color(0xFF042C73);
  final Color inactiveColor = const Color(0xFF777777);
  final Color activeBackground = const Color(0x3374AAF3);

  late final VisitorController visitorController;
  List<Visitors> allVisitors = []; // store full list
  List<Visitors> recentVisitors = []; // store recent 100 only (for display)

  bool _showMessage = false;

  @override
  void initState() {
    super.initState();
    final graphqlService = GraphQLService(GraphQLConfig().client.value);
    visitorController = VisitorController(graphqlService);
    fetchVisitors();
    fetchVisitors1();
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showMessage = true;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchVisitors1() async {
    List<Visitors>? fetched = await visitorController.fetchVisitors();

    if (fetched != null) {
      fetched.sort((a, b) {
        final aTime = DateTime.tryParse(a.intime ?? '') ?? DateTime(2000);
        final bTime = DateTime.tryParse(b.intime ?? '') ?? DateTime(2000);
        return bTime.compareTo(aTime); // Sort recent first
      });
    }
  }

  // Call this in your initState or screen load
  Future<void> fetchVisitors() async {
    List<Visitors>? fetchedVisitors = await visitorController.fetchVisitors();

    if (fetchedVisitors != null && fetchedVisitors.isNotEmpty) {
      setState(() {
        allVisitors = fetchedVisitors; // full list for total count
        recentVisitors =
            fetchedVisitors.reversed
                .take(100)
                .toList(); // latest 100 for display
      });

      print("Total Visitors count: ${allVisitors.length}");
      print("Recent Visitors shown: ${recentVisitors.length}");

      for (var visitor in allVisitors) {
        print(
          "Name: ${visitor.visitorname}, Meeting: ${visitor.meetingperson}",
        );
      }
    } else {
      print("Failed to fetch visitors or empty list received.");
    }
  }

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
    // Helper function to check if a date string is valid and not empty
    bool isValidDate(String? dateStr) {
      if (dateStr == null || dateStr.trim().isEmpty) return false;
      return DateTime.tryParse(dateStr) != null;
    }

    // Debugging each visitor’s info
    for (var visitor in recentVisitors) {
      print(
        'Visitor: ${visitor.visitorname}, In: ${visitor.intime}, Out: ${visitor.outtime}',
      );
    }

    // Total visitors count
    int totalVisitorsCount = recentVisitors.length;

    // Count checked-in visitors (valid intime, missing or empty outtime)
    int checkInCount =
        recentVisitors.where((visitor) {
          return isValidDate(visitor.intime) && !isValidDate(visitor.outtime);
        }).length;

    // Count checked-out visitors (both valid intime and outtime)
    int checkOutCount =
        recentVisitors.where((visitor) {
          return isValidDate(visitor.intime) && isValidDate(visitor.outtime);
        }).length;

    print('Total Visitors Count: $totalVisitorsCount');
    print('Checked-in Visitors Count: $checkInCount');
    print('Checked-out Visitors Count: $checkOutCount');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 60,
          flexibleSpace: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/Png/SplashLogo.png',
                    width: 80,
                    height: 55,
                    fit: BoxFit.contain,
                  ),
                  Image.asset(
                    'assets/Png/Notification.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar and header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                CommonSearchBar(
                  controller: searchController,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogScreen()),
                    );
                  },
                ),

                const SizedBox(height: 26),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: Container(
              color: const Color(0xFFF4F4F4),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 372,
                      height: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                        border: const Border(
                          bottom: BorderSide(
                            color: Color(0xFFFFA1A1),
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.asset(
                              'assets/Png/Visitor_count.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF606060),
                                  ),
                                ),
                                Text(
                                  "Visitor’s",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            recentVisitors.length.toString(),
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(minHeight: 90),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: const Border(
                                bottom: BorderSide(
                                  color: Color(0xFF8DBBDC),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'assets/Png/Check_in.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Check-In',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF777777),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$checkInCount',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            constraints: BoxConstraints(minHeight: 90),
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: const Border(
                                bottom: BorderSide(
                                  color: Color(0xFF6FD277),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'assets/Png/Check_out.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Check-Out',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF777777),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$checkOutCount',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Visit Log',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'View All >>>',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0C448E),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentVisitors.length,
                      itemBuilder: (context, index) {
                        final visitor = recentVisitors[index];

                        // If already checked out, show overlay 'View' button
                        if (visitor.outtime != null &&
                            visitor.outtime!.isNotEmpty) {
                          return Stack(
                            children: [
                              VisitorCard(visitor: visitor),
                              Positioned(
                                right: 10,
                                bottom: 22,
                                child: GestureDetector(
                                  onTap:
                                      () =>
                                          _handleCheckOutTap(context, visitor),
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'View',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        // Otherwise, show the regular VisitorCard
                        return VisitorCard(visitor: visitor);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  void _handleCheckOutTap(BuildContext context, Visitors visitor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVisitorForm(visitorId: visitor.visitorid),
      ),
    );
  }
}
