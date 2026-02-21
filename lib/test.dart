import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  bool _showInput = false; // ✅ kontrol tampil/sembunyi widget input

  List<Map<String, dynamic>> tasks = [
    {"title": "Task 1", "done": true, "time": "13:00"},
    {"title": "Task 2", "done": false, "time": null},
    {"title": "Task 3", "done": false, "time": null},
  ];

  void _openInput() {
    setState(() => _showInput = true);
    // delay sedikit agar widget sudah render sebelum request focus
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode); // ✅ keyboard muncul otomatis
    });
  }

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      tasks.add({
        "title": _controller.text.trim(),
        "done": false,
        "time": null,
      });
      _controller.clear();
      _showInput = false; // ✅ sembunyikan input setelah tambah
    });
    FocusScope.of(context).unfocus();
  }

  void _closeInput() {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo 1"),
      ),
      body: Stack(
        children: [

          // ✅ List utama
          ReorderableListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                key: ValueKey(task["title"]),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.drag_indicator),
                    Checkbox(
                      value: task["done"],
                      onChanged: (val) {
                        setState(() {
                          tasks[index]["done"] = val;
                          tasks[index]["time"] = val == true
                              ? TimeOfDay.now().format(context)
                              : null;
                        });
                      },
                    ),
                  ],
                ),
                title: Text(task["title"]),
                trailing: Text(
                  task["time"] != null
                      ? "Completed at ${task["time"]}"
                      : "Completed at - - : - -",
                  style: TextStyle(
                    fontSize: 12,
                    color: task["done"] ? Colors.black : Colors.grey,
                  ),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = tasks.removeAt(oldIndex);
                tasks.insert(newIndex, item);
              });
            },
          ),

          // ✅ Overlay gelap saat input muncul
          if (_showInput)
            GestureDetector(
              onTap: _closeInput, // tap di luar → tutup
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

          // ✅ Widget input muncul di tengah layar
          if (_showInput)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Menambahkan tugas baru",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "masukan tugas",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _addTask(), // ✅ tekan enter → simpan
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _closeInput,
                          child: const Text("Batal"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addTask,
                          child: const Text("Tambah"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
        ],
      ),

      // Bottom Navigation
      floatingActionButton: FloatingActionButton(
        onPressed: _openInput, // ✅ tekan + → muncul widget input
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.settings),
            Icon(Icons.home),
            SizedBox(width: 40), // ruang untuk FAB
            Icon(Icons.person),
            Icon(Icons.directions_run),
          ],
        ),
      ),
    );
  }
}
