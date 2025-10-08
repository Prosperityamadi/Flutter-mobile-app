import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spar/pages/Navigation/home_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //Controller for search input
  static TextEditingController searchMealController = TextEditingController();

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
                        controller: searchMealController,
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
            MyHorizontalIconContainer(
              onIconSelected: (label) {},
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Search Results',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 20,
                                alignment: Alignment.center,
                                color: Color(0xFFF9E9ED),
                                child: Text(
                                  '0',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFFC42348),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: [
                              Image(
                                image: AssetImage(
                                    'assets/images/search_result.png'),
                                width: 126,
                                height: 85,
                              ),
                              Text(
                                'No results found',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
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
