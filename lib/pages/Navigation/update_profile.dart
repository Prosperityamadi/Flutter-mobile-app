import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:spar/others/userdata.dart';
import 'package:spar/services/auth.dart';

class UpdateProfile extends StatefulWidget {
  final File? currentImage;
  final String? phoneNumber;

  const UpdateProfile({
    super.key,
    this.currentImage,
    this.phoneNumber,
  });

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // Controller for username input
  TextEditingController userNameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final AuthService _auth = AuthService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current image and username
    _selectedImage = widget.currentImage;
    userNameController.text = UserData.userName ?? '';
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? returnedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (returnedImage == null) return;

      // Save to permanent directory
      final permanentImage = await _saveImagePermanently(File(returnedImage.path));

      setState(() {
        _selectedImage = permanentImage;
      });
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Save image to permanent app directory
  Future<File> _saveImagePermanently(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final permanentPath = path.join(directory.path, fileName);

    // Copy the image to permanent storage
    final savedImage = await image.copy(permanentPath);
    return savedImage;
  }

  // Save profile updates to Firestore
  Future<void> _saveProfile() async {
    final newUserName = userNameController.text.trim();

    // Validate username
    if (newUserName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a username',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Color(0xFFC42348),
            ),
          ),
          backgroundColor: Color(0xFFF9E9ED),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = _auth.getCurrentUser();

      if (user == null) {
        throw Exception('No user logged in');
      }

      // For now, just save the local file path as profileImageUrl
      // In Step 6, we'll upload to Firebase Storage and get a real URL
      String? imagePath;
      if (_selectedImage != null) {
        imagePath = _selectedImage!.path;
      }

      // Update Firestore
      bool success = await _auth.updateUserProfile(
        uid: user.uid,
        name: newUserName,
        profileImageUrl: imagePath,
      );

      if (success) {
        // Update local UserData
        UserData.userName = newUserName;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Profile updated successfully!',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Color(0xFFC42348),
                ),
              ),
              backgroundColor: Color(0xFFF9E9ED),
            ),
          );

          // Return the image to profile page
          Navigator.pop(context, _selectedImage);
        }
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('ERROR saving profile: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update profile. Please try again.',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, _selectedImage);
          },
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft02,
            size: 30,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Profile',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 80),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFF9E9ED),
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? HugeIcon(
                      icon: HugeIcons.strokeRoundedUser02,
                      size: 50,
                      color: Color(0xFFC42348),
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImageFromGallery,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFC42348),
                          shape: BoxShape.circle,
                        ),
                        child: const HugeIcon(
                          icon: HugeIcons.strokeRoundedCamera01,
                          color: Color(0xFFF9E9ED),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "username",
                      hintStyle: GoogleFonts.poppins(
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFA1B3C2),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Image(
                          image: AssetImage("assets/images/GH_flag.png")),
                    ),
                    SizedBox(width: 4),
                    Container(
                      child: Text(
                        "233",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.phoneNumber ?? "No phone number",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 60,
                width: 500,
                child: TextButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: TextButton.styleFrom(
                    backgroundColor: _isSaving
                        ? Color(0xFFEDBBC6)
                        : Color(0xFFC42348),
                  ),
                  child: _isSaving
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    'Save',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Delete account button
              SizedBox(
                height: 60,
                width: 500,
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          height: 300,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                  width: 60,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                        color: Color(0xFFEEF6FB), width: 2),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Are you sure you want to delete your account?',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        'this action cannot be undone',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      OverflowBar(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFC42348),
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'No',
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              // TODO: Add delete account from Firestore
                                              await _auth.signOut();
                                              if (context.mounted) {
                                                Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/loginPage',
                                                      (Route<dynamic> route) => false,
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Yes',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                                color: Color(0xFFC42348),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Color(0xFFC42348),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}