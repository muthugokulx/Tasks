import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tasks/Services/api_client.dart';
import 'package:tasks/models/todoModels.dart';

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  bool isLoading = true;
  bool isError = false;
  List<Todomodels> todos = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final api = ApiClient().dio;
      final response = await api.get("/todos");

      final result = response.data as List;

      setState(() {
        todos = result.map((e) => Todomodels.fromJson(e)).toList();
        isLoading = false;
      });
    } on DioException catch (_) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "TRACK YOUR SCHEDULE",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Failed to Load Todos"),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: fetchTodos, child: Text("Retry")),
                ],
              ),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  leading: Checkbox(value: todo.isCompleted, onChanged: null),
                );
              },
            ),
    );
  }
}
