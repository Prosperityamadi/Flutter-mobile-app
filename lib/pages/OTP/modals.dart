import 'package:flutter/material.dart';

// This modal is designed to be a reusable widget for showing a simple success state.
// It can be triggered from anywhere in the app using the static `show` method.
class SuccessModal extends StatelessWidget {
  final String title;
  // An optional callback that runs when the modal is closed, either automatically or by the user.
  final VoidCallback? onClose;

  // If set, the modal will automatically close after this duration.
  final Duration? autoCloseDuration;

  const SuccessModal({
    Key? key,
    this.title = "Success",
    this.onClose,
    this.autoCloseDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Auto close after duration if specified
    if (autoCloseDuration != null) {
      Future.delayed(autoCloseDuration!, () {
        // Checking `Navigator.canPop` ensures I don't try to pop a route that's already gone.
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
          // If an `onClose` function was passed in, I'm making sure it gets called.
          if (onClose != null) onClose!();
        }
      });
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Adding a subtle shadow for a bit of depth.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          // Centering the icon and text vertically.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // This is the container for the check icon.
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // Using the secondary theme color for the icon's background circle.
                color: Color(0xFFFFE1E8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: const Color(0xFFC42348),
                size: 24,
              ),
            ),
            SizedBox(height: 12),
            // The main text, which defaults to "Success".
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Static method to show the modal
  static void show(
    BuildContext context, {
    String title = "Success",
    VoidCallback? onClose,
    Duration? autoCloseDuration =
        const Duration(seconds: 2), // Set a default auto-close duration.
    bool barrierDismissible =
        false, // Prevents closing the modal by tapping the overlay.
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      // A semi-transparent overlay color for the background.
      barrierColor: Colors.black.withOpacity(0.5),
      // The builder just returns an instance of our SuccessModal.
      builder: (context) => SuccessModal(
        title: title,
        onClose: onClose,
        autoCloseDuration: autoCloseDuration,
      ),
    );
  }
}
