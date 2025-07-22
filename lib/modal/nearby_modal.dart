class NearbyModal {
  double? cASHMT;
  double? cASHBU;

  NearbyModal({this.cASHMT, this.cASHBU});

  NearbyModal.fromJson(Map<String, dynamic> json) {
    cASHMT = json['CASHMT'];
    cASHBU = json['CASHBU'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CASHMT'] = this.cASHMT;
    data['CASHBU'] = this.cASHBU;
    return data;
  }
}
