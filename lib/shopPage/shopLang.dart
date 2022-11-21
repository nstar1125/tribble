class ShopText{
  String title = "";
  String mainTxt = "";
  String purchaseTxt = "";
  String exchangeTxt = "";
  String peanutTxt = "";
  String suffixTxt = "";
  String currencyTxt = "";
  String pMsgS = "";
  String pMsgF = "";
  String eMsgS = "";
  String eMsgF = "";
  String eBtnTxt = "";

  setKor(){
    title = "땅콩 환전소";
    mainTxt = " 현재 보유한 땅콩: ";
    purchaseTxt = "땅콩 구매";
    exchangeTxt = "땅콩 환전";
    peanutTxt = "땅콩";
    suffixTxt = " 개";
    currencyTxt = " 원";
    pMsgS = "땅콩 구입에 성공하였습니다!";
    pMsgF = "땅콩 구입에 실패하였습니다.";
    eMsgS = "환전에 성공하였습니다!";
    eMsgF = "땅콩이 모자랍니다!";
    eBtnTxt = "환전하기";
  }
  setEng(){
    title = "Peanut Exchange";
    mainTxt = " Current peanuts: ";
    purchaseTxt = "Purchase peanuts";
    exchangeTxt = "Exchange peanuts";
    peanutTxt = "peanuts";
    suffixTxt = "";
    currencyTxt = " WON";
    pMsgS = "Peanut purchase successful!";
    pMsgF = "Failed to purchase peanuts.";
    eMsgS = "Successfully exchanged!";
    eMsgF = "Not enough peanuts!";
    eBtnTxt = "Exchange";
  }
}