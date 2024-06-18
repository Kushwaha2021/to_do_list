import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isComplete;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isComplete,
  });

  factory Todo.fromDocument(DocumentSnapshot doc) {
    return Todo(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
      dueDate: (doc['dueDate'] as Timestamp).toDate(),
      isComplete: doc['isComplete'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'isComplete': isComplete,
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isComplete,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
