class ForwardPricesModal {
  double? cASHMT;
  double? cASHBU;
  int? nRBYOFFSET;

  ForwardPricesModal({this.cASHMT, this.cASHBU, this.nRBYOFFSET});

  ForwardPricesModal.fromJson(Map<String, dynamic> json) {
    cASHMT = json['CASHMT'];
    cASHBU = json['CASHBU'];
    nRBYOFFSET = json['NRBYOFFSET'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CASHMT'] = this.cASHMT;
    data['CASHBU'] = this.cASHBU;
    data['NRBYOFFSET'] = this.nRBYOFFSET;
    return data;
  }
}
