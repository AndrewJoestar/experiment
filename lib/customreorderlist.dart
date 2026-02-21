import 'package:flutter/material.dart';

class CustomList  extends StatefulWidget{
  const CustomList ({super.key});

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  final FocusNode _focusNode  = FocusNode();
  final TextEditingController _controller = TextEditingController();

  bool _showInput = false; //Status widget input

   List<Map<String, dynamic>> tasks = [
    {"title" : "Ngoding", "status" : "Done"},
    {"title" : "Makan", "status" : "Pending"},
    {"title" : "Mandi", "status" : "Pending"},
    {"title" : "Tidur", "status" : "Done"},
  ];

   //Function input tasks terbaru
   //Menampilkan input
   void _openInput(){
     setState(() => _showInput = true);
      Future.delayed(const Duration(milliseconds: 100), (){
        //Delay penampilan input keyboard
        FocusScope.of(context).requestFocus(_focusNode);
      });
   }

   void _addTask(){
     if(_controller.text.trim().isEmpty) return;

     setState(() {
       //Menambahkan task baru ke dalam list
       tasks.add({"title" : _controller.text.trim(), "status" : "Pending"});
       _controller.clear();
        _showInput = false;//Menutup input setelah menambahkan task
     });
     FocusScope.of(context).unfocus();
   }

   void _closeInput(){
     setState(() => _showInput = false);
     _controller.clear();
     FocusScope.of(context).unfocus();
   }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index){
        final task = tasks[index];

        return ListTile(
          key: ValueKey(task["title"]),
          leading: const Icon(Icons.list),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(task["status"],
                style: TextStyle(fontSize: 15,
                  color: task["status"] == "Done" ? Colors.green : Colors.amber
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.drag_handle),
            ],
          ),
          title: Text(task["title"]),
        );
      },
      onReorder: (int oldIndex, int newIndex){
        setState(() {
          if(newIndex >  oldIndex) newIndex = -1;

          final movedItem = tasks.removeAt(oldIndex);
          tasks.insert(newIndex, movedItem);
        });
      },
    );

  }
}