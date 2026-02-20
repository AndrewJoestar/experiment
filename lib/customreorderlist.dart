import 'package:flutter/material.dart';

class CustomList  extends StatefulWidget{
  const CustomList ({super.key});

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {

   List<Map<String, dynamic>> items = [
    {"title" : "Ngoding", "status" : "Done"},
    {"title" : "Makan", "status" : "Pending"},
    {"title" : "Mandi", "status" : "Pending"},
    {"title" : "Tidur", "status" : "Done"},
  ];

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index){
        final item = items[index];

        return ListTile(
          key: ValueKey(item["title"]),
          leading: const Icon(Icons.list),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item["status"],
                style: TextStyle(fontSize: 15,
                  color: item["status"] == "Done" ? Colors.green : Colors.amber
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.drag_handle),
            ],
          ),
          title: Text(item["title"]),
        );
      },
      onReorder: (int oldIndex, int newIndex){
        setState(() {
          if(newIndex >  oldIndex) newIndex = -1;

          final movedItem = items.removeAt(oldIndex);
          items.insert(newIndex, movedItem);
        });
      },
    );
  }
}