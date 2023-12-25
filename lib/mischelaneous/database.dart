import 'package:evergreen_employee_app/model/login.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseStore {
  getSessionDB() async {
    return await openDatabase(
      'database.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS session ( employee_id INTEGER PRIMARY KEY, name TEXT NOT NULL, email TEXT NOT NULL, token TEXT, isSigninedIn BOOLEAN, department INT, photo_url TEXT, is_admin BOOLEAN DEFAULT 0)',
        );
      },
    );
  }

  getEmployee() async {
    var db = await getSessionDB();
    var user = await db.query('session');
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  initializeLocalTokenFromDatabase() async {
    var db = await getSessionDB();
    var user = await db.query('session');
    if (user != null && user.length != 0) {
      return user[0]['token'];
    } else {
      return null;
    }
  }

  deleteSession() async {
    var db = await getSessionDB();
    await db.delete('session');
  }

  addEmployeeData(UserModel user) async {
    deleteSession();
    var db = await getSessionDB();
    var res = db.insert('session', user.toJson());
    return res;
  }

  static void logout() {
    DatabaseStore().deleteSession();
  }
}
