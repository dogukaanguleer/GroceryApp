import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/services/database.dart';
import 'package:grocery_app/model/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<AppUser> signInWithEmail(String _email,String _password) async {
  final List<AppUser> users = await getAllUsers();
  AppUser user = AppUser('', '', '', _email, _password, '', Type.customer);
  if(users.isEmpty) {
    return user;
  }
  for (var element in users) {
    if(element.email == user.email) {
      user = element;
      break;
    }
  }
  await _auth.signInWithEmailAndPassword(email: _email, password: _password);
  return user;
}

Future checkUser(AppUser user) async {
  final List<AppUser> users = await getAllUsers();
  if(users.isEmpty) {
    return user;
  }
  for (var element in users) {
    if(element.email == user.email) {
      user = element;
      break;
    }
  }
  return user;
}

Future<AppUser> createUserWithEmail(String _email,String _password) async {
  UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
  AppUser user = AppUser(userCredential.user!.uid, '', '', _email, _password, '', Type.customer);
  user.setId(saveUser(user));
  return user;
}

Future logout() async {
  FirebaseAuth.instance.signOut();
}

Future passwordChange(AppUser appUser,String _password) async {
  appUser.password = _password;
  appUser.update();
  User? user = _auth.currentUser;
  user!.updatePassword(_password);
}

Future emailChange(AppUser appUser,String _email) async {
  appUser.email = _email;
  appUser.update();
  User? user = _auth.currentUser;
  user!.updateEmail(_email);
}