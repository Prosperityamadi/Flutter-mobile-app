import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller for phone number input
  static TextEditingController phoneController = TextEditingController();

  // Tracks whether the phone number is valid (10 digits)
  bool _isPhoneNumberValid = false;

  @override
  void initState() {
    super.initState();
    // Listen for changes in the text field
    phoneController.addListener(_onPhoneNumberChanged);
  }

  @override
  void dispose() {
    // Dispose controller to free resources
    phoneController.dispose();
    super.dispose();
  }

  // Check if phone number entered has exactly 10 digits
  void _onPhoneNumberChanged() {
    setState(() {
      _isPhoneNumberValid = phoneController.text.length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top section with branding (heading)
            LoginHeading(),
            SizedBox(
              height: 24,
            ),
            // Phone number input + button
            PhoneNumber(
                phoneController: phoneController,
                isPhoneNumberValid: _isPhoneNumberValid)
          ],
        ),
      ),
    );
  }
}

// Heading/branding section at the top of the login page
class LoginHeading extends StatelessWidget {
  const LoginHeading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 375,
      color: const Color(0xFFC42348),
      child: Stack(
        children: [
          // Background pizza pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset(
                'assets/images/bg_pizza.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground pizza image
          Positioned(
            width: 600,
            top: 120,
            left: 90,
            child: Image(
              image: AssetImage('assets/images/bg_pizza2.png'),
            ),
          ),
          SizedBox(
            width: 800,
          ),
          // Text content (brand + tagline)
          Padding(
            padding: const EdgeInsets.only(left: 21.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand name "Dennis"
                Text(
                  "Dennis",
                  style: GoogleFonts.poppins(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Brand name "Pizza"
                Text(
                  "Pizza",
                  style: GoogleFonts.poppins(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Brand tagline - first line
                Text(
                  "Great taste for",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                // Brand tagline - second line
                Text(
                  "a delightful experience",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// Phone number input widget that handles user input validation and OTP request
class PhoneNumber extends StatelessWidget {
  const PhoneNumber({
    super.key,
    required this.phoneController,
    required bool isPhoneNumberValid,
  }) : _isPhoneNumberValid = isPhoneNumberValid;

  final TextEditingController phoneController;
  final bool _isPhoneNumberValid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(21.0),
      child: Container(
        child: Column(
          children: [
            // Instructions text for user
            Text(
              "Enter your phone number to get OTP ",
              style: GoogleFonts.poppins(
                fontStyle: FontStyle.normal,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Phone number input field with Ghana country code prefix
            Container(
              decoration: BoxDecoration(
                border: BoxBorder.all(width: 0.5, color: Color(0xFFE0E0E0)),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Ghana flag icon
                  Container(
                    child:
                        Image(image: AssetImage("assets/images/GH_flag.png")),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  // Ghana country code display
                  Container(
                    child: Text(
                      "233",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  // Phone number input field
                  Expanded(
                    child: TextField(
                      //stores the number in the text field
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "e.g. 0244123456",
                        hintStyle: GoogleFonts.poppins(
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA1B3C2),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // Get OTP button - enabled only when phone number is valid
            Container(
              child: SizedBox(
                height: 60,
                width: 500,
                child: TextButton(
                  style: TextButton.styleFrom(
                    // Dynamic background color based on validation state
                    // Button active only if phone number is valid
                    backgroundColor: _isPhoneNumberValid
                        ? Color(0xFFC42348) // Active state - brand color
                        : Color(0xFFEDBBC6), // Disabled state - lighter shade
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _isPhoneNumberValid
                      ? () {
                          // Navigate to OTP verification page with phone number
                          final phoneNumber = phoneController.text;
                          context.go('/otpPage/$phoneNumber');
                          // A print statement to check the phone number
                          print("Phone number: ${phoneController.text}");
                        }
                      : null, // Disable button when phone number is invalid
                  child: Text(
                    "Get OTP",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Terms and conditions disclaimer
            Container(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
                  children: [
                    TextSpan(text: "By clicking, I accept the "),
                    TextSpan(
                        text: "term of service ",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold)),
                    TextSpan(text: "and "),
                    TextSpan(
                      text: "privacy policies ",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
