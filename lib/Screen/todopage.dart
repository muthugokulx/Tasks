import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/Services/api_client.dart';
import 'package:tasks/bloc/todo_bloc.dart';
import 'package:tasks/bloc/todo_events.dart';
import 'package:tasks/bloc/todo_state.dart';
import 'package:tasks/models/todoModels.dart';

class Todopage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc()..add(FetchTodos()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "TRACK YOUR SCHEDULES",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is TodoFailure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TodoBloc>().add(FetchTodos());
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (state is TodoLoaded) {
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) {
                  final todo = state.todos[index];
                  return ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (_) {
                        context.read<TodoBloc>().add(ToggleTodoStatus(index));
                      },
                    ),
                  );
                },
              );
            }
            return SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTodoBottomSheet(context);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

void _showAddTodoBottomSheet(BuildContext parentContext) {
  final TextEditingController controller = TextEditingController();

  showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          right: 16,
          left: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Add Todo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Add Todo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();

                if (text.isEmpty) {
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(content: Text("Todo Cannot be Empty")),
                  );
                  return;
                }

                //Sending Values to Bloc
                parentContext.read<TodoBloc>().add(AddTodo(text));
                Navigator.pop(parentContext);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      );
    },
  );
}
