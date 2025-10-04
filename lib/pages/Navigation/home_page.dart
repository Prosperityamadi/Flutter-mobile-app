import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import 'package:spar/others/foodcard/food_items.dart';
import 'package:spar/others/foodcard/foodcard.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // imagelist for auto scrollable images on homepage
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F5F7),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        toolbarHeight: 65,
        actions: [
          IconButton(
            onPressed: () {},
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
              MyHorizontalIconContainer(),
              SizedBox(
                height: 15,
              ),
              //Most popular and hot picks
              Container(
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
                      // Important for nesting in a ListView
                      shrinkWrap: true,
                      // Important for nesting in a ListView
                      itemCount: mostPopularItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16, // Horizontal space
                        mainAxisSpacing: 16, // Vertical space
                        childAspectRatio:
                            0.75, // Adjust this ratio to get the height you want
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // Get the current item from your list
                        final item = mostPopularItems[index];
                        // Return the custom FoodCard widget
                        return FoodCard(
                          item: item,
                          onAdd: () {
                            print('${item.name} added to cart!');
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16),
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
                      // Important for nesting in a ListView
                      shrinkWrap: true,
                      // Important for nesting in a ListView
                      itemCount: hotPicksItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16, // Horizontal space
                        mainAxisSpacing: 16, // Vertical space
                        childAspectRatio:
                        0.75, // Adjust this ratio to get the height you want
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // Get the current item from your list
                        final item = hotPicksItems[index];
                        // Return the custom FoodCard widget
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
              )
            ],
          )
        ],
      ),
    );
  }
}

//homepage horizontal icons that is also used in the search page
class MyHorizontalIconContainer extends StatelessWidget {
   MyHorizontalIconContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyHorizontalIcons(
                onPressed: () {},
                icon: HugeIcons.strokeRoundedPizza02,
                label: 'Pizza'),
            MyHorizontalIcons(
                onPressed: () {},
                icon: HugeIcons.strokeRoundedRiceBowl01,
                label: 'Food'),
            MyHorizontalIcons(
                onPressed: () {},
                icon: HugeIcons.strokeRoundedIceCream01,
                label: 'Desserts'),
            MyHorizontalIcons(
                onPressed: () {},
                icon: HugeIcons.strokeRoundedMilkBottle,
                label: 'Drinks'),
          ],
        ),
      ),
    );
  }
}

//homepage horizontal icons
class MyHorizontalIcons extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback? onPressed;

  MyHorizontalIcons(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: HugeIcon(
            icon: icon,
            size: 45,
            color: Color(0xFF8195A6),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontStyle: FontStyle.normal,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8195A6),
          ),
        ),
      ],
    );
  }
}
