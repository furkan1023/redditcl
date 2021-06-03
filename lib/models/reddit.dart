import 'dart:ffi';

class RedditPost {
  String id;
  String title;
  String description;
  String author;
  String thumbnail;
  String url;
  int score;
  String link_flair_text;
  double upvoteRatio;
  int thumbnail_height;
  int thumbnail_width;
  int ups;
  int downs;

  RedditPost({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnail="",
    this.author="",
    this.upvoteRatio=0.0,
    this.ups=0,
    this.downs=0,
    this.link_flair_text="",
    this.score=0,
    this.url="",
    this.thumbnail_height=0,
    this.thumbnail_width=0
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    
    return RedditPost(
      title: json['title'].toString(),
      id: json['id'].toString(),
      thumbnail: json['thumbnail'].toString(),
      description: json['selftext'].toString(),
      author: json['author'].toString(),
      upvoteRatio: json['upvote_ratio']==null?0.0:json['upvote_ratio'],
      ups: json['ups']==null?0:json['ups'],
      downs: json['downs']==null?0:json['downs'],
      link_flair_text: json['link_flair_text'].toString(),
      score: json['score']==null?0:json['score'],
      url: json['url'].toString(),
      thumbnail_height: json['thumbnail_height']==null?0:json['thumbnail_height'],
      thumbnail_width: json['thumbnail_width']==null?0:json['thumbnail_width'],
    );
  }
    String getTitle(){
    return title;
  }
  increaseScore(){
    this.ups+=1;
    this.score+=1;
  }
  decreaseScore(){
    this.ups-=1;
    this.score-=1;
  }
}