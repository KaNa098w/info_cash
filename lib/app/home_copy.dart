import 'package:flutter/material.dart';
import 'package:info_cash/app/all_info_column.dart';
import 'package:info_cash/app/sale_grafic.dart';
import 'defactura_pie.dart';
import 'package:info_cash/core/responses/organization_response.dart';
import 'package:info_cash/core/services/organization_service.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final OrganizationServices _organizationServices = OrganizationServices();
  List<OrganizationResponse> _organizations = [];
  OrganizationResponse? _selectedOrganization;
  DateTime? _dateN;
  DateTime? _dateK;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDefactura();
  }

  Future<void> _initializeDefactura() async {
    final today = DateTime.now();
    final lastMonth = DateTime(today.year, today.month - 1, today.day);

    setState(() {
      _dateN = lastMonth;
      _dateK = today;
    });
  }

  Future<void> _selectOrganization() async {
    setState(() {
      _isLoading = true;
    });

    final organizations =
        await _organizationServices.getOrganizations('warehouse');

    setState(() {
      _organizations = organizations;
      _isLoading = false;
    });

    final selectedOrganization = await showDialog<OrganizationResponse>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Выберите организацию'),
          content: Container(
            width: double.maxFinite,
            height: 500,
            child: ListView.builder(
              itemCount: _organizations.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.business,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      _organizations[index].name ?? 'Нет названия',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    // subtitle: Text(
                    //   'ID: ${_organizations[index].uID}', // Изменено 'id' на 'uID'
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.deepPurple.shade200,
                    //   ),
                    // ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.deepPurple.shade300,
                    ),
                    onTap: () {
                      Navigator.pop(context, _organizations[index]);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedOrganization != null) {
      setState(() {
        _selectedOrganization = selectedOrganization;
      });

      final dateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDateRange: DateTimeRange(
          start: _dateN ?? DateTime.now(),
          end: _dateK ?? DateTime.now(),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                onSurface: Colors.deepPurple,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (dateRange != null) {
        setState(() {
          _dateN = dateRange.start;
          _dateK = dateRange.end;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Касса')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _selectOrganization,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Выбрать организацию и диапазон дат',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
            if (_selectedOrganization != null &&
                _dateN != null &&
                _dateK != null)
              Container(
                height: 500,
                child: AllInfoColumn(
                  selectedOrganization: _selectedOrganization,
                  dateN: _dateN!,
                  dateK: _dateK!,
                ),
              ),
            if (_selectedOrganization != null &&
                _dateN != null &&
                _dateK != null)
              Container(
                height: 400,
                child: SaleGrafic(
                  key: ValueKey(
                      '${_selectedOrganization!.uID}-${_dateN.toString()}-${_dateK.toString()}'),
                  selectedOrganization: _selectedOrganization,
                  dateN: _dateN!,
                  dateK: _dateK!,
                ),
              ),
            if (_selectedOrganization != null &&
                _dateN != null &&
                _dateK != null)
              Container(
                height: 500,
                child: DefacturaPie(
                  dateN: _dateN!,
                  dateK: _dateK!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
