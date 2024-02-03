import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:zs_managment/companents/login/models/user_model.dart';
import 'package:zs_managment/widgets/custom_responsize_textview.dart';
class UserDataGrid extends StatefulWidget {
  GlobalKey<SfDataGridState> keyTable;
  List<UserModel> listUsers;
  Function(UserModel) callBack;
  UserDataGrid({required this.listUsers,required this.keyTable,required this.callBack,Key? key}) : super(key: key);

  @override
  State<UserDataGrid> createState() => _UserDataGridState();
}

class _UserDataGridState extends State<UserDataGrid> {
  late EmployeeDataSource _employeeDataSource;
  bool isloading = false;
  UserModel modelUser = UserModel();

  @override
  void initState() {
    _employeeDataSource = EmployeeDataSource(employeeData: widget.listUsers,callBack:widget.callBack);
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Flexible(flex: 0, child: basliqHisse()),
            const Divider(
              thickness: 0,
              color: Colors.white,
            ),
            Flexible(flex: 8, child: isloading ? progress() : dataGrid())
          ],
        ),
      ),
    );
  }

  Widget progress() {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(width: 20),
          Text(
            "Yuklenir",
            // style: AppTheme.basic.textTheme.headline5!
            //     .copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget basliqHisse() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [],
    );
  }

  Widget dataGrid() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SfDataGridTheme(
            data: SfDataGridThemeData(headerColor: Colors.blue.withOpacity(0.3)),
            child: SfDataGrid(
              onCellTap: (DataGridCellTapDetails details) {
                if(details.rowColumnIndex.columnIndex==0) {
                  String val=_employeeDataSource
                      .effectiveRows[details.rowColumnIndex.rowIndex - 1]
                      .getCells()[9]
                      .value
                      .toString();
                  int deyer=int.parse(val);
                 UserModel model=widget.listUsers.where((element) => element.id==deyer).toList().first;
                widget.callBack(model);
                }},
              selectionMode: SelectionMode.single,
              navigationMode: GridNavigationMode.row,
              allowFiltering: true,
              selectionManager: SelectionManagerBase(),
              onSelectionChanged: (newRow, oldrow) {},
              isScrollbarAlwaysShown: true,
              columnWidthMode: ColumnWidthMode.fill,
              columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
              allowSorting: true,
              key: widget.keyTable,
              source: _employeeDataSource,
              columns: <GridColumn>[
                GridColumn(
                    autoFitPadding: const EdgeInsets.only(left: 2),
                    allowFiltering: false,
                    allowSorting: false,
                    maximumWidth: 80,
                    columnName: "",
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(labeltext: '',
                          //  overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ))),
                GridColumn(
                  allowFiltering: true,
                  minimumWidth: 250,
                    autoFitPadding: const EdgeInsets.only(left: 2),
                    columnName: 'userName'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(
                          labeltext: 'userName'.tr,
                          textAlign: TextAlign.start,
                        ))),
                GridColumn(
                  allowFiltering: true,
                  minimumWidth: 100,
                    autoFitPadding: const EdgeInsets.only(left: 2),
                    columnName: 'userCode'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(
                          labeltext: 'userCode'.tr,
                          textAlign: TextAlign.start,
                        ))),
                GridColumn(
                    filterPopupMenuOptions: const FilterPopupMenuOptions(
                        filterMode: FilterMode.checkboxFilter
                    ),
                    allowSorting: false,
                    maximumWidth: 120,
                    autoFitPadding: const EdgeInsets.only(left: 5),
                    columnName: 'userGender'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(labeltext: 'userGender'.tr,
                          textAlign: TextAlign.left,
                        ))),
                GridColumn(
                    allowFiltering: true,
                    allowSorting: true,
                  minimumWidth: 150,
                    autoFitPadding: const EdgeInsets.only(left: 2),
                    columnName: 'userRegion'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(labeltext: 'userRegion'.tr,
                          textAlign: TextAlign.left,
                        ))),
                GridColumn(
                  minimumWidth: 100,
                    autoFitPadding: const EdgeInsets.only(left: 2),
                    columnName: 'usersDepartment'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(labeltext:'usersDepartment'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ))),
                GridColumn(

                  minimumWidth: 150,
                    autoFitPadding: const EdgeInsets.only(left: 2),
                    columnName: 'usersPosition'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(labeltext: 'usersPosition'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ))),
                GridColumn(
                    filterPopupMenuOptions: const FilterPopupMenuOptions(
                        filterMode: FilterMode.checkboxFilter
                    ),
                  minimumWidth: 200,
                    autoFitPadding: EdgeInsets.only(left: 2),
                    columnName: 'usersStatus'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(labeltext:'usersStatus'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ))),
                GridColumn(
                    minimumWidth: 200,
                    autoFitPadding: const EdgeInsets.only(left: 2),
                    columnName: 'lastAktivdate'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(labeltext: 'lastAktivdate'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ))),
                GridColumn(
                  visible: false,
                    maximumWidth: 50,
                    autoFitPadding: const EdgeInsets.only(left: 2),
                    columnName: 'Id'.tr,
                    label: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: CustomText(labeltext:'Id'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<UserModel> employeeData, required Function(UserModel p1) callBack}) {
    _employeeData = employeeData
        .map<DataGridRow>((UserModel e) => DataGridRow(
        cells: <DataGridCell>[
              const DataGridCell<String>(columnName: "", value: ""),
              DataGridCell<String>(
                  columnName: 'userName'.tr, value: "${e.name} ${e.surname}"),
              DataGridCell<String>(
                  columnName: 'userCode'.tr, value: e.code),
              DataGridCell<String>(
                columnName: 'userGender'.tr,
                value: e.gender.toString(),
              ),
              DataGridCell<String>(columnName: 'userRegion'.tr, value: e.regionName),
              DataGridCell<String>(
                  columnName: 'usersDepartment'.tr, value: e.moduleName),
              DataGridCell<String>(
                  columnName: 'usersPosition'.tr, value: e.roleName),
              DataGridCell<String>(
                  columnName: 'usersStatus'.tr,
                  value: controlPermision(e.deviceLogin!,e.usernameLogin!)),
              DataGridCell<String>(
                  columnName: 'lastAktivdate'.tr,
                  value: e.lastOnlineDate.toString()),
              DataGridCell<String>(
                  columnName: 'Id'.tr,
                  value: e.id.toString()),
            ]))
        .toList();
  }

  String getLastOnlineDay(String date) {
    String day = "0";
    final date2 = DateTime.now();

    final gun = date2.difference(DateTime.parse(date)).inDays;
    if (gun < 1) {
      day = 'bugun'.tr;
    } else if (gun >= 7 && gun < 31) {
      double hefte = (gun / 7);
      day = hefte.round().toString() + " hefte".tr;
    } else if (gun >= 30) {
      double hefte = (gun / 30);
      day = hefte.round().toString() + " ay".tr;
    } else {
      day = gun.toString() + " gun".tr;
    }
    return day;
  }

  List<DataGridRow> _employeeData = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: [
      Container(
        alignment: Alignment.center,
            child: const Icon(Icons.info_outline,color: Colors.blue,),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: CustomText(labeltext: row.getCells()[1].value,textAlign:TextAlign.start,overflow: TextOverflow.ellipsis),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: CustomText(labeltext: row.getCells()[2].value,textAlign:TextAlign.center,overflow: TextOverflow.ellipsis),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Image.asset(
          row.getCells()[3].value == "0"
              ? "images/imageman.png"
              : "images/imagewoman.png",
          width: 40,
          height: 40,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomText(labeltext:row.getCells()[4].value.toString()),
        //child: Text(row.getCells()[4].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomText(labeltext:row.getCells()[5].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomText(labeltext:row.getCells()[6].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Row(
              children: [
                CustomText(labeltext: "Windows"),
                Icon(
                  row.getCells()[7].value.toString().contains("Windows") ? Icons.verified_user : Icons.block,
                  color:  row.getCells()[7].value.toString().contains("Windows") ? Colors.green : Colors.red,
                )
              ],
            ),
            const SizedBox(
              width: 2,
            ),
            Row(
              children: [
                 CustomText(
                 labeltext: "Mobile",
                ),
                Icon(
                  row.getCells()[7].value.toString().contains("Mobile") ? Icons.verified_user : Icons.block,
                  color:  row.getCells()[7].value.toString().contains("Mobile")  ? Colors.green : Colors.red,
                )
              ],
            ),
          ],
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             // Text(row.getCells()[8].value.toString().isNotEmpty||row.getCells()[8].value!=null?row.getCells()[8].value.toString().substring(11,19):''),
              SizedBox(
                width: 5,
              ),
              // ConstrainedBox(
              //   constraints: const BoxConstraints(minWidth: 50),
              //   child: Container(
              //     padding: const EdgeInsets.all(2),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(5)),
              //       color: getLastOnlineDay(row.getCells()[8].value.toString())
              //           .contains("bugun")
              //           ? Colors.green.withOpacity(0.5)
              //           : Colors.red.withOpacity(0.5),
              //     ),
              //     child: Text(
              //       textAlign: TextAlign.center,
              //       getLastOnlineDay(row.getCells()[8].value.toString()),
              //       style: TextStyle(color: Colors.white, fontSize: 12),
              //     ),
              //   ),
              // ),
            ],
          )),
      Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomText(labeltext:row.getCells()[9].value.toString()),
          ),

        ]);
  }

 String controlPermision(bool deviceLogin, bool usernameLogin) {
    String value='';
    if(deviceLogin && usernameLogin){
      value="Mobile|Windows";
    }else{
      if(deviceLogin){
        value= "Mobile";
      }else if(usernameLogin){
        value= 'Windows';
      }else{
       value= "Yetki Yoxdur";
      }
    }
    return value;

 }
}

class ColumnSizeController extends ColumnSizer {
  @override
  double computeCellWidth(
      GridColumn column,
      DataGridRow row,
      Object? cellValue,
      TextStyle textStyle,
      ) {
    // I set the property to maximumWidth but you can play more.
    return column.maximumWidth;
  }
}