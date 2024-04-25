import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DailyGoalData{ 
  final int id;
  final String date; 
  final String exercise;
  final int totalRepGoal;
   
  DailyGoalData({this.id, this.date, this.exercise, this.totalRepGoal});
  
  DailyGoalData.fromMap(Map<String, dynamic> item): 
    id=item["id"], date=item["date"], exercise= item["exercise"], totalRepGoal=item["totalRepGoal"];
  
  Map<String, dynamic> toMap(){
    return {'date':date,'exercise': exercise, 'totalRepGoal':totalRepGoal};
  }
}
class SqliteServiceDailyGoal {
  
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print(path);
    
    return openDatabase(
      join(path, 'database_dailygoal.db'),
      onCreate: (database, version) async {
         await database.execute( 
           """CREATE TABLE DailyGoal
           (id INTEGER PRIMARY KEY autoincrement, 
            date TEXT, 
            exercise TEXT, 
            totalRepGoal INTEGER DEFAULT 0
            )""",
      );
           
     },
     version: 1,
    );
  }

  Future<int> createItem(DailyGoalData dailyGoalData) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert(
      'DailyGoal', dailyGoalData.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DailyGoalData>> getItems() async {
    final db = await initializeDB();
    final List<Map<String, Object>> queryResult = 
      await db.query('DailyGoal');
    return queryResult.map((e) => DailyGoalData.fromMap(e)).toList();
  }

  Future<void> deleteData(DailyGoalData data) async {
    final db = await initializeDB();

    await db.delete('DailyGoal', where: "id = ?", whereArgs: [data.id]);
  }

  Future<int> updateData(DailyGoalData data) async {
    final db = await initializeDB();
    return await db.update('DailyGoal', data.toMap(),
        where: "id = ?", whereArgs: [data.id]);
  }
}