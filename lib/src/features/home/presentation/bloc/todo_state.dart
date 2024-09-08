
part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, failure }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<Todo>? todos;
  final String? failure;
  const TodoState({
    required this.status,
    this.todos = const [],
    this.failure = '',
  });
  @override
  List<Object?> get props => [status, todos, failure];
  factory TodoState.initial() => const TodoState(status: TodoStatus.initial);
  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
    String? failure,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool get stringify => true;
}
