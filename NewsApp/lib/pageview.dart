import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: Container(
          color: Color(0xFF0F2A5F),
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int count=0;
    return PageView.builder(
      controller: _controller,
      scrollDirection: Axis.vertical,
      itemBuilder: (context,position){
        return Scaffold(
                 body: Container(
                    child:
                     Column(
                       children: <Widget>[
                        new Expanded(
                         flex: 1,
                         child:
                          Container(
                            child:
                             GestureDetector(
                                child:
                              new FutureBuilder<List<News>>(
                               future: fetchNews(
                                  http.Client(),),
                                builder: (context,snapshot){
                               if(snapshot.hasError)print(snapshot.error);

                                 if (snapshot.hasData) {
                                  // if (count==10)
                                   //  {
                                   //    count=0;
                                   //  }
                                   return Page(snapshot.data[position].author,snapshot.data[position].title,snapshot.data[position].description,snapshot.data[position].imgurl,snapshot.data[position].url);
                                 } else {
                                   return Center(child:CircularProgressIndicator());
                                 }
                                },
                              ),
                              )
                             ),
                          )
                     ],
               ),
            ),
        );
      },
    );
  }
  Future<List<News>> fetchNews(http.Client client) async {
    final response = await client.get(Uri.parse("https://newsapi.org/v2/everything?q=sports&language=en&apiKey=5ccdf373158c417f81d1535310b444ec"));
    final parsed = json.decode(response.body);
    return (parsed["articles"] as List)
        .map<News>((json) => new News.fromJson(json))
        .toList();
  }

}
class News {
  String author;
  String title;
  String description;
  String url;
  String imgurl;

  News({this.author,  this.title, this.description, this.url, this.
  imgurl, image});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      imgurl:json['urlToImage'] as String,
    );
  }
}
class Page extends StatelessWidget
{
  String title;
  String author;
  String description;
  String imgurl;
  String url;
  Page(this.author,this.title,this.description,this.imgurl,this.url);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(10),
        color: Colors.black,
        child: Container(
          color:Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 60,
                  child: Center(child: Text('News',style: TextStyle(fontSize: 24,color: Colors.black,fontWeight: FontWeight.w800),)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            Padding(
               padding: EdgeInsets.all(15),
               child:Container(
                 child: Center(
                   child: CachedNetworkImage(
                     imageUrl: imgurl,
                     placeholder: (context, url) => CircularProgressIndicator(
                       valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(55, 0, 60, 1)),
                     ),
                     errorWidget: (context, url, error) => Padding(padding: EdgeInsets.all(20),child: Icon(FontAwesomeIcons.newspaper,size: 50,color: Color.fromRGBO(55, 0, 60, 1),)),
                   ),
                 ),
               ),
            ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('$title',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.black),)

              ),
            author!=null?Padding(
              padding: EdgeInsets.all(15),
              child: Text('$author',style: TextStyle(color: Colors.grey,fontSize: 16),),
            ):Text(' '),
              Padding(
                  padding: EdgeInsets.all(15),
                  child:Text('$description',style: TextStyle(fontSize: 18,color: Colors.black),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}