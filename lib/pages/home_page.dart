// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/item_data.dart';
import '../models/order_data.dart';
import '../models/table_data.dart';
import '../utils/build_context_ext.dart';
import '../utils/constants.dart';
import 'category_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ItemData? moreResult;

  buildHeader(String title, String subTitle) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title\n',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: subTitle,
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildAlertHeader(TableData tableData, Function(void Function()) setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          tableData.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () async {
            moreResult = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MyCategoryPage()),
            );

            if (moreResult != null) {
              if (tableData.orderData == null) {
                tableData.orderData = OrderData(
                  id: 1,
                  name: 'Order of Table ${tableData.name}',
                  itemDatas: [],
                );
                moreResult!.qty++;
                tableData.orderData!.itemDatas.add(moreResult!);
              } else {
                final i = tableData.orderData!.itemDatas
                    .indexWhere((el) => el == moreResult);
                if (i >= 0) {
                  tableData.orderData!.itemDatas[i].qty++;
                } else {
                  moreResult!.qty++;
                  tableData.orderData!.itemDatas.add(moreResult!);
                }
              }
            }

            setState(() {});
          },
          child: Row(
            children: [
              Icon(Icons.add, color: Colors.green),
              Text(
                'More',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  buildAlertBody(TableData tableData, Function(void Function()) setState) {
    return tableData.orderData != null &&
            tableData.orderData!.itemDatas.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height / 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tableData.orderData!.itemDatas.length,
                    itemBuilder: (_, i) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 1,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tableData.orderData!.itemDatas[i].name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${tableData.orderData!.itemDatas[i].price * tableData.orderData!.itemDatas[i].qty} VND',
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (tableData
                                                  .orderData!.itemDatas[i].qty >
                                              0) {
                                            tableData.orderData!.itemDatas[i]
                                                .qty -= 1;
                                            setState(() {});
                                          }
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        child: Text(
                                          tableData.orderData!.itemDatas[i].qty
                                              .toString(),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          tableData
                                              .orderData!.itemDatas[i].qty += 1;
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : Container(child: Text('No orders available'));
  }

  buildAlertFooter(TableData tableData, Function(void Function()) setState) {
    var summary = .0;
    if (tableData.orderData != null) {
      for (var el in tableData.orderData!.itemDatas) {
        summary += el.price * el.qty;
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$summary VND'),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('VAT', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('5%'),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${summary * 1.05} VND'),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(
                    tableData.orderData?.itemDatas.isEmpty,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    tableData.orderData = null;
                  },
                  child: const Text(
                    'Pay',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildDivider() {
    return Divider(
      height: 30,
      thickness: 1,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  buildHeader('Co so Cau Giay', 'Nhan vien A'),
                  buildHeader(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    DateFormat('hh:mm a').format(DateTime.now()),
                  ),
                ],
              ),
              buildDivider(),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: fakeTableData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (_, i) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fakeTableData[i].status
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: () async {
                        fakeTableData[i].status = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              builder: (_) {
                                return StatefulBuilder(
                                  builder: (context, setState) => Container(
                                    height: context.height * 2 / 3,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 32,
                                    ),
                                    child: Column(
                                      children: [
                                        buildAlertHeader(
                                          fakeTableData[i],
                                          setState,
                                        ),
                                        buildDivider(),
                                        buildAlertBody(
                                          fakeTableData[i],
                                          setState,
                                        ),
                                        buildDivider(),
                                        buildAlertFooter(
                                          fakeTableData[i],
                                          setState,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ) ??
                            fakeTableData[i].status;
                        setState(() {});
                      },
                      child: Text(fakeTableData[i].name),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
