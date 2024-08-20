import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:info_cash/core/responses/info_sklad.dart';
import 'package:info_cash/core/services/info_service.dart';
import 'package:info_cash/core/responses/organization_response.dart';
import 'package:intl/intl.dart';

class SaleGrafic extends StatefulWidget {
  final OrganizationResponse? selectedOrganization;
  final DateTime? dateN;
  final DateTime? dateK;

  const SaleGrafic({
    Key? key,
    this.selectedOrganization,
    this.dateN,
    this.dateK,
  }) : super(key: key);

  @override
  _SaleGraficState createState() => _SaleGraficState();
}

class _SaleGraficState extends State<SaleGrafic> {
  final InfoService _infoService = InfoService();
  GetOrderInfo? _orderInfo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrderInfo();
  }

  Future<void> _fetchOrderInfo() async {
    if (widget.selectedOrganization != null &&
        widget.dateN != null &&
        widget.dateK != null) {
      setState(() {
        _isLoading = true;
      });
      final orderInfo = await _infoService.getOrderInfo(
        widget.selectedOrganization!.uID!,
        widget.dateN!,
        widget.dateK!,
      );
      setState(() {
        _orderInfo = orderInfo;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isLoading)
          Center(child: CircularProgressIndicator())
        else if (_orderInfo == null || _orderInfo!.yearBody == null)
          Center(child: Text("Нет данных для отображения"))
        else
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType.days,
                dateFormat: DateFormat.MMMd(),
              ),
              primaryYAxis: NumericAxis(),
              title: ChartTitle(text: 'Отгруженные заказы'),
              legend: Legend(isVisible: false),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                zoomMode: ZoomMode.x,
              ),
              series: <ChartSeries<_ChartData, DateTime>>[
                AreaSeries<_ChartData, DateTime>(
                  dataSource: _buildChartData(),
                  xValueMapper: (_ChartData data, _) => data.date,
                  yValueMapper: (_ChartData data, _) => data.countOrder,
                  name: 'Отгружен',
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.6),
                      Colors.blue.withOpacity(0.0),
                    ],
                    stops: [0.2, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderColor: Colors.blue,
                  borderWidth: 2,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<_ChartData> _buildChartData() {
    final List<_ChartData> chartData = [];

    for (var yearBody in _orderInfo!.yearBody!) {
      for (var monthBody in yearBody.monthBody!) {
        for (var dayBody in monthBody.dayBody!) {
          if (dayBody.status == "Отгружен") {
            // Фильтрация данных по статусу
            final date =
                DateTime(_orderInfo!.year!, yearBody.month!, monthBody.day!);
            chartData.add(_ChartData(
                date, dayBody.countOrder ?? 0, dayBody.status ?? ""));
          }
        }
      }
    }

    return chartData;
  }
}

class _ChartData {
  final DateTime date;
  final int countOrder;
  final String status;

  _ChartData(this.date, this.countOrder, this.status);
}
