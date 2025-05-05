import 'dart:io';

import 'package:dio/dio.dart';
import 'package:money_tracking_app/constants/baseurl.dart';
import 'package:money_tracking_app/models/user.dart';

class UserApi {
  final Dio dio = Dio();

  Future<bool> registerUser(User user, File? userFile) async {
    try {
      // เอาข้อมูลใส่ Formdata
      final formdata = FormData.fromMap({
        'userFullName': user.userFullName,
        'userName': user.userName,
        'userPassword': user.userPassword,
        'userBirthDate': user.userBirthDate,
        if (userFile != null)
          'userImage': await MultipartFile.fromFile(
            userFile.path,
            filename: userFile.path.split('/').last,
            contentType: DioMediaType('image', userFile.path.split('.').last),
          ),
      });
      // เอาข้อมูล formdata ส่งไปที่ API ตาม Endpoint ที่ทำไว้
      final responseData = await dio.post(
        '$baseUrl/user/',
        data: formdata,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      // หลังจากทำงานเสร็จ ณ ที่นี้ตรวจสอบผลการทำงานจาก responseData
      if (responseData.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: ${e}');
      return false;
    }
  }

  // Check Login
  Future<User> checkLogin(User user) async {
    try {
      final responseData = await dio.get(
        '$baseUrl/user/${user.userName}/${user.userPassword}',
      );
      // ตรวจสอบผลการทำงานจาก responseData
      if (responseData.statusCode == 200) {
        // ถ้าสำเร็จให้แปลงข้อมูลที่ได้เป็น User
        return User.fromJson(responseData.data['info']);
      } else {
        return User();
      }
    } catch (e) {
      print('Error: ${e}');
      return User();
    }
  }
}
