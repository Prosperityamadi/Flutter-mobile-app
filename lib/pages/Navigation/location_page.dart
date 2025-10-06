import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController searchPlaceController = TextEditingController();
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
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Change delivery location',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          BoxBorder.all(width: 0.5, color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 8.0),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedSearch01,
                            color: Color(0xFF8195A6),
                            size: 20,
                            strokeWidth: 2.5,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchPlaceController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Search places",
                              hintStyle: GoogleFonts.poppins(
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF8195A6),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                          child: Image(
                            image: AssetImage('assets/images/googlemap.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
