import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:redditcl/states/homepage_state.dart';
import 'package:redditcl/states/redditState.dart';
import 'package:redditcl/states/settings.dart';
import 'package:redditcl/states/subredditpage_state.dart';
import 'dart:io';
import 'css/fonts.dart';
import 'pages/homepage.dart';
import 'models/reddit.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => RedditState()),
        ChangeNotifierProvider(create: (_) => SubredditPageState()),
        ChangeNotifierProvider(create: (_) => HomepageState()),
        ChangeNotifierProvider(create: (_) => Settings()),
      ],
      child:MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    )
    );
  }
}
