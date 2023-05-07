// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vts_component/vts_component.dart';

import '../models/customer_data.dart';
import '../models/user_data.dart';
import '../utils/build_context_ext.dart';
import '../utils/http_utils.dart';

class PayingPage extends StatefulWidget {
  const PayingPage({super.key});

  @override
  State<PayingPage> createState() => _PayingPageState();
}

class _PayingPageState extends State<PayingPage> {
  String? searchValue;
  bool isLoading = false;
  bool isAlertLoading = false;
  bool showReInitDatas = false;
  late SharedPreferences prefs;
  UserData? userData;
  List<CustomerData> itemDatas = [];
  List<VTSSelectItem> searchList = [];

  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initCustomerDatas();
  }

  @override
  void dispose() {
    super.dispose();
    customerNameController.dispose();
    customerPhoneController.dispose();
  }

  void initCustomerDatas() async {
    try {
      isLoading = true;
      if (mounted) setState(() {});

      prefs = await SharedPreferences.getInstance();
      userData = UserData.fromJson(jsonDecode(prefs.getString('user')!));

      final itemStr = await HttpUtils.getCustomerDatas(userData!.accessToken);
      final itemJson = json.decode(itemStr);
      itemDatas.clear();
      List<CustomerData>.from(
        itemJson.map((el) => itemDatas.add(CustomerData.fromJson(el))),
      );
      searchList = itemDatas
          .map(
            (item) => VTSSelectObjectItem<CustomerData>(
              object: item,
              labelMappingFn: (i) => i.phone,
              valueMappingFn: (i) => i.name,
            ),
          )
          .toList();

      isLoading = false;
      if (mounted) setState(() {});
    } catch (e) {
      context.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showReInitDatas) {
      initCustomerDatas();
      showReInitDatas = false;
    }

    var filterList = [];
    if (searchValue != null) {
      for (var el in itemDatas) {
        if (el.name.contains(searchValue!)) {
          filterList.add(el);
        }
      }
    } else {
      filterList = itemDatas;
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
                      prefixIcon:
                          const Icon(Icons.search, color: VTSColors.PRIMARY_1),
                      emptyLabel: 'Nothing available',
                      emptyLabelTextStyle:
                          const TextStyle(color: VTSColors.FUNC_RED_1),
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: filterList.length,
                            itemBuilder: (_, i) {
                              return Card(
                                margin: const EdgeInsets.all(8),
                                child: ListTile(
                                  title: Text(
                                    filterList[i].name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(filterList[i].phone),
                                  onTap: () =>
                                      Navigator.pop(context, filterList[i]),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
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
                            ? const Center(child: CircularProgressIndicator())
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
                                      controller: customerNameController,
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
                                      controller: customerPhoneController,
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
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () {
                                              customerNameController.clear();
                                              customerPhoneController.clear();
                                              context.pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            onPressed: () async {
                                              try {
                                                isAlertLoading = true;
                                                setState(() {});

                                                final result = await HttpUtils
                                                    .saveCustomer(
                                                  userData!,
                                                  CustomerData(
                                                    name: customerNameController
                                                        .text,
                                                    phone:
                                                        customerPhoneController
                                                            .text,
                                                  ),
                                                );

                                                isAlertLoading = false;
                                                setState(() {});

                                                showReInitDatas = true;
                                                customerNameController.clear();
                                                customerPhoneController.clear();
                                                context.pop(result);
                                              } catch (e) {
                                                context.pop();
                                                context
                                                    .showSnackBar(e.toString());
                                              }
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ),
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
              child: const Text('New customer'),
            ),
          ],
        ),
      ),
    );
  }
}
