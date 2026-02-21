import 'package:flutter/material.dart';

class CustomList  extends StatefulWidget{
  const CustomList ({super.key});

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  final FocusNode _focusNode  = FocusNode();
  final TextEditingController _controller = TextEditingController();

  bool _showInput = true; //Status widget input

   List<Map<String, dynamic>> tasks = [
    {"title" : "Ngoding", "status" : "Done"},
    {"title" : "Makan", "status" : "Pending"},
    {"title" : "Mandi", "status" : "Pending"},
    {"title" : "Tidur", "status" : "Done"},
  ];

   //Function input tasks terbaru
   //Menampilkan input
   void openInput(){
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

    if(_showInput)
      GestureDetector(
        onTap: _closeInput,
        child: Container(
          color: Colors.black.withOpacity(0.3),
        ),
      );

    //Widget input muncul tengah layar
    if(_showInput);
    Center(child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Tambahkan Tugas Baru",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12,),
          TextField(
            focusNode: _focusNode,
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Masukan tugas",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              )
            ),
            onSubmitted: (_) => _addTask(),
          ),
          const SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: _closeInput,
                  child: const Text("Batal")
              ),
              const SizedBox(width: 8,),
              ElevatedButton(onPressed: _addTask, child: const Text("Tambah")
              ),
            ],
          )
        ],
      ),
    ),
    );
  }
}