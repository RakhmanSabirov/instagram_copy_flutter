import 'package:flutter/material.dart.';
import 'package:instagram_flutter/resources/auth_method.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier{
  Users? _user;
  final AuthMethods _authMethods = AuthMethods();

  Users get getUser => _user!;
  Future<void> refreshUser() async{
    Users user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}