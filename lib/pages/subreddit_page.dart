import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:redditcl/pages/homepage.dart';
import 'package:redditcl/states/subredditpage_state.dart';
import 'dart:io';
import '../css/fonts.dart';
import 'postpage.dart';
import '../models/reddit.dart';
import '../states/redditState.dart';
import '../states/settings.dart';

class SubredditPage extends StatefulWidget {
  String pageName;
  SubredditPage(this.pageName);
  @override
  _SubredditPageState createState() => _SubredditPageState(pageName);
}

class _SubredditPageState extends State<SubredditPage> {
  late String pageName;
  var redditState;
  var subredditpageState;

  _SubredditPageState(String pageName) {
    this.pageName = pageName;
  }
  @override
  void initState() {
    redditState = Provider.of<RedditState>(context, listen: false);
    subredditpageState =
        Provider.of<SubredditPageState>(context, listen: false);
    settingsState = Provider.of<Settings>(context, listen: false);
    bool darkMode = settingsState.darkmodeValue;
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
    redditState.disposeState();
    subredditpageState.disposeState();
    print("first" + redditState.weights.length.toString());
    fetchPost(pageName, "hot");
    super.initState();
  }

  @override
  void dispose() {
    print("kapa");
    super.dispose();
  }

  List<RedditPost> postList = [];
  Random random = new Random();

