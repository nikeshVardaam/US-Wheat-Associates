class RegionsAndClassesModal {
  List<String>? gulfOfMexico;
  List<String>? greatLakes;
  List<String>? pacificNorthwest;

  RegionsAndClassesModal(
      {this.gulfOfMexico, this.greatLakes, this.pacificNorthwest});

  RegionsAndClassesModal.fromJson(Map<String, dynamic> json) {
    gulfOfMexico = json['Gulf of Mexico'].cast<String>();
    greatLakes = json['Great Lakes'].cast<String>();
    pacificNorthwest = json['Pacific Northwest'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Gulf of Mexico'] = this.gulfOfMexico;
    data['Great Lakes'] = this.greatLakes;
    data['Pacific Northwest'] = this.pacificNorthwest;
    return data;
  }
}
