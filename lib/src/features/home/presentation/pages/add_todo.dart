import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/src/core/utility/widgets/custom_textfield.dart';
import 'package:todo/src/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:todo/src/features/home/data/models/todo.dart';
import 'package:todo/src/features/home/presentation/bloc/todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final String _currentDate = DateFormat('d-MMMM-yyyy').format(DateTime.now());

  Todo? _todo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_todo == null) {
      _todo = ModalRoute.of(context)?.settings.arguments as Todo?;

      if (_todo != null) {
        _topicController.text = _todo!.title;
        _dueDateController.text =
            DateFormat('MM/dd/yyyy').format(_todo!.duedate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          _todo == null ? 'Create ToDo' : 'Update ToDo',
          style: textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentDate,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your\'s CS prepration list',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _topicController,
                  label: 'Topic Name',
                  hintText: 'Ex: Flutter',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Topic name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  readOnly: true,
                  controller: _dueDateController,
                  label: 'Select Due Date',
                  hintText: 'MM/DD/YYYY',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDueDate,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a due date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveTodo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE992),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: Text(
                      _todo == null ? 'Save' : 'Update',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 224, 201, 0),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dueDateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      DateTime? dueDate =
          DateFormat('MM/dd/yyyy').parseStrict(_dueDateController.text);

      if (_todo != null) {
        BlocProvider.of<TodoBloc>(context).add(
          UpdatedTodo(
            userId:context.read<AuthenticationBloc>().state.user?.uid??'' ,
            todo: _todo!.copyWith(
              title: _topicController.text,
              duedate: dueDate,
            ),
          ),
        );
      } else {
        BlocProvider.of<TodoBloc>(context).add(
          CreatedTodo(
            userId:context.read<AuthenticationBloc>().state.user?.uid??'' ,
            todo: Todo(
              title: _topicController.text,
              createdAt: DateTime.now(),
              duedate: dueDate,
            ),
          ),
        );
      }

      _topicController.clear();
      _dueDateController.clear();
      Navigator.pop(context);
    }
  }
}
