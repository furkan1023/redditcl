  
import 'package:flutter/foundation.dart';

class Settings with ChangeNotifier {
  bool darkmode=false;
  int bottomNavigator=0;
  darkModeReverseCurrentState(){
    darkmode=!darkmode;
    notifyListeners();
  }
  changeNavigator(int index){
    bottomNavigator=index;
    notifyListeners();
  }
  get darkmodeValue => darkmode;
  get bottomNavigatorValue => bottomNavigator;
  
  

}