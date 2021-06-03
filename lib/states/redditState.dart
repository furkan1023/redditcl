  
import 'package:flutter/foundation.dart';
import '../models/reddit.dart';

class RedditState with ChangeNotifier {
  List<RedditPost> posts=[];

  List<RedditPost> get weights => posts;
  RedditPost redditWhere(int index){
    try{
      return posts[index];
    }catch(e){
      return new RedditPost(id:"None",description: "None",title: "None");
    }
  }

  setList(List<RedditPost> list) {
    posts=list;
    notifyListeners();
  }
  increaseScoreIndex(RedditPost post) {
    posts.singleWhere((element) => element==post).increaseScore();
    notifyListeners();
  }
  decreaseScoreIndex(RedditPost post) {
    posts.singleWhere((element) => element==post).decreaseScore();
    notifyListeners();
  }
  disposeState(){
    posts=[];
  }
}