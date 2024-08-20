class DefecturaResponse {
  String? uIDS;
  String? codeSklad;
  String? nameSklad;
  int? positionCount;

  DefecturaResponse(
      {this.uIDS, this.codeSklad, this.nameSklad, this.positionCount});

  DefecturaResponse.fromJson(Map<String, dynamic> json) {
    uIDS = json['UIDS'];
    codeSklad = json['code_sklad'];
    nameSklad = json['name_sklad'];
    positionCount = json['position_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UIDS'] = this.uIDS;
    data['code_sklad'] = this.codeSklad;
    data['name_sklad'] = this.nameSklad;
    data['position_count'] = this.positionCount;
    return data;
  }
}
