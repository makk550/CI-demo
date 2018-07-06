/**
*Description : Generates a report in Excel format based up on the filter criteria   
*Developed By:  sarad03
*/

public class PRM_PartnerEcosystem  {


public string SearchAccountStatus{get;set;}  
 public string SearchSecondaryAccountType{get;set;} 
  public Date SearchTechnologyPartnerEffectiveDateFrom{get;set;} 
    public Date SearchTechnologyPartnerEffectiveDate{get;set;} 
    
   public String SearchTechnologyPartnerEffectiveDateFrom1{get;set;} 
   public String SearchTechnologyPartnerEffectiveDate1{get;set;} 
String accstatus = '' ;
String SecAcc= '' ;
String dfrom= '' ;
String dto= '' ;
        public PRM_PartnerEcosystem(ApexPages.StandardController controller) {
        accstatus =  Apexpages.currentPage().getParameters().get('accstatus');
        SecAcc =    Apexpages.currentPage().getParameters().get('SecAcc');
        dfrom =   Apexpages.currentPage().getParameters().get('dfrom');
        dto = Apexpages.currentPage().getParameters().get('dto');
    Go();
    
                }
//getting the records based upon the filter
public void Go() {
       wrapperacccon = new   List<ProductAlignmentdetails>();  
       
       SearchAccountStatus = accstatus ;
       
       SearchSecondaryAccountType = SecAcc ;
     if(SearchAccountStatus == '-- None ---' ){
    SearchAccountStatus = null ;
    
    }
    if(SearchSecondaryAccountType == '-- None ---' ) {
    SearchSecondaryAccountType = null ;
    }


    if(Apexpages.currentPage().getParameters().get('dfrom') != null  ){
   
    try{
          SearchTechnologyPartnerEffectiveDateFrom = date.ValueOf(dfrom); 
          }catch(Exception e){
          SearchTechnologyPartnerEffectiveDateFrom = null ;
          }
   }
 if(Apexpages.currentPage().getParameters().get('dto') != null  ){
  
    try{
          SearchTechnologyPartnerEffectiveDateFrom = date.ValueOf(dto); 
          }catch(Exception e){
          SearchTechnologyPartnerEffectiveDate = null ;
          }
   }

 
  if(SearchTechnologyPartnerEffectiveDateFrom != null){
          if(SearchTechnologyPartnerEffectiveDate == null){
          SearchTechnologyPartnerEffectiveDate = System.today();
          String str = String.valueOf(System.today());
       //  SearchTechnologyPartnerEffectiveDate1 =  str.subString(8,10)+'/'+str.subString(5,7)+'/'+str.subString(0,4);
          }
  
      }
      
       if(SearchTechnologyPartnerEffectiveDateFrom == null){
          if(SearchTechnologyPartnerEffectiveDate != null){
          SearchTechnologyPartnerEffectiveDate = null ;
         
          }
  
      }
      system.debug('************'+SearchAccountStatus);
      
            system.debug('************'+SearchSecondaryAccountType);
            
                  system.debug('************'+SearchTechnologyPartnerEffectiveDateFrom);
                  
                        system.debug('************'+SearchTechnologyPartnerEffectiveDate);
      
      
      
     List<Product_Alignment__c> pra ;
     if(SearchSecondaryAccountType !=null && SearchTechnologyPartnerEffectiveDate !=null && SearchAccountStatus != null && SearchTechnologyPartnerEffectiveDateFrom != null)
     {
          if(SearchAccountStatus == 'Terminated'){
           
            pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.Technology_Partner_Effective_Date__c <=:SearchTechnologyPartnerEffectiveDate AND Related_Account__r.Technology_Partner_Effective_Date__c >=:SearchTechnologyPartnerEffectiveDateFrom AND Related_Account__r.Account_Status__c = :SearchAccountStatus AND Related_Account__r.Secondary_Account_Type__c  includes (:SearchSecondaryAccountType)];
         }else{
       
            pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.IsPartner =: true AND  Related_Account__r.Technology_Partner_Effective_Date__c <=:SearchTechnologyPartnerEffectiveDate AND Related_Account__r.Technology_Partner_Effective_Date__c >=:SearchTechnologyPartnerEffectiveDateFrom AND Related_Account__r.Account_Status__c = :SearchAccountStatus AND Related_Account__r.Secondary_Account_Type__c  includes (:SearchSecondaryAccountType)];
        
            }     
      }
      if (SearchSecondaryAccountType ==null && SearchTechnologyPartnerEffectiveDate == null && SearchAccountStatus == null && SearchTechnologyPartnerEffectiveDateFrom == null){
           pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.IsPartner =: true ORDER By Related_Account__r.Name DESC];
         }
      if(SearchTechnologyPartnerEffectiveDate != null && SearchAccountStatus != null && SearchTechnologyPartnerEffectiveDateFrom !=null && SearchSecondaryAccountType == null) {
          if(SearchAccountStatus == 'Terminated'){
          
              pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND  Related_Account__r.Technology_Partner_Effective_Date__c <=:SearchTechnologyPartnerEffectiveDate AND Related_Account__r.Technology_Partner_Effective_Date__c >=:SearchTechnologyPartnerEffectiveDateFrom AND  Related_Account__r.Account_Status__c = :SearchAccountStatus ];          
          }else{
         
               pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.IsPartner =: true AND  Related_Account__r.Technology_Partner_Effective_Date__c <=:SearchTechnologyPartnerEffectiveDate AND Related_Account__r.Technology_Partner_Effective_Date__c >=:SearchTechnologyPartnerEffectiveDateFrom AND  Related_Account__r.Account_Status__c = :SearchAccountStatus ];
         }
      }
      if(SearchSecondaryAccountType !=null && SearchAccountStatus != null && SearchTechnologyPartnerEffectiveDate == null && SearchTechnologyPartnerEffectiveDateFrom == null)
             {    
              if(SearchAccountStatus == 'Terminated'){    
                  
                   pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.Account_Status__c = :SearchAccountStatus AND Related_Account__r.Secondary_Account_Type__c  includes (:SearchSecondaryAccountType)];
                  }else{
                  
                   pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.IsPartner =: true AND Related_Account__r.Account_Status__c = :SearchAccountStatus AND Related_Account__r.Secondary_Account_Type__c  includes (:SearchSecondaryAccountType)];
                }
    
      }
      if(SearchSecondaryAccountType !=null && SearchTechnologyPartnerEffectiveDate != null && SearchTechnologyPartnerEffectiveDateFrom != null && SearchAccountStatus == null )
     {
          
         pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.IsPartner =: true AND  Related_Account__r.Technology_Partner_Effective_Date__c <=:SearchTechnologyPartnerEffectiveDate AND Related_Account__r.Technology_Partner_Effective_Date__c >=:SearchTechnologyPartnerEffectiveDateFrom AND Related_Account__r.Secondary_Account_Type__c  includes (:SearchSecondaryAccountType)];
      }
      if(SearchSecondaryAccountType !=null && SearchAccountStatus == null && SearchTechnologyPartnerEffectiveDate == null && SearchTechnologyPartnerEffectiveDateFrom == null)
       {
           pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.IsPartner =: true AND Related_Account__r.Secondary_Account_Type__c  includes (:SearchSecondaryAccountType)  ];
      }
      if(SearchSecondaryAccountType ==null && SearchAccountStatus != null && SearchTechnologyPartnerEffectiveDate == null && SearchTechnologyPartnerEffectiveDateFrom == null )
             {    
                  if(SearchAccountStatus == 'Terminated'){   
                           pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.Account_Status__c = :SearchAccountStatus ];

                    }else{
                            pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.IsPartner =: true AND Related_Account__r.Account_Status__c = :SearchAccountStatus ]; 
                    }



      }
      if(SearchSecondaryAccountType ==null && SearchAccountStatus == null && SearchTechnologyPartnerEffectiveDate != null && SearchTechnologyPartnerEffectiveDateFrom != null){
     
           pra= [SELECT Id,name,Related_Account__c,Notes__c,Related_Account__r.Account_Status__c, Related_Account__r.Owner.Name,Related_Account__r.Completion_of_DLA__c,BU__c,Related_Account__r.Secondary_Account_Type__c,Related_Account__r.Completion_of_NDA__c,Product__r.Name,Related_Account__r.Program_Level_techpartner__c,Related_Account__r.Technology_Partner_Effective_Date__c,Related_Account__r.Technology_Partner_Renewal_Amount__c,Related_Account__r.Name FROM Product_Alignment__c where Related_Account__r.recordType.Name='Technology Partner' AND Product__c =: null AND Related_Account__r.IsPartner =: true AND Related_Account__r.Technology_Partner_Effective_Date__c >=: SearchTechnologyPartnerEffectiveDateFrom  AND Related_Account__r.Technology_Partner_Effective_Date__c <=: SearchTechnologyPartnerEffectiveDate  ];    
      
      }
      
 Map<Id,ProductAlignmentdetails> m = new Map<Id,ProductAlignmentdetails>();
