import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Model/VisitorModel.dart';
import '../BottomScreens/VisitorScreen/AddVisitorScreen.dart';

class VisitorCard extends StatelessWidget {
  final Visitors visitor;

  const VisitorCard({super.key, required this.visitor});

  String _formatTime(BuildContext context, String? timeString) {
    if (timeString == null || timeString.isEmpty) return '-';

    try {
      final timeOfDay = TimeOfDay.fromDateTime(DateTime.parse(timeString));
      return timeOfDay.format(context); // Formats like 8:30 PM
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> purposeColors = {
      'Client Meeting': Color(0xFF6C63FF),
      'Job Interview': Color(0xFFE91E63),
      'Delivery': Color(0xFF4CAF50),
      'Maintenance Work': Color(0xFF2196F3),
      'Audit/Inspection': Color(0xFFFFC107),
      'Training/Workshop': Color(0xFF9C27B0),
      'Official Visit': Color(0xFF009688),
      'Family Visit': Color(0xFFFF5722),
      'Project Discussion': Color(0xFF3F51B5),
      'Others': Color(0xFF607D8B),
    };

    // Get the color for the purpose from the map, default to a fallback color if not found
    Color purposeColor =
        purposeColors[visitor.purpose ?? ''] ??
        Color(0xFF000000); // Default black

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Section
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFFFF0000),
                        child: Text(
                          visitor.visitorname?[0] ?? 'V',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          visitor.visitorname ?? '',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: const Color(0xFF333333),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    visitor.phone ?? '',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xFF777777),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      visitor.purpose ?? '',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: purposeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Section
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 30,
                  width: 95,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Png/Logout.png',
                        width: 23,
                        height: 23,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          _formatTime(context, visitor.intime),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: const Color(0xFF777777),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                if (visitor.outtime == null || visitor.outtime!.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: () => _handleCheckOutTap(context, visitor),
                      child: Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color(0xFF289931),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Check-Out',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
