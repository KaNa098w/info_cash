class OrganizationResponse {
  String? uID;
  String? code;
  String? name;

  OrganizationResponse({this.uID, this.code, this.name});

  OrganizationResponse.fromJson(Map<String, dynamic> json) {
    uID = json['UID'];
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UID'] = this.uID;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}
