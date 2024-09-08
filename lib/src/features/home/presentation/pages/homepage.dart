import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/src/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:todo/src/features/home/data/models/todo.dart';
import 'package:todo/src/features/home/presentation/bloc/todo_bloc.dart';
import 'package:todo/src/features/home/presentation/widgets/todo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TodoBloc todoBloc;

  List<Todo> todos = [];
  final List<Color> colors = [
    const Color(0xFFE7D1EE),
    const Color(0xFFC1D3E5),
    const Color(0xFFD8E4C2),
    const Color(0xFFE6C0C2),
  ];

  @override
  void initState() {
    todoBloc = BlocProvider.of(context);
    todoBloc.add(FetchedTodo(
        userId: context.read<AuthenticationBloc>().state.user?.uid ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFFFEE992),
        onPressed: () {
          Navigator.pushNamed(context, '/addToDo');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('My ToDo'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthenticationBloc>().add(LoggedOut());

                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          top: 16,
          right: 12,
          bottom: 8,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Computer Science',
                  style: textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      todos.sort((a, b) => a.duedate.compareTo(b.duedate));
                    });
                  },
                  icon: const Icon(Icons.filter_list),
                  color: Colors.black,
                )
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
             
                if (state.status == TodoStatus.loading) {
                  return const SizedBox(
                    height: 500,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(255, 213, 59, 1),
                      ),
                    ),
                  );
                }
                if (state.status == TodoStatus.success) {
                  todos = state.todos!;
                  if (todos.isEmpty) {
                    return SizedBox(
                        height: 500,
                        child: Center(
                            child: Image.asset('assets/images/empty.png')));
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) =>
                        const SizedBox.shrink(),
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final colorIndex = index % colors.length;
                      final color = colors[colorIndex];
                      final todo = todos[index];
                      print('todos $todo');
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        background:
                            Container(color: Colors.red.withOpacity(0.5)),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          todoBloc.add(
                            DeletedTodo(
                              userId: context
                                      .read<AuthenticationBloc>()
                                      .state
                                      .user
                                      ?.uid ??
                                  '',
                              todoId: todo.docId!,
                            ),
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/addToDo',
                              arguments: todo,
                            );
                          },
                          child: ToDoCard(
                            color: color,
                            todo: Todo(
                              title: todo.title,
                              createdAt: todo.createdAt,
                              duedate: todo.duedate,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
