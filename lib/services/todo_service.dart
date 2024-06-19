import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/constants.dart';
import '../models/todo_model.dart';
import 'auth_service.dart';

class TodoService with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoService.initialize(){
    fetchTodos();
  }
  Future<void> fetchTodos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await _db
          .collection('users').doc(user.uid).collection("todos")
          .get();
      _todos = querySnapshot.docs.map((doc) => Todo.fromDocument(doc)).toList();
      notifyListeners();
    }
  }

  Future<void> addTodo(Todo todo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = await _db.collection('users').doc(user.uid).collection('todos').add({
        ...todo.toMap(),
      });
      _todos.add(todo.copyWith(id: docRef.id));
      notifyListeners();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
    await  _db.collection('users').doc(user.uid).collection('todos').doc(todo.id).update(todo.toMap());
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      notifyListeners();
    }
    }
  }

  Future<void> deleteTodo(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _db.collection('users').doc(user.uid).collection('todos')
          .doc(id)
          .delete();
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
    }
  }
}
