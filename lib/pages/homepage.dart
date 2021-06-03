import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:redditcl/pages/subreddit_page.dart';
import 'dart:io';
import '../css/fonts.dart';
import '../models/reddit.dart';
import '../states/homepage_state.dart';
import '../states/settings.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {

  TextEditingController search = TextEditingController();
  late AnimationController _controller;
  String foundedPage = "lol";
  late Animation _welcomeTextAnimation;
  late Animation _text2Animation;
  var homepageState;
  var settingsState;
  late Color textColor;
  late Color bgColor;
  late Color searchColor;
  var hintColor;
  bool darkMode = false;
  late double totalHeight, totalWidth;
  void changePage(int index) {
    settingsState.changeNavigator(index);
  }

  @override
  Widget build(BuildContext context) {
    totalHeight = MediaQuery.of(context).size.height;
    totalWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
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
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Positioned(
                  right: totalWidth * 0.3 / 10,
                  child: TextButton(
                    onPressed: () {
                      settingsState.darkModeReverseCurrentState();
                      setState(() {
                        darkMode = !darkMode;
                        changeColor(darkMode);
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Dark Mode",
                          style:
                              TextStyle(color: textColor, fontSize: fontSize),
                        ),
                        SizedBox(width:10),
                        Container(
                            width: totalWidth * 1 / 10,
                            height: totalHeight * 1.5 / 10,
                            child: CupertinoSwitch(
                              value: darkMode,
                              onChanged: (bool value) {
                                settingsState.darkModeReverseCurrentState();
                                setState(() {
                                  darkMode = value;
                                  changeColor(value);
                                });
                              },
                            ))
                      ],
                    ),
                  )),
              Container(
                width: totalWidth,
                height: totalHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      width: totalWidth * 6 / 10,
                      height: totalHeight * 1.5 / 10,
                      image: AssetImage("assets/reddit3.png"),
                    ),
                    Center(
                      child: Opacity(
                        opacity: _welcomeTextAnimation.value,
                        child: Text(
                          "Welcome",
                          style: TextStyle(
                              color: textColor,
                              fontSize: bigTitleSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Billabong'),
                        ),
                      ),
                    ),
                    Center(
                      child: Opacity(
                        opacity: _text2Animation.value,
                        child: Text(
                          "What were you looking for ?",
                          style: TextStyle(
                              color: textColor,
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Billabong'),
                        ),
                      ),
                    ),
                    TextField(
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
                          hintStyle: TextStyle(color: hintColor),
                          hintText: "Here",
                          suffixIcon: Icon(
                            Icons.search,
                            color: textColor,
                          ),
                          fillColor: searchColor),
                      controller: search,
                      onChanged: searchPage,
                      style: TextStyle(color: textColor),
                    ),
                    Consumer<HomepageState>(
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
                                  height: totalHeight * 0.7 / 10,
                                  padding: EdgeInsets.only(left: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.chevron_right,
                                        size: titleSize,
                                        color: textColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        foundedPage,
                                        style: TextStyle(
                                            fontSize: titleSize,
                                            color: textColor),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Text("");
                      },
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  changeColor(bool darkmode) {
    print(darkmode);
    if (darkmode == true) {
      textColor = Colors.white;
      bgColor = Colors.black;
      searchColor = Colors.black;
      hintColor = Colors.white54;
    } else {
      textColor = Colors.black;
      bgColor = Colors.white;
      searchColor = Colors.white70;
      hintColor = Colors.grey[800];
    }
  }

  void searchPage(String text) async {
    try{
      
    var response = await http.get(Uri.parse("https://www.reddit.com/r/$text"));
    if (response.statusCode == 200 && text != "" && search.text == text) {
      foundedPage = text;
      homepageState.foundedEqualsTrue();
    } else {
      homepageState.foundedEqualsFalse();
    }
    }catch(e){

    }
  }

  @override
  void initState() {
    homepageState = Provider.of<HomepageState>(context, listen: false);
    settingsState = Provider.of<Settings>(context, listen: false);
    darkMode=settingsState.darkmodeValue;
    changeColor(settingsState.darkmodeValue);
    homepageState.disposeState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _welcomeTextAnimation = Tween(begin: 0.3, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0, 1.0, curve: Curves.easeOut)));
    _text2Animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0, 1.0, curve: Curves.easeOut)));
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }
}
