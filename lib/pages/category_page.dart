import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vts_component/vts_component.dart';

import '../models/item_data.dart';
import '../models/user_data.dart';
import '../utils/build_context_ext.dart';
import '../utils/http_utils.dart';

class MyCategoryPage extends StatefulWidget {
  const MyCategoryPage({super.key});

  @override
  State<MyCategoryPage> createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  String? searchValue;
  bool isLoading = false;
  late SharedPreferences prefs;
  UserData? userData;
  List<ItemData> itemDatas = [];
  List<VTSSelectItem> searchList = [];

  @override
  void initState() {
    super.initState();
    initItemDatas();
  }

  initItemDatas() async {
    try {
      isLoading = true;
      if (mounted) setState(() {});

      prefs = await SharedPreferences.getInstance();
      userData = UserData.fromJson(jsonDecode(prefs.getString('user')!));

      final itemStr = await HttpUtils.getItemDatas(userData!.accessToken);
      final itemJson = json.decode(itemStr);
      List<ItemData>.from(
        itemJson['content'].map((el) => itemDatas.add(ItemData.fromJson(el))),
      );
      searchList = itemDatas
          .map(
            (item) => VTSSelectObjectItem<ItemData>(
              object: item,
              labelMappingFn: (i) => i.name,
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('${filterList[i].price} VND'),
                            onTap: () => Navigator.pop(context, filterList[i]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
