// import 'package:flutter/material.dart';
// import 'package:info_cash/core/api/graphic.dart';
// import 'package:info_cash/core/responses/defectura_response.dart';
// import 'package:info_cash/core/responses/info_sklad.dart';
// import 'package:info_cash/core/responses/organization_response.dart';
// import 'package:info_cash/core/services/defecturalist_services.dart';
// import 'package:info_cash/core/services/organization_service.dart';
// import 'package:info_cash/core/services/info_service.dart';
// import 'package:intl/intl.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   DateTime? _selectedDate;
//   DateTimeRange? _selectedDateRange;
//   final OrganizationServices _catalogService = OrganizationServices();
//   final InfoService _infoService = InfoService();
//   final DefecturalistServices _defecturaService = DefecturalistServices();

//   String _selectedOrganization = 'Организация 1';
//   List<OrganizationResponse> _organizations = [];
//   String _warehouseInfo = '';
//   String _yearInfo = '';
//   String _defecturaInfo = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchOrganizations();
//   }

//   Future<void> _fetchOrganizations() async {
//     try {
//       List<OrganizationResponse> organizations =
//           await _catalogService.getOrganizations('organizations');
//       setState(() {
//         _organizations = organizations;
//       });
//     } catch (error) {
//       print('Не удалось загрузить организации: $error');
//     }
//   }

//   Future<void> _fetchWarehouseData(String uID) async {
//     try {
//       String formattedStart;
//       String formattedEnd;

//       if (_selectedDate != null) {
//         formattedStart = DateFormat('dd.MM.yyyy').format(_selectedDate!);
//         formattedEnd = formattedStart;
//       } else if (_selectedDateRange != null) {
//         formattedStart =
//             DateFormat('dd.MM.yyyy').format(_selectedDateRange!.start);
//         formattedEnd = DateFormat('dd.MM.yyyy').format(_selectedDateRange!.end);
//       } else {
//         DateTime now = DateTime.now();
//         DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//         DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

//         formattedStart = DateFormat('dd.MM.yyyy').format(startOfWeek);
//         formattedEnd = DateFormat('dd.MM.yyyy').format(endOfWeek);
//       }

//       var response = await _infoService.getOrganizations(
//         uID,
//         formattedStart,
//         formattedEnd,
//       );

//       if (response != null && response is List) {
//         List<GetOrderInfo> infoSkladList = (response as List)
//             .map((data) => GetOrderInfo.fromJson(data))
//             .toList();

//         StringBuffer warehouseInfoBuffer = StringBuffer();
//         String yearInfo = response.year as String;

//         for (var infoSklad in infoSkladList) {
//           yearInfo = 'Год: ${infoSklad.year}';
//           if (infoSklad.yearBody != null) {
//             for (var year in infoSklad.yearBody!) {
//               if (year.monthBody != null) {
//                 for (var month in year.monthBody!) {
//                   if (month.dayBody != null) {
//                     for (var day in month.dayBody!) {
//                       warehouseInfoBuffer.writeln(
//                           'Год: ${infoSklad.year}, Месяц: ${year.month}, День: ${month.day}, Статус: ${day.status}, Количество заказов: ${day.countOrder}');
//                     }
//                   }
//                 }
//               }
//             }
//           }
//         }

//         setState(() {
//           _warehouseInfo = warehouseInfoBuffer.toString();
//           _yearInfo = yearInfo;
//         });
//       } else {
//         setState(() {
//           _warehouseInfo = 'Нет данных';
//           _yearInfo = '';
//         });
//       }
//     } catch (error) {
//       print('Не удалось загрузить данные склада: $error');
//       setState(() {
//         _warehouseInfo = 'Ошибка загрузки данных';
//         _yearInfo = _yearInfo;
//       });
//     }
//   }

//   Future<void> _fetchDefecturaData(String dateN, String dateK) async {
//     try {
//       var response = await _defecturaService.getOrganizations(dateN, dateK);

