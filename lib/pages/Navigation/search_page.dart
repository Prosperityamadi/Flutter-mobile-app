import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spar/pages/Navigation/home_page.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //Controller for search input
  static TextEditingController searchController = TextEditingController();
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
              child: Container(
                decoration: BoxDecoration(
                  border: BoxBorder.all(width: 0.5, color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        color: Color(0xFF8195A6),
                        size: 20,
                        strokeWidth: 2.5,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Search meals",
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
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC42348)),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            MyHorizontalIconContainer(),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.white,
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFC42348)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