TotalCAProducts = 0;
TotalMAINFRAME = 0;
TotalSEC = 0;
TotalVSA = 0;
TotalCloud = 0;
TotalServiceAssurance = 0;
TotalServicePortfolioManagement  = 0 ;
TotalNimsoft = 0;
TotalSaaS = 0;
TotalStorage = 0;
TotalDLA = 0;
TotalInboundOEM = 0;
TotalOutboundOEM = 0;
TotalOutboundResale = 0 ;
TotalInboundResale = 0;
TotalCATechPartnerProgram = 0;
TotalPartnerTechPartnerProgram  = 0;
TotalAllianceAgreement = 0;
TotalMarketingAgreement = 0;

 for (Product_Alignment__c pa: pra)
     {
    
     ProductAlignmentdetails wrapval = m.get(pa.Related_Account__c); 
     if(wrapval == null)
         wrapval  = new ProductAlignmentdetails ();
        wrapval.AccountName  = pa.Related_Account__r.Name ;
        wrapval.NDA  = pa.Related_Account__r.Completion_of_NDA__c ;
        
        
         if(pa.Related_Account__r.Program_Level_techpartner__c == null){
            if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Strategic Alliance') ){
                 wrapval.PartnerLevel = 'Strategic' ;
                 }
        }else{
       wrapval.PartnerLevel = pa.Related_Account__r.Program_Level_techpartner__c ;
          }
        
     
  
       wrapval.PartnerManager = pa.Related_Account__r.Owner.Name ;
 
    
    
    String s =String.valueOf(pa.Related_Account__r.Technology_Partner_Effective_Date__c);
    if(s != null){
   
     String Total = s.subString(5,7)+'/'+s.subString(8,10)+'/'+s.subString(0,4);
    wrapval.AgreementDate=Total ;
  
    
    }
    
    
       wrapval.RenewalFee = pa.Related_Account__r.Technology_Partner_Renewal_Amount__c;
      
        if(pa.BU__c == 'MAINFRAME' ){
                wrapval.MAINFRAME = 'x' ; 
            
        }else if(pa.BU__c == 'SEC' ){
             
                wrapval.SEC = 'x' ; 
        }else if(pa.BU__c == 'VSA' ){
                wrapval.VSA = 'x' ; 
             
        }else if(pa.BU__c == 'OTHER' ){
        
               if(pa.Notes__c == 'Cloud CSU' ){
                wrapval.Cloud = 'x' ; 
              
               }else if(pa.Notes__c == 'CA Products' ){
                        wrapval.CAProducts = 'x' ; 
                     
                }else if(pa.Notes__c == 'Nimsoft'){
                    wrapval.Nimsoft = 'x' ; 
                 
                }else if(pa.Notes__c == 'SaaS'){
                    wrapval.SaaS = 'x' ; 
                  
                }
        }else if(pa.BU__c == 'SA' ){
                wrapval.ServiceAssurance = 'x' ; 
             
        }else if(pa.BU__c == 'PPM' ){
                wrapval.ServicePortfolioManagement  = 'x' ; 
             
        }else if(pa.BU__c == 'RMDM' ){
                wrapval.Storage = 'x' ; 
            
        }
        String myString2 = 'Technology Partner Program;';
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('DLA') ){
                wrapval.DLA = 'x' ;
          
               
        }
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Inbound OEM') ){
                wrapval.InboundOEM = 'x' ; 
             
        }
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Outbound OEM')){
                wrapval.OutboundOEM = 'x' ; 
             
        }
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Inbound Reseller') ){
                wrapval.InboundResale = 'x' ; 
             
        }
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Outbound Reseller') ){
                wrapval.OutboundResale = 'x' ; 
          
        }
       
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Technology Partner Program') ){
       // }else if(pa.Related_Account__r.Secondary_Account_Type__c == myString2 ){
                wrapval.CATechPartnerProgram = 'x' ; 
              
        }
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Partner\'s Tech Program') ){
                wrapval.PartnerTechPartnerProgram  = 'x' ; 
              
        }
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Alliance Agreement') ){
                wrapval.AllianceAgreement = 'x' ; 
             
        }
        if(pa.Related_Account__r.Secondary_Account_Type__c.contains('Marketing Agreement') ){
                wrapval.MarketingAgreement = 'x' ; 
             
        }
        
        m.put(pa.Related_Account__c,wrapval);
         
       }    
   
    wrapperacccon =  m.values();
 for(ProductAlignmentdetails s : wrapperacccon ){
       if(s.CAProducts == 'x'){
       TotalCAProducts = TotalCAProducts  + 1;
       
       }
       if(s.MAINFRAME == 'x'){
       TotalMAINFRAME = TotalMAINFRAME  + 1;
       
       }
       if(s.SEC == 'x'){
       TotalSEC = TotalSEC  + 1;
       
       }
       if(s.VSA == 'x'){
       TotalVSA = TotalVSA  + 1;
       
       }
       if(s.Cloud == 'x'){
       TotalCloud = TotalCloud  + 1;
       
       }
       if(s.ServiceAssurance == 'x'){
       TotalServiceAssurance = TotalServiceAssurance  + 1;
       
       }
       if(s.ServicePortfolioManagement == 'x'){
       TotalServicePortfolioManagement = TotalServicePortfolioManagement  + 1;
       
       }
       if(s.Nimsoft == 'x'){
       TotalNimsoft = TotalNimsoft  + 1;
       
       }
       if(s.SaaS == 'x'){
       TotalSaaS = TotalSaaS + 1;
       
       }
       if(s.Storage == 'x'){
       TotalStorage = TotalStorage  + 1;
       
       }
       if(s.DLA == 'x'){
       TotalDLA = TotalDLA  + 1;
       
       }
       if(s.InboundOEM == 'x'){
       TotalInboundOEM = TotalInboundOEM  + 1;
       
       }
       if(s.OutboundOEM == 'x'){
       TotalOutboundOEM = TotalOutboundOEM  + 1;
       
       }
       if(s.OutboundResale == 'x'){
       TotalOutboundResale = TotalOutboundResale  + 1;
       
       }
       if(s.InboundResale == 'x'){
       TotalInboundResale = TotalInboundResale  + 1;
       
       }
       if(s.CATechPartnerProgram == 'x'){
       TotalCATechPartnerProgram = TotalCATechPartnerProgram  + 1;
       
       }
       
       if(s.PartnerTechPartnerProgram == 'x'){
       TotalPartnerTechPartnerProgram = TotalPartnerTechPartnerProgram  + 1;
       
       }
       if(s.AllianceAgreement == 'x'){
       TotalAllianceAgreement = TotalAllianceAgreement  + 1;
       
       }
 if(s.MarketingAgreement == 'x'){
       TotalMarketingAgreement = TotalMarketingAgreement  + 1;
       
       }

   
   }
               
           
            }


