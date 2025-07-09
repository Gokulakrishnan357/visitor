import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../Components/Utills/TextformFiled.dart';
import '../../../../../Controller/UserController.dart';
import '../../../../../Controller/VisitorController.dart';
import '../../../../../Model/SingleVisitorModel.dart';
import '../../../../../Model/UserModel.dart';
import '../../HomeScreen.dart';
import '../../SubScreens/BottomNavBar.dart';
import '../LogScreen.dart';
import '../MemberScreen.dart';
import '../ProfileScreen.dart';

class AddVisitorForm extends StatefulWidget {
  final int? visitorId;

  const AddVisitorForm({super.key, this.visitorId});

  @override
  State<AddVisitorForm> createState() => _AddVisitorFormState();
}

class _AddVisitorFormState extends State<AddVisitorForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final meetingPersonController = TextEditingController();
  String? selectedPurpose;
  TimeOfDay? selectedTime;
  TimeOfDay? outTime;
  final int _currentIndex = 0;
  XFile? personImage;
  XFile? idProofImage;
  int? userId;
  late VisitorController visitorController;
  late UserController userController;
  bool isLoadingVisitor = true;
  final TextEditingController _timeController = TextEditingController();
  bool isCheckoutPressed = false;
  VisitorInfo? visitorInfo;
  final TextEditingController _dummyController = TextEditingController();
  bool isReadonlyMode = false;
  bool isCheckoutDone = false;
  bool selectedTime1 = false;

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

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    visitorController = Get.find<VisitorController>();
    userController = Get.find<UserController>();

    // Fetch user data
    _fetchUserDetails();

    if (widget.visitorId != null) {
      _fetchVisitorDetails(widget.visitorId!);
    }
  }

  bool get canSubmit =>
      nameController.text.isNotEmpty &&
      selectedTime != null &&
      personImage != null &&
      idProofImage != null &&
      userId != null;

  // Asynchronous function to fetch user details
  Future<void> _fetchUserDetails() async {
    UserModel? userModel = await userController.fetchAllUsers();

    if (userModel != null &&
        userModel.data?.users != null &&
        userModel.data!.users!.isNotEmpty) {
      // Extract the first user
      Users firstUser = userModel.data!.users![0];

      // Get the userId
      userId = firstUser.userId;

      if (userId != null) {
        print("User ID: $userId");
      } else {
        print("User ID is null");
      }
    } else {
      print("No users found");
    }
  }

  Future<void> _fetchVisitorDetails(int visitorId) async {
    final fetchedVisitorInfo = await visitorController.getVisitorById(
      visitorId,
    );

    if (fetchedVisitorInfo != null) {
      setState(() {
        isCheckoutPressed = true;
        visitorInfo = fetchedVisitorInfo;

        nameController.text = fetchedVisitorInfo.visitorName ?? '';
        phoneController.text = fetchedVisitorInfo.phone ?? '';
        selectedPurpose = fetchedVisitorInfo.purpose;
        meetingPersonController.text = fetchedVisitorInfo.meetingPerson ?? '';

        selectedTime =
            fetchedVisitorInfo.inTime != null
                ? TimeOfDay.fromDateTime(
                  DateTime.parse(fetchedVisitorInfo.inTime!),
                )
                : null;

        outTime =
            fetchedVisitorInfo.outTime != null
                ? TimeOfDay.fromDateTime(
                  DateTime.parse(fetchedVisitorInfo.outTime!),
                )
                : null;

        isLoadingVisitor = false;
      });
    } else {
      print('Failed to fetch visitor details');
      setState(() => isLoadingVisitor = false);
    }
  }

  Future<void> _pickImage(Function(XFile) onImagePicked) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      onImagePicked(image);
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

  void _submitForm({required int userId}) async {
    if (_formKey.currentState!.validate() &&
        selectedPurpose != null &&
        selectedTime != null &&
        personImage != null &&
        idProofImage != null &&
        phoneController.text.length == 10) {
      // Show confirmation dialog
      _showConfirmDialog(userId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please check and confirm that all fields are filled...',
          ),
        ),
      );
    }
  }

  void _showConfirmDialog(int userId) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_note_sharp,
                    size: 40,
                    color: const Color(0xFF0C9854),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Confirm this Visitor Details",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C9854),
                          minimumSize: const Size(50, 35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();

                          DateTime now = DateTime.now();
                          DateTime combinedDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );

                          String formattedTime = DateFormat(
                            'HH:mm',
                          ).format(combinedDateTime);

                          final visitor = await visitorController.createVisitor(
                            visitorName: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                            purpose: selectedPurpose!,
                            meetingPerson: meetingPersonController.text.trim(),
                            personImageUrl: personImage?.path,
                            idProofImageUrl: idProofImage?.path,
                            intime: formattedTime,
                            userId: userId,
                          );

                          if (visitor != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Visitor added successfully."),
                              ),
                            );

                            // 🔁 Fetch updated visitor list after mutation
                            await visitorController.fetchVisitors();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LogScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to add visitor.")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget build(BuildContext context) {
    final canCheckOut = outTime != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isCheckoutPressed ? "Visitor Log" : "Add New Visitor",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            _buildLabel("Visitor Name"),
            CustomTextFormField(
              hintText: 'Enter name',
              controller: nameController,
              readOnly: isReadonlyMode || isCheckoutPressed,
              onChanged: (_) => setState(() {}), // Trigger rebuild
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              validator: (val) => val!.isEmpty ? "Please enter name" : null,
            ),
            const SizedBox(height: 16),
            _buildLabel("Phone"),
            Row(
              children: [
                const Text("🇮🇳 +91"),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextFormField(
                    hintText: 'Enter your mobile number',
                    controller: phoneController,
                    onChanged: (_) => setState(() {}),
                    readOnly: isReadonlyMode || isCheckoutPressed,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                        return 'Enter a valid Indian mobile number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildLabel("Purpose"),

            DropdownButtonFormField<String>(
              value: selectedPurpose,
              onChanged:
                  isCheckoutPressed
                      ? null
                      : (val) {
                        setState(() {
                          selectedPurpose = val;
                        });
                      },
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: purposeColors[selectedPurpose] ?? Color(0xFFF2994A),
              ),
              hint: Text(
                "Select Purpose",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFFA4A4A4),
                ),
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFFD4D4D4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Color(0xFFD4D4D4),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
              items:
                  purposeColors.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Center(
                            child: Text(
                              entry.key,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: entry.value,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              validator: (val) => val == null ? "Please select purpose" : null,
            ),

            const SizedBox(height: 16),
            _buildLabel("Meeting Person"),
            CustomTextFormField(
              hintText: 'Enter name',
              controller: meetingPersonController,
              readOnly: isReadonlyMode || isCheckoutPressed,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              validator:
                  (val) => val!.isEmpty ? "Please enter meeting person" : null,
            ),
            const SizedBox(height: 16),

            // Time Fields Section (depending on isCheckoutPressed)
            isCheckoutPressed ? _buildInOutTimeRow() : _buildTimeFields(),

            const SizedBox(height: 24),

            if (widget.visitorId == null && !isReadonlyMode) ...[
              _buildImagePicker(
                label: "Person Image",
                image: personImage,
                onPick: (file) => setState(() => personImage = file),
              ),
              const SizedBox(height: 24),
              _buildImagePicker(
                label: "ID Proof",
                image: idProofImage,
                onPick: (file) => setState(() => idProofImage = file),
              ),
            ],

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 26.0,
              ),
              child:
                  widget.visitorId != null
                      ? isLoadingVisitor
                          ? const Center(child: CircularProgressIndicator())
                          : visitorInfo != null
                          ? (visitorInfo!.outTime != null ||
                                  (isCheckoutPressed && isReadonlyMode))
                              ? Column(
                                children: [
                                  if (visitorInfo!.outTime == null)
                                    Text(
                                      "User Check-in Checkout is Done",
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: const Color(0xFF0C448E),
                                      ),
                                    )
                                  else
                                    Builder(
                                      builder: (context) {
                                        final parsedDate = DateTime.tryParse(
                                          visitorInfo!.outTime ?? '',
                                        );

                                        final formattedDate =
                                            parsedDate != null
                                                ? DateFormat(
                                                  'dd.MM.yyyy',
                                                ).format(parsedDate)
                                                : '';

                                        return Center(
                                          child: Text(
                                            "Checkout is Done for this Visitor on $formattedDate",
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: const Color(0xFF0C448E),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              )
                              : Center(
                                child: ElevatedButton(
                                  onPressed:
                                      canCheckOut
                                          ? () async {
                                            if (visitorInfo?.visitorId !=
                                                null) {
                                              final now = TimeOfDay.now();
                                              final outTimeStr =
                                                  "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                                              outTime = now;

                                              final updatedVisitor =
                                                  await visitorController
                                                      .updateVisitorOutTime(
                                                        userId: userId!,
                                                        visitorId:
                                                            visitorInfo!
                                                                .visitorId!,
                                                        outTime: outTimeStr,
                                                      );

                                              if (updatedVisitor != null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Visitor checked out successfully...!",
                                                    ),
                                                  ),
                                                );
                                                setState(() {
                                                  isCheckoutPressed = true;
                                                  isReadonlyMode = true;
                                                  visitorInfo = VisitorInfo(
                                                    visitorId:
                                                        visitorInfo!.visitorId,
                                                    visitorName:
                                                        visitorInfo!
                                                            .visitorName,
                                                    inTime: visitorInfo!.inTime,
                                                    outTime: outTimeStr,
                                                  );
                                                  isCheckoutDone =
                                                      true; // Mark checkout as done
                                                });
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Failed to check out visitor.",
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Visitor ID not found.",
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          : null, // Disabled when outTime is not selected
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        canCheckOut
                                            ? const Color(0xFF0C9854)
                                            : const Color(
                                              0xFF0C9854,
                                            ).withOpacity(0.5),
                                    minimumSize: const Size(300, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    'Check - Out',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                          : const Center(
                            child: Text(
                              "Failed to load visitor info.",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                      : Padding(
                        padding: const EdgeInsets.only(
                          left: 25.0,
                        ), // Uniform left padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: ElevatedButton(
                                onPressed:
                                    canSubmit
                                        ? () => _submitForm(userId: userId!)
                                        : null, // Disable if canSubmit is false

                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      canSubmit
                                          ? const Color(0xFF0C9854)
                                          : const Color(
                                            0xFF0C9854,
                                          ).withOpacity(0.5),
                                  minimumSize: const Size(150, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  'Submit',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
            ),


            const SizedBox(height: 80), // Space for FAB
          ],
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

  Widget _buildTimeFields() {
    final isCheckOut = widget.visitorId != null;

    return Row(
      children: [
        // In-Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("In - Time"),

              GestureDetector(
                onTap: () async {
                  final now = TimeOfDay.now();
                  setState(() => selectedTime = now);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Current time selected: ${now.format(context)}',
                      ),
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hintText: selectedTime?.format(context) ?? '-',
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: Color(0xFF777777),
                    ),

                    controller: _dummyController,
                    validator: (val) {
                      if (selectedTime == null) {
                        return "Please select in time";
                      }
                      return null;
                    },
                    readOnly: isReadonlyMode || isCheckoutPressed,
                    hintTextStyle: TextStyle(
                      fontWeight:
                          selectedTime != null
                              ? FontWeight.bold
                              : FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),
        // Out-Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Out - Time"),
              GestureDetector(
                onTap:
                    isCheckOut
                        ? () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) setState(() => outTime = time);
                        }
                        : null,
                child: AbsorbPointer(
                  absorbing: !isCheckOut,
                  child: CustomTextFormField(
                    hintText: outTime?.format(context) ?? '-',
                    suffixIcon: Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color:
                          isCheckOut ? Color(0xFF777777) : Colors.grey.shade400,
                    ),
                    controller: _dummyController,
                    validator: (val) {
                      if (isCheckOut && outTime == null) {
                        return "Please select out time";
                      }
                      return null;
                    },
                    readOnly: isReadonlyMode || isCheckoutPressed,
                    hintTextStyle: TextStyle(
                      fontWeight:
                          outTime != null ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                      color: isCheckOut ? Colors.black : Colors.grey.shade400,
                    ),
                    filled: true,
                    fillColor: isCheckOut ? Colors.white : Colors.grey.shade100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInOutTimeRow() {
    return Row(
      children: [
        // In-Time (read-only)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("In - Time"),
              GestureDetector(
                onTap: null,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hintText:
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : '-',
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: Color(0xFF777777),
                    ),
                    controller: _dummyController,
                    readOnly: isReadonlyMode || isCheckoutPressed,
                    validator: (val) {
                      if (selectedTime == null) {
                        return "Please select in time";
                      }
                      return null;
                    },
                    hintTextStyle: TextStyle(
                      fontWeight:
                          selectedTime != null
                              ? FontWeight.bold
                              : FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),
        // Out-Time (editable only if isCheckoutPressed)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Out - Time"),
              GestureDetector(
                onTap:
                    (isCheckoutPressed && outTime == null)
                        ? () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) setState(() => outTime = time);
                        }
                        : null,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hintText: outTime != null ? outTime!.format(context) : '-',
                    suffixIcon: const Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: Color(0xFF777777),
                    ),

                    controller: _dummyController,
                    readOnly: true, // Always true to match In Time behavior
                    validator: (val) {
                      if (isCheckoutPressed && outTime == null) {
                        return "Please select out time";
                      }
                      return null;
                    },
                    hintTextStyle: TextStyle(
                      fontWeight:
                          outTime != null ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: const Color(0xFF282727),
      ),
    ),
  );

  Widget _buildImagePicker({
    required String label,
    required XFile? image,
    required Function(XFile) onPick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFFD4D4D4), width: 1),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Center(
                  child: Text(
                    image != null
                        ? "Image selected"
                        : "Take a ${label.toLowerCase()}",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color:
                          image != null
                              ? const Color(0xFF0C448E)
                              : const Color(0xFFA4A4A4),
                      fontWeight:
                          image != null ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () => _pickImage(onPick),
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text("Take Photo"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C448E),
                  foregroundColor: Colors.white,
                  fixedSize: const Size(140, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  textStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
