import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spar/others/foodcard/food_items.dart';
import 'package:spar/others/foodcard/foodcard.dart';
import 'package:spar/pages/Navigation/cart_page.dart';
import 'package:spar/pages/Navigation/location_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Amasaman, Sonitra";
  String? selectedIconLabel; // Tracks the currently selected icon

  // image list for auto scrollable images on homepage
  final List<String> imageList = [
    'assets/images/jollof_rice.jpg',
    'assets/images/pizza_homepage.jpg',
    'assets/images/shawarma_homepage.jpg',
    'assets/images/soft-drinks.jpg',
    'assets/images/champagne.jpg',
  ];

  // List of most popular items
  final List<FoodItem> mostPopularItems = [
    FoodItem(
      imagePath: 'assets/images/fried_rice.png',
      name: 'Fried Rice',
      onOptionPressed: () {},
    ),
    FoodItem(
      imagePath: 'assets/images/gretaben.png',
      name: 'Gretaben',
      onOptionPressed: () {},
    ),
    FoodItem(
      imagePath: 'assets/images/jollof_rice2.png',
      name: 'Jollof Rice',
      onOptionPressed: () {},
    ),
    FoodItem(
      imagePath: 'assets/images/pepperoni_pizza.png',
      name: 'Pepperoni Pizza',
      onOptionPressed: () {},
    ),
  ];

  //List of Hot Picks
  final List<FoodItem> hotPicksItems = [
    FoodItem(
      imagePath: 'assets/images/cheese_pizza.png',
      name: 'Classic Cheese Pizza',
      onOptionPressed: () {},
    ),
    FoodItem(
      imagePath: 'assets/images/chicken_pizza.png',
      name: 'Chicken Pizza',
      onOptionPressed: () {},
    ),
    FoodItem(
      imagePath: 'assets/images/pepperoni_pizza.png',
      name: 'Pepperoni Pizza',
      onOptionPressed: () {},
    ),
    FoodItem(
      imagePath: 'assets/images/shawarma.png',
      name: 'Shawarma',
      onOptionPressed: () {},
    ),
    FoodItem(
      imagePath: 'assets/images/fried_rice.png',
      name: 'Fried Rice',
      onOptionPressed: () {},
    ),
    FoodItem(
      imagePath: 'assets/images/jollof_rice2.png',
      name: 'Jollof Rice',
      onOptionPressed: () {},
    ),
  ];

  /// Toggles the selection of an icon.
  /// If the selected icon is tapped again, it's deselected.
  void _handleIconSelection(String label) {
    setState(() {
      if (selectedIconLabel == label) {
        selectedIconLabel = null;
      } else {
        selectedIconLabel = label;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5F7),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        toolbarHeight: 65,
        title: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Color(0xFFE0E0E0),
            ),
          ),
          //Location
          child: TextButton(
            //onPressed function
            onPressed: () {
              showModalBottomSheet<void>(
                useSafeArea: false,
                isDismissible: false,
                enableDrag: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white,
                    ),
                    height: 400,
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          children: [
                            // first row of the bottom modal
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(
                                top: 15,
                                bottom: 15,
                                right: 30,
                                left: 30,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedSent,
                                        color: Color(0xFFC42348),
                                        strokeWidth: 3,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "Select Location",
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Close',
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFC42348),
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                            //location suggestion can be added here
                            SizedBox(
                              height: 200,
                            ),
                            //last row of the bottom modal that redirect to a full location page
                            Container(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFC42348),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              margin: EdgeInsets.all(12),
                              child: TextButton(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedLocation03,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Change delivery location",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    HugeIcon(
                                      icon: HugeIcons
                                          .strokeRoundedArrowRightDouble,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LocationPage()),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFFC42348),
                      size: 25,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Amasaman, Sonitra',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
                HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowDown01,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
        //shopping Cart
        actions: [
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
      body: ListView(
        children: [
          Column(
            children: [
              //homepage image slides
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
                child: CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1.0,
                    aspectRatio: 2.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    initialPage: 2,
                    autoPlay: true,
                  ),
                  items: imageList
                      .map((item) => Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              item,
                              fit: BoxFit.cover,
                            ),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //homepage horizontal icons
              MyHorizontalIconContainer(
                selectedLabel: selectedIconLabel,
                onIconSelected: _handleIconSelection,
              ),
              SizedBox(
                height: 15,
              ),
              // Conditionally display content based on icon selection
              if (selectedIconLabel == null)
                _buildDefaultContent() // Show default content
              else
                _buildEmptyContent(), // Show the empty page
            ],
          )
        ],
      ),
    );
  }

  /// This widget builds the default content (Most Popular & Hot Picks).
  Widget _buildDefaultContent() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Most Popular',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See all',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Color(0xFFC42348))),
              ],
            ),
          ),
          // Most popular items grid
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: mostPopularItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (BuildContext context, int index) {
              final item = mostPopularItems[index];
              return FoodCard(
                item: item,
                onAdd: () {
                  print('${item.name} added to cart!');
                },
              );
            },
          ),
          SizedBox(height: 25),
          // Hot picks section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hot Picks',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See all',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Color(0xFFC42348))),
              ],
            ),
          ),
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: hotPicksItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (BuildContext context, int index) {
              final item = hotPicksItems[index];
              return FoodCard(
                item: item,
                onAdd: () {
                  print('${item.name} added to cart!');
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// empty content widget
  Widget _buildEmptyContent() {
    return Container();
  }
}

/// A widget that displays the horizontal list of icon categories.
class MyHorizontalIconContainer extends StatelessWidget {
  final String? selectedLabel; // The label of the currently selected icon
  final Function(String) onIconSelected; // Callback when an icon is tapped

  const MyHorizontalIconContainer({
    super.key,
    this.selectedLabel,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Data for the icons
    final List<Map<String, dynamic>> iconData = [
      {'icon': HugeIcons.strokeRoundedPizza02, 'label': 'Pizza'},
      {'icon': HugeIcons.strokeRoundedRiceBowl01, 'label': 'Food'},
      {'icon': HugeIcons.strokeRoundedIceCream01, 'label': 'Desserts'},
      {'icon': HugeIcons.strokeRoundedMilkBottle, 'label': 'Drinks'},
    ];

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: iconData.map((data) {
            final label = data['label'] as String;
            return MyHorizontalIcons(
              onPressed: () => onIconSelected(label),
              icon: data['icon'],
              label: label,
              isSelected:
                  selectedLabel == label, // Determine if the icon is selected
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Represents a single pressable icon in the horizontal list.
class MyHorizontalIcons extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;

  const MyHorizontalIcons({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: HugeIcon(
            icon: icon,
            size: 45,
            color: isSelected ? Color(0xFFC42348) : const Color(0xFF8195A6),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontStyle: FontStyle.normal,
            fontSize: 12,
            color: isSelected ? Color(0xFFC42348) : Color(0xFF8195A6),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
