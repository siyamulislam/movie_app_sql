

 String MOVIE_TABLE = 'movie_tbl';
final String MOVIE_COL_ID = 'movie_id';
final String MOVIE_COL_NAME = 'movie_name';
final String MOVIE_COL_CATEGORY = 'movie_category';
final String MOVIE_COL_RELEASEDATE = 'movie_releasedATE';
final String MOVIE_COL_RATING = 'movie_rating';
final String MOVIE_COL_IMAGE = 'movie_image';
final String MOVIE_COL_DES = 'movie_description';
final String MOVIE_COL_FAV = 'movie_isfav';

class Movies {
  int? id;
  String? name;
  String? category;
  int? releaseDate;
  double? rating;
  String? image;
  String? description;
  bool isfav=false;

  Movies({
    this.id,
    this.name,
    this.category,
    this.releaseDate,
    this.rating,
    this.image,
    this.description,
    this.isfav = false,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      MOVIE_COL_NAME: name,
      MOVIE_COL_CATEGORY: category,
      MOVIE_COL_RELEASEDATE: releaseDate,
      MOVIE_COL_RATING: rating,
      MOVIE_COL_IMAGE: image,
      MOVIE_COL_DES: description,
      MOVIE_COL_FAV: isfav ? 1 : 0
    };
    if (id != null) {
      map[MOVIE_COL_ID] = id;
    }
    return map;
  }

  Movies.fromMap(Map<String,dynamic> map){
    id=map[MOVIE_COL_ID];
    name=map[MOVIE_COL_NAME];
    category=map[MOVIE_COL_CATEGORY];
    releaseDate=map[MOVIE_COL_RELEASEDATE];
    rating=map[MOVIE_COL_RATING];
    image=map[MOVIE_COL_IMAGE];
    description=map[MOVIE_COL_DES];
    isfav=map[MOVIE_COL_FAV]==0? false:true;
}


}
