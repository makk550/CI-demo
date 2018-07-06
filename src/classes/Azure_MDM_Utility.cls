/**************
Created By : merha02
From : AWS_MDM_Utility
*****************/

public class Azure_MDM_Utility {
    
   public static AzureResponse JSONparserSoldTodata(String resbody,String compareType,String BPType,String OppCountryCode,String Salesorg){
            	
       system.debug('---opp country code----'+OppCountryCode);
       system.debug('----sales org ----'+SalesOrg);
       
                AzureResponse AzureOb = new AzureResponse();
                List<SOLDIdData> SOLDIdDataList =new List<SOLDIdData>();
                Map<String,String> JPConstants =new Map<String,String>();
                Set<String> countryCodeHM =SAP_ECC_Utility.countryCodeHM;
                if(OppCountryCode.equalsIgnoreCase('JP')){
                    JPConstants=JPRegionConstants();
                }
                JSONParser parser = JSON.createParser(resbody);
                while (parser.nextToken() != null){
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'executionStatus')) {
                            System.debug('executionStatus');
                            parser.nextToken();
                            parser.nextToken();
                            System.debug(parser.getText());
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                                (parser.getText() == 'status')){
                                    parser.nextToken();
                                    AzureOb.Status=parser.getText();
                                }
                            parser.nextToken();
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                                (parser.getText() == 'description')){
                                    parser.nextToken();
                                    AzureOb.Message=parser.getText();
                                }
                            
                        }
                   if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == compareType)) {
                            parser.nextToken();
                            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {       
                               while (parser.nextToken() != null) {
                                   if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                        SOLDIdData s = (SOLDIdData)parser.readValueAs(SOLDIdData.class);
                                       String idType = getIDType(s.BPType);
                                       if(BPType =='SOLDTO' || (idType != '' && BPType.contains(idType) && s.BPType.contains(Salesorg))){
                                           s.SiteID =String.valueOf(Integer.valueOf(s.SiteID));
                                           s.Country =getCountryFromValue(s.Country);
                                           s.Name = s.Name.unescapeHtml4();
                                           s.Street=s.Street.unescapeHtml4();
                                           s.Street2=s.Street2.unescapeHtml4();
                                           s.City=s.City.unescapeHtml4();
                                           if(OppCountryCode.equalsIgnoreCase('JP')){
                                                   String RegCode ='REGION'+s.State;
                                                   if(JPConstants.containsKey(RegCode)){
                                                       String regionStr = JPConstants.get(RegCode);
                                                       s.State = regionStr.substring(0, regionStr.indexOf('|'));
       	               				    			   s.StateLocal = regionStr.substring(regionStr.indexOf('|')+1, regionStr.length());
                                                   }                 
                                            }
                                           /*if(!String.isBlank(OppCountryCode) && !countryCodeHM.contains(OppCountryCode)){
                                                 s.NameLocal='';
                                                 s.StreetLocal='';
                                                 s.Street2Local='';
                                                 s.CityLocal='';
                                                 s.StateLocal='';
                                            }*/
                                           SOLDIdDataList.add(s);
                                           System.debug(s);
                                       }
                                        
                                   }
                               }
                               AzureOb.SoldToList=SOLDIdDataList;
                            }
                        }
                    
                }
            System.debug('------Azure------'+AzureOb);
            return AzureOb;
         }
       
    public static AzureResponse JSONparserMDMdata(String resbody,String OppCountryCode){
                AzureResponse AzureOb = new AzureResponse();
                List<SOLDIdData> SOLDIdDataList =new List<SOLDIdData>();
           		Set<String> countryCodeHM =SAP_ECC_Utility.countryCodeHM;
           		Map<String,String> JPConstants =new Map<String,String>();
                if(OppCountryCode.equalsIgnoreCase('JP')){
                    JPConstants=JPRegionConstants();
                }
                JSONParser parser = JSON.createParser(resbody);
                while (parser.nextToken() != null){
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'executionStatus')) {
                            System.debug('executionStatus');
                            parser.nextToken();
                            parser.nextToken();
                            System.debug(parser.getText());
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                                (parser.getText() == 'status')){
                                    parser.nextToken();
                                    AzureOb.Status=parser.getText();
                                }
                            parser.nextToken();
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                                (parser.getText() == 'description')){
                                    parser.nextToken();
                                    AzureOb.Message=parser.getText();
                                }
                            
                        }
                   if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'Customer_Details')) {
                            parser.nextToken();
                            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {       
                               while (parser.nextToken() != null) {
                                   if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                        MDMResIdData s = (MDMResIdData)parser.readValueAs(MDMResIdData.class);
                                        String idType = getIDType(s.BPType);
                                        s.SiteID =String.valueOf(Integer.valueOf(s.SiteID));
                                        s.Country =getCountryFromValue(s.Country);
                                        if(OppCountryCode.equalsIgnoreCase('JP')){
                                                   String RegCode ='REGION'+s.State;
                                                   if(JPConstants.containsKey(RegCode)){
                                                       String regionStr = JPConstants.get(RegCode);
                                                       s.State = regionStr.substring(0, regionStr.indexOf('|'));
       	               				    			   s.StateLocal = regionStr.substring(regionStr.indexOf('|')+1, regionStr.length());
                                                   }                 
                                            }
                                       	  SOLDIdData ST = new SOLDIdData();
                                         ST.SiteID =s.SiteID;
                                         //ST.Name=s.Name;
                                       	 ST.Name = s.Name.unescapeHtml4();
                                       	 ST.Name2 = s.Name2.unescapeHtml4();
                                         ST.Street=s.Street.unescapeHtml4();
                                         ST.Street2=s.Street2.unescapeHtml4();
                                         ST.City=s.City.unescapeHtml4();
                                         ST.State=s.State;
                                         ST.Country=s.Country;
                                         ST.Pincode=s.Pincode;
                                         ST.BPType=s.BPType;
                                         
                                         ST.NationInternationalCode=s.NationInternationalCode;
                                       	 if(!String.isBlank(OppCountryCode) && countryCodeHM.contains(OppCountryCode)){
                                                //clear the first and last local details for contacts
                                                //clearlocalDetails();
                                                 ST.NameLocal=s.NameLocal;
                                                 ST.StreetLocal=s.StreetLocal;
                                                 ST.Street2Local=s.Street2Local;
                                                 ST.CityLocal=s.CityLocal;
                                                 ST.StateLocal=s.StateLocal;
                                          }
                                         if(!String.isBlank(s.ABNNumber) && ST.Country =='AU'){
                                               String str1='ABN:';
                                               ST.ABNNumber=str1 + s.ABNNumber;
                                         }else{
                                             ST.ABNNumber ='';
                                         }
                                        SOLDIdDataList.add(ST);
                                       /*if(s.SalesOrg.size() >0 && (s.SalesOrg.size() == s.CompanyCode.size())){
                                          
                                           for(Integer i=0;i<s.SalesOrg.size();i++){
                                               
                                               
                                               ST.CompanyCode=s.CompanyCode[i];
                                               ST.SalesOrg=s.SalesOrg[i];
                                               SOLDIdDataList.add(ST);
                                               
                                           }
                                           
                                       }else{
                                           
                                        }*/
                                       
                                        
                                   }
                               }
                                AzureOb.SoldToList=SOLDIdDataList;
                               System.debug('----'+SOLDIdDataList);
                            }
                        }
                    
                }
            System.debug('AzureOb___'+AzureOb);
            return AzureOb;
         }
    
    public static HttpRequest SiteSearchHttpRequest(String endpoint,String jsonRequest){
        String auth_token = Azure_UtilityClass.Azure_Authrization();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setTimeout(100000);
       	req.setbody(jsonRequest);
        req.setHeader('Authorization','Bearer '+auth_token);
        req.setHeader('Content-Type','application/json');
        
        System.debug(req);
        
        return req;
    }
    
    public String getFullsite(String siteId){
         while (siteId.length() < 10) {
            siteId ='0'+siteId;
        }
        return siteId;
    }
    
    public static String getIDType(String value) {
        String idType = '';
        
        if (value != null && value.contains('BP - Bill-to party')) 
        	idType = 'BILLTO';
        else  if (value != null && value.contains('SH - Ship-to party')) 
        	idType = 'SHIPTO';
        else  if (value != null && value.contains('SP - Sold-to party')) 
        	idType = 'COMSOLDTO';
               
        return idType;
    }
   
    public class AzureResponse{
        public String Message{get;set;}
        public String Status{get;set;}
        public List<SOLDIdData> SoldToList{get;set;}
        //public List<BusinessPartnerData> BPList;
        public AzureResponse(){
            this.SoldToList =  new List<SOLDIdData>();
            this.Message ='';
            this.Status='';
            //this.BPList =  new List<BusinessPartnerData>();
        }
    }
    public class SOLDIdData{
        public String SiteID{get;set;}
        public String Name{get;set;}
        public String Name2{get;set;}		//US467348 - added as part of it - by BAJPI01
        public String Street{get;set;}
        public String Street2{get;set;}
        public String Pincode{get;set;}
        public String City{get;set;}
        public String State{get;set;}
        public String Country{get;set;}
        public String NameLocal{get;set;}
        public String StreetLocal{get;set;}
        public String Street2Local{get;set;}
        public String CityLocal{get;set;}
        public String StateLocal{get;set;}
        public String NationInternationalCode{get;set;}
        public String CompanyCode{get;set;}
        public String SalesOrg{get;set;}
        public String priceList{get;set;}
        public String BPType{get;set;}
        public String ABNNumber{get;set;}
        SOLDIdData(){
            this.Name='';
            this.Name='';
            this.BPType='';
            this.CompanyCode='';
            this.Pincode='';
            this.Street2='';
            this.SalesOrg='';
            this.priceList='';
            this.SiteID='';
            this.NameLocal='';
        	this.StreetLocal='';
        	this.Street2Local='';
        	this.CityLocal='';
            this.StateLocal='';
        	this.NationInternationalCode='';
            this.ABNNumber='';
        }
    }
    
    public class MDMResIdData{
        public String SiteID{get;set;}
        public String Name{get;set;}
        public String Name2{get;set;}
        public String Street{get;set;}
        public String Street2{get;set;}
        public String Pincode{get;set;}
        public String City{get;set;}
        public String State{get;set;}
        public String Country{get;set;}
        public String NameLocal{get;set;}
        public String StreetLocal{get;set;}
        public String Street2Local{get;set;}
        public String CityLocal{get;set;}
        public String StateLocal{get;set;}
        public String NationInternationalCode{get;set;}
        public String ABNNumber{get;set;}
        public List<String> CompanyCode{get;set;}
        public List<String> SalesOrg{get;set;}
        public List<String> priceList{get;set;}
        public String BPType{get;set;}
        public MDMResIdData(){
            this.Name='';
            this.Name2='';
            this.BPType='';
            this.CompanyCode=new List<String>();
            this.Pincode='';
            this.Street2='';
            this.SalesOrg=new List<String>();
            this.priceList=new List<String>();
            this.SiteID='';
            this.NameLocal='';
        	this.StreetLocal='';
        	this.Street2Local='';
        	this.CityLocal='';
            this.StateLocal='';
        	this.NationInternationalCode='';
            this.ABNNumber='';
        }
    }
    
     public static String getCountryFromValue(String value) {
       String country = '';
       if (value != null) {
           Integer commaPos = value.indexOf(',');
           country = value.substring(0,commaPos);
           if (country != null) {
               country = country.trim();
           } else {
               country = '';
           }
       }
       return country;
   }
   
    public static Map<String,String> JPRegionConstants(){
        Map<String,String> RegionConstants = new Map<String,String>();
        RegionConstants.put('REGION1','Hokkaido|\u5317\u6D77\u9053');
        RegionConstants.put('REGION2','Aomori|\u9752\u68EE\u770C');
        RegionConstants.put('REGION3','Iwate|\u5CA9\u624B\u770C');
        RegionConstants.put('REGION4','Miyagi|\u5BAE\u57CE\u770C');
        RegionConstants.put('REGION5','Akita|\u79CB\u7530\u770C');
        RegionConstants.put('REGION6','Yamagata|\u5C71\u5F62\u770C');
        RegionConstants.put('REGION7','Fukushima|\u798F\u5CF6\u770C');
        RegionConstants.put('REGION8','Ibaraki|\u8328\u57CE\u770C');
        RegionConstants.put('REGION9','Tochigi|\u6803\u6728\u770C');
        RegionConstants.put('REGION10','Gunma|\u7FA4\u99AC\u770C');
        RegionConstants.put('REGION11','Saitama|\u57FC\u7389\u770C');
        RegionConstants.put('REGION12','Chiba|\u5343\u8449\u770C');
        RegionConstants.put('REGION13','Tokyo|\u6771\u4EAC\u90FD');
        RegionConstants.put('REGION14','Kanagawa|\u795E\u5948\u5DDD\u770C');
        RegionConstants.put('REGION15','Niigata|\u65B0\u6F5F\u770C');
        RegionConstants.put('REGION16','Toyama|\u5BCC\u5C71\u770C');
        RegionConstants.put('REGION17','Ishikawa|\u77F3\u5DDD\u770C');
        RegionConstants.put('REGION18','Fukui|\u798F\u4E95\u770C');
        RegionConstants.put('REGION19','Yamanashi|\u5C71\u68A8\u770C');
        RegionConstants.put('REGION20','Nagano|\u9577\u91CE\u770C');
        RegionConstants.put('REGION21','Gifu|\u5C90\u961C\u770C');
        RegionConstants.put('REGION22','Shizuoka|\u9759\u5CA1\u770C');
        RegionConstants.put('REGION23','Aichi|\u611B\u77E5\u770C');
        RegionConstants.put('REGION24','Mie|\u4E09\u91CD\u770C');
        RegionConstants.put('REGION25','Shiga|\u6ECB\u8CC0\u770C');
        RegionConstants.put('REGION26','Kyoto|\u4EAC\u90FD\u5E9C');
        RegionConstants.put('REGION27','Osaka|\u5927\u962A');
        RegionConstants.put('REGION28','Hyogo|\u5175\u5EAB\u770C');
        RegionConstants.put('REGION29','Nara|\u5948\u826F\u770C');
        RegionConstants.put('REGION30','Wakayama|\u548C\u6B4C\u5C71\u770C');
        RegionConstants.put('REGION31','Tottori|\u9CE5\u53D6\u770C');
        RegionConstants.put('REGION32','Shimane|\u5CF6\u6839\u770C');
        RegionConstants.put('REGION33','Okayama|\u5CA1\u5C71\u770C');
        RegionConstants.put('REGION34','Hiroshima|\u5E83\u5CF6\u770C');
        RegionConstants.put('REGION35','Yamaguchi|\u5C71\u53E3\u770C');
        RegionConstants.put('REGION36','Tokushima|\u5FB3\u5CF6\u770C');
        RegionConstants.put('REGION37','Kagawa|\u9999\u5DDD\u770C');
        RegionConstants.put('REGION38','Ehime|\u611B\u5A9B\u770C');
        RegionConstants.put('REGION39','Kochi|\u9AD8\u77E5\u770C');
        RegionConstants.put('REGION40','Fukuoka|\u798F\u5CA1\u770C');
        RegionConstants.put('REGION41','Saga|\u4F50\u8CC0\u770C');
        RegionConstants.put('REGION42','Nagasaki|\u9577\u5D0E\u770C');
        RegionConstants.put('REGION43','Kumamoto|\u718A\u672C\u770C');
        RegionConstants.put('REGION44','Oita|\u5927\u5206\u770C');
        RegionConstants.put('REGION45','Miyazaki|\u5BAE\u5D0E\u770C');
        RegionConstants.put('REGION46','Kagoshima|\u9E7F\u5150\u5CF6\u770C');
        RegionConstants.put('REGION47','Okinawa|\u6C96\u7E04\u770C');
        return RegionConstants;
    }

}