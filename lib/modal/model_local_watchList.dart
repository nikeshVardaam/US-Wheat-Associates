import 'package:uswheat/modal/watchlist_modal.dart';

class ModelLocalWatchlist {
  String? type;
  String? date;
  String? cls;
  WheatData? yearAverage;
  WheatData? finalAverage;
  WheatData? currentAverage;

  ModelLocalWatchlist({
    required this.type,
    required this.date,
    required this.cls,
    required this.yearAverage,
    required this.finalAverage,
    required this.currentAverage,
  });

  factory ModelLocalWatchlist.fromJson(Map<String, dynamic> json) {
    return ModelLocalWatchlist(
      type: json['type'] as String?,
      date: json['date'] as String?,
      cls: json['cls'] as String?,
      yearAverage: json['yearAverage'] != null ? WheatData.fromJson(json['yearAverage']) : null,
      finalAverage: json['finalAverage'] != null ? WheatData.fromJson(json['finalAverage']) : null,
      currentAverage: json['currentAverage'] != null ? WheatData.fromJson(json['currentAverage']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'date': date,
      'cls': cls,
      'yearAverage': yearAverage,
      'finalAverage': finalAverage,
      'currentAverage': currentAverage,
    };
  }
}
