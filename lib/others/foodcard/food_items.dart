class FoodItem {
  final String imagePath;
  final String name;
  // final String price;
  final void Function()? onOptionPressed;

  FoodItem({
    required this.imagePath,
    required this.name,
    // required this.price,
     this.onOptionPressed,
  });
}

