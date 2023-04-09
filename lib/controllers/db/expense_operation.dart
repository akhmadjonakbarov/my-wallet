import '../../models/models.dart';
import 'db_helper.dart';

class ExpenseOperation {
  ExpenseOperation? expenseOperation;
  static DBHelper dbHelperProvider = DBHelper.instance;
  static const String _tableName = "expenses";

  static Future getData() async {
    // this method gets data
    final sqlDB = await dbHelperProvider.database;
    List<Map<String, dynamic>> datas =
        await sqlDB.query(_tableName, orderBy: "id");
    return datas.map((data) => Expense.fromMap(data)).toList();
  }

  static Future<void> insertData({required Map<String, dynamic> data}) async {
    // this method enters data
    final sqlDB = await dbHelperProvider.database;
    if (data.isNotEmpty) {
      await sqlDB.insert(_tableName, data);
      print("Data was added successfully");
    }
  }

  static Future<int> updateData({required Expense expense}) async {
    // this method update data
    final sqlDB = await dbHelperProvider.database;
    int res = await sqlDB.update(
      _tableName,
      expense.toMap(),
      where: "id = ?",
      whereArgs: [expense.id],
    );
    print("Data was updated successfully");
    return res;
  }

  static Future<void> deleteData({required Expense expense}) async {
    // this method delete data
    final sqlDB = await dbHelperProvider.database;
    sqlDB.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [expense.id],
    );
    print("Data was deleted successfully");
  }
}
