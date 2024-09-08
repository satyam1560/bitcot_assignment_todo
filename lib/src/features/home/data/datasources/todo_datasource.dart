import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/src/features/home/data/models/todo.dart';

class TodoDatasource {
  final FirebaseFirestore firestore;

  TodoDatasource({
    required this.firestore,
  });

  Future<void> createTodo({
    required Todo todo,
    required String userId,
  }) async {
    try {
      await firestore
          .collection('Users')
          .doc(userId)
          .collection('todos')
          .add(todo.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateTodoInList({
    required Todo updatedTodo,
      required String userId,
  }) async {
    try {
      await firestore
          .collection('Users')
          .doc(userId)
          .collection('todos')
          .doc(updatedTodo.docId ?? '')
          .set(updatedTodo.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Todo>> getTodos(  {required String userId}) async {

    try {
      QuerySnapshot snapshot = await firestore
          .collection('Users')
          .doc(userId)
          .collection('todos')
          .get();

      List<Todo> todos = snapshot.docs.map((doc) {
        return Todo.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
      }).toList();

      return todos;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodoInList({
    required String todoId,
      required String userId,
  }) async {
    final firestore = FirebaseFirestore.instance;

    try {
      DocumentReference todoDocRef = firestore
          .collection('Users')
          .doc(userId)
          .collection('todos')
          .doc(todoId);

      await todoDocRef.delete();
    } catch (error) {
      rethrow;
    }
  }
}
