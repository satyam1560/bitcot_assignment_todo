part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class CreatedTodo extends TodoEvent {
  final Todo todo;
  final String userId;
  const CreatedTodo({
    required this.todo,
    required this.userId,
  });

  @override
  List<Object> get props => [todo, userId];
}

class UpdatedTodo extends TodoEvent {
  final Todo todo;
  final String userId;
  const UpdatedTodo({
    required this.todo,
    required this.userId,
  });
  @override
  List<Object> get props => [todo, userId];
}

class DeletedTodo extends TodoEvent {
  final String todoId;
  final String userId;
  const DeletedTodo({required this.todoId, required this.userId});
  @override
  List<Object> get props => [todoId, userId];
}

class FetchedTodo extends TodoEvent {
  final String userId;
  const FetchedTodo({required this.userId});
  @override
  List<Object> get props => [userId];
}

class SortTodosByDueDate extends TodoEvent {}
