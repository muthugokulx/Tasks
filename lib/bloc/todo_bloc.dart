import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:tasks/Services/api_client.dart';
import 'package:tasks/models/todoModels.dart';
import 'todo_events.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<FetchTodos>(_onFetchTodos);
  }

  Future<void> _onFetchTodos(FetchTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final api = ApiClient().dio;
      final response = await api.get("/todos");

      final result = response.data as List;

      emit(TodoLoaded(result.map((e) => Todomodels.fromJson(e)).toList()));
    } on DioException catch (_) {
      emit(TodoFailure("Failed to load Data"));
    }
  }
}
