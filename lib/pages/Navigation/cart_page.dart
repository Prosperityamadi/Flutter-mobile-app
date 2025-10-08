import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft02,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedDelete02,
              color: Color(0xFFC42348),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/empty_cart.png'),
            ),
            SizedBox(height: 10,),
            Text(
              'Your cart is empty',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Back to menu',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFC42348)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                minimumSize: MaterialStateProperty.all(Size(200, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
