class GetOrderInfoAll {
  String? status;
  int? countOrder;
  double? summOrder;

  GetOrderInfoAll({this.status, this.countOrder, this.summOrder});

  GetOrderInfoAll.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    countOrder = json['count_order'];
    summOrder = json['summ_order'] is int
        ? (json['summ_order'] as int).toDouble()
        : json['summ_order'] as double?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count_order'] = this.countOrder;
    data['summ_order'] = this.summOrder;
    return data;
  }
}
