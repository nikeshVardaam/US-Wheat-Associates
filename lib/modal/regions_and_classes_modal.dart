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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Gulf'] = gulf;
    data['Great Lakes'] = greatLakes;
    data['Pacific Northwest'] = pacificNorthwest;
    return data;
  }
}
