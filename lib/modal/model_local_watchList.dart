import 'package:uswheat/modal/graph_modal.dart';
import 'package:uswheat/modal/watchlist_modal.dart';

class ModelLocalWatchlist {
  List<ModelLocalWatchlistData>? list;

  ModelLocalWatchlist.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null && json['list'] is List) {
      list = (json['list'] as List).map((v) => ModelLocalWatchlistData.fromJson(v)).toList();
    } else {
      list = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModelLocalWatchlistData {
  String? type;
  String? date;
  String? cls;
  WheatData? yearAverage;
  WheatData? finalAverage;
  WheatData? currentAverage;

  ModelLocalWatchlistData({
    required this.type,
    required this.date,
    required this.cls,
    required this.yearAverage,
    required this.finalAverage,
    required this.currentAverage,
  });

  factory ModelLocalWatchlistData.fromJson(Map<String, dynamic> json) {
    return ModelLocalWatchlistData(
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

class ModelLocalPriceWatchListData{
  String? type;
  String? date;
  String? cls;
  String? graphCode;

}
