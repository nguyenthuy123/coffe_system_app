// ignore_for_file: use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:datn/models/customer_response/customer.dart';
import 'package:datn/models/item_response/item.dart';
import 'package:datn/models/table_response/order.dart';
import 'package:datn/models/table_response/table_response.dart';
import 'package:datn/models/table_response/table.dart' as m;
import 'package:datn/models/user_response/user.dart';
import 'package:datn/pages/item_page.dart';
import 'package:datn/pages/payment_page.dart';
import 'package:datn/utils/build_context_ext.dart';
import 'package:datn/utils/http_utils.dart';
import 'package:datn/widgets/button_widget.dart';
import 'package:datn/widgets/text_content_widget.dart';
import 'package:datn/widgets/text_link_widget.dart';
import 'package:datn/widgets/text_subtitle_widget.dart';
import 'package:datn/widgets/text_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool isAlertLoading = false;
  bool isLoadingPayment = false;
  bool showReInitDatas = false;
  Item? moreItem;
  late SharedPreferences prefs;
  User? user;
  Customer? customer;
  TableResponse? tableResponse;

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
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 32),
      child: Row(
        children: [
          ButtonWidget(
            onPressed: () async {
              if (await HttpUtils.logout(user!)) {
                prefs.remove('user');
                context.pop();
              }
            },
            text: 'Logout',
          ),
        ],
      ),
    );
  }

  buildAlertHeader(m.Table table, Function(void Function()) setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        TextTitleWidget(text: table.name, type: TextTitleType.big),
        GestureDetector(
          onTap: () async {
            moreItem = await context.push(const ItemPage());

            if (moreItem != null) {
              if (table.order == null) {
                table.order = Order(
                  id: 1,
                  name: 'More for ${table.name}',
                  items: [],
                );
                moreItem!.qty++;
                table.order!.items.add(moreItem!);
              } else {
                final i = table.order!.items.indexWhere((el) => el == moreItem);
                if (i >= 0) {
                  table.order!.items[i].qty++;
                } else {
                  moreItem!.qty++;
                  table.order!.items.add(moreItem!);
                }
              }
            }

            setState(() {});
          },
          child: Row(
            children: const [
              Icon(Icons.add, color: Colors.blue),
              TextLinkWidget(link: 'More items'),
            ],
          ),
        )
      ],
    );
  }

  buildAlertBody(m.Table table, Function(void Function()) setState) {
    return table.order != null && table.order!.items.isNotEmpty
        ? isAlertLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: context.height / 4,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: table.order!.items.length,
                        itemBuilder: (_, i) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextTitleWidget(
                                          text: table.order!.items[i].name!,
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (table.order!.items[i].qty >
                                                    0) {
                                                  table.order!.items[i].qty -=
                                                      1;

                                                  if (table.order!.items[i]
                                                          .qty ==
                                                      0) {
                                                    table.order!.items.remove(
                                                      table.order!.items[i],
                                                    );
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
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Text(
                                                '${table.order!.items[i].qty}',
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                table.order!.items[i].qty += 1;
                                                setState(() {});
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextTitleWidget(
                                          text:
                                              '${table.order!.items[i].price} VND',
                                          type: TextTitleType.small,
                                        ),
                                        TextTitleWidget(
                                          text:
                                              '${table.order!.items[i].price! * table.order!.items[i].qty} VND',
                                          type: TextTitleType.small,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
        : const TextSubtitleWidget(text: 'No orders available');
  }

  buildAlertFooter(m.Table table, Function(void Function()) setState) {
    var summary = .0;
    if (table.order != null) {
      for (var el in table.order!.items) {
        summary += el.price! * el.qty;
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextTitleWidget(text: 'Summary'),
            TextContentWidget(text: '$summary VND'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            TextTitleWidget(text: 'VAT'),
            TextContentWidget(text: '5%'),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextTitleWidget(text: 'Payment'),
            TextContentWidget(text: '${summary * 1.05} VND'),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            ButtonWidget(
              onPressed: () async {
                try {
                  isAlertLoading = true;
                  setState(() {});

                  final result = await HttpUtils.saveOrder(user!, table);
                  // tableData.orderData!.itemDatas.clear();

                  isAlertLoading = false;
                  setState(() {});

                  context.pop(result);
                } catch (e) {
                  context.showSnackBar(e.toString());
                }
              },
              color: Colors.green,
              text: 'Ok',
            ),
            if (table.status!) const SizedBox(width: 10),
            if (table.status!)
              ButtonWidget(
                onPressed: () async {
                  final data = await context.push(const PaymentPage());
                  customer = data?['customer'];

                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextTitleWidget(text: 'Pay order'),
                              if (isLoadingPayment)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          ),
                          content: const TextSubtitleWidget(
                            text: 'Do you want to pay orders for this table?',
                          ),
                          actions: [
                            ButtonWidget(
                              color: Colors.red,
                              onPressed: () => context.pop(),
                              text: 'Cancel',
                              isExpanded: false,
                            ),
                            ButtonWidget(
                              onPressed: () async {
                                isLoadingPayment = true;
                                setState(() {});

                                if (await HttpUtils.payOrders(
                                  user!,
                                  table,
                                  customer,
                                  data['paymentMethod'],
                                )) {
                                  table.order = null;
                                  context.pop(); // Exit alert dialog
                                  showReInitDatas = true;
                                }

                                isLoadingPayment = false;
                                setState(() {});

                                context.pop(); // Exit bottom dialog
                              },
                              text: 'OK',
                              isExpanded: false,
                            ),
                          ],
                        );
                      });
                },
                text: 'Pay',
              ),
          ],
        ),
      ],
    );
  }

  buildDivider() {
    return const Divider(height: 30, thickness: 1, color: Colors.grey);
  }

  getTables() async {
    try {
      tableResponse = await HttpUtils.getTables(user!);
    } catch (e) {
      context.showSnackBar(e.toString());
    }

    isLoading = false;
    if (mounted) setState(() {});
  }

  getUser() async {
    isLoading = true;
    if (mounted) setState(() {});

    await initSharedPreferences();

    user = User.fromJson(jsonDecode(prefs.getString('user')!));
    print(user);

    await getTables();
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (showReInitDatas) {
      getTables();
      showReInitDatas = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Row(
                children: [
                  buildHeader('Co so Cau Giay', user?.name ?? ''),
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
                        itemCount: tableResponse!.tables!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemBuilder: (_, i) {
                          final table = tableResponse!.tables![i];

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  table.status! ? Colors.grey : Colors.green,
                            ),
                            onPressed: () async {
                              table.status = await showModalBottomSheet(
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
                                              buildAlertHeader(table, setState),
                                              buildDivider(),
                                              buildAlertBody(table, setState),
                                              buildDivider(),
                                              buildAlertFooter(table, setState),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ) ??
                                  table.status;
                              setState(() {});
                            },
                            child: Text(table.name!),
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
