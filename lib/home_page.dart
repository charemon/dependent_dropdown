import 'dart:io';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> parentList = [];
  List<dynamic> child1List = [];
  List<dynamic> child2List = [];
  List<dynamic> child1 = [];
  List<dynamic> child2 = [];

  String? parentId, child1Id, child2Id;
  PDFDocument document = new PDFDocument();
  bool show_pdf = false;

  @override
  void initState() {
    super.initState();

    this.parentList.add({"value": 1, "text": "Kamen Rider"});
    this.parentList.add({"value": 2, "text": "Super Sentai"});

    this.child1List = [
      {"id": 1, "name": "Kamen Rider Showa", "ParentId": 1},
      {"id": 2, "name": "Kamen Rider Heisei", "ParentId": 1},
      {"id": 3, "name": "Kamen Rider Reiwa", "ParentId": 1},
      {"id": 4, "name": "Super Sentai Showa", "ParentId": 2},
      {"id": 5, "name": "Super Sentai Heisei", "ParentId": 2},
      {"id": 6, "name": "Super Sentai Reiwa", "ParentId": 2},
    ];

    this.child2List = [
      {"id": 1, "name": "Kamen Rider Ichigo", "ParentId": 1},
      {"id": 2, "name": "Kamen Rider Black", "ParentId": 1},
      {"id": 3, "name": "Kamen Rider Black RX", "ParentId": 1},
      {"id": 4, "name": "Kamen Rider Kuuga", "ParentId": 2},
      {"id": 5, "name": "Kamen Rider Faiz", "ParentId": 2},
      {"id": 6, "name": "Kamen Rider Gaim", "ParentId": 2},
      {"id": 7, "name": "Kamen Rider Zero-One", "ParentId": 3},
      {"id": 8, "name": "Kamen Rider Saber", "ParentId": 3},
      {"id": 9, "name": "Kamen Rider Geats", "ParentId": 3},
      {"id": 10, "name": "Dai Sentai Goggle V", "ParentId": 4},
      {"id": 11, "name": "Choushinsei Flashman", "ParentId": 4},
      {"id": 12, "name": "Choujuu Sentai Liveman ", "ParentId": 4},
      {"id": 13, "name": "Choujin Sentai Jetman", "ParentId": 5},
      {"id": 14, "name": "Kyouryuu Sentai Zyuranger", "ParentId": 5},
      {"id": 15, "name": "Kaizoku Sentai Gokaiger", "ParentId": 5},
      {"id": 16, "name": "Kikai Sentai Zenkaiger", "ParentId": 6},
      {"id": 17, "name": "Avataro Sentai Donbrothers", "ParentId": 6},
      {"id": 18, "name": "Ohsama Sentai King-Ohger", "ParentId": 6},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Dropdown"),
        backgroundColor: Colors.blue,
      ),
      body: (this.show_pdf == false)
          ? Column(
              children: [
                FormHelper.dropDownWidgetWithLabel(
                    context,
                    "Parent",
                    "Pilih Salah Satu",
                    this.parentId,
                    this.parentList, (onChangedVal) {
                  setState(() {
                    this.parentId = onChangedVal;
                    this.child1 = this
                        .child1List
                        .where((child1Item) =>
                            child1Item['ParentId'].toString() ==
                            onChangedVal.toString())
                        .toList();
                    this.child1Id = null;
                  });
                }, (onValidateVal) {
                  if (onValidateVal == []) {
                    return "Mohon Pilih Salah Satu";
                  }
                  return null;
                },
                    borderColor: Theme.of(context).primaryColor,
                    borderFocusColor: Theme.of(context).primaryColor,
                    borderRadius: 10,
                    optionLabel: "text",
                    optionValue: "value"),
                FormHelper.dropDownWidgetWithLabel(
                    context,
                    "Child 1",
                    "Pilih Salah Satu",
                    this.child1Id,
                    this.child1, (onChangedVal) {
                  setState(() {
                    this.child1Id = onChangedVal;
                    this.child2 = this
                        .child2List
                        .where((child2Item) =>
                            child2Item['ParentId'].toString() ==
                            onChangedVal.toString())
                        .toList();
                    this.child2Id = null;
                  });
                }, (onValidateVal) {
                  if (onValidateVal == []) {
                    return "Mohon Pilih Salah Satu";
                  }
                  return null;
                },
                    borderColor: Theme.of(context).primaryColor,
                    borderFocusColor: Theme.of(context).primaryColor,
                    borderRadius: 10,
                    optionLabel: "name",
                    optionValue: "id"),
                FormHelper.dropDownWidgetWithLabel(
                    context,
                    "Child 2",
                    "Pilih Salah Satu",
                    this.child2Id,
                    this.child2, (onChangedVal) async {
                  final pdf = new pw.Document();
                  //Directory extDir = null;
                  var extDir;
                  if (Platform.isAndroid) {
                    extDir = await getApplicationDocumentsDirectory();
                  } else {
                    extDir = await getApplicationDocumentsDirectory();
                  }
                  final file = File("${extDir.path}/example.pdf");
                  this.child2Id = onChangedVal;
                  List<dynamic> child2Val = this
                      .child2
                      .where((child2Item) =>
                          child2Item['id'].toString() ==
                          onChangedVal.toString())
                      .toList();
                  pdf.addPage(pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (pw.Context context) {
                        return pw.Center(
                          child: pw.Text(child2Val[0]['name']),
                        ); // Center
                      }));
                  await file.writeAsBytes(await pdf.save());
                  this.document = await PDFDocument.fromFile(File(file.path));
                  setState(() {
                    this.show_pdf = true;
                  });
                }, (onValidateVal) {
                  if (onValidateVal == []) {
                    return "Mohon Pilih Salah Satu";
                  }
                  return null;
                },
                    borderColor: Theme.of(context).primaryColor,
                    borderFocusColor: Theme.of(context).primaryColor,
                    borderRadius: 10,
                    optionLabel: "name",
                    optionValue: "id"),
              ],
            )
          : Stack(children: <Widget>[
              PDFViewer(
                document: document,
                zoomSteps: 1,
              ),
              Positioned(
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: FloatingActionButton.extended(
                              heroTag: "hero1",
                              onPressed: () async {
                                setState(() {
                                  this.show_pdf = false;
                                });
                              },
                              label: const Text(
                                'Kembali',
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                      ])))
            ]),
    ));
  }
}
