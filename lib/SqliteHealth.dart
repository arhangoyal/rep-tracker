import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HealthData{ 
  final String date; 
  final double weight;
  final double ldl;
  final double hdl;
  final double trig;
   
  HealthData({this.date, this.weight, this.ldl, this.hdl, this.trig});
  
  HealthData.fromMap(Map<String, dynamic> item): 
    date=item["date"], weight= item["weight"], ldl=item["ldl"], hdl=item["hdl"], trig=item["trig"];
  
  Map<String, dynamic> toMap(){
    return {'date':date,'weight': weight, 'ldl':ldl, 'hdl':hdl, 'trig':trig};
  }
}
class SqliteService {
  
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    print ("&&&&&&&&&&&");
    print(path);
    print ("###########");
    
    return openDatabase(
      join(path, 'database_health.db'),
      onCreate: (database, version) async {
         await database.execute( 
           """CREATE TABLE Health
           (date TEXT PRIMARY KEY, 
            weight REAL DEFAULT 0, 
            ldl REAL DEFAULT 0, 
            hdl REAL DEFAULT 0, 
            trig REAL DEFAULT 0)""",
      );
           
     },
     version: 1,
    );
  }

  Future<int> createItem(HealthData healthData) async {
    int result = 0;
    final Database db = await initializeDB();
    final id = await db.insert(
      'Health', healthData.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HealthData>> getItems() async {
    final db = await initializeDB();
    final List<Map<String, Object>> queryResult = 
      await db.query('Health');
    return queryResult.map((e) => HealthData.fromMap(e)).toList();
  }

  Future<void> deleteData(HealthData data) async {
    final db = await initializeDB();

    await db.delete('Health', where: "date = ?", whereArgs: [data.date]);
  }

  Future<int> updateData(HealthData data) async {
    final db = await initializeDB();
    return await db.update('Health', data.toMap(),
        where: "date = ?", whereArgs: [data.date]);
  }
}