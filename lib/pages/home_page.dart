// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer_data.dart';
import '../models/item_data.dart';
import '../models/order_data.dart';
import '../models/user_data.dart';
import '../models/table_data.dart';
import '../utils/http_utils.dart';
import '../utils/build_context_ext.dart';
import 'category_page.dart';
import 'paying_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  bool isAlertLoading = false;
  bool showReInitDatas = false;
  ItemData? moreResult;
  late SharedPreferences prefs;
  UserData? userData;
  CustomerData? customerData;
  List<TableData> tableDatas = [];

  buildHeader(String title, String subTitle) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title\n',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: subTitle,
              style: const TextStyle(
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

  buildFooter() {
    return ElevatedButton(
      onPressed: () async {
        final result = await HttpUtils.logout(userData!);
        if (result) {
          prefs = await SharedPreferences.getInstance();
          prefs.remove('user');
          print(prefs.getString('user'));
          context.pop();
        }
      },
      child: const Text('Logout'),
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () async {
            moreResult = await context.push(const MyCategoryPage());

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
            children: const [
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
        ? isAlertLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: context.height / 4,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tableData.orderData!.itemDatas.length,
                        itemBuilder: (_, i) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 1,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        tableData.orderData!.itemDatas[i].name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${tableData.orderData!.itemDatas[i].price} VND',
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (tableData.orderData!
                                                      .itemDatas[i].qty >
                                                  0) {
                                                tableData.orderData!
                                                    .itemDatas[i].qty -= 1;

                                                if (tableData.orderData!
                                                        .itemDatas[i].qty ==
                                                    0) {
                                                  tableData.orderData!.itemDatas
                                                      .remove(tableData
                                                          .orderData!
                                                          .itemDatas[i]);
                                                }

                                                setState(() {});
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                              border: Border.all(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            child: Text(
                                              tableData
                                                  .orderData!.itemDatas[i].qty
                                                  .toString(),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              tableData.orderData!.itemDatas[i]
                                                  .qty += 1;
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${tableData.orderData!.itemDatas[i].price * tableData.orderData!.itemDatas[i].qty} VND',
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
        : const Text('No orders available');
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
            const Text('Summary',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('$summary VND'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('VAT', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('5%'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Payment',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${summary * 1.05} VND'),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      isAlertLoading = true;
                      setState(() {});

                      final result = await HttpUtils.saveOrder(
                        userData!,
                        tableData,
                      );

                      // tableData.orderData!.itemDatas.clear();

                      isAlertLoading = false;
                      setState(() {});
                      context.pop(result);
                      // tableData.orderData?.itemDatas.isEmpty,
                    } catch (e) {
                      context.showSnackBar(e.toString());
                    }
                  },
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
                margin: const EdgeInsets.only(left: 5),
                child: ElevatedButton(
                  onPressed: () async {
                    final data = await context.push(const PayingPage());
                    customerData = data['customerData'];

                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text(
                              'Do you want to pay orders for this table?',
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () async {
                                  final result = await HttpUtils.payOrders(
                                    userData!,
                                    tableData,
                                    customerData,
                                    data['paymentMethod'],
                                  );
                                  if (result) {
                                    tableData.orderData = null;
                                    context.pop(); // Exit alert dialog
                                    showReInitDatas = true;
                                  }
                                  context.pop(); // Exit bottom dialog
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
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
    return const Divider(
      height: 30,
      thickness: 1,
      color: Colors.grey,
    );
  }

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  initUserData() async {
    isLoading = true;
    prefs = await SharedPreferences.getInstance();
    userData = UserData.fromJson(jsonDecode(prefs.getString('user')!));
    if (mounted) setState(() {});

    initTableDatas(userData!.accessToken, userData!.storeId);
  }

  initTableDatas(String token, int storeId) async {
    try {
      final tableStr = await HttpUtils.getTableDatas(token, storeId);
      final tableJson = json.decode(tableStr);
      tableDatas.clear();
      List<TableData>.from(
        tableJson['data'].map((el) => tableDatas.add(TableData.fromJson(el))),
      );
      isLoading = false;
      if (mounted) setState(() {});
    } catch (e) {
      context.showSnackBar(e.toString());
    }

    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    if (showReInitDatas) {
      initTableDatas(userData!.accessToken, userData!.storeId);
      showReInitDatas = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  buildHeader('Co so Cau Giay', userData?.name ?? ''),
                  buildHeader(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    DateFormat('hh:mm a').format(DateTime.now()),
                  ),
                ],
              ),
              buildDivider(),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: tableDatas.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (_, i) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tableDatas[i].status
                                  ? Colors.grey
                                  : Colors.green,
                            ),
                            onPressed: () async {
                              tableDatas[i].status = await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                    builder: (_) {
                                      return StatefulBuilder(
                                        builder: (context, setState) =>
                                            Container(
                                          height: context.height * 2 / 3,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 32,
                                          ),
                                          child: Column(
                                            children: [
                                              buildAlertHeader(
                                                tableDatas[i],
                                                setState,
                                              ),
                                              buildDivider(),
                                              buildAlertBody(
                                                tableDatas[i],
                                                setState,
                                              ),
                                              buildDivider(),
                                              buildAlertFooter(
                                                tableDatas[i],
                                                setState,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ) ??
                                  tableDatas[i].status;
                              setState(() {});
                            },
                            child: Text(tableDatas[i].name),
                          );
                        },
                      ),
              ),
              buildFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
