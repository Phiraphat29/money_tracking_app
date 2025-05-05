import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:money_tracking_app/constants/baseurl.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/money_api.dart';
import 'package:money_tracking_app/views/dashboard_ui.dart';
import 'package:money_tracking_app/views/expense_ui.dart';
import 'package:money_tracking_app/views/income_ui.dart';

class HomeUI extends StatefulWidget {
  final User user;
  const HomeUI({super.key, required this.user});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  // textformfield income controller
  TextEditingController moneyIncomeDetailController = TextEditingController();
  TextEditingController moneyIncomeValueController = TextEditingController();
  TextEditingController moneyIncomeDateController = TextEditingController();

  // textformfield expense controller
  TextEditingController moneyExpenseDetailController = TextEditingController();
  TextEditingController moneyExpenseValueController = TextEditingController();
  TextEditingController moneyExpenseDateController = TextEditingController();

  // bottombar controller
  final bottombarController = PageController(initialPage: 1);

  // index of bottombar
  int index = 1;

  // refresh state
  void refreshHomeState() {
    setState(() {});
  }

  // show snackbar
  showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: color,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Color(primaryColor),
        selectedItemColor: Color(secondaryColor),
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() {
            index = value;
            bottombarController.jumpToPage(value);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.moneyBillTrendUp),
            label: 'เงินเข้า',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.moneyBillTransfer),
            label: 'เงินออก',
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              // Custom curved app bar
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Color(primaryColor),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      30,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        widget.user.userFullName!,
                        style: TextStyle(
                          color: Color(secondaryColor),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    widget.user.userImage != ""
                        ? Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: ClipOval(
                            child: Image.network(
                              '$baseUrl/images/users/${widget.user.userImage!}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Icon(Icons.account_circle_rounded, size: 100),
                        ),
                  ],
                ),
              ),
              // Detail Box
              Padding(
                padding: const EdgeInsets.only(top: 140.0, left: 20, right: 20),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(primaryPaleColor),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(
                      color: Color(primaryAccentColor),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 2,
                        color: Color(primaryPaleColor),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FutureBuilder(
                      future: MoneyApi().getMoney(widget.user.userID!),
                      builder: (context, snapshot) {
                        // Calculate total of balance, income and expense
                        double totalBalance = 0;
                        double totalIncome = 0;
                        double totalExpense = 0;
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          for (var money in snapshot.data!) {
                            if (money.moneyType == 1) {
                              // Income
                              totalIncome += money.moneyInOut!;
                            } else {
                              // Expense
                              totalExpense += money.moneyInOut!;
                            }
                          }
                        }
                        totalBalance = totalIncome - totalExpense;
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'ยอดเงินคงเหลือ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(secondaryColor),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${totalBalance.toStringAsFixed(2)} บาท',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(secondaryColor),
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10,
                                    color: Color(primaryAccentColor),
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '⬇ยอดเงินเข้ารวม',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color(secondaryColor),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      totalIncome.toStringAsFixed(2),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color(secondaryColor),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Color(primaryAccentColor),
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'ยอดเงินออกรวม⬆',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(secondaryColor),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      totalExpense.toStringAsFixed(2),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color(secondaryColor),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Color(primaryAccentColor),
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: bottombarController,
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              children: [
                // Income page
                IncomeUI(user: widget.user, onTransactionAdd: refreshHomeState),
                // Home page
                DashboardUI(user: widget.user),
                // Expense page
                ExpenseUI(
                  user: widget.user,
                  onTransactionAdd: refreshHomeState,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
