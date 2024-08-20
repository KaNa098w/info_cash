   // final Map<String, List<IncomeExpenseData>> _organizationIncomeExpenseData = {
  //   'Организация 1': [
  //     IncomeExpenseData(DateTime(2023, 1), 3000, 1000),
  //     IncomeExpenseData(DateTime(2023, 2), 3500, 1200),
  //     IncomeExpenseData(DateTime(2023, 3), 4000, 1500),
  //     IncomeExpenseData(DateTime(2023, 4), 4500, 1700),
  //     IncomeExpenseData(DateTime(2023, 5), 5000, 2000),
  //   ],
  //   'Организация 2': [
  //     IncomeExpenseData(DateTime(2023, 1), 2000, 800),
  //     IncomeExpenseData(DateTime(2023, 2), 2500, 900),
  //     IncomeExpenseData(DateTime(2023, 3), 2800, 950),
  //     IncomeExpenseData(DateTime(2023, 4), 3000, 1000),
  //     IncomeExpenseData(DateTime(2023, 5), 3000, 1100),
  //   ],
  //   'Организация 3': [
  //     IncomeExpenseData(DateTime(2023, 1), 6000, 2500),
  //     IncomeExpenseData(DateTime(2023, 2), 6200, 2700),
  //     IncomeExpenseData(DateTime(2023, 3), 6500, 3000),
  //     IncomeExpenseData(DateTime(2023, 4), 6800, 3200),
  //     IncomeExpenseData(DateTime(2023, 5), 7000, 3500),
  //   ],
  // };
  

  
  // const SizedBox(height: 20),
          // SizedBox(
          //   height: 300,
          //   child: SfCircularChart(
          //     title: ChartTitle(text: 'Отчет по операциям'),
          //     legend: Legend(
          //       isVisible: true,
          //       overflowMode: LegendItemOverflowMode.wrap,
          //     ),
          //     series: <CircularSeries>[
          //       PieSeries<Operation, String>(
          //         dataSource: _operations,
          //         xValueMapper: (Operation operation, _) => operation.type,
          //         yValueMapper: (Operation operation, _) => operation.amount,
          //         dataLabelMapper: (Operation operation, _) =>
          //             '${operation.type}: ${operation.amount}',
          //         dataLabelSettings: const DataLabelSettings(isVisible: true),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 20),
          // const Text(
          //   'Операции',
          //   style: TextStyle(fontSize: 20),
          // ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: _operations.length,
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text(_operations[index].type),
          //       trailing: Text('${_operations[index].amount}'),
          //     );
          //   },
          // ),
          // const SizedBox(height: 20),
          // const Text(
          //   'Статистика роста доходов и расходов',
          //   style: TextStyle(fontSize: 20),
          // ),
          // SizedBox(
          //   height: 300,
          //   child: SfCartesianChart(
          //     primaryXAxis: DateTimeAxis(),
          //     title: ChartTitle(text: 'Рост доходов и расходов по месяцам'),
          //     legend: Legend(isVisible: true),
          //     tooltipBehavior: TooltipBehavior(enable: true),
          //     series: <CartesianSeries>[
          //       LineSeries<IncomeExpenseData, DateTime>(
          //         name: 'Доход',
          //         dataSource:
          //             _organizationIncomeExpenseData[_selectedOrganization]!,
          //         xValueMapper: (IncomeExpenseData data, _) => data.month,
          //         yValueMapper: (IncomeExpenseData data, _) => data.income,
          //         dataLabelSettings: const DataLabelSettings(isVisible: true),
          //       ),
          //       LineSeries<IncomeExpenseData, DateTime>(
          //         name: 'Расход',
          //         dataSource:
          //             _organizationIncomeExpenseData[_selectedOrganization]!,
          //         xValueMapper: (IncomeExpenseData data, _) => data.month,
          //         yValueMapper: (IncomeExpenseData data, _) => data.expense,
          //         dataLabelSettings: const DataLabelSettings(isVisible: true),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 20),