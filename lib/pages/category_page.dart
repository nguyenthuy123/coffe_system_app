// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:vts_component/vts_component.dart';

import '../models/item_data.dart';
import '../utils/build_context_ext.dart';
import '../utils/constants.dart';

class MyCategoryPage extends StatefulWidget {
  const MyCategoryPage({super.key});

  @override
  State<MyCategoryPage> createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  String? searchValue;
  final searchList = fakeItemData
      .map(
        (item) => VTSSelectObjectItem<ItemData>(
          object: item,
          labelMappingFn: (i) => i.name,
          valueMappingFn: (i) => i.name,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    var filterList = [];
    if (searchValue != null) {
      for (var el in fakeItemData) {
        if (el.name.contains(searchValue!)) {
          filterList.add(el);
        }
      }
    } else {
      filterList = fakeItemData;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 8),
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
                prefixIcon: Icon(Icons.search, color: VTSColors.PRIMARY_1),
                emptyLabel: 'Nothing available',
                emptyLabelTextStyle: TextStyle(color: VTSColors.FUNC_RED_1),
              ),
            ),
            SizedBox(
              height: context.height / 2,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filterList.length,
                itemBuilder: (_, i) {
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        filterList[i].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
