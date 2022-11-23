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
}