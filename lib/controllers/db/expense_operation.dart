import 'db_helper.dart';
import '../../models/models.dart';

class ExpenseOperation {
  ExpenseOperation? expenseOperation;
  static DBHelper dbHelperProvider = DBHelper.instance;
  static const String _tableName = "expenses";

  static Future getData() async {
    // this method gets data
    final sqlDB = await dbHelperProvider.database;
    List<Map<String, dynamic>> datas = await sqlDB.query(_tableName);
    return datas.map((data) => Expense.fromMap(data)).toList();
  }

  static Future<void> insertData({required Map<String, dynamic> data}) async {
    // this method enters data
    final sqlDB = await dbHelperProvider.database;
    if (data.isNotEmpty) {
      await sqlDB.insert(_tableName, data);
    }
  }

  static Future<int> updateData({required Expense expense}) async {
    // this method update data
    final sqlDB = await dbHelperProvider.database;
    return await sqlDB.update(
      _tableName,
      expense.toMap(),
      where: "id = ?",
      whereArgs: [expense.id],
    );
  }

  static Future<void> deleteData({required Expense expense}) async {
    // this method delete data
    final sqlDB = await dbHelperProvider.database;
    sqlDB.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [expense.id],
    );
  }
}
