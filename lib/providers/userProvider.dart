import 'package:flutter/material.dart';

class LogginUser {
  String? id;
  String? name;
  String? role;
  LogginUser({required this.id, required this.name, required this.role});
}

class UserProvider with ChangeNotifier {
  LogginUser? _user;

  LogginUser? getUser() => _user;

  void setUser(String id, String name, String role) {
    final user = LogginUser(id: id, name: name, role: role);

    _user = user;
    notifyListeners();
  }

  @override
  String toString() {
    var id = _user!.id;
    var name = _user!.name;
    var role = _user!.role;
    return 'User{id: $id, name: $name, role: $role}';
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
