import 'package:flutter/material.dart';
import 'package:movie_hub/db/sqflite_db.dart';
import 'package:movie_hub/model/movie_model.dart';
import 'package:movie_hub/widgets/movie_item.dart';

import 'add_movie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  reloadHome() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Hub'),
      ),
      body: FutureBuilder(
        future: DBSQFLiteHelper.getAllMovie(),
        builder: (context, AsyncSnapshot<List<Movies>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return Center(child: Text("No data found!"));
            }
            return ListView.builder(
                itemBuilder: (context, ee) => MovieItem(
                      e: snapshot.data![ee],
                      refresh: () => reloadHome(),
                    ),
                itemCount: snapshot.data!.length);
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Failed to Fetch data!"),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Add_Movie()))
              .then((value) {
            if (value == true) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Movie Added!"),
                duration: Duration(seconds: 4),
                action: SnackBarAction(label: 'Undo', onPressed: () {}),
              ));
            }
            setState(() {});
          });
        },
        tooltip: "add",
        child: Icon(Icons.add, size: 35),
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }
}
