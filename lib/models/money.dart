class Money {
  int? moneyID;
  String? moneyDetail;
  String? moneyDate;
  double? moneyInOut;
  int? moneyType;
  int? userID;

  Money({
    this.moneyID,
    this.moneyDetail,
    this.moneyDate,
    this.moneyInOut,
    this.moneyType,
    this.userID,
  });

  Money.fromJson(Map<dynamic, dynamic> json) {
    moneyID = json['moneyID'];
    moneyDetail = json['moneyDetail'];
    moneyDate = json['moneyDate'];
    moneyInOut = json['moneyInOut'];
    moneyType = json['moneyType'];
    userID = json['userID'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['moneyID'] = this.moneyID;
    data['moneyDetail'] = this.moneyDetail;
    data['moneyDate'] = this.moneyDate;
    data['moneyInOut'] = this.moneyInOut;
    data['moneyType'] = this.moneyType;
    data['userID'] = this.userID;
    return data;
  }
}
