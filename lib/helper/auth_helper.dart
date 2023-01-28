import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:todoapp/app/app.dart';

class AuthHelper {
  final Account account = Account(client);

  Future<model.Account> createUserWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await account.create(
        email: email,
        password: password,
        name: name,
        userId: ID.unique(),
      );
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  Future<bool> signOut() async {
    try {
      await account.deleteSessions();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<model.Session> loginUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await account.createEmailSession(email: email, password: password);
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  void logout() {
    account.deleteSessions();
    prefs.clear();
  }

  Future<model.Session> loginAnnonymously() async {
    try {
      final response = await account.createAnonymousSession();
      return response;
    } on AppwriteException {
      rethrow;
    }
  }

  void loginWithNumber() {
    try {
      final token = account.createPhoneSession(
        userId: ID.unique(),
        phone: '+917031932380',
      );

      //verify token

    } on AppwriteException {
      rethrow;
    }
  }
}
