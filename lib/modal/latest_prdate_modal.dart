class LatestPrdateModal {
  String? prdate;

  LatestPrdateModal({this.prdate});

  factory LatestPrdateModal.fromJson(Map<String, dynamic> json) {
    return LatestPrdateModal(
      prdate: json['prdate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prdate': prdate,
    };
  }
}
