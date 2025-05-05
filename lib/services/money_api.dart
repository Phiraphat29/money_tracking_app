import 'package:dio/dio.dart';
import 'package:money_tracking_app/constants/baseurl.dart';
import 'package:money_tracking_app/models/money.dart';

class MoneyApi {
  final Dio dio = Dio();

  // insert money
  Future<bool> insertMoney(Money money) async {
    try {
      // เอาข้อมูลใส่ Formdata
      final formdata = FormData.fromMap({
        'moneyDetail': money.moneyDetail,
        'moneyDate': money.moneyDate,
        'moneyInOut': money.moneyInOut.toString(),
        'moneyType': money.moneyType.toString(),
        'userID': money.userID.toString(),
      });
      // เอาข้อมูล formdata ส่งไปที่ API ตาม Endpoint ที่ทำไว้
      final responseData = await dio.post(
        '$baseUrl/money/',
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

  // get money to show in homeui _buildHomePage and split type into income and expense (1, 2)
  Future<List<Money>> getMoney(int userID) async {
    var moneyList = <Money>[];
    try {
      final responseData = await dio.get('$baseUrl/money/$userID');
      // ตรวจสอบผลการทำงานจาก responseData
      if (responseData.statusCode == 200) {
        // ถ้าสำเร็จให้แปลงข้อมูล
        for (var element in responseData.data['data']) {
          element['moneyInOut'] = element['moneyInOut'].toDouble();
          var money = Money.fromJson(element);

          moneyList.add(money);
        }
        return moneyList;
      } else {
        return [];
      }
    } catch (e) {
      print('Error: ${e}');
      return [];
    }
  }
}