public Integer   TotalCAProducts {set;get;}
public String TotalCAProducts123 {set;get;}
public Integer   TotalMAINFRAME {set;get;}
public Integer   TotalSEC {set;get;}
public Integer   TotalVSA {set;get;}
public Integer   TotalCloud {set;get;}
public Integer   TotalServiceAssurance {set;get;}

public Integer   TotalServicePortfolioManagement  {set;get;}
public Integer   TotalNimsoft {set;get;}
public Integer   TotalSaaS {set;get;}
public Integer   TotalStorage {set;get;}
public Integer   TotalDLA {set;get;}


public Integer   TotalInboundOEM {set;get;}
public Integer   TotalOutboundOEM {set;get;}

public Integer   TotalOutboundResale {set;get;}
public Integer   TotalInboundResale {set;get;}

public Integer   TotalCATechPartnerProgram {set;get;}

public Integer   TotalPartnerTechPartnerProgram  {set;get;}

public Integer   TotalAllianceAgreement {set;get;}
public Integer   TotalMarketingAgreement {set;get;}









 
 
   public List<ProductAlignmentdetails> wrapperacccon {set;get;}
  public class ProductAlignmentdetails {
   public id ID{set;get;}
         public String AccountName  {set;get;}
         
     
public String   CAProducts {set;get;}
public String   MAINFRAME {set;get;}
public String   SEC {set;get;}
public String   VSA {set;get;}
public String   Cloud {set;get;}
public String   ServiceAssurance {set;get;}

public String   ServicePortfolioManagement  {set;get;}
public String   Nimsoft {set;get;}
public String   SaaS {set;get;}
public String   Storage {set;get;}
public String   DLA {set;get;}


public String   InboundOEM {set;get;}
public String   OutboundOEM {set;get;}

public String   OutboundResale {set;get;}
public String   InboundResale {set;get;}

public String   CATechPartnerProgram {set;get;}

public String   PartnerTechPartnerProgram  {set;get;}

public String   AllianceAgreement {set;get;}
public String   MarketingAgreement {set;get;}

// public String   AgreementSummary {set;get;}
public String   NDA {set;get;}
public String   ProductName {set;get;}

public String   PartnerLevel {set;get;}
public String   PartnerManager{set;get;}
public String AgreementDate {set;get;}
public Decimal RenewalFee {set;get;}
 }
 
  
  public List<SelectOption> getAccountStatusList() {
          
            List<SelectOption> piclistValue=new List<SelectOption>();
            
            Schema.DescribeFieldResult F = Account.Account_Status__c.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
          piclistValue.add(new SelectOption('-- None ---','-- None ---'));
            for(integer loopIndex=0;loopIndex < p.size();loopIndex++)
            {
                piclistValue.add(new SelectOption(P[loopIndex].getValue(),P[loopIndex].getValue()));
            }             
            return piclistValue;               
    } 
    
    public List<SelectOption> getSecondaryAccountType() {
          
            List<SelectOption> piclistValue=new List<SelectOption>();
            
            Schema.DescribeFieldResult F = Account.Secondary_Account_Type__c.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
          piclistValue.add(new SelectOption('-- None ---','-- None ---'));
            for(integer loopIndex=0;loopIndex < p.size();loopIndex++)
            {
                piclistValue.add(new SelectOption(P[loopIndex].getValue(),P[loopIndex].getValue()));
            }             
            return piclistValue;               
    } 
    
    // Test Method
    public static testmethod void methodforPRM_Test1(){
        
      
        
        Product_Alignment__c pao = new Product_Alignment__c();
     
        
        
          Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(pao);
             PRM_PartnerEcosystem  MP = new PRM_PartnerEcosystem (sc);
            // MP.Go();
            //List<SelectOption> p1 = MP.getSecondaryAccountType();
            //List<SelectOption> p = MP.getAccountStatusList(); 
        
        }
   

}