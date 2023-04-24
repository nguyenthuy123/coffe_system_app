// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:vts_component/vts_component.dart';

import '../models/order_data.dart';

class MyCategoryPage extends StatefulWidget {
  const MyCategoryPage({super.key});

  @override
  State<MyCategoryPage> createState() => _MyCategoryPageState();
}

class _MyCategoryPageState extends State<MyCategoryPage> {
  final dataset = [
    OrderData(name: 'Tra xanh Matcha', cost: 40000, count: 1),
    OrderData(name: 'Tra dao', cost: 55000, count: 1),
    OrderData(name: 'Hong tra xanh', cost: 35000, count: 1),
    OrderData(name: 'Tra sua panda', cost: 35000, count: 1),
  ];

  late final listObjectItem = dataset
      .map(
        (item) => VTSSelectObjectItem<OrderData>(
          object: item,
          labelMappingFn: (i) => i.name,
          valueMappingFn: (i) => i.name,
        ),
      )
      .toList();

  String? searchValue;

  @override
  Widget build(BuildContext context) {
    var filter = [];
    if (searchValue != null) {
      for (var el in dataset) {
        if (el.name.contains(searchValue!)) {
          filter.add(el);
        }
      }
    } else {
      filter = dataset;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 8),
              child: VTSSearchBar(
                maxItemDropdown: 10,
                items: listObjectItem,
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
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filter.length,
                itemBuilder: (_, i) {
                  return Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context, filter[i]);
                      },
                      title: Text(
                        filter[i].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${filter[i].cost} VND'),
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
