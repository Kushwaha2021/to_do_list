class UserModel {
  final String id;
  final String email;
  final String name;

  UserModel({required this.id, required this.email, required this.name, });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(
          id: json['id'],
          name: json['name'],
          email: json['email'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
  };
}
