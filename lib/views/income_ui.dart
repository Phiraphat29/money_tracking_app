import 'package:flutter/material.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/components/custom_textformfield.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/money_api.dart';

class IncomeUI extends StatefulWidget {
  final User user;
  final VoidCallback onTransactionAdd;
  const IncomeUI({
    super.key,
    required this.user,
    required this.onTransactionAdd,
  });

  @override
  State<IncomeUI> createState() => _IncomeUIState();
}

class _IncomeUIState extends State<IncomeUI> {
  // textformfield income controller
  TextEditingController moneyIncomeDetailController = TextEditingController();
  TextEditingController moneyIncomeValueController = TextEditingController();
  TextEditingController moneyIncomeDateController = TextEditingController();

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
          backgroundColor: Colors.white,
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
              color: Color(successColor),
            ),
          ),
          content: Text(message),
          backgroundColor: Colors.white,
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

  // widget unfocus
  void unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'เงินเข้า',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(primaryColor),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CustomTextformfield(
                      controller: moneyIncomeDetailController,
                      hintText: 'DETAIL',
                      labelText: 'รายการเงินเข้า',
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: moneyIncomeValueController,
                      hintText: '0.00',
                      labelText: 'จำนวนเงินเข้า',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: moneyIncomeDateController,
                      hintText: 'DATE INCOME',
                      labelText: 'วัน เดือน ปีเงินที่เข้า',
                      isDatePicker: true,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: 'บันทึกเงินเข้า',
                      onPressed: () async {
                        // validate
                        if (moneyIncomeDetailController.text.trim().isEmpty) {
                          showAlertDialog('กรุณากรอกรายละเอียดให้ครบถ้วน');
                        } else if (moneyIncomeValueController.text
                                .trim()
                                .isEmpty ||
                            double.tryParse(
                                  moneyIncomeValueController.text.trim(),
                                ) ==
                                null) {
                          showAlertDialog('กรุณากรอกจำนวนเงิน (เลขและทศนิยม)');
                        } else if (moneyIncomeDateController.text
                            .trim()
                            .isEmpty) {
                          showAlertDialog('กรุณากรอกวันที่บันทึก');
                        } else {
                          // if validating fine
                          // create Money
                          Money money = Money(
                            moneyDetail:
                                moneyIncomeDetailController.text.trim(),
                            moneyDate: moneyIncomeDateController.text.trim(),
                            moneyInOut: double.parse(
                              moneyIncomeValueController.text.trim(),
                            ),
                            moneyType: 1,
                            userID: widget.user.userID,
                          );
                          // send data via api to database
                          if (await MoneyApi().insertMoney(money)) {
                            showSuccessDialog('บันทึกเงินเข้าสำเร็จ');
                            // clear data in textfield
                            moneyIncomeDetailController.clear();
                            moneyIncomeValueController.clear();
                            moneyIncomeDateController.clear();

                            widget.onTransactionAdd();
                            unfocus();
                          } else {
                            showAlertDialog('บันทึกเงินเข้าไม่สำเร็จ');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
