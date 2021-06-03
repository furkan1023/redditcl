  
import 'package:flutter/foundation.dart';

class SubredditPageState with ChangeNotifier {
  bool founded=false;
  int type=1; 

  foundedEqualsTrue(){
    founded=true;
    notifyListeners();
  }
  foundedEqualsFalse(){
    founded=false;
    notifyListeners();
  }
  changeType(int type) {
    this.type=type;
    notifyListeners();
  }
  disposeState(){
    founded=false;
    type=1;
  }
  get typeValue => type;
  get foundedValue => founded;

}