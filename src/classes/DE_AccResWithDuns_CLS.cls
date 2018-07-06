public with sharing class DE_AccResWithDuns_CLS implements Comparable {

  public string accId {get;set;}   //SFDC ID   
  public string accName {get;set;}
  public string tradeStyle {get;set;}
  public string city {get;set;}
  public string state {get;set;}
  public string regionName {get; set;}
  public string address {get;set;}
  public string country {get;set;}
  public string countryname {get;set;}
  public string street {get;set;}
  public string zipCode {get;set;}
  public string geo {get;set;}
  public string GPAccNo {get;set;}
  public string GPAccName {get;set;}
  public string salReg {get;set;}
  public string GPSeg {get;set;}
  public string territory {get;set;}
  public string GobUltReg {get;set;}
  public string segment {get;set;}
  public string coverMod {get;set;}
  public string opparea {get;set;}
  public string accDunsNo {get;set;}
  public string sicCode {get;set;}
  public string sicDesc {get;set;}
  public string GPSIC2Digit{get;set;}
  public string GPSIC4Digit{get;set;}
  public string GPIndustry{get;set;}
  public ID GPSIC { get; set; }
        
  public string CAAccountId {get;set;}
  public string accStatus {get;set;}
  public boolean hasAccess {get;set;}
  
  public boolean IsFirstRow {get;set;}
  public string displayseq {get; set;}                  
  
  
  public integer cCode {get;set;}
  public boolean hasBestMatch {get;set;}
  public string hiddenBestMatchName {get;set;}

  public string strChecked {get;set;}
  public string accRecordTypeId {get;set;}
  
  public Integer compareTo(Object ObjToCompare) {
      return city.CompareTo(((DE_AccResWithDuns_CLS)ObjToCompare).city);
  }
  
  public string CAAccountName {get;set;} 

}