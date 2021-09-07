import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_hub/db/sqflite_db.dart';
import 'package:movie_hub/db/temp_db.dart';
import 'package:movie_hub/model/movie_model.dart';
class Add_Movie extends StatefulWidget {
  const Add_Movie({Key? key}) : super(key: key);

  @override
  _Add_MovieState createState() => _Add_MovieState();
}

class _Add_MovieState extends State<Add_Movie> {
  var movie = Movies(name: '', category: '');
  final _formKey = GlobalKey<FormState>();
  DateTime? dt;
  String category = categories[0];
  String? _imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Movie"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: "Enter Movie Name"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Please Enter Movie Name!");
                  }
                  return null;
                },
                onSaved: (value) => movie.name = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: "Enter Rating"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Enter valid rating!");
                  }
                  if (double.parse(value) < 0 || double.parse(value) > 10) {
                    return ("Rating must be 0-10");
                  }
                  return null;
                },
                onSaved: (value) => movie.rating = double.parse(value!),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: _pickDate, child: Text("Select Date")),
                  Text(dt == null
                      ? "dd/mm/yyyy"
                      : dt!.day.toString() +
                      '/' +
                      dt!.month.toString() +
                      '/' +
                      dt!.year.toString()),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: _pickDate, child: Text("Select Category")),
                  DropdownButton(
                    underline: Divider(
                      height: 21,
                      color: Colors.green,
                    ),
                    value: category,
                    items: categories
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        category = value.toString();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                        height: 90.0 + 45.0,
                        width: 120.0 + 60.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _imagePath==null?Text( 'no image found!'):
                        kIsWeb ? Image.network(_imagePath!)
                            : Image.file(File(_imagePath!),fit: BoxFit.cover,),
                       // Image.file(File(_imagePath!),fit: BoxFit.cover,)
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          _pickImage();
                        },
                        icon: Icon(Icons.camera_alt),
                        iconSize: 24,
                      ),
                    ), Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        onPressed: () {
                          _pickImage2();
                        },
                        icon: Icon(Icons.image),
                        iconSize: 24,
                        // color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: "Choose Movie Description"),
                onSaved: (value) {
                  movie.description = value;
                },

              ),
              SizedBox(height: 10),
              ElevatedButton(
                //style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: _saveData,
                child: Text("Save"),
              ), SizedBox(height: 10),
              // ElevatedButton(
              //   style:ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
              //   onPressed: _deleteData,
              //   child: Text("Delete"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _saveData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //movie.id=movies.length+1;
      movie.releaseDate= dt!.millisecondsSinceEpoch;
      movie.category = category;
      movie.image=_imagePath;

      // print(movie);
      DBSQFLiteHelper.insertMovie(movie).then((value) {
        if(value>0){
          Navigator.of(context).pop(true);
        }
      });
    }
  }

  void _pickDate() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2050))
        .then((value) {
      setState(() {
        dt = value;

      });
    });
    }

  void _pickImage() {
    ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        _imagePath=value!.path;
      });
    });
  }void _pickImage2() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _imagePath=value!.path;
      });
    });
  }
}
