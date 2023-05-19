import 'dart:convert';

import 'package:datn/models/item_response/item.dart';
import 'package:datn/models/item_response/item_response.dart';
import 'package:datn/models/user_response/user.dart';
import 'package:datn/utils/build_context_ext.dart';
import 'package:datn/utils/http_utils.dart';
import 'package:datn/widgets/text_subtitle_widget.dart';
import 'package:datn/widgets/text_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vts_component/vts_component.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String? searchValue;
  bool isLoading = false;
  late SharedPreferences prefs;
  User? user;
  ItemResponse? itemResponse;
  List<VTSSelectItem> searchList = [];

  getItems() async {
    try {
      isLoading = true;
      if (mounted) setState(() {});

      prefs = await SharedPreferences.getInstance();
      user = User.fromJson(jsonDecode(prefs.getString('user')!));

      itemResponse = await HttpUtils.getItems(user!);
      searchList = itemResponse!.items!
          .map(
            (item) => VTSSelectObjectItem<Item>(
              object: item,
              labelMappingFn: (i) => i.name!,
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
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    var filterList = [];
    if (!isLoading) {
      if (searchValue != null) {
        for (var el in itemResponse!.items!) {
          if (el.name!.contains(searchValue!)) {
            filterList.add(el);
          }
        }
      } else {
        filterList = itemResponse!.items!;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
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
                emptyLabel: 'No items available',
                emptyLabelTextStyle: const TextStyle(color: Colors.red),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : itemResponse!.items!.isNotEmpty && filterList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: filterList.length,
                          itemBuilder: (_, i) {
                            final item = filterList[i];

                            return Card(
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                title: TextTitleWidget(
                                  text: item.name,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: TextSubtitleWidget(
                                    text: '${item.price} VND',
                                  ),
                                ),
                                onTap: () => context.pop(item),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: TextSubtitleWidget(
                            text: 'No items available',
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
