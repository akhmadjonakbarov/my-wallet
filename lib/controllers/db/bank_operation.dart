import 'package:my_wallet/controllers/db/db_helper.dart';

import '../../models/models.dart';

class BankOperation {
  BankOperation? bankOperation;
  static DBHelper dbHelperProvider = DBHelper.instance;
  static const String _tableName = "banks";

  static Future getData() async {
    final sqlDB = await dbHelperProvider.database;
    List<Map<String, dynamic>> datas = await sqlDB.query(
      _tableName,
      orderBy: "id",
    );
    return datas.map((data) => Bank.fromMap(data)).toList();
  }

  static Future<void> insertData({required Map<String, dynamic> data}) async {
    final sqlDB = await dbHelperProvider.database;
    if (data.isNotEmpty) {
      await sqlDB.insert(_tableName, data);
      print("Data was added successfully");
    }
  }

  static Future<int> updateData({required Bank bank}) async {
    final sqlDB = await dbHelperProvider.database;
    int res = await sqlDB.update(_tableName, bank.toMap(),
        where: "id = ?", whereArgs: [bank.id]);
    return res;
  }

  static Future<void> deleteData({required Bank bank}) async {
    // this method delete data
    final sqlDB = await dbHelperProvider.database;
    sqlDB.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [bank.id],
    );
    print("Data was deleted successfully");
  }
}
