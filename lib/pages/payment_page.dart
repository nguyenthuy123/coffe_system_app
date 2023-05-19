// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:datn/models/customer_response/customer.dart';
import 'package:datn/models/user_response/user.dart';
import 'package:datn/utils/build_context_ext.dart';
import 'package:datn/utils/http_utils.dart';
import 'package:datn/widgets/button_widget.dart';
import 'package:datn/widgets/text_subtitle_widget.dart';
import 'package:datn/widgets/text_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vts_component/vts_component.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? searchValue;
  bool isLoading = false;
  bool isAlertLoading = false;
  bool showReInitDatas = false;
  late SharedPreferences prefs;
  User? user;
  List<Customer> customers = [];
  List<VTSSelectItem> searchList = [];
  String? paymentMethod = 'CASH';

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void getCustomers() async {
    // try {
    isLoading = true;
    if (mounted) setState(() {});

    prefs = await SharedPreferences.getInstance();
    user = User.fromJson(jsonDecode(prefs.getString('user')!));

    customers = await HttpUtils.getCustomers(user!);
    searchList = customers
        .map(
          (item) => VTSSelectObjectItem<Customer>(
            object: item,
            labelMappingFn: (i) => i.phone!,
            valueMappingFn: (i) => i.name,
          ),
        )
        .toList();

    isLoading = false;
    if (mounted) setState(() {});
    // } catch (e) {
    //   context.showSnackBar(e.toString());
    // }
  }

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showReInitDatas) {
      getCustomers();
      showReInitDatas = false;
    }

    var filterList = [];
    if (!isLoading) {
      if (searchValue != null) {
        for (var el in customers) {
          if (el.name!.contains(searchValue!)) {
            filterList.add(el);
          }
        }
      } else {
        filterList = customers;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                    child: VTSSearchBar(
                      maxItemDropdown: 10,
                      items: searchList,
                      showAlways: true,
                      onSelectChange: (value) {
                        searchValue = value;
                        setState(() {});
                      },
                      placeholder: 'Search',
                      borderRadius: BorderRadius.circular(50.0),
                      prefixIcon: const Icon(Icons.search),
                      emptyLabel: 'No customers available',
                      emptyLabelTextStyle: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextTitleWidget(text: 'Payment method'),
                        DropdownButton(
                          value: paymentMethod,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: [
                            'CASH',
                            'BANK_TRANSFER',
                            'CARD',
                          ].map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            paymentMethod = newValue!;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : customers.isNotEmpty && filterList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: filterList.length,
                                itemBuilder: (_, i) {
                                  final customer = filterList[i];

                                  return Card(
                                    margin: const EdgeInsets.all(8),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(8),
                                      title: TextTitleWidget(
                                        text: customer.name,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: TextSubtitleWidget(
                                          text: customer.phone,
                                        ),
                                      ),
                                      onTap: () => context.pop({
                                        'customer': customer,
                                        'paymentMethod': paymentMethod,
                                      }),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: TextSubtitleWidget(
                                  text: 'No customers available',
                                ),
                              ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonWidget(
                    onPressed: () {
                      context.pop({
                        'customer': null,
                        'paymentMethod': paymentMethod,
                      });
                    },
                    text: 'Pay',
                  ),
                  const SizedBox(width: 10),
                  ButtonWidget(
                    onPressed: () async {
                      await showModalBottomSheet(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 32,
                              ),
                              child: isAlertLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Column(
                                      children: [
                                        const Text(
                                          'Add new customer',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: nameController,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              labelText: 'Customer Name',
                                              border: OutlineInputBorder(),
                                              suffixIcon: Icon(Icons.person),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: phoneController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Customer Phone',
                                              border: OutlineInputBorder(),
                                              suffixIcon: Icon(Icons.phone),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            ButtonWidget(
                                              color: Colors.red,
                                              onPressed: () {
                                                nameController.clear();
                                                phoneController.clear();
                                                context.pop();
                                              },
                                              text: 'Cancel',
                                            ),
                                            const SizedBox(width: 10),
                                            ButtonWidget(
                                              onPressed: () async {
                                                try {
                                                  isAlertLoading = true;
                                                  setState(() {});

                                                  final result = await HttpUtils
                                                      .saveCustomer(
                                                    user!,
                                                    Customer(
                                                      name: nameController.text,
                                                      phone:
                                                          phoneController.text,
                                                    ),
                                                  );

                                                  isAlertLoading = false;
                                                  setState(() {});

                                                  showReInitDatas = true;
                                                  nameController.clear();
                                                  phoneController.clear();
                                                  context.pop(result);
                                                } catch (e) {
                                                  context.pop();
                                                  context.showSnackBar(
                                                    e.toString(),
                                                  );
                                                }
                                              },
                                              text: 'OK',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                            ),
                          );
                        },
                      );
                      setState(() {});
                    },
                    text: 'New customer',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
