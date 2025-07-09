import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Components/Utills/TextformFiled.dart';
import '../../../../Controller/UserController.dart';
import '../../../../Model/UserModel.dart';
import '../../../../Service/GraphqlService/Graphql_Service.dart';
import '../../HomeScreen/HomeScreen.dart';
import '../RegisterScreen/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController contactController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contactController.addListener(_handleInputChange);
  }

  void _handleInputChange() {
    final value = contactController.text;

    // Allow only digits if input is number and limit to 10
    if (RegExp(r'^\d*$').hasMatch(value)) {
      if (value.length > 10) {
        contactController.text = value.substring(0, 10);
        contactController.selection = TextSelection.fromPosition(
          TextPosition(offset: contactController.text.length),
        );
      }
    }
  }

  // Function to login user
  Future<void> _login() async {
    final emailOrPhone = contactController.text.trim();
    final password = passwordController.text.trim();

    if (emailOrPhone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please Wait Verify Login...")),
    );

    final userController = UserController(
      GraphQLService(GraphQLProvider.of(context).value),
    );

    final result = await userController.loginUser(emailOrPhone, password);
    final user = result['user'] as Users?;
    final message = result['message'] as String?;

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      showLoginWelcomeDialog(context, username: user.companyname ?? "User");

      await Future.delayed(const Duration(seconds: 4));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } else {
      showErrorDialog(context, message: message ?? "Login failed.");
    }
  }

  void showLoginWelcomeDialog(
    BuildContext context, {
    required String username,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          color: Color(0xFF0C448E),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'You’ve successfully Login',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0C448E),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Text(
                      'Welcome $username...!',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Just close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0C448E),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void showErrorDialog(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFDA1A0C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDA1A0C),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  // Logo
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Png/SplashLogo.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Email or Phone Field Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "E-Mail (or) Phone No",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // TextField with border
                  CustomTextFormField(
                    hintText: "Enter Your mail id (or) Phone number",
                    controller: contactController,
                    keyboardType:
                        TextInputType.emailAddress, // remove duplicate
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number or mail id required';
                      }

                      final isDigitsOnly = RegExp(r'^\d+$').hasMatch(value);
                      final isEmail = RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value);

                      if (isDigitsOnly) {
                        if (value.length != 10) {
                          return 'Enter a valid 10-digit phone number';
                        }
                      } else if (!isEmail) {
                        return 'Please enter a valid email address that matches with your domain';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  CustomTextFormField(
                    hintText: "Enter password",
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    showSuffixIcon: true,
                    togglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: 320,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0C448E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          height: 1.0, // 100% line-height
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Divider(color: Color(0xFFD4D4D4), thickness: 1, height: 32),

                  const SizedBox(height: 10),

                  // Divider with text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If you don’t have account ?",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),

                      // Add space between the texts
                      SizedBox(width: 8),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Click Here",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0059FF),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Google Sign-in
                  Container(
                    width: 310,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Google sign-in logic
                      },
                      child: Center(
                        child: Image.asset(
                          'assets/Png/google_icon.png',
                          height: 700,
                          width: 300, // Increased width
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
