import 'package:flutter/material.dart';
import 'package:info_cash/core/services/detalization_defectura_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:info_cash/core/responses/defectura_response.dart';
import 'package:info_cash/core/services/defecturalist_services.dart';
import 'package:info_cash/core/responses/detalization_defectura_response.dart';

class DefacturaPie extends StatefulWidget {
  final DateTime dateN;
  final DateTime dateK;

  const DefacturaPie({Key? key, required this.dateN, required this.dateK})
      : super(key: key);

  @override
  _DefacturaPieState createState() => _DefacturaPieState();
}

class _DefacturaPieState extends State<DefacturaPie> {
  final DefecturalistServices _defecturalistServices = DefecturalistServices();
  final DetalizationDeFecturaServices _detalizationService =
      DetalizationDeFecturaServices();

  List<DefecturaResponse> _defecturaList = [];
  List<bool> _isVisibleList = [];
  int _totalPositionCount = 0;
  int? _selectedIndex;
  bool _isLoadingDetails = false;
  List<DetalizationDefecturaResponse> _detailList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final defecturaList =
          await _defecturalistServices.getDefectura(widget.dateN, widget.dateK);
      setState(() {
        if (defecturaList != null) {
          _defecturaList = defecturaList;
          _isVisibleList = List<bool>.filled(defecturaList.length, true);
          _recalculateTotal();
        }
      });
    } catch (e) {
      print("Error fetching defectura data: $e");
    }
  }

  void _recalculateTotal() {
    _totalPositionCount = 0;
    for (int i = 0; i < _defecturaList.length; i++) {
      if (_isVisibleList[i]) {
        _totalPositionCount += _defecturaList[i].positionCount ?? 0;
      }
    }
  }

  Future<void> _showDetails(String uID) async {
    setState(() {
      _isLoadingDetails = true; // Устанавливаем флаг загрузки в true
      _detailList = []; // Очищаем предыдущие данные перед загрузкой новых
    });
    try {
      final List<DetalizationDefecturaResponse> details =
          await _detalizationService.getDetalizationDefectura(
              uID, widget.dateN, widget.dateK);
      if (details.isNotEmpty) {
        setState(() {
          _detailList =
              details; // Обновляем список данных для отображения в таблице
        });
        _showDetailsDialog();
      } else {
        _showErrorDialog('Нет данных для отображения');
      }
    } catch (e) {
      _showErrorDialog('Ошибка загрузки данных');
    } finally {
      setState(() {
        _isLoadingDetails = false; // Завершаем загрузку
      });
    }
  }

  void _showDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Детализация Дефектуры'),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildDetailsTable(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailsTable() {
    return DataTable(
      columnSpacing: 20.0, // Пространство между колонками для лучшей видимости
      columns: [
        DataColumn(label: Expanded(child: Text('Наименование'))),
        DataColumn(label: Expanded(child: Text('Количество'))),
      ],
      rows: _detailList.map((detail) {
        return DataRow(cells: [
          DataCell(Container(
              width: 150,
              child: Text(detail.nameSku ?? ''))), // Устанавливаем ширину
          DataCell(Container(
              width: 50, child: Text(detail.positionCount?.toString() ?? ''))),
        ]);
      }).toList(),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _defecturaList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 480,
                    child: SfCircularChart(
                      title: ChartTitle(text: 'Диаграмма Дефектуры'),
                      legend: Legend(
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap,
                        toggleSeriesVisibility: true,
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<DefecturaResponse, String>(
                          dataSource: _defecturaList,
                          xValueMapper: (DefecturaResponse data, _) =>
                              data.nameSklad,
                          yValueMapper: (DefecturaResponse data, _) =>
                              data.positionCount,
                          dataLabelMapper: (DefecturaResponse data, _) {
                            List<String> words =
                                data.nameSklad?.split(' ') ?? [];
                            String lastWord =
                                words.isNotEmpty ? words.last : '';
                            return '${data.positionCount}\n$lastWord';
                          },
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            connectorLineSettings: ConnectorLineSettings(
                                type: ConnectorType.curve),
                          ),
                          radius: '80%',
                          innerRadius: '40%',
                          explode: true,
                          onPointTap: (ChartPointDetails details) {
                            if (details.pointIndex != null &&
                                _defecturaList[details.pointIndex!].uIDS !=
                                    null) {
                              setState(() {
                                _isLoadingDetails =
                                    true; // Устанавливаем флаг загрузки при нажатии
                              });
                              _showDetails(
                                  _defecturaList[details.pointIndex!].uIDS!);
                            } else {
                              _showErrorDialog(
                                  'Не удалось загрузить данные для выбранного элемента.');
                            }
                          },
                        ),
                      ],
                      annotations: <CircularChartAnnotation>[
                        CircularChartAnnotation(
                          widget: Container(
                            child: Text(
                              'Всего: $_totalPositionCount',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isLoadingDetails)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
  }
}
