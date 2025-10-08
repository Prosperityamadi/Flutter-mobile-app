import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spar/pages/Navigation/cart_page.dart';
import 'package:spar/pages/Navigation/main_navigation.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5F7),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Order History",
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedShoppingCart02,
                size: 30,
                color: Color(0xFF8195A6),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            children: [
              SizedBox(height: 20,),
              Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/empty_cart.png'),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Text(
                      'You haven’t placed any order yet',
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text(
                        'Browse our menu and make your first order. Once you have placed an order, your order receipts will be saved for you here.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 11, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    // Order now button
                    // which redirects to the main navigation page
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainNavigation()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        'Order Now',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFC42348)),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.white),
                        minimumSize:
                        MaterialStateProperty.all(const Size(200, 50)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
