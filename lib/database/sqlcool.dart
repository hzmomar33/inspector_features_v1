import 'package:sqlcool/sqlcool.dart';

class SqlCool {
  SqlCool._();

  Db db = Db();
  DbTable images = DbTable('images')
  ..integer("id", unique: true)
  ..varchar("file_path", nullable: false)
  ..timestamp("created_on");

  initDb() {
    List<DbTable> scheme = [images];
    db.init(
      path: 'inspector_db',
      schema: scheme,
      verbose: true,
      debug: true
    ).catchError((e){
      print(e);
    });
  }

  Future<Db> get database async{
    if (!db.hasSchema){
      initDb();
    }

    return db;
  }


}