import 'package:flutter/material.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/components/custom_textformfield.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/user_api.dart';
import 'package:money_tracking_app/views/home_ui.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  // controller
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
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
                            'เข้าใช้งาน Money Tracking',
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
                  children: [
                    SizedBox(height: 20),
                    Image.asset('assets/images/welcomelogo.png', width: 200),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: userNameController,
                      labelText: 'ชื่อผู้ใช้',
                      hintText: "USERNAME",
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: userPasswordController,
                      labelText: 'รหัสผ่าน',
                      hintText: "PASSWORD",
                      isObsecure: true,
                    ),
                    SizedBox(height: 50),
                    CustomButton(
                      text: 'เข้าใช้งาน',
                      onPressed: () async {
                        // validate
                        if (userNameController.text.trim().isEmpty) {
                          showSnackbar('กรอกชื่อ', Color(negativeColor));
                        } else if (userPasswordController.text.trim().isEmpty) {
                          showSnackbar('กรอกรหัสผ่าน', Color(negativeColor));
                        } else {
                          // if validating fine
                          // create User
                          User user = User(
                            userName: userNameController.text.trim(),
                            userPassword: userPasswordController.text.trim(),
                          );
                          // call Check Login
                          user = await UserApi().checkLogin(user);
                          if (user.userID != null) {
                            showSnackbar('เข้าใช้งานสำเร็จ', Colors.green);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeUI(user: user),
                              ),
                            );
                          } else {
                            showSnackbar(
                              'ขื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
                              Color(negativeColor),
                            );
                          }
                        }
                      },
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
