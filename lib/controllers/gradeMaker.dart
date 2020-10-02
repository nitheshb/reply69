extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

followerGrades(followersCount) async {
  try {

    if(followersCount <101){
      return "Mentor-${superPush(0, followersCount)}";
    }else if(followersCount <1001){
      return "Guru-${superPush(100, followersCount)}";
    }else if(followersCount <10001){
      return "Master ${subGradeFetch(1000, followersCount)}";
    }else if(followersCount <20001){
      return "Grand Master ${subGradeFetch(10000, followersCount)}";
    }else if(followersCount <30001){
      return "Commander ${subGradeFetch(20000, followersCount)}";
    }else if(followersCount >40001){
      return "Ace ${subGradeFetch(30000, followersCount)}";
    }else{
      return "True Skill";
    }

  }catch(e) {
    return 'chek';
    print('error at ${e}');
  }
}
superPush(homeCount, actualCount){
  if(actualCount < homeCount+100 ){
    return "V";
  }else if(actualCount < homeCount+300 ){
    return "IV";
  }
  else if(actualCount < homeCount+500 ){
    return "III";
  }
  else if(actualCount < homeCount+700 ){
    return "II";
  }
  else if(actualCount < homeCount+1000 ){
    return "I";
  }
}
subGradeFetch(homeCount, actualCount){
  if(actualCount < homeCount+1000 ){
    return "V";
  }else if(actualCount < homeCount+3000 ){
    return "IV";
  }
  else if(actualCount < homeCount+5000 ){
    return "III";
  }
  else if(actualCount < homeCount+7000 ){
    return "II";
  }
  else if(actualCount < homeCount+10000 ){
    return "I";
  }
}