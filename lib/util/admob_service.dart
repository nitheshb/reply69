import 'dart:io';
class AdMobService{

  String getAdMobAppId(){
    if(Platform.isIOS) {
      return null;
    }else if (Platform.isAndroid){
      return "ca-app-pub-4168056942187656~5357490113";
    }
    return null;
  }

  String getBannerAdId(){
     if(Platform.isIOS) {
      return null;
    }else if (Platform.isAndroid){
      return "ca-app-pub-4168056942187656/6287428403";
    }
    return null;
  }

}