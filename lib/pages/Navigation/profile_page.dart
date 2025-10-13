import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spar/others/userdata.dart';
import 'package:spar/pages/Navigation/update_profile.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  bool _isLoading = false;
  String _selectedPaymentMethod = 'Cash'; // Track selected payment method

  @override
  void initState() {
    super.initState();
    //Load profile image and payment method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileImage();
      _loadPaymentMethod();
    });
  }

  @override
  void didUpdateWidget(ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload when widget updates
    _loadProfileImage();
  }

  // Load saved payment method from shared preferences
  Future<void> _loadPaymentMethod() async {
    final prefs = await SharedPreferences.getInstance();
    final paymentMethod = prefs.getString('payment_method') ?? 'Cash';
    if (mounted) {
      setState(() {
        _selectedPaymentMethod = paymentMethod;
      });
    }
  }

  // Save payment method to shared preferences
  Future<void> _savePaymentMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('payment_method', method);
  }

  // Load saved image path from shared preferences
  Future<void> _loadProfileImage() async {
    if (_isLoading) return; // Prevent multiple simultaneous loads

    setState(() {
      _isLoading = true;
    });

    try {
      // Add a small delay to ensure Flutter is ready
      await Future.delayed(Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final imagePath = prefs.getString('profile_image_path');

      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          if (mounted) {
            setState(() {
              _profileImage = file;
              _isLoading = false;
            });
          }
        } else {
          // Clean up invalid path
          await prefs.remove('profile_image_path');
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading profile image: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Save image path to shared preferences
  Future<void> _saveProfileImage(File image) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', image.path);
  }

  // Delete old profile image to avoid clutter
  Future<void> _deleteOldProfileImage() async {
    if (_profileImage != null && await _profileImage!.exists()) {
      try {
        await _profileImage!.delete();
      } catch (e) {
        debugPrint('Failed to delete old image: $e');
      }
    }
  }

  // Show payment method selection dialog
  void _showPaymentMethodDialog() {
    String tempSelection = _selectedPaymentMethod;

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 350,
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    // Handle bar
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Color(0xFFEEF6FB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: 20),

                    //payment method selection
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Color(0xFFEEF6FB), width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Column(
                          children: [
                            // Cash option
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  tempSelection = 'Cash';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/cash.png'),
                                          width: 24,
                                          height: 24,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          'Cash',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Radio<String>(
                                      value: 'Cash',
                                      groupValue: tempSelection,
                                      activeColor: Color(0xFFC42348),
                                      onChanged: (String? value) {
                                        setModalState(() {
                                          tempSelection = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                                color: const Color(0xFFEEF6FB),
                                indent: 15,
                                endIndent: 15,
                                height: 2,
                                thickness: 2),

                            // Online Payment option
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  tempSelection = 'Online Payment';
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        HugeIcon(
                                          icon:
                                              HugeIcons.strokeRoundedPayment01,
                                          color: Color(0xFFC42348),
                                          size: 24,
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          'Online Payment',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Radio<String>(
                                      value: 'Online Payment',
                                      groupValue: tempSelection,
                                      activeColor: Color(0xFFC42348),
                                      onChanged: (String? value) {
                                        setModalState(() {
                                          tempSelection = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Done button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedPaymentMethod = tempSelection;
                          });
                          _savePaymentMethod(tempSelection);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC42348),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Done',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 80,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          //profile display and update display
          ListTile(
            leading: SizedBox(
              height: 50,
              width: 50,
              child: CircleAvatar(
                backgroundColor: const Color(0xFFF9E9ED),
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? HugeIcon(
                        icon: HugeIcons.strokeRoundedUser02,
                        color: Color(0xFFC42348),
                        size: 30,
                      )
                    : null,
              ),
            ),
            title: Text(
              UserData.userName ?? "",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            subtitle: Text("${UserData.phoneNumber}"),
            trailing: IconButton(
              onPressed: () async {
                // Navigate and wait for result
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfile(
                      currentImage: _profileImage,
                    ),
                  ),
                );

                // Update profile image if user selected one
                if (result != null && result is File) {
                  // Delete old image before saving new one
                  await _deleteOldProfileImage();

                  setState(() {
                    _profileImage = result;
                  });

                  // Save the image path permanently
                  await _saveProfileImage(result);
                }
              },
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedEdit04,
                color: Color(0xFFC42348),
                size: 20,
              ),
            ),
          ),
          Divider(
            thickness: 3,
            color: Color(0xFFEEF6FB),
          ),
          //payment method
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _selectedPaymentMethod == 'Cash'
                            ? Image(
                                image: AssetImage('assets/images/cash.png'),
                                width: 24,
                                height: 24,
                              )
                            : HugeIcon(
                                icon: HugeIcons.strokeRoundedPayment01,
                                color: Color(0xFFC42348),
                                size: 24,
                              ),
                        SizedBox(width: 10),
                        Text(
                          _selectedPaymentMethod,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: _showPaymentMethodDialog,
                      child: Text(
                        'Change',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          color: Color(0xFFC42348),
                          decorationColor: Color(0xFFC42348),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            thickness: 3,
            color: Color(0xFFEEF6FB),
          ),
          // Other section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Other',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
          //Account setting
          OtherProfileOptions(
            onOptionPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfile(
                    currentImage: _profileImage,
                  ),
                ),
              );

              // Update profile image if user selected one
              if (result != null && result is File) {
                // Delete old image before saving new one
                await _deleteOldProfileImage();

                setState(() {
                  _profileImage = result;
                });

                // Save the image path permanently
                await _saveProfileImage(result);
              }
            },
            icon: HugeIcons.strokeRoundedSettings01,
            text: 'Account Settings',
          ),
          // Promotion Codes
          OtherProfileOptions(
            onOptionPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'No promotion codes available at the moment',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color(0xFFC42348),
                    ),
                  ),
                  backgroundColor: Color(0xFFF9E9ED),
                ),
              );
            },
            icon: HugeIcons.strokeRoundedDiscount,
            text: 'Promotion Codes',
          ),
          //Privacy
          OtherProfileOptions(
            onOptionPressed: () {},
            icon: HugeIcons.strokeRoundedSecurity,
            text: 'Privacy',
          ),
          //About
          OtherProfileOptions(
            onOptionPressed: () {},
            icon: HugeIcons.strokeRoundedInformationCircle,
            text: 'About',
          ),
          //Support
          OtherProfileOptions(
            onOptionPressed: () {},
            icon: HugeIcons.strokeRoundedCustomerSupport,
            text: 'Support',
          ),
          SizedBox(
            height: 70,
          ),
          //Logout
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/loginPage',
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFFC42348),
                    ),
                  ),
                ),
                Text(
                  'version 1.0.0',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//Other profile options
class OtherProfileOptions extends StatelessWidget {
  final VoidCallback onOptionPressed;
  final dynamic icon;
  final String text;

  OtherProfileOptions({
    super.key,
    required this.onOptionPressed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onOptionPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HugeIcon(
            icon: icon,
            size: 24,
            color: Color(0xFFC42348),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
