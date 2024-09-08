
import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String? docId;
  final String title;
  final DateTime createdAt;
  final DateTime duedate;

  const Todo({
    this.docId,
    required this.title,
    required this.createdAt,
    required this.duedate,
  });

  @override
  List<Object?> get props => [
        docId,
        title,
        createdAt,
        duedate,
      ];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'duedate': duedate.millisecondsSinceEpoch,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> map, {String? id}) {
    return Todo(
      docId: id,
      title: map['title'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      duedate: DateTime.fromMillisecondsSinceEpoch(map['duedate'] as int),
    );
  }

  @override
  bool get stringify => true;

  Todo copyWith({
    String? docId,
    String? title,
    DateTime? createdAt,
    DateTime? duedate,
  }) {
    return Todo(
      docId: docId ?? this.docId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      duedate: duedate ?? this.duedate,
    );
  }
}
