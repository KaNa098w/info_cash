class GetOrderInfo {
  int? year;
  List<YearBody>? yearBody;

  GetOrderInfo({this.year, this.yearBody});

  GetOrderInfo.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    if (json['year_body'] != null) {
      yearBody = <YearBody>[];
      json['year_body'].forEach((v) {
        yearBody!.add(new YearBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    if (this.yearBody != null) {
      data['year_body'] = this.yearBody!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YearBody {
  int? month;
  List<MonthBody>? monthBody;

  YearBody({this.month, this.monthBody});

  YearBody.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    if (json['month_body'] != null) {
      monthBody = <MonthBody>[];
      json['month_body'].forEach((v) {
        monthBody!.add(new MonthBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    if (this.monthBody != null) {
      data['month_body'] = this.monthBody!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MonthBody {
  int? day;
  List<DayBody>? dayBody;

  MonthBody({this.day, this.dayBody});

  MonthBody.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['day_body'] != null) {
      dayBody = <DayBody>[];
      json['day_body'].forEach((v) {
        dayBody!.add(new DayBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    if (this.dayBody != null) {
      data['day_body'] = this.dayBody!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DayBody {
  String? status;
  int? countOrder;

  DayBody({this.status, this.countOrder});

  DayBody.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    countOrder = json['count_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count_order'] = this.countOrder;
    return data;
  }
}
