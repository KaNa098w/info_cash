class DetalizationDefecturaResponse {
  String? codeSku;
  String? nameSku;
  int? positionCount;

  DetalizationDefecturaResponse(
      {this.codeSku, this.nameSku, this.positionCount});

  DetalizationDefecturaResponse.fromJson(Map<String, dynamic> json) {
    codeSku = json['code_sku'];
    nameSku = json['name_sku'];
    positionCount = json['position_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code_sku'] = this.codeSku;
    data['name_sku'] = this.nameSku;
    data['position_count'] = this.positionCount;
    return data;
  }
}
