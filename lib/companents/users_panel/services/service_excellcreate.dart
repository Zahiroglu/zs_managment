import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:zs_managment/companents/users_panel/helper/save_file_mobile.dart';
import 'package:zs_managment/constands/app_constands.dart';


class ServiceExcell{

  Future<bool> exportUsersDataGridToExcel(GlobalKey<SfDataGridState> key) async {
    bool isCreated=false;
    final Workbook workbook =
    key.currentState!.exportToExcelWorkbook(startRowIndex: 6);
    Style globalStyleon = workbook.styles.add('stylea');
    globalStyleon.wrapText = true;
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName("D1").text = "${AppConstands.appName} - Hesabat";
    Style globalStylebasliq = workbook.styles.add('stylebasliq');
    globalStylebasliq.fontName = 'Times New Roman';
    globalStylebasliq.fontSize = 14;
    globalStylebasliq.fontColor = '#000102';
    globalStylebasliq.bold = true;
    globalStylebasliq.vAlign=VAlignType.center;
    globalStylebasliq.hAlign=HAlignType.center;
    sheet.getRangeByName('D1').cellStyle = globalStylebasliq;
    //////////////////////////////Parametrler///////////////////////////////////////////////////////////////////
    // sheet.getRangeByName("A2").text = ShablomSozler().tarix+firstDay.toString()+"-dən "+secondDay.toString()+"-dək";
    // sheet.getRangeByName("A3").text = isustaselected? ShablomSozler().secilenusta+selectedUsta.name.toString()+" "+selectedUsta.surname.toString():ShablomSozler().secilenusta;
    // sheet.getRangeByName("A4").text =muessiSeselected? ShablomSozler().secilenmuessise+modelSelectedOrgans.name.toString(): ShablomSozler().secilenmuessise;
    // sheet.getRangeByName("D1:E1").merge();
    sheet.getRangeByName("A2:C2").merge();
    sheet.getRangeByName("A3:C3").merge();
    sheet.getRangeByName("A4:C4").merge();
    Style globalStyle = workbook.styles.add('style');
    Style globalStyleheader = workbook.styles.add('stylehead');
    globalStyleheader.borders.all.lineStyle = LineStyle.medium;
    globalStyleheader.borders.all.color = '#000102';
    globalStyleheader.fontName = 'Times New Roman';
    globalStyleheader.fontSize = 14;
    globalStyleheader.fontColor = '#000102';
    globalStyleheader.bold = true;
    ////////////////////////////////
    globalStyle.fontName = 'Times New Roman';
    globalStyle.fontSize = 12;
    globalStyle.fontColor = '#000102';
    globalStyle.bold = false;
    //globalStyle.wrapText = true;
    //globalStyle.indent = 1;
    globalStyle.hAlign = HAlignType.left;
    globalStyle.vAlign = VAlignType.bottom;
    //globalStyle.rotation = 90;
    globalStyle.borders.all.lineStyle = LineStyle.thin;
    globalStyle.borders.all.color = '#000102';
    globalStyle.numberFormat = '_(\$* #,##0_)';
    globalStyle.wrapText=true;
    sheet.getRangeByName('A2').cellStyle = globalStyle;
    sheet.getRangeByName('A3').cellStyle = globalStyle;
    sheet.getRangeByName('A4').cellStyle = globalStyle;
    sheet.getRangeByName('A5').cellStyle = globalStyle;
    sheet.getRangeByIndex(6, 1, sheet.getLastRow(), sheet.getLastColumn()).cellStyle = globalStyle;
    sheet.getRangeByIndex(6, 1, sheet.getLastRow(), sheet.getLastColumn()).autoFitColumns();
    sheet.getRangeByIndex(6, 1, 6, sheet.getLastColumn()).cellStyle = globalStyleheader;
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await saveAndLaunchFile(bytes, 'Hesabat.xlsx').whenComplete(() =>isCreated==true).onError((error, stackTrace) =>isCreated==false);

    return isCreated;
  }


}