import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:spar/others/userdata.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize with current image if available
    _selectedImage = widget.currentImage;
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
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
      final permanentImage =
      await _saveImagePermanently(File(returnedImage.path));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leading: IconButton(
          onPressed: () {
            // Return the selected image when going back
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
                    //Ghana flag icon
                    Container(
                      child:
                      Image(image: AssetImage("assets/images/GH_flag.png")),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    // Ghana country code display
                    Container(
                      child: Text(
                        "233",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    // Phone number display - GET FROM WIDGET PARAMETER
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
                  onPressed: () {
                    final newUserName = userNameController.text;

                    // Check if username is empty
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

                    // Save and navigate back
                    UserData.userName = newUserName;
                    Navigator.pop(context, _selectedImage);
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFC42348),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //delete account button
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
                                // Handle bar
                                Container(
                                  width: 60,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                SizedBox(height: 20),
                                //delete account text
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
                                          // color: Color(0xFFC42348),
                                        ),
                                      ),
                                      Text(
                                        'this action cannot be undone',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          // color: Color(0xFFC42348),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      OverflowBar(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 50,
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
                                            decoration: BoxDecoration(
                                              color: Color(0xFFC42348),
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/loginPage',
                                                    (Route<dynamic> route) => false,
                                              );
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