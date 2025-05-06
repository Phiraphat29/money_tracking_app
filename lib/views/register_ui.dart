import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/components/custom_textformfield.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/user_api.dart';
import 'package:money_tracking_app/views/welcome_ui.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  File? userFile;

  // Controller
  TextEditingController userFullNameController = TextEditingController();
  TextEditingController userBirthDateController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  Future<void> openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      userFile = File(image.path);
    });
  }

  // show alert dialog
  showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'คำเตือน',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color(primaryColor),
            ),
          ),
          content: Text(message),
          backgroundColor: Color(backgroundColor),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // show success dialog
  showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'สำเร็จ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color(positiveColor),
            ),
          ),
          content: Text(message),
          backgroundColor: Color(backgroundColor),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show Snackbar
  showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(prominentColor),
          ),
        ),
        backgroundColor: color,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // widget unfocus
  void unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(backgroundColor),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            // Custom curved app bar
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Color(primaryColor),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Color(prominentColor),
                          size: 32,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                              color: Color(prominentColor),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'ข้อมูลผู้ใช้งาน',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          openCamera();
                        },
                        child: Container(
                          width: 125,
                          height: 125,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child:
                              userFile == null
                                  ? Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.camera,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  )
                                  : ClipOval(
                                    child: Image.file(
                                      userFile!,
                                      width: 125,
                                      height: 125,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: userFullNameController,
                      labelText: 'ชื่อ-นามสกุล',
                      hintText: 'YOUR NAME',
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: userBirthDateController,
                      labelText: 'วัน-เดือน-ปี-เกิด',
                      hintText: 'YOUR BIRTHDAY',
                      isDatePicker: true,
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: userNameController,
                      labelText: 'ชื่อผู้ใช้งาน',
                      hintText: 'USERNAME',
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: userPasswordController,
                      labelText: 'รหัสผ่าน',
                      hintText: 'PASSWORD',
                      isObsecure: true,
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: CustomButton(
                        text: 'บันทึกการลงทะเบียน',
                        onPressed: () async {
                          // send data to API
                          // validate
                          if (userFullNameController.text.trim().isEmpty) {
                            showAlertDialog('กรุณากรอกชื่อ-นามสกุล');
                          } else if (userBirthDateController.text
                              .trim()
                              .isEmpty) {
                            showAlertDialog('กรุณากรอกวันเกิด');
                          } else if (userNameController.text.trim().isEmpty) {
                            showAlertDialog('กรุณากรอกชื่อ');
                          } else if (userPasswordController.text
                              .trim()
                              .isEmpty) {
                            showAlertDialog('กรุณากรอกรหัสผ่าน');
                          } else {
                            // ถ้าผ่านการ-validate
                            // สร้าง User
                            User user = User(
                              userFullName: userFullNameController.text.trim(),
                              userBirthDate:
                                  userBirthDateController.text.trim(),
                              userName: userNameController.text.trim(),
                              userPassword: userPasswordController.text.trim(),
                            );
                            // send data via api to database
                            if (await UserApi().registerUser(user, userFile)) {
                              showSnackbar(
                                'ลงทะเบียนสำเร็จ',
                                Color(positiveColor),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeUI(),
                                ),
                              );
                            } else {
                              showAlertDialog('ลงทะเบียนไม่สำเร็จ');
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
