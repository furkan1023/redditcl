import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../css/fonts.dart';
import 'homepage.dart';
import '../models/reddit.dart';
import '../states/settings.dart';

class PostPage extends StatefulWidget {
  RedditPost post;
  String pagename;
  PostPage(this.post, this.pagename);

  @override
  _PostPageState createState() => _PostPageState(post, pagename);
}

class _PostPageState extends State<PostPage> {
  late RedditPost post;
  late String pagename;
  _PostPageState(RedditPost post, String pagename) {
    this.post = post;
    this.pagename = pagename;
    //getPost();
  }
  var settingsState;
  @override
  void initState() {
    settingsState = Provider.of<Settings>(context, listen: false);
    bool darkMode = settingsState.darkmodeValue;
    print(post.thumbnail_width);
    print(post.thumbnail_height);
    if (darkMode == true) {
      textColor = Colors.white;
      backgroundcolor = Colors.black;
      searchColor = Colors.black;
      hintColor = Colors.white54;
      backgroundcolor2 = Color.fromRGBO(56, 56, 56, 0.4);
    } else {
      textColor = Colors.black;
      backgroundcolor = Colors.grey[300];
      searchColor = Colors.white70;
      hintColor = Colors.grey[800];
      backgroundcolor2 = Colors.white;
    }
  }

  void changePage(int index) {
    settingsState.changeNavigator(index);
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  List<Color> totalColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.orange
  ];
  List<RedditPost> commentList = [];
  Color textColor = Colors.black;
  Random random = new Random();
  late double totalHeight, totalWidth;
  Color appBarColor = Colors.white70;
  var backgroundcolor;
  late Color backgroundcolor2;
  var searchColor;
  var hintColor;
  @override
  Widget build(BuildContext context) {
    totalHeight = MediaQuery.of(context).size.height;
    totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundcolor2,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: textColor),
        primary: true,
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Consumer<Settings>(
        builder: (context, value, child) {
          int selectedIndex = value.bottomNavigatorValue;
          return BottomNavigationBar(
            backgroundColor: Colors.transparent,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
            currentIndex: selectedIndex,
            onTap: changePage,
            selectedItemColor: Colors.red,
            unselectedItemColor: textColor,
          );
        },
      ),
      body: Container(
        width: totalWidth,
        height: totalHeight,
        color: backgroundcolor,
        child: ListView(
          children: [
            Container(
              color: backgroundcolor2,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: totalWidth * 1 / 10,
                        height: totalWidth * 1 / 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(width: 2, color: Colors.grey),
                            image: DecorationImage(
                              image: AssetImage("assets/fluttericon.png"),
                            )),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: totalWidth * 5.5 / 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "r/" + pagename,
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                            Text(
                              "Posted by u/" + post.author,
                              style: TextStyle(
                                  fontSize: smallfontSize,
                                  color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          width: totalWidth * 2 / 10,
                          height: totalHeight * 0.5 / 10,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(19)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Text(
                      post.title,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: titleSize),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: totalWidth * 4 / 10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: totalColors[random.nextInt(5)],
                        borderRadius: BorderRadius.circular(19)),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Text(post.link_flair_text,
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  if (post.thumbnail != "" && post.thumbnail != "self")
                    Container(
                      width: post.thumbnail_width.toDouble(),
                      height: post.thumbnail_height.toDouble(),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(post.thumbnail),
                              fit: BoxFit.fill)),
                    ),
                  Container(
                    child: Text(
                      post.description,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                post.score++;
                                post.ups++;
                              });
                            },
                            child: Icon(
                              Icons.arrow_upward,
                              color: textColor,
                            ),
                          ),
                          Text(
                            post.score.toString(),
                            style: TextStyle(color: textColor),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  post.score--;
                                  post.ups--;
                                });
                              },
                              child: Icon(
                                Icons.arrow_downward,
                                color: textColor,
                              )),
                        ],
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.comment,
                                color: textColor,
                              ),
                            ],
                          )),
                      TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: textColor,
                              ),
                              Text(
                                "Share",
                                style: TextStyle(color: textColor),
                              )
                            ],
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
