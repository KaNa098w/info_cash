import 'package:flutter/material.dart';
import 'package:info_cash/core/responses/all_info_response.dart';
import 'package:info_cash/core/responses/organization_response.dart';
import 'package:info_cash/core/services/all_info_service.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AllInfoColumn extends StatefulWidget {
  final OrganizationResponse? selectedOrganization;
  final DateTime? dateN;
  final DateTime? dateK;

  const AllInfoColumn({
    Key? key,
    this.selectedOrganization,
    this.dateN,
    this.dateK,
  }) : super(key: key);

  @override
  _AllInfoColumnState createState() => _AllInfoColumnState();
}

class _AllInfoColumnState extends State<AllInfoColumn> {
  final AllInfoServices _allInfoServices = AllInfoServices();

  List<GetOrderInfoAll> _orderInfoList = [];
  Map<String, bool> _selectedStatuses =
      {}; // Для управления отображением статусов

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final lastThreeDays = today.subtract(Duration(days: 2));

    DateTime dateN = widget.dateN ?? lastThreeDays;
    DateTime dateK = widget.dateK ?? today;

    String uID = widget.selectedOrganization?.uID ??
        '2bfb6368-e9af-11ee-abbf-ac1f6b3ea7f5';

    _getOrderInfo(uID, dateN, dateK);
  }

  Future<void> _getOrderInfo(String uID, DateTime dateN, DateTime dateK) async {
    try {
      final orderInfoList =
          await _allInfoServices.getOrderInfoAll(uID, dateN, dateK);
      setState(() {
        _orderInfoList = orderInfoList;
        _selectedStatuses = {
          for (var order in orderInfoList) order.status!: true
        };
      });
    } catch (e) {
      print("Error fetching order info: $e");
    }
  }

  @override
  void didUpdateWidget(covariant AllInfoColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedOrganization != oldWidget.selectedOrganization ||
        widget.dateN != oldWidget.dateN ||
        widget.dateK != oldWidget.dateK) {
      _getOrderInfo(
          widget.selectedOrganization!.uID!, widget.dateN!, widget.dateK!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,##0', 'en_US');
    final List<Color> _colorPalette = [
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
      Colors.deepOrangeAccent,
      Colors.amberAccent,
      Colors.deepPurpleAccent,
      Colors.pinkAccent,
      Colors.yellowAccent,
      Colors.cyanAccent,
    ];

    final filteredOrderInfoList = _orderInfoList
        .where((order) => _selectedStatuses[order.status] ?? false)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (widget.selectedOrganization != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Организация: ${widget.selectedOrganization!.name}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.dateN != null && widget.dateK != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Период: ${widget.dateN!.day}.${widget.dateN!.month}.${widget.dateN!.year} - ${widget.dateK!.day}.${widget.dateK!.month}.${widget.dateK!.year}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          if (filteredOrderInfoList.isNotEmpty)
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                title: ChartTitle(
                  text: 'Статистика заказов',
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                primaryXAxis: CategoryAxis(
                  labelRotation: -45,
                  majorGridLines: MajorGridLines(width: 0),
                ),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value}',
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(size: 0),
                ),
                series: <ChartSeries>[
                  ColumnSeries<GetOrderInfoAll, String>(
                    dataSource: filteredOrderInfoList,
                    xValueMapper: (GetOrderInfoAll data, int index) =>
                        data.status!,
                    yValueMapper: (GetOrderInfoAll data, _) => data.countOrder,
                    name: 'Количество заказов',
                    pointColorMapper: (GetOrderInfoAll data, int index) =>
                        _colorPalette[index % _colorPalette.length],
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    width: 0.6,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    isTrackVisible: true,
                    trackColor: Colors.grey.shade200,
                    enableTooltip: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.lightBlueAccent.withOpacity(0.7)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
                annotations: filteredOrderInfoList.asMap().entries.map((entry) {
                  int index = entry.key;
                  GetOrderInfoAll data = entry.value;
                  return CartesianChartAnnotation(
                    widget: Container(
                      child: Transform.rotate(
                        angle: -1 *
                            3.14159 /
                            180, // Поворот текста на -45 градусов
                        child: Text(
                          '${numberFormat.format(data.summOrder)}₸', // Используем форматировщик
                          style: TextStyle(
                            color: const Color.fromARGB(255, 46, 11, 0),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    coordinateUnit: CoordinateUnit.point,
                    region: AnnotationRegion.chart,
                    x: data.status!,
                    y: data.countOrder! > 2000
                        ? data.countOrder! + (data.countOrder! * 0.1)
                        : data.countOrder! < 100
                            ? data.countOrder! + (data.countOrder! * 20)
                            : data.countOrder! + (data.countOrder! * 1),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
