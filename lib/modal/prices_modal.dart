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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dlymnth'] = this.dlymnth;
    data['dlyyr'] = this.dlyyr;
    data['prdate'] = this.prdate;
    data['date'] = this.date;
    data['portregn'] = this.portregn;
    data['cashbu'] = this.cashbu;
    data['cashmt'] = this.cashmt;
    data['nrbyoffset'] = this.nrbyoffset;
    return data;
  }
}
