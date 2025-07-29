class   NearbyModal {
  final double cASHMT;
  final double cASHBU;

  NearbyModal({required this.cASHMT, required this.cASHBU});

  factory NearbyModal.fromJson(Map<String, dynamic> json) {
    return NearbyModal(
      cASHMT: (json['CASHMT'] ?? 0).toDouble(),
      cASHBU: (json['CASHBU'] ?? 0).toDouble(),
    );
  }
}
