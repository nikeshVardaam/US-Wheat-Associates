class AllPriceDataModal {
  Nearby? nearby;
  Nearby? weekly;
  Yearly? yearly;
  List<Forward>? forward;
  String? prdate;

  AllPriceDataModal(
      {this.nearby, this.weekly, this.yearly, this.forward, this.prdate});

  AllPriceDataModal.fromJson(Map<String, dynamic> json) {
    if (json['nearby'] is Map<String, dynamic>) {
      nearby = Nearby.fromJson(json['nearby']);
    } else {
      nearby = null;
    }

    if (json['weekly'] is Map<String, dynamic>) {
      weekly = Nearby.fromJson(json['weekly']);
    } else {
      weekly = null;
    }

    if (json['yearly'] is Map<String, dynamic>) {
      yearly = Yearly.fromJson(json['yearly']);
    } else {
      yearly = null;
    }

    if (json['forward'] != null && json['forward'] is List) {
      forward = (json['forward'] as List)
          .map((v) => Forward.fromJson(v))
          .toList();
    } else {
      forward = [];
    }

    prdate = json['prdate'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nearby != null) {
      data['nearby'] = this.nearby!.toJson();
    }
    if (this.weekly != null) {
      data['weekly'] = this.weekly!.toJson();
    }
    if (this.yearly != null) {
      data['yearly'] = this.yearly!.toJson();
    }
    if (this.forward != null) {
      data['forward'] = this.forward!.map((v) => v.toJson()).toList();
    }
    data['prdate'] = this.prdate;
    return data;
  }
}

class Nearby {
  double? cASHMT;
  double? cASHBU;

  Nearby({this.cASHMT, this.cASHBU});

  Nearby.fromJson(Map<String, dynamic> json) {
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

class Yearly {
  double? cASHMT;

  Yearly({this.cASHMT});

  Yearly.fromJson(Map<String, dynamic> json) {
    cASHMT = json['CASHMT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CASHMT'] = this.cASHMT;
    return data;
  }
}

class Forward {
  double? cASHMT;
  double? cASHBU;
  int? nRBYOFFSET;

  Forward({this.cASHMT, this.cASHBU, this.nRBYOFFSET});

  Forward.fromJson(Map<String, dynamic> json) {
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
