class ModelRegion {
  Map<String, List<String>> regions;

  ModelRegion({required this.regions});

  // From JSON
  factory ModelRegion.fromJson(Map<String, dynamic> json) {
    final Map<String, List<String>> regionMap = {};
    json.forEach((key, value) {
      regionMap[key] = List<String>.from(value);
    });
    return ModelRegion(regions: regionMap);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    regions.forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}

class RegionAndClasses {
  String? region;
  List<String>? classes;

  RegionAndClasses({required this.region, required this.classes});
}
