import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Configuration/Graphql_Config.dart';
import '../../../Controller/VisitorController.dart';
import '../../../Model/VisitorModel.dart';
import '../../../Service/GraphqlService/Graphql_Service.dart';
import '../Auth/LoginScreen/LoginScreen.dart';
import '../HomeScreen/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  const SplashScreen({super.key, this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Visitors> recentVisitors = [];

  late VisitorController visitorController;

  @override
  void initState() {
    super.initState();
    final graphqlService = GraphQLService(GraphQLConfig().client.value);
    visitorController = VisitorController(graphqlService);
    fetchVisitors();
    _checkLoginStatus();
  }

  Future<void> fetchVisitors() async {
    List<Visitors>? fetchedVisitors = await visitorController.fetchVisitors();

    if (fetchedVisitors != null && fetchedVisitors.isNotEmpty) {
      setState(() {
        // Reverse to show newest first, then take top 10
        recentVisitors = fetchedVisitors.reversed.take(10).toList();
      });

      // Optional: Debug output
      print("Visitors count: ${recentVisitors.length}");

      for (var visitor in recentVisitors) {
        "Name: ${visitor.visitorname}, Meeting: ${visitor.meetingperson}";
      }
    } else {
      print("Failed to fetch visitors or empty list received.");
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.get('isLoggedIn');

    // Handle both String and bool types gracefully
    final isLoggedIn = storedValue == true || storedValue == 'true';

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Center(
          child: SizedBox(
            width: 153,
            height: 115.24,
            child: Image.asset(
              'assets/Png/SplashLogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
