import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExerciseDone{ 
  final int id;
  final String date; 
  final String timeTaken;
  final String exercise;
  final int totalRepTarget;
  final int totalRepDone;
  final String success;
   
  ExerciseDone({this.id, this.date, this.timeTaken, this.exercise, this.totalRepTarget, this.totalRepDone, this.success});
  
  ExerciseDone.fromMap(Map<String, dynamic> item): 
    id=item["id"], date=item["date"], timeTaken=item["timeTaken"], exercise= item["exercise"], totalRepTarget=item["totalRepTarget"], totalRepDone=item["totalRepDone"], success=item["success"];
  
  Map<String, dynamic> toMap(){
    return {'date':date, 'timeTaken':timeTaken, 'exercise': exercise, 'totalRepTarget':totalRepTarget, 'totalRepDone':totalRepDone, 'success':success};
  }
}
class SqliteServiceExerciseDone {
  
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print(path);
    
    return openDatabase(
      join(path, 'database_exercisedone.db'),
      onCreate: (database, version) async {
         await database.execute( 
           """CREATE TABLE ExerciseDone
           (id INTEGER PRIMARY KEY autoincrement, 
            date TEXT, 
            timeTaken TEXT,
            exercise TEXT, 
            totalRepTarget INTEGER DEFAULT 0, 
            totalRepDone INTEGER DEFAULT 0,
            success TEXT 
            )""",
      );
           
     },
     version: 1,
    );
  }

  Future<int> createItem(ExerciseDone exerciseDone) async {
    //int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert(
      'ExerciseDone', exerciseDone.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace);
      return id;
  }

  Future<List<ExerciseDone>> getItems() async {
    final db = await initializeDB();
    final List<Map<String, Object>> queryResult = 
      await db.query('ExerciseDone');
    return queryResult.map((e) => ExerciseDone.fromMap(e)).toList();
  }

  Future<void> deleteData(ExerciseDone data) async {
    final db = await initializeDB();

    await db.delete('ExerciseDone', where: "id = ?", whereArgs: [data.id]);
  }
  Future<void> dropData() async {
    final db = await initializeDB();
    await db.execute("DROP TABLE IF EXISTS ExerciseDone");

    //await db.delete('ExerciseDone', where: "id = ?", whereArgs: [data.id]);
  }
  Future<int> updateData(ExerciseDone data) async {
    final db = await initializeDB();
    return await db.update('ExerciseDone', data.toMap(),
        where: "id = ?", whereArgs: [data.id]);
  }
}