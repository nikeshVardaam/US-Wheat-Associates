class SalesData {
  final String month;
  final double sales;

  SalesData({required this.month, required this.sales});

  @override
  String toString() {
    return 'SalesData(month: $month, sales: $sales)';
  }
}
