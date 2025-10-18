import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:spar/pages/OTP/modals.dart';
import 'package:spar/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spar/others/userdata.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  OtpPage({required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // Valid OTP for dev mode (replace with backend validation later)
  String validPin = "123456";

  // Stores the OTP entered by the user
  String enteredPin = "";

  // Tracks whether the user has entered all 6 digits of the OTP
  bool isComplete = false;

  // Loading state
  bool _isLoading = false;

  // Instance of AuthService for handling authentication
  final AuthService _auth = AuthService();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Success modal
  void _showSuccessModal() {
    SuccessModal.show(
      context,
      title: "Success",
      autoCloseDuration: Duration(seconds: 2),
      onClose: () {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/homePage',
                (route) => false,
          );
        }
      },
    );
  }

  // Handle OTP verification and sign in
  Future<void> _handleOTPVerification() async {
    if (!isComplete || _isLoading) return;

    if (!formKey.currentState!.validate()) {
      print("Invalid PIN");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print("Valid PIN: $enteredPin");
      print("DEBUG: Checking if user exists with phone: ${widget.phoneNumber}");

      // Check if user already exists with this phone number
      String? existingUserId = await _auth.getUserIdByPhone(widget.phoneNumber);

      dynamic result;

      if (existingUserId != null) {
        // Returning user - sign them in and load their data
        print("DEBUG: Returning user found: $existingUserId");
        result = await _auth.signInExistingUser(existingUserId);

        if (result != null) {
          // Load user data from Firestore
          Map<String, dynamic>? userData = await _auth.getUserData(existingUserId);

          if (userData != null) {
            // Populate UserData with saved information
            UserData.phoneNumber = userData['phoneNumber'];
            UserData.userName = userData['name'];

            print("DEBUG: Loaded user data - Name: ${userData['name']}");
          }
        }
      } else {
        // New user - create account and save to Firestore
        print("DEBUG: New user, creating account");
        result = await _auth.signInAnon(widget.phoneNumber);
      }

      print("DEBUG: Sign-in result: $result");

      // Check if sign-in was successful
      if (result != null && mounted) {
        print("DEBUG: Sign-in successful, showing modal");

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_phone_number', widget.phoneNumber);

        // Show success modal
        _showSuccessModal();
      } else {
        throw Exception("Authentication failed");
      }
    } catch (e) {
      print("ERROR in _handleOTPVerification: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Authentication failed. Please try again.",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions text
              Text(
                "Enter the OTP",
                style: GoogleFonts.poppins(
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              // Phone number display
              Text(
                "${widget.phoneNumber}",
                style: GoogleFonts.poppins(
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFC42348),
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFC42348),
                ),
              ),
              SizedBox(height: 20),

              // Dev mode hint
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFFFB74D)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFFF9800), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Dev Mode: Use 123456 as OTP",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Form with OTP input
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Pinput(
                      validator: (value) {
                        return value == validPin ? null : "Invalid OTP";
                      },
                      onChanged: (pin) {
                        setState(() {
                          enteredPin = pin;
                          isComplete = pin.length == 6;
                        });
                      },
                      length: 6,
                      defaultPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFC42348)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 56,
                        height: 56,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onCompleted: (pin) {
                        print("Completed: $pin");
                        setState(() {
                          enteredPin = pin;
                          isComplete = true;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Continue button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: isComplete && !_isLoading
                            ? _handleOTPVerification
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: isComplete && !_isLoading
                                ? Color(0xFFC42348)
                                : Color(0xFFEDBBC6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: _isLoading
                                ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Resend code option
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(text: "Didn't receive it? "),
                    TextSpan(
                      text: "Resend code ",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC42348),
                      ),
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