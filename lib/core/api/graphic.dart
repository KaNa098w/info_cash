class Operation {
  final String type;
  final int amount;

  Operation(this.type, this.amount);
}

class IncomeExpenseData {
  final DateTime month;
  final int income;
  final int expense;

  IncomeExpenseData(this.month, this.income, this.expense);
}

class WarehouseData {
  int nds;
  int acceptedOrders;
  int completedOrders;
  int uncompletedOrders;
  int pendingOrders;

  WarehouseData({
    required this.nds,
    required this.acceptedOrders,
    required this.completedOrders,
    required this.uncompletedOrders,
    required this.pendingOrders,
  });
}

class OrderData {
  final String status;
  final int count;

  OrderData(this.status, this.count);
}
