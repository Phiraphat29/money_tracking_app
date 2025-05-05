import 'package:flutter/material.dart';
import 'package:money_tracking_app/components/custom_button.dart';
import 'package:money_tracking_app/components/custom_textformfield.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/money_api.dart';

class ExpenseUI extends StatefulWidget {
  final User user;
  final VoidCallback onTransactionAdd;
  const ExpenseUI({
    super.key,
    required this.user,
    required this.onTransactionAdd,
  });

  @override
  State<ExpenseUI> createState() => _ExpenseUIState();
}

class _ExpenseUIState extends State<ExpenseUI> {
  // textformfield expense controller
  TextEditingController moneyExpenseDetailController = TextEditingController();
  TextEditingController moneyExpenseValueController = TextEditingController();
  TextEditingController moneyExpenseDateController = TextEditingController();

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
                'เงินออก',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(primaryColor),
                ),
              ),
              // Add your income page widgets here
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    CustomTextformfield(
                      controller: moneyExpenseDetailController,
                      hintText: 'DETAIL',
                      labelText: 'รายการเงินออก',
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: moneyExpenseValueController,
                      hintText: '0.00',
                      labelText: 'จำนวนเงินออก',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    CustomTextformfield(
                      controller: moneyExpenseDateController,
                      hintText: 'DATE EXPENSE',
                      labelText: 'วัน เดือน ปีเงินที่ออก',
                      isDatePicker: true,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: 'บันทึกเงินออก',
                      onPressed: () async {
                        // validate
                        if (moneyExpenseDetailController.text.trim().isEmpty) {
                          showAlertDialog('กรุณากรอกรายละเอียดให้ครบถ้วน');
                        } else if (moneyExpenseValueController.text
                                .trim()
                                .isEmpty ||
                            double.tryParse(
                                  moneyExpenseValueController.text.trim(),
                                ) ==
                                null) {
                          showAlertDialog('กรุณากรอกจำนวนเงิน (เลขและทศนิยม)');
                        } else if (moneyExpenseDateController.text
                            .trim()
                            .isEmpty) {
                          showAlertDialog('กรุณากรอกวันที่บันทึก');
                        } else {
                          // if validating fine
                          // create Money
                          Money money = Money(
                            moneyDetail:
                                moneyExpenseDetailController.text.trim(),
                            moneyDate: moneyExpenseDateController.text.trim(),
                            moneyInOut: double.parse(
                              moneyExpenseValueController.text.trim(),
                            ),
                            moneyType: 2,
                            userID: widget.user.userID,
                          );
                          // send data via api to database
                          if (await MoneyApi().insertMoney(money)) {
                            showSuccessDialog('บันทึกเงินออกสำเร็จ');
                            // clear data in textfield
                            moneyExpenseDetailController.clear();
                            moneyExpenseValueController.clear();
                            moneyExpenseDateController.clear();

                            widget.onTransactionAdd();
                            unfocus();
                          } else {
                            showAlertDialog('บันทึกเงินออกไม่สำเร็จ');
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
