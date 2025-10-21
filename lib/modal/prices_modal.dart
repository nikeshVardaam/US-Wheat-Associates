class PricesModal {
  num? dlymnth;
  num? dlyyr;
  String? prdate;
  String? date;
  String? portregn;
  num? cashbu;
  num? cashmt;
  num? nrbyoffset;

  PricesModal(
      {this.dlymnth,
        this.dlyyr,
        this.prdate,
        this.date,
        this.portregn,
        this.cashbu,
        this.cashmt,
        this.nrbyoffset});

  PricesModal.fromJson(Map<String, dynamic> json) {
    dlymnth = json['dlymnth'];
    dlyyr = json['dlyyr'];
    prdate = json['prdate'];
    date = json['date'];
    portregn = json['portregn'];
    cashbu = json['cashbu'];
    cashmt = json['cashmt'];
    nrbyoffset = json['nrbyoffset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dlymnth'] = dlymnth;
    data['dlyyr'] = dlyyr;
    data['prdate'] = prdate;
    data['date'] = date;
    data['portregn'] = portregn;
    data['cashbu'] = cashbu;
    data['cashmt'] = cashmt;
    data['nrbyoffset'] = nrbyoffset;
    return data;
  }
}
