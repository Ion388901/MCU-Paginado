import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import "package:http/http.dart" as http;
import 'package:crypto/crypto.dart' as crypto;

void main() => runApp(new MarvelApp());

String generateMd5(String input) {
  return crypto.md5.convert(utf8.encode(input)).toString();
}

class MarvelApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(title: Text("Marvel Comics!"),),
          body:InfinityDudes()
      ),
    );
  }
}

class InfinityDudes extends StatefulWidget{
  @override
  ListInfinityDudesState createState() => new ListInfinityDudesState();
}

class ListInfinityDudesState extends State<InfinityDudes>{
  Future<List<InfinityComic>> getDudes() async{
    var now = new DateTime.now();
    var md5D = generateMd5(now.toString()+"01df0b638abf44a1bcc3dff2d6fb7da51b585075"+"d17a7bbe7bb5257a711c63a5c7b2da04");
    var url = "https://gateway.marvel.com:443/v1/public/characters?&ts=" + now.toString()+  "&apikey=d17a7bbe7bb5257a711c63a5c7b2da04&hash="+md5D;
    print(url);

    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    List<InfinityComic> dudes = [];
    var dataMarvel = jsonData("data");
    var marvelArray = dataMarvel["results"];
    for(var dude in marvelArray){
      var thumb = dude["thumbnail"];
      var image = "${thumb["path"]}.jpg";
      InfinityComic infinityComic = InfinityComic(dude["name"], image);
      dudes.add(infinityComic);
    }

    return dudes;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        body: Container(
          child: FutureBuilder(
            future: getDudes(),

            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child:Text("error..."),
                  ),
                );
              }else{
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                          NetworkImage(snapshot.data[index].cover),
                        ),
                        title: Text(snapshot.data[index].title),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(builder:
                              (context)=>
                                  InfinityDetail(snapshot.data[index]) ));
                        },
                      );
                    });
              }
            },



          ),
        )
    );
  }
}

class InfinityComic{
  final String title;
  final String cover;
  InfinityComic(this.title, this.cover);
}

class InfinityDetail extends StatelessWidget{
  final InfinityComic infinityComic;
  InfinityDetail(this.infinityComic);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(infinityComic.title),
        ),
        body: Image.network(
          infinityComic.cover,
        )
    );
  }
}

/*
class HelloWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        RowWidget(),
        RowWidget()
      ],
    );
    //return Container(
      //color: Colors.blueAccent,
      //height: 300.0,
      //width: 400.0,
      //child: Center(
        //child: Text(
          //"Hello Dudes!",
          //style: TextStyle(fontSize: 45.0, color: Colors.white),
        //)
      //),
      //child: Text(
        //"Hello Dudes!"
      //),
    //);
  }
}

class RowWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Center( child: Container(
      color: Colors.blueAccent,
      height: 300.0,
      width: 400.0,
      child: Center(
        child: Text(
          "Hello Dudes!!",
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        )
      ),
    )
    );
  }
}


void main() {

  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Hello Dudes, Flutter!!"
          ),
        ),
        //body: Container(color: Colors.lightGreen,),
        body: HelloWidget(),
      ),
    )
  );
  */