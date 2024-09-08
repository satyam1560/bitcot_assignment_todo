import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/features/home/data/datasources/todo_datasource.dart';
import 'package:todo/src/features/home/data/models/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoDatasource todoDatasource;
  TodoBloc({required this.todoDatasource}) : super(TodoState.initial()) {
    on<CreatedTodo>(_onCreatedTodo);
    on<UpdatedTodo>(_onUpdatedTodo);
    on<DeletedTodo>(_onDeletedTodo);
    on<FetchedTodo>(_onFetchedTodo);
  }

  Future<void> _onCreatedTodo(
      CreatedTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));

    try {
      await todoDatasource.createTodo(
        todo: event.todo,
        userId: event.userId,
      );
      final todos = await todoDatasource.getTodos(userId: event.userId);
      emit(state.copyWith(
        status: TodoStatus.success,
        todos: todos,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TodoStatus.failure,
        failure: e.toString(),
      ));
    }
  }

  Future<void> _onUpdatedTodo(
      UpdatedTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));

    try {
      await todoDatasource.updateTodoInList(
        updatedTodo: event.todo,
        userId: event.userId,
      );
      add(FetchedTodo(userId: event.userId));
    } catch (e) {
      emit(state.copyWith(
        status: TodoStatus.failure,
        failure: e.toString(),
      ));
    }
  }

  Future<void> _onDeletedTodo(
      DeletedTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));

    try {
      await todoDatasource.deleteTodoInList(
        todoId: event.todoId,
        userId: event.userId,
      );
      add(FetchedTodo(userId: event.userId));
    } catch (e) {
      emit(state.copyWith(
        status: TodoStatus.failure,
        failure: e.toString(),
      ));
    }
  }

  Future<void> _onFetchedTodo(
      FetchedTodo event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));

    try {
      final todos = await todoDatasource.getTodos(userId: event.userId);
      emit(state.copyWith(
        status: TodoStatus.success,
        todos: todos,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.failure,
          failure: e.toString(),
        ),
      );
    }
  }
}
