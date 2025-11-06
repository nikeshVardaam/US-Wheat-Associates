class GraphModal {
  double? cASHMT;
  String? pRDATE;

  GraphModal({this.cASHMT, this.pRDATE});

  GraphModal.fromJson(Map<String, dynamic> json) {
    cASHMT = json['CASHMT'];
    pRDATE = json['PRDATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CASHMT'] = cASHMT;
    data['PRDATE'] = pRDATE;
    return data;
  }
}
