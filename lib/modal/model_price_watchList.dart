import 'package:uswheat/modal/watchlist_modal.dart';
import 'package:uswheat/modal/graph_modal.dart';

class ModelPriceWatchList {
  final String type;
  final FilterData filterData; // uses FilterData from watchlist_modal.dart
  final List<GraphDataModal>? graphData;

  ModelPriceWatchList({
    required this.type,
    required this.filterData,
    this.graphData,
  });

  factory ModelPriceWatchList.fromJson(Map<String, dynamic> json) {
    return ModelPriceWatchList(
      type: json['type'],
      filterData: FilterData.fromJson(json['filterdata']),
      graphData: json['graphData'] != null ? (json['graphData'] as List).map((e) => GraphDataModal.fromJson(e)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'filterdata': filterData,
      if (graphData != null) 'graphData': graphData!.map((e) => e.toJson()).toList(),
    };
  }
}
