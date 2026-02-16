//material imports
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  String? uid; // user ID
  bool _isAdmin = false; // admin flag

  //  Getters
  bool get isLoggedIn => uid != null;
  bool get isAdmin => _isAdmin;

  void setUser({required String userId, required bool isAdmin}) {
    uid = userId;
    _isAdmin = isAdmin; //sets admin privileges app-wide
    notifyListeners();
  }

  void logout() {
    //removes admin priveleges on logout
    uid = null;
    _isAdmin = false;
    notifyListeners();
  }
}
