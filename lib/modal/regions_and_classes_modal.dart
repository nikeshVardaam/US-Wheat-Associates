class RegionsAndClassesModal {
  List<String>? gulf;
  List<String>? greatLakes;
  List<String>? pacificNorthwest;

  RegionsAndClassesModal({this.gulf, this.greatLakes, this.pacificNorthwest});

  RegionsAndClassesModal.fromJson(Map<String, dynamic> json) {
    gulf = json['Gulf'].cast<String>();
    greatLakes = json['Great Lakes'].cast<String>();
    pacificNorthwest = json['Pacific Northwest'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Gulf'] = this.gulf;
    data['Great Lakes'] = this.greatLakes;
    data['Pacific Northwest'] = this.pacificNorthwest;
    return data;
  }
}
