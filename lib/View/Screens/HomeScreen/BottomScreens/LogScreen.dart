import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../Components/Utills/CommonSearchBar.dart';
import '../../../../Components/Utills/TextformFiled.dart';
import '../../../../Configuration/Graphql_Config.dart';
import '../../../../Controller/VisitorController.dart';
import '../../../../Model/VisitorModel.dart';
import '../../../../Service/GraphqlService/Graphql_Service.dart';
import '../HomeScreen.dart';
import '../SubScreens/BottomNavBar.dart';
import '../SubScreens/VisitorCard.dart';
import 'MemberScreen.dart';
import 'ProfileScreen.dart';
import 'VisitorScreen/AddVisitorScreen.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String selectedFilter = "All";
  final int _currentIndex = 1;

  final Color activeColor = const Color(0xFF042C73);
  final Color inactiveColor = const Color(0xFF777777);
  final Color activeBackground = const Color(0x3374AAF3);

  List<Visitors> allVisitors = [];
  List<Visitors> filteredVisitors = [];

  late VisitorController visitorController;

  bool _showMessage = false;
  bool _showDateFields = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final graphqlService = GraphQLService(GraphQLConfig().client.value);
    visitorController = VisitorController(graphqlService);
    fetchVisitors();

    _timer = Timer(Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _showMessage = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  Future<void> fetchVisitors() async {
    List<Visitors>? fetched = await visitorController.fetchVisitors();
    if (fetched != null) {
      // Sort by updatedat (newest first)
      fetched.sort((a, b) {
        final aTime = DateTime.tryParse(a.updatedat ?? '') ?? DateTime(2000);
        final bTime = DateTime.tryParse(b.updatedat ?? '') ?? DateTime(2000);
        return bTime.compareTo(aTime); // descending
      });

      setState(() {
        allVisitors = fetched;
        applyFilter();
      });
    }
  }

  void applyFilter() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredVisitors =
          allVisitors.where((visitor) {
            final nameMatch = (visitor.visitorname ?? '')
                .toLowerCase()
                .contains(query);
            final phoneMatch = (visitor.phone ?? '').toLowerCase().contains(
              query,
            );
            final purposeMatch = (visitor.purpose ?? '').toLowerCase().contains(
              query,
            );
            final queryMatch =
                query.isEmpty || nameMatch || phoneMatch || purposeMatch;

            // Status filter
            final statusMatch =
                selectedFilter == "All"
                    ? true
                    : selectedFilter == "Check-In"
                    ? visitor.outtime == null
                    : visitor.outtime != null;

            // Date filter
            bool dateMatch = true;
            if (fromDate != null && toDate != null) {
              final updatedAt = DateTime.tryParse(visitor.updatedat ?? '');
              if (updatedAt != null) {
                dateMatch =
                    updatedAt.isAfter(fromDate!.subtract(Duration(days: 1))) &&
                    updatedAt.isBefore(toDate!.add(Duration(days: 1)));
              } else {
                dateMatch = false;
              }
            }

            return queryMatch && statusMatch && dateMatch;
          }).toList();
    });
  }

  void filterSearch(String query) => applyFilter();

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

  void _selectFromDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        fromDate = selectedDate;
        fromDateController.text = dateFormat.format(fromDate!);
      });
      applyFilter();
    }
  }

  void _selectToDate(BuildContext context) async {
    if (fromDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please select From Date first.')));
      return;
    }

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: fromDate!,
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        toDate = selectedDate;
        toDateController.text = dateFormat.format(toDate!);
      });
      applyFilter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 65, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CommonSearchBar(
                        controller: searchController,
                        onChanged: filterSearch,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showDateFields = true;
                        });
                        _selectFromDate(context);
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDEDED),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.calendar_month, size: 28),
                      ),
                    ),
                  ],
                ),

                if (_showDateFields)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            hintText: 'From Date',
                            controller: fromDateController,
                            readOnly: true,
                            suffixIcon: const Icon(
                              Icons.calendar_month,
                              size: 28,
                            ),
                            onTap: () => _selectFromDate(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextFormField(
                            hintText: 'To Date',
                            controller: toDateController,
                            readOnly: true,
                            suffixIcon: const Icon(
                              Icons.calendar_month,
                              size: 28,
                            ),
                            onTap: () => _selectToDate(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 372,
                  height: 36,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          ['All', 'Check-In', 'Check-Out'].map((filter) {
                            final isSelected = selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => selectedFilter = filter);
                                  applyFilter();
                                },
                                child: Container(
                                  width: 110,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Color(0xFF0C448E)
                                            : Color(0xFFEDEDED),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    filter,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child:
                filteredVisitors.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child:
                            _showMessage
                                ? Text(
                                  'No Visitor Results Found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF0C448E),
                                  ),
                                )
                                : const SpinKitFadingCircle(
                                  color: Color(0xFF0C448E),
                                  size: 40.0,
                                ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      itemCount: filteredVisitors.length,
                      itemBuilder: (context, index) {
                        final visitor = filteredVisitors[index];

                        // If already checked out, show overlay 'View' button
                        if (visitor.outtime != null &&
                            visitor.outtime!.isNotEmpty) {
                          return Stack(
                            children: [
                              VisitorCard(visitor: visitor),
                              Positioned(
                                right: 10,
                                bottom: 21,
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
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
        onAddTap: () {
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
