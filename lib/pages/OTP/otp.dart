import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:spar/pages/OTP/modals.dart';

// OTP Verification Page
class OtpPage extends StatefulWidget {
  final String phoneNumber;

  OtpPage({required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // valid OTP for now (replace with backend validation later)
  String validPin = "123456";

  // Stores the currently entered OTP
  String enteredPin = "";

  // Tracks whether the OTP input is complete (6 digits entered)
  bool isComplete = false;

  // Key to manage form validation
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Shows the success modal and navigates to home page after closing
  void _showSuccessModal() {
    SuccessModal.show(
      context,
      title: "Success",
      autoCloseDuration: Duration(seconds: 2),
      onClose: () {
        // Navigate to home page once the modal is dismissed
        print("OTP verification successful, navigating to home page");
        context.go("/home");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Any OTP setup logic can go here later if needed
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
              // Instructions
              Text(
                "Enter the OTP sent to ",
                style: GoogleFonts.poppins(
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              // Display phone number with underline + custom color
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
        
              // OTP Form
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Pinput(
                      // OTP validation: only valid if it matches [validPin]
                      validator: (value) {
                        return value == validPin ? null : "Invalid OTP";
                      },
                      // Updates enteredPin and completeness status in real-time
                      onChanged: (pin) {
                        setState(() {
                          enteredPin = pin;
                          isComplete = pin.length == 6;
                        });
                      },
                      // Length of OTP
                      length: 6,
                      // Default input theme
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
        
                      // Theme when input is focused
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
        
                      // Theme for submitted/validated input
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
        
                      // Once PIN is fully entered
                      onCompleted: (pin) {
                        print("Completed: $pin");
                        setState(() {
                          enteredPin = pin;
                          isComplete = true;
                        });
                      },
                    ),
        
                    SizedBox(height: 20),
        
                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: isComplete
                            ? () {
                          if (formKey.currentState!.validate()) {
                            // Valid OTP → show success modal
                            _showSuccessModal();
                            print("Valid PIN: $enteredPin");
                          } else {
                            // Invalid OTP (validator handles error message)
                            print("Invalid PIN");
                          }
                        }
                            : null, // Disabled when OTP is incomplete
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
        
              // Resend option
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