//       if (response != null) {
//         setState(() {
//           _defecturaInfo =
//               'UIDS: ${response.uIDS}, Склад: ${response.nameSklad}, Количество позиций: ${response.positionCount}';
//         });
//       } else {
//         setState(() {
//           _defecturaInfo = 'Нет данных';
//         });
//       }
//     } catch (error) {
//       print('Не удалось загрузить данные дефектуры: $error');
//       setState(() {
//         _defecturaInfo = 'Ошибка загрузки данных';
//       });
//     }
//   }

//   void _selectOrganization(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Выберите организацию'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: _organizations.map((OrganizationResponse organization) {
//               return ListTile(
//                 title: Text(organization.name ?? ''),
//                 onTap: () {
//                   setState(() {
//                     _selectedOrganization = organization.name ?? '';
//                     _fetchWarehouseData(organization.uID ?? '');
//                   });
//                   Navigator.of(context).pop();
//                 },
//               );
//             }).toList(),
//           ),
//         );
//       },
//     );
//   }

//   void _selectDefectura(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Выберите дату'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   DateTime? pickedStart = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime(2101),
//                   );

//                   if (pickedStart != null) {
//                     DateTime? pickedEnd = await showDatePicker(
//                       context: context,
//                       initialDate: pickedStart.add(Duration(days: 1)),
//                       firstDate: pickedStart,
//                       lastDate: DateTime(2101),
//                     );

//                     if (pickedEnd != null) {
//                       String dateN =
//                           DateFormat('dd.MM.yyyy').format(pickedStart);
//                       String dateK = DateFormat('dd.MM.yyyy').format(pickedEnd);

//                       _fetchDefecturaData(dateN, dateK);
//                       Navigator.of(context).pop();
//                     }
//                   }
//                 },
//                 child: const Text('Выбрать диапазон дат'),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _selectedDateRange = null; // Сброс диапазона дат при выборе одной даты
//       });
//       _fetchWarehouseData(_selectedOrganization);
//     }
//   }

//   Future<void> _selectDateRange(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//       initialDateRange: _selectedDateRange,
//     );
//     if (picked != null && picked != _selectedDateRange) {
//       setState(() {
//         _selectedDateRange = picked;
//         _selectedDate = null; // Сброс одной даты при выборе диапазона дат
//       });
//       _fetchWarehouseData(_selectedOrganization);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('Касса')),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           Center(
//             child: Text(
//               'Добро пожаловать в $_selectedOrganization!',
//               style: const TextStyle(fontSize: 24),
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => _selectDefectura(context),
//             child: const Text('Показать дефектура товаров'),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () => _selectOrganization(context),
//             child: const Text('Выбрать организацию'),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () => _selectDate(context),
//                 child: const Text('Выбрать дату'),
//               ),
//               ElevatedButton(
//                 onPressed: () => _selectDateRange(context),
//                 child: const Text('Выбрать диапазон дат'),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           if (_selectedDate != null)
//             Center(child: Text('Выбранная дата: ${_selectedDate!.toLocal()}')),
//           if (_selectedDateRange != null)
//             Text(
//               'Выбранный диапазон дат: ${_selectedDateRange!.start.toLocal()} - ${_selectedDateRange!.end.toLocal()}',
//             ),
//           const SizedBox(height: 20),
//           const Text(
//             'Информация о складе',
//             style: TextStyle(fontSize: 20),
//           ),
//           Text(
//             _yearInfo,
//             style: TextStyle(color: Colors.black),
//           ), // Выводим только год
//           const SizedBox(height: 20),
//           Text(
//             _warehouseInfo,
//             style: TextStyle(color: Colors.black),
//           ), // Выводим информацию о складе
//           const SizedBox(height: 20),
//           const Text(
//             'Дефектура товаров',
//             style: TextStyle(fontSize: 20),
//           ),
//           Text(
//             _defecturaInfo,
//             style: TextStyle(color: Colors.black),
//           ), // Выводим информацию о дефектуре товаров
//         ],
//       ),
//     );
//   }
// }
