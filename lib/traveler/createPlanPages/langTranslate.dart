class LangTranslate{
  List<String> foodList = [
    "🍽 Meal",
    "🍺 Beer",
    "☕️ Cafe",
    "🏮 Local market",
  ];
  List<String> placeList = [
    "⛰ Landscape",
    "🏯 Traditional place",
    "🛍 Shopping",
    "🪂 Activity",
    "🏟 Sports",
    "🎨 Arts",
    "🎯 Entertainment",
    "🧖 Relax",
    "🚶 Walk",
  ];
  List<String> prefList = [
    "🎎 Only local",
    "🔥 Hot place",
    "📷 Photo spot",
    "🤳 alone",
    "🎈 Young",
    "😌 Leisurely"
  ];
  List<String> foodListk = [
    "🍽 식사",
    "🍺 술",
    "☕️ 카페",
    "🏮 시장",
  ];
  List<String> placeListk = [
    "⛰ 풍경",
    "🏯 전통 장소",
    "🛍 쇼핑",
    "🪂 액티비티",
    "🏟 스포츠",
    "🎨 예술",
    "🎯 유흥/오락",
    "🧖 휴양",
    "🚶 산책",
  ];
  List<String> prefListk = [
    "🎎 현지에서만",
    "🔥 핫플레이스",
    "📷 사진 명소",
    "🤳 혼자서도",
    "🎈 젊음의",
    "😌 여유로운"
  ];
  toEng(String tileStr){
    switch(tileStr){
      case "🍽 식사":
        return foodList[0];
      case "🍺 술":
        return foodList[1];
      case "☕️ 카페":
        return foodList[2];
      case "🏮 시장":
        return foodList[3];
      case "⛰ 풍경":
        return placeList[0];
      case "🏯 전통 장소":
        return placeList[1];
      case "🛍 쇼핑":
        return placeList[2];
      case "🪂 액티비티":
        return placeList[3];
      case "🏟 스포츠":
        return placeList[4];
      case "🎨 예술":
        return placeList[5];
      case "🎯 유흥/오락":
        return placeList[6];
      case "🧖 휴양":
        return placeList[7];
      case "🚶 산책":
        return placeList[8];
      case "🎎 현지에서만":
        return prefList[0];
      case "🔥 핫플레이스":
        return prefList[1];
      case "📷 사진 명소":
        return prefList[2];
      case "🤳 혼자서도":
        return prefList[3];
      case "🎈 젊음의":
        return prefList[4];
      case "😌 여유로운":
        return prefList[5];
    }


  }
  toKor(String tileStr){
    switch(tileStr){
      case "🍽 Meal":
        return foodListk[0];
      case "🍺 Beer":
        return foodListk[1];
      case "☕️ Cafe":
        return foodListk[2];
      case "🏮 Local market":
        return foodListk[3];
      case "⛰ Landscape":
        return placeListk[0];
      case "🏯 Traditional place":
        return placeListk[1];
      case "🛍 Shopping":
        return placeListk[2];
      case "🪂 Activity":
        return placeListk[3];
      case "🏟 Sports":
        return placeListk[4];
      case "🎨 Arts":
        return placeListk[5];
      case "🎯 Entertainment":
        return placeListk[6];
      case "🧖 Relax":
        return placeListk[7];
      case "🚶 Walk":
        return placeListk[8];
      case "🎎 Only local":
        return prefListk[0];
      case "🔥 Hot place":
        return prefListk[1];
      case "📷 Photo spot":
        return prefListk[2];
      case "🤳 alone":
        return prefListk[3];
      case "🎈 Young":
        return prefListk[4];
      case "😌 Leisurely":
        return prefListk[5];
    }


  }
}