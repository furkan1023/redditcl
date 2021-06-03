  
import 'package:flutter/foundation.dart';

class HomepageState with ChangeNotifier {
  bool founded=false;
  int bottomNavigator=0;
  foundedEqualsTrue(){
    founded=true;
    notifyListeners();
  }
  foundedEqualsFalse(){
    founded=false;
    notifyListeners();
  }
  get foundedValue => founded;
  
  disposeState(){
    founded=false;
  }

}