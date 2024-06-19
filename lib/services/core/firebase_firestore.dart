import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';


class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;

  static Future<void> createUser({
    required String name,
    required String email,
    required String id,
  }) async {
    final user = UserModel(
        id: id,
        email: email,
        name: name,
    );

    await firestore
        .collection('users')
        .doc(id)
        .set(user.toJson());
  }




}
