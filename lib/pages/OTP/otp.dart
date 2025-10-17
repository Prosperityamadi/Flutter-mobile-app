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
  // valid OTP for now (replace with backend validation later)
  String validPin = "123456";

  // Stores the OTP entered by the user.
  String enteredPin = "";

  // Tracks whether the user has entered all 6 digits of the OTP.
  bool isComplete = false;

  // Instance of AuthService for handling authentication.
  final AuthService _auth = AuthService();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //success modal
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

  @override
  void initState() {
    super.initState();
    // Future OTP setup logic can be added here if needed.
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
              // Displays instructions to the user.
              Text(
                "Enter the OTP sent to ",
                style: GoogleFonts.poppins(
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              // Displays the phone number with custom styling.
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
              SizedBox(height: 40),

              // The form containing the OTP input field and continue button.
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Pinput(
                      // Validates the entered OTP against the valid PIN.
                      validator: (value) {
                        return value == validPin ? null : "Invalid OTP";
                      },
                      // Updates the state as the user types in the OTP.
                      onChanged: (pin) {
                        setState(() {
                          enteredPin = pin;
                          isComplete = pin.length == 6;
                        });
                      },
                      // The expected length of the OTP.
                      length: 6,
                      // The default theme for the pinput field.
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

                      // The theme for the pinput field when it is focused.
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

                      // The theme for the pinput field after the OTP has been submitted.
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

                      // Called when the user has entered the full OTP.
                      onCompleted: (pin) {
                        print("Completed: $pin");
                        setState(() {
                          enteredPin = pin;
                          isComplete = true;
                        });
                      },
                    ),

                    SizedBox(height: 20),

                    // The "Continue" button, which is enabled only when the OTP is complete.
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: isComplete
                            ? () async {
                                if (formKey.currentState!.validate()) {
                                  print("Valid PIN: $enteredPin");

                                  // Save the phone number to SharedPreferences AND UserData
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'last_phone_number', widget.phoneNumber);

                                  UserData.phoneNumber = widget.phoneNumber;
                                  // Authenticate the user
                                  dynamic result = await _auth.signInAnon();

                                  print("DEBUG: Sign-in result: $result");

                                  // Check if sign-in was successful
                                  if (result != null && mounted) {
                                    print(
                                        "DEBUG: Sign-in successful, showing modal");
                                    // SuccessModal
                                    _showSuccessModal();
                                  } else {
                                    print("ERROR: Sign-in failed");
                                    // Error message if authentication failed
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                  }
                                } else {
                                  // If the OTP is invalid
                                  print("Invalid PIN");
                                }
                              }
                            : null,
                        // Button disabled if OTP is not complete.
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: isComplete
                                ? Color(0xFFC42348)
                                : Color(0xFFEDBBC6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
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

              // The "Resend code" option.
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
