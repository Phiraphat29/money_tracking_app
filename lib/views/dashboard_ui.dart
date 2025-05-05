import 'package:flutter/material.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/models/user.dart';
import 'package:money_tracking_app/services/money_api.dart';

class DashboardUI extends StatefulWidget {
  final User user;
  const DashboardUI({super.key, required this.user});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'เงินเข้า/เงินออก',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(primaryColor),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Money>>(
              future: MoneyApi().getMoney(widget.user.userID!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('ข้อผิดพลาด: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('ไม่พบรายการธุรกรรม'));
                } else {
                  // Sort the transactions by moneyID (newest/highest ID first)
                  final sortedTransactions = List<Money>.from(snapshot.data!);
                  sortedTransactions.sort((a, b) {
                    // Sort in descending order (newest/highest ID first)
                    return (b.moneyID ?? 0).compareTo(a.moneyID ?? 0);
                  });

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = sortedTransactions[index];
                      final isIncome = transaction.moneyType == 1;

                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 12),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Color(primaryAccentColor),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                isIncome
                                    ? Color(successColor)
                                    : Color(primaryAccentColor),
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            transaction.moneyDetail ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(transaction.moneyDate ?? ''),
                          trailing: Text(
                            '${isIncome ? "+" : "-"}${transaction.moneyInOut?.toStringAsFixed(2)} บาท',
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
