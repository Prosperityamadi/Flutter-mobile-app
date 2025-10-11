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

  @override
  void initState() {
    super.initState();
    // Load image after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileImage();
    });
  }

  @override
  void didUpdateWidget(ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload when widget updates
    _loadProfileImage();
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
        children: [
          SizedBox(
            height: 10,
          ),
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
        ],
      ),
    );
  }
}
