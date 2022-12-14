class LangTranslate{
  List<String> foodList = [
    "๐ฝ Meal",
    "๐บ Beer",
    "โ๏ธ Cafe",
    "๐ฎ Local market",
  ];
  List<String> placeList = [
    "โฐ Landscape",
    "๐ฏ Traditional place",
    "๐ Shopping",
    "๐ช Activity",
    "๐ Sports",
    "๐จ Arts",
    "๐ฏ Entertainment",
    "๐ง Relax",
    "๐ถ Walk",
  ];
  List<String> prefList = [
    "๐ Only local",
    "๐ฅ Hot place",
    "๐ท Photo spot",
    "๐คณ alone",
    "๐ Young",
    "๐ Leisurely"
  ];
  List<String> foodListk = [
    "๐ฝ ์์ฌ",
    "๐บ ์ ",
    "โ๏ธ ์นดํ",
    "๐ฎ ์์ฅ",
  ];
  List<String> placeListk = [
    "โฐ ํ๊ฒฝ",
    "๐ฏ ์ ํต ์ฅ์",
    "๐ ์ผํ",
    "๐ช ์กํฐ๋นํฐ",
    "๐ ์คํฌ์ธ ",
    "๐จ ์์ ",
    "๐ฏ ์ ํฅ/์ค๋ฝ",
    "๐ง ํด์",
    "๐ถ ์ฐ์ฑ",
  ];
  List<String> prefListk = [
    "๐ ํ์ง์์๋ง",
    "๐ฅ ํซํ๋ ์ด์ค",
    "๐ท ์ฌ์ง ๋ช์",
    "๐คณ ํผ์์๋",
    "๐ ์ ์์",
    "๐ ์ฌ์ ๋ก์ด"
  ];
  toEng(String tileStr){
    switch(tileStr){
      case "๐ฝ ์์ฌ":
        return foodList[0];
      case "๐บ ์ ":
        return foodList[1];
      case "โ๏ธ ์นดํ":
        return foodList[2];
      case "๐ฎ ์์ฅ":
        return foodList[3];
      case "โฐ ํ๊ฒฝ":
        return placeList[0];
      case "๐ฏ ์ ํต ์ฅ์":
        return placeList[1];
      case "๐ ์ผํ":
        return placeList[2];
      case "๐ช ์กํฐ๋นํฐ":
        return placeList[3];
      case "๐ ์คํฌ์ธ ":
        return placeList[4];
      case "๐จ ์์ ":
        return placeList[5];
      case "๐ฏ ์ ํฅ/์ค๋ฝ":
        return placeList[6];
      case "๐ง ํด์":
        return placeList[7];
      case "๐ถ ์ฐ์ฑ":
        return placeList[8];
      case "๐ ํ์ง์์๋ง":
        return prefList[0];
      case "๐ฅ ํซํ๋ ์ด์ค":
        return prefList[1];
      case "๐ท ์ฌ์ง ๋ช์":
        return prefList[2];
      case "๐คณ ํผ์์๋":
        return prefList[3];
      case "๐ ์ ์์":
        return prefList[4];
      case "๐ ์ฌ์ ๋ก์ด":
        return prefList[5];
    }


  }
  toKor(String tileStr){
    switch(tileStr){
      case "๐ฝ Meal":
        return foodListk[0];
      case "๐บ Beer":
        return foodListk[1];
      case "โ๏ธ Cafe":
        return foodListk[2];
      case "๐ฎ Local market":
        return foodListk[3];
      case "โฐ Landscape":
        return placeListk[0];
      case "๐ฏ Traditional place":
        return placeListk[1];
      case "๐ Shopping":
        return placeListk[2];
      case "๐ช Activity":
        return placeListk[3];
      case "๐ Sports":
        return placeListk[4];
      case "๐จ Arts":
        return placeListk[5];
      case "๐ฏ Entertainment":
        return placeListk[6];
      case "๐ง Relax":
        return placeListk[7];
      case "๐ถ Walk":
        return placeListk[8];
      case "๐ Only local":
        return prefListk[0];
      case "๐ฅ Hot place":
        return prefListk[1];
      case "๐ท Photo spot":
        return prefListk[2];
      case "๐คณ alone":
        return prefListk[3];
      case "๐ Young":
        return prefListk[4];
      case "๐ Leisurely":
        return prefListk[5];
    }


  }
}