  fetchPost(String page, String type) async {
    try{
      
    postColors = [];
    List<RedditPost> postListTmp = [];
    Response response;
    response = await http
        .get(Uri.parse("https://www.reddit.com/r/$page/$type.json?count=20"));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      Map<String, dynamic> data = map["data"];
      for (int i = 0; i < data["children"].length; i++) {
        Map<String, dynamic> dataChildren = data["children"][i];
        Map<String, dynamic> dataChildrenData = dataChildren["data"];
        postListTmp.add(RedditPost.fromJson(dataChildrenData));
        postColors.add(totalColors[random.nextInt(5)]);
      }
      redditState.setList(postListTmp);
    } else {
      throw Exception('Failed to load photos');
    }
    }catch(e){

    }
  }

  List<Color> totalColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.orange
  ];
  var settingsState;
  void changePage(int index) {
    settingsState.changeNavigator(index);

    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  List<Color> postColors = [];
  String foundedPage = "lol";
  TextEditingController search = TextEditingController();
  late Color textColor;
  late double totalHeight, totalWidth;
  Color appBarColor = Colors.white70;
  late var backgroundcolor;
  late Color backgroundcolor2;
  late Color searchColor;
  var hintColor;
  @override
  Widget build(BuildContext context) {
    totalHeight = MediaQuery.of(context).size.height;
    totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
      backgroundColor: backgroundcolor,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              height: totalHeight * 2 / 10,
              width: totalWidth,
              child: Container(
                height: totalHeight * 2 / 10,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg2.jpg"), fit: BoxFit.fill)),
              )),
          Container(
            height: totalHeight,
            width: totalWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: totalHeight * 0.2 / 10,
                ),
                Container(
                  height: totalHeight * 0.6 / 10,
                  width: totalWidth,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepage()));
                        },
                        child: Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: totalWidth * 8 / 10,
                        height: totalHeight * 0.7 / 10,
                        alignment: Alignment.center,
                        child: TextField(
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              hintText: "Here",
                              prefixIcon: Icon(
                                Icons.search,
                                color: appBarColor,
                              ),
                              fillColor: Colors.black.withOpacity(0.4)),
                          controller: search,
                          onChanged: searchPage,
                          style: TextStyle(color: appBarColor),
                        ),
                      )
                    ],
                  ),
                ),
                Consumer<SubredditPageState>(
                  builder: (context, value, child) {
                    var founded = value.foundedValue;
                    return founded == true
                        ? TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SubredditPage(foundedPage)));
                            },
                            child: Container(
                              height: totalHeight * 0.6 / 10,
                              padding:
                                  EdgeInsets.only(left: totalWidth * 1 / 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.chevron_right,
                                    size: titleSize,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    foundedPage,
                                    style: TextStyle(
                                        fontSize: smallfontSize,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: totalHeight * 0.6 / 10,
                          );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: totalWidth * 0.5 / 10),
                  child: Container(
                    width: totalWidth * 2 / 10,
                    height: totalWidth * 2 / 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(width: 2, color: Colors.grey),
                        image: DecorationImage(
                          image: AssetImage("assets/fluttericon.png"),
                        )),
                  ),
                ),
                SizedBox(
                  height: totalHeight * 0.2 / 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "r/$pageName",
                        style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold,
                            color: textColor),
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
                ),
                Consumer<SubredditPageState>(
                  builder: (context, value, child) {
                    int type = value.typeValue;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              subredditpageState.changeType(1);
                              fetchPost(pageName, "hot");
                            },
                            child: Container(
                              width: totalWidth * 2.5 / 10,
                              height: totalHeight * 0.6 / 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.whatshot,
                                      color:
                                          type != 1 ? textColor : Colors.blue),
                                  Text(
                                    "Hot",
                                    style: TextStyle(
                                        color: type != 1
                                            ? textColor
                                            : Colors.blue),
                                  )
                                ],
                              ),
                            )),
                        TextButton(
                            onPressed: () {
                              subredditpageState.changeType(2);
                              fetchPost(pageName, "new");
                            },
                            child: Container(
                              width: totalWidth * 2.5 / 10,
                              height: totalHeight * 0.6 / 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.wb_sunny,
                                      color:
                                          type != 2 ? textColor : Colors.blue),
                                  Text(
                                    "New",
                                    style: TextStyle(
                                        color: type != 2
                                            ? textColor
                                            : Colors.blue),
                                  )
                                ],
                              ),
                            )),
                        TextButton(
                            onPressed: () {
                              subredditpageState.changeType(3);
                              fetchPost(pageName, "top");
                            },
                            child: Container(
                              width: totalWidth * 2.5 / 10,
                              height: totalHeight * 0.6 / 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_play,
                                      color:
                                          type != 3 ? textColor : Colors.blue),
                                  Text(
                                    "Top",
                                    style: TextStyle(
                                        color: type != 3
                                            ? textColor
                                            : Colors.blue),
                                  )
                                ],
                              ),
                            ))
                      ],
                    );
                  },
                ),
                Consumer<RedditState>(
                  builder: (context, state, child) {
                    var posts = state.posts;
                    print("posts:" + posts.length.toString());
                    print("postColors:" + postColors.length.toString());
                    return Container(
                      width: totalWidth,
                      height: totalHeight * 5 / 10,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          for (int i = 0; i < posts.length; i++)
                            getPost(posts[i], i)
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getPost(RedditPost post, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostPage(post, pageName)));
        },
        child: Container(
            width: totalWidth,
            color: backgroundcolor2,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: post.thumbnail != "self" && post.thumbnail != ""
                          ? (totalWidth * 7 / 10) - 20
                          : totalWidth - 40,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: totalWidth * 1 / 10,
                                height: totalWidth * 1 / 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 2, color: Colors.grey),
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/fluttericon.png"),
                                    )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Posted by u/" + post.author,
                                    style: TextStyle(
                                        fontSize: smallfontSize,
                                        color: Colors.grey[600]),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: postColors[index],
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(post.link_flair_text,
                                        style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: totalHeight * 0.2 / 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: post.thumbnail != "self" &&
                                        post.thumbnail != ""
                                    ? totalWidth * 2.5 / 10
                                    : totalWidth - 40,
                                constraints: BoxConstraints(
                                    maxHeight: totalHeight * 2 / 10),
                                child: Text(
                                  post.title,
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize),
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                          Container(
                              width: post.thumbnail != "self" &&
                                      post.thumbnail != ""
                                  ? (totalWidth * 6 / 10) - 20
                                  : totalWidth - 20,
                              constraints: BoxConstraints(
                                  maxHeight: totalHeight * 2 / 10),
                              child: Text(
                                post.description,
                                style: TextStyle(color: textColor),
                              )),
                        ],
                      ),
                    ),
                    if (post.thumbnail != "self" && post.thumbnail != "")
                      Container(
                        width: (totalWidth * 2.5 / 10),
                        height: totalHeight * 2 / 10,
                        child: Image.network(
                          post.thumbnail,
                          fit: BoxFit.fill,
                        ),
                      )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            redditState.increaseScoreIndex(post);
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
                              redditState.decreaseScoreIndex(post);
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
            )),
      ),
    );
  }

  void searchPage(String text) async {
    try{
      var response = await http.get(Uri.parse("https://www.reddit.com/r/$text"));
    if (response.statusCode == 200 && text != "" && search.text == text) {
      foundedPage = text;
      subredditpageState.foundedEqualsTrue();
    } else {
      subredditpageState.foundedEqualsFalse();
    }
    }catch(e){

    }
  }
}
