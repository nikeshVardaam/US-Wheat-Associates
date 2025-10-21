class ForwardPricesModal {
  num? cASHMT;
  num? cASHBU;
  num? nRBYOFFSET;

  ForwardPricesModal({this.cASHMT, this.cASHBU, this.nRBYOFFSET});

  ForwardPricesModal.fromJson(Map<String, dynamic> json) {
    cASHMT = json['CASHMT'];
    cASHBU = json['CASHBU'];
    nRBYOFFSET = json['NRBYOFFSET'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CASHMT'] = cASHMT;
    data['CASHBU'] = cASHBU;
    data['NRBYOFFSET'] = nRBYOFFSET;
    return data;
  }
}
