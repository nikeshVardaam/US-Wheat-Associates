class WeekDataModal {
  double? cASHMT;
  double? cASHBU;

  WeekDataModal({this.cASHMT, this.cASHBU});

  factory WeekDataModal.fromJson(Map<String, dynamic> json) {
    return WeekDataModal(
      cASHMT: (json['CASHMT'] as num?)?.toDouble(),
      cASHBU: (json['CASHBU'] as num?)?.toDouble(),
    );
  }

  static WeekDataModal? fromList(dynamic jsonList) {
    if (jsonList is List && jsonList.isNotEmpty && jsonList.first is Map) {
      return WeekDataModal.fromJson(jsonList.first);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'CASHMT': cASHMT,
      'CASHBU': cASHBU,
    };
  }
}
