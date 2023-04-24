// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_data.dart';
import '../models/table_data.dart';
import 'category_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final today = DateTime.now();
  OrderData? moreResult;
  final dataset = [
    TableData(
      name: 'Table 1',
      status: false,
      orders: [
        OrderData(name: 'Tra xanh Matcha', cost: 40000, count: 1),
        OrderData(name: 'Tra dao', cost: 55000, count: 1),
        OrderData(name: 'Hong tra xanh', cost: 35000, count: 1),
        OrderData(name: 'Tra sua panda', cost: 35000, count: 1),
      ],
    ),
    TableData(name: 'Table 2', orders: [], status: false),
    TableData(name: 'Table 3', orders: [], status: false),
    TableData(name: 'Table 4', orders: []),
    TableData(name: 'Table 5', orders: []),
    TableData(name: 'Table 11', orders: []),
    TableData(name: 'Table 12', orders: []),
    TableData(name: 'Table 13', orders: []),
    TableData(name: 'Table 14', orders: []),
    TableData(name: 'Table 15', orders: []),
    TableData(name: 'Table 21', orders: []),
    TableData(name: 'Table 22', orders: []),
    TableData(name: 'Table 23', orders: [], status: false),
    TableData(name: 'Table 24', orders: [], status: false),
    TableData(name: 'Table 25', orders: [], status: false),
    TableData(name: 'Table 1', orders: []),
    TableData(name: 'Table 2', orders: []),
    TableData(name: 'Table 3', orders: []),
    TableData(name: 'Table 4', orders: []),
    TableData(name: 'Table 5', orders: []),
    TableData(name: 'Table 11', orders: []),
    TableData(name: 'Table 12', orders: []),
    TableData(name: 'Table 13', orders: [], status: false),
    TableData(name: 'Table 14', orders: [], status: false),
    TableData(name: 'Table 15', orders: [], status: false),
    TableData(name: 'Table 21', orders: [], status: false),
    TableData(name: 'Table 22', orders: []),
    TableData(name: 'Table 23', orders: []),
    TableData(name: 'Table 24', orders: []),
    TableData(name: 'Table 25', orders: []),
  ];

  buildHeader(String title, String subTitle) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
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
              final i = tableData.orders.indexWhere((el) => el == moreResult);
              if (i >= 0) {
                tableData.orders[i].count++;
              } else {
                tableData.orders.add(moreResult!);
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
    return tableData.orders.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tableData.orders.length,
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
                                tableData.orders[i].name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${tableData.orders[i].cost * tableData.orders[i].count} VND',
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (tableData.orders[i].count > 0) {
                                            tableData.orders[i].count -= 1;
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
                                          tableData.orders[i].count.toString(),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          tableData.orders[i].count += 1;
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
    for (var el in tableData.orders) {
      summary += el.cost * el.count;
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
        SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'Pay',
              style: TextStyle(color: Colors.white),
            ),
          ),
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
                  buildHeader('Co so Cau Giay\n', 'Nhan vien A'),
                  SizedBox(width: 30),
                  buildHeader(
                    '${DateFormat('dd/MM/yyyy').format(today)}\n',
                    DateFormat('hh:mm a').format(today),
                  ),
                ],
              ),
              buildDivider(),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: dataset.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (_, i) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            dataset[i].status ? Colors.green : Colors.red,
                      ),
                      onPressed: () async {
                        dataset[i].status = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              builder: (_) {
                                return StatefulBuilder(
                                  builder: (context, setState) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        2 /
                                        3,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 32,
                                    ),
                                    child: Column(
                                      children: [
                                        buildAlertHeader(
                                          dataset[i],
                                          setState,
                                        ),
                                        buildDivider(),
                                        buildAlertBody(
                                          dataset[i],
                                          setState,
                                        ),
                                        buildDivider(),
                                        buildAlertFooter(
                                          dataset[i],
                                          setState,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ) ??
                            dataset[i].status;
                        setState(() {});
                      },
                      child: Text(dataset[i].name),
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
