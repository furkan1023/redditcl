import 'dart:ffi';

class Comment {
  String id;
  String title;
  String description;
  String author;
  int score;
  String link_flair_text;
  double upvoteRatio;
  int ups;
  int downs;

  Comment({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.upvoteRatio,
    required this.ups,
    required this.downs,
    required this.link_flair_text,
    required this.score
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    
    return Comment(
      title: json['title'].toString(),
      id: json['id'].toString(),
      description: json['selftext'].toString(),
      author: json['author'].toString(),
      upvoteRatio: json['upvote_ratio'],
      ups: json['ups'],
      downs: json['downs'],
      link_flair_text: json['link_flair_text'].toString(),
      score: json['score']
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