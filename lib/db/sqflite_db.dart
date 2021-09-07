import 'package:movie_hub/model/movie_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

class DBSQFLiteHelper {
  static final String CREATE_MOVIE_TABLE = '''create table $MOVIE_TABLE(
$MOVIE_COL_ID  integer primary key autoincrement,
$MOVIE_COL_NAME text not null,
$MOVIE_COL_CATEGORY text not null,
$MOVIE_COL_RELEASEDATE integer not null,
$MOVIE_COL_RATING real not null,
$MOVIE_COL_IMAGE text not null,
$MOVIE_COL_DES text not null,
$MOVIE_COL_FAV integer not null
)
''';

// ? open DB
  static Future<Database> open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'movie.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(CREATE_MOVIE_TABLE);
      },
    );
  }

  //? insert  Movies
  static Future<int> insertMovie(Movies movie) async {
    final db = await open();
    return db.insert(MOVIE_TABLE, movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }
  //? get all movies
  static Future<List<Movies>> getAllMovie() async {
    final db = await open();
    final List<Map<String, dynamic>> movieMap =
        await db.rawQuery('select * from $MOVIE_TABLE');
    return List.generate(
        movieMap.length, (index) => Movies.fromMap(movieMap[index]));
  }


  static Future <Movies> getMovieByID(int? mID) async {
    final db = await open();
    //final List<Map<String, dynamic>> movieMap =
    List<Map<String, dynamic>> mapList =await db.query(MOVIE_TABLE,where: '$MOVIE_COL_ID=?',whereArgs: [mID]);
    
      return Movies.fromMap(mapList.first);
    
  }

  static Future <List<Movies>> getCustomMovie(int mID) async {
    final db = await open();
    final List<Map<String, dynamic>> movieMap =
        await db.rawQuery('select * from $MOVIE_TABLE WHERE movie_id=$mID');
    //return Movies.fromMap(movieMap.first);
    return List.generate(
        movieMap.length, (index) => Movies.fromMap(movieMap[index]));
  }

  static deleteMovie() async {
    final db = await open();
    return db.delete(MOVIE_TABLE);
    //db.insert(MOVIE_TABLE, movies.toMap());
  }

  static Future<int?> deleteMovieByID (int? dID)async{
    final db = await open();
    return db.delete(MOVIE_TABLE,where: '$MOVIE_COL_ID=?',whereArgs: [dID]);
  }
  static updateMovieFav(int? mID,bool isFavv) async {
    int isFavDegit;
    if(isFavv==true) isFavDegit=0;
    else isFavDegit=1;
    final db = await open();
    return db.rawQuery('UPDATE movie_tbl SET movie_isfav=$isFavDegit WHERE movie_id=$mID');
  }
  static updateMovieRating(int? rID,double? _rating) async {
    final db = await open();
    return db.rawQuery('UPDATE movie_tbl SET $MOVIE_COL_RATING=$_rating WHERE movie_id=$rID');
  }
  static updateMovieName(int? rID, String? _name) async {
    final db = await open();
    //UPDATE movie_tbl SET movie_name="qwre" WHERE movie_id=17
    return db.rawQuery('UPDATE movie_tbl SET movie_name="$_name" WHERE movie_id=$rID');
  }
}
