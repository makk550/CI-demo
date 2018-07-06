public class SAPRequestPayloadutility{
	
  public static Map<String,SBQQ__QuoteLine__c> MaintnsQuotelineMap=new Map<String,SBQQ__QuoteLine__c>();
  
public static QuoteHeaderDetails quoteHeaderLevelDetails(SBQQ__Quote__c sbqqQuote,List<SBQQ__QuoteLine__c> sbqLines){	      
     QuoteHeaderDetails qutoteHeadr=new QuoteHeaderDetails();
            qutoteHeadr.SALES_DOCUMENT_NUMBER=String.ValueOf(sbqqQuote.SAP_Quote_Number__c);
            qutoteHeadr.DOCUMENT_TYPE=sbqqQuote.Document_Type__c;
            qutoteHeadr.CALLER_SYSTEM=sbqqQuote.Caller_System__c;
            qutoteHeadr.COUNTRY=sbqqQuote.SoldTo_Country__c;
            qutoteHeadr.SALES_ORG=sbqqQuote.Sales_Organization__c;
            qutoteHeadr.CURRENCY_KEY=sbqqQuote.CurrencyIsoCode;
      QuoteDetails quoteDetail=new QuoteDetails();
            quoteDetail.REVENUE_RECOG_MODEL='R';
            quoteDetail.OPP_NUMBER=sbqqQuote.Opportunity_Number__c;
        if(sbqqQuote.Salesforce_CPQ_Quote_Signed__c==true)
            quoteDetail.SIGNED_BY_CUSTOMER=String.valueOf('X');
         else
           quoteDetail.SIGNED_BY_CUSTOMER='';
            quoteDetail.CPQ_QUOTE_NUMBER=sbqqQuote.Name;
            quoteDetail.QUICK_CONTRACT='No';
        if(sbqqQuote.Ramp_Indicator__c==true)
            quoteDetail.RAMP_FLAG=String.ValueOf('Y');
         else
           quoteDetail.RAMP_FLAG=String.ValueOf('N');
        
        if(sbqqQuote.Ramp_Bridge_Order__c==true)     
            quoteDetail.RAMP_BRIDGE_FLAG=String.valueOf('Y');
        else
            quoteDetail.RAMP_BRIDGE_FLAG=String.valueOf('N'); 
        
      if(sbqqQuote.SBQQ__PaymentTerms__c=='Due on receipt')  
          quoteDetail.PAYMENT_TERMS='DUE_ON_RECEIPT';
      else if(String.isNotBlank(sbqqQuote.SBQQ__PaymentTerms__c))
         quoteDetail.PAYMENT_TERMS=sbqqQuote.SBQQ__PaymentTerms__c.toUpperCase().deleteWhitespace();
       else
           quoteDetail.PAYMENT_TERMS='';
        
         qutoteHeadr.QUOTE_DETAILS=quoteDetail;
      QuoteDateDetails datedetai=new QuoteDateDetails();       
        datedetai.INSTALLATION_DATE=ConcadnateDates(sbqqQuote.Quote_Effective_Date__c);
        System.debug('sbqqQuote.SBQQ__EndDate__c==========='+sbqqQuote.End_Date_form__c);
        datedetai.DISMANTLING_DATE=ConcadnateDates(sbqqQuote.End_Date_form__c);    
            qutoteHeadr.DATES=datedetai;
      QuoteBusinessPatners quotebussiness=new QuoteBusinessPatners();
            quotebussiness.SOLD_TO_BP_ID=sbqqQuote.SoldTo_BPID__c;
            quotebussiness.SHIP_TO_BP_ID=sbqqQuote.ShipTo_BPID__c;
            quotebussiness.BILL_TO_BP_ID=sbqqQuote.BillTo_BPID__c;
            quotebussiness.EMPLOYEE_RESPONSIBLE=sbqqQuote.Sales_Rep_PMF_Key__c;
            quotebussiness.BILLING_CONTACT=sbqqQuote.BillingContact_ID__c;
            quotebussiness.SHIPPING_CONTACT=sbqqQuote.ShippingContact_ID__c;
            quotebussiness.TECHNICAL_CONTACT=sbqqQuote.TechnicalContact_ID__c;
            quotebussiness.ENDUSER_BP_ID=sbqqQuote.EndUser_BPID__c;
            quotebussiness.RESELLER_BP_ID=sbqqQuote.Reseller_BPID__c;
           qutoteHeadr.BUSINESS_PARTNERS=quotebussiness;
        QuoteDealTeamDetails dealteam=new QuoteDealTeamDetails();
           dealteam=dealTeamInfo(sbqqQuote,sbqLines);
           qutoteHeadr.DEAL_TEAM_DATA=dealteam;
         return qutoteHeadr;

        
    }
		
public static QuoteDealTeamDetails dealTeamInfo(SBQQ__Quote__c sQuot,List<SBQQ__QuoteLine__c> squoteLines){
      
   QuoteDealTeamDetails quoteteam=new QuoteDealTeamDetails();
   Map<string,SBQQ__QuoteLine__c> combinedMap=new Map<string,SBQQ__QuoteLine__c>();
  if(sQuot!=null&&squoteLines!=null){
     quoteteam.ENT_ACCOUNT_ID=sQuot.ExtnCAEaid__c;
      Decimal quotalsum=0.00;
   for(SBQQ__QuoteLine__c quteline:squoteLines){
     if(quteline.Maintenance_Product__c!='Yes'){   
       if(quteline.Quote_Type__c=='Renewal'){
          quotalsum+=quotalsum+quteline.SBQQ__NetTotal__c;      
         }
         combinedMap.put(quteline.Upgrade_SAP__c, quteline);
        }    
      }
      quoteteam.COMMISSIONABLE_VALUE=String.valueOf(quotalsum);
      
    if(combinedMap.containsKey('U')&&combinedMap.containsKey('R')){
         quoteteam.COMBINED_TRANSACTION ='Y';    
      }else{     
          quoteteam.COMBINED_TRANSACTION ='N'; 
        }
      }   
     return quoteteam;   
    }
    public static BillPlanDetails billPlanDetails( List<Payment_Plan__c> paymentlin){
        
         List<BillPlanList> billpanList=new List<BillPlanList>();
             BillPlanDetails billdetail=new  BillPlanDetails();
      for(Payment_Plan__c payments:paymentlin){
        BillPlanList billplist=new BillPlanList();
           billplist.LINE_NUMBER='000000';
           billplist.BILLPLAN_VALUE=String.ValueOf(payments.Amount__c);
           billplist.BILLPLAN_DATE=ConcadnateDates(payments.Date__c);
           billpanList.add(billplist); 
          }  
        billdetail.row=billpanList;   
        
        return billdetail;
    }
    
    
  public static QuoteIteamDetails quoteIteamDetails(List<SBQQ__QuoteLine__c> sbqLines){
	  
          for(SBQQ__QuoteLine__c sqline:sbqLines){	        
			if(sqline.Maintenance_Product__c=='Yes'){
                    MaintnsQuotelineMap.put(sqline.Maintenance_Parent_Quote_Line__c, sqline);
                    
                  }
		    }	  
       List<QuoteIteamList> quoteIteams=new List<QuoteIteamList>();
       QuoteIteamDetails quoteDetails=new QuoteIteamDetails();
       System.debug('-------sbqLines-'+sbqLines);
       if(sbqLines!=null&&sbqLines.size()>0){
           for(SBQQ__QuoteLine__c quotLin :sbqLines ){
            if(quotLin.SBQQ__ProductCode__c!=null&&quotLin.Maintenance_Product__c!='Yes'){
                String LineNumber=quotLin.Name.remove('QL-');
               QuoteIteamList qutem=new QuoteIteamList();
               qutem.LINE_NUMBER=String.ValueOf(LineNumber);
               qutem.MATERIAL=quotLin.SBQQ__ProductCode__c;
               qutem.QUANTITY='1';
               qutem.INSTALLATION_DATE=ConcadnateDates(quotLin.Start_Date__c);
                System.debug(' qutem.INSTALLATION_DATE==============='+ qutem.INSTALLATION_DATE);
               qutem.DISMANTLING_DATE=ConcadnateDates(quotLin.End_Date__c);
                System.debug(' qutem.DISMANTLING_DATE======'+ qutem.DISMANTLING_DATE);
               qutem.RENEWABLE_ARR=String.valueOf(quotLin.Renewable_ARR__c);
              SBQQ__QuoteLine__c squotelinemaint=MaintnsQuotelineMap.get(quotLin.Name);
              if(String.isNotBlank(quotLin.Instance_Id__c)){
               qutem.PRODUCT_INSTANCE_ID=quotLin.Instance_Id__c;
              }else if(squotelinemaint!=null&&String.isNotBlank(squotelinemaint.Instance_Id__c)){
                qutem.PRODUCT_INSTANCE_ID=squotelinemaint.Instance_Id__c;    
              }else{
                qutem.PRODUCT_INSTANCE_ID='';  
              }
              if(quotLin.Free_of_Charge_Product__c==true)
                qutem.FOC_FLAG='X';
              else
                 qutem.FOC_FLAG='';
                
               quoteIteams.add(qutem);  
            
            }
                 
        }
            
          quoteDetails.row=quoteIteams;
           
         }
        
        
        
        return quoteDetails;
    }
    
    
 Public static String ConcadnateDates(Date datevalue){
     String Datestring='';
     if(datevalue!=null){
        String month;
        String year;
        string day;
    if(String.valueOf(datevalue.month()).length()==1){
        month='0'+String.valueOf(datevalue.month());  
      }else{
        month=String.valueOf(datevalue.month());       
       }
            
     if(String.valueOf(datevalue.day()).length()==1){
        day='0'+String.valueOf(datevalue.day());  
     }else{
        day=String.valueOf(datevalue.day());       
     }
          
     year=String.valueof(datevalue.year());
        
      Datestring=year+month+day;
     }
     
     return Datestring;
        
    }
	
	
public static SalesText  quoteSalesText(SBQQ__Quote__c sbqqQuote){
      SalesText saltext=new SalesText();
         saltext.LINE_NUMBER='000000';
         saltext.TEXT_NAME='EXTERNAL_ORDER_TEXT';
         String input=sbqqQuote.Deal_Description__c;
    if(input!=null){
         input = input.replaceAll('<[/a-zAZ0-9]*>','');
         Blob beforeblob = Blob.valueOf(input);
         input = EncodingUtil.base64Encode(beforeblob);
         System.debug('input======'+String.valueOf(input));
         saltext.TEXT_VALUE=String.valueOf(input);
       }
return saltext;  
     
 } 
    
   

public  class QuoteHeaderDetails{
       public String SALES_DOCUMENT_NUMBER;
       public String DOCUMENT_TYPE;
       public String COUNTRY;
       public String SALES_ORG;
       public String CURRENCY_KEY;
       public String CALLER_SYSTEM;
       public String PROD_PROPOSAL_SEARCH;
       public QuoteDetails QUOTE_DETAILS;
       public QuoteDateDetails DATES;
       public QuoteBusinessPatners BUSINESS_PARTNERS;
       public QuoteDealTeamDetails DEAL_TEAM_DATA;
        
        public QuoteHeaderDetails(){
            QUOTE_DETAILS=new QuoteDetails();
            DATES=new QuoteDateDetails();
            BUSINESS_PARTNERS=new QuoteBusinessPatners();
            DEAL_TEAM_DATA =new QuoteDealTeamDetails();
            
        }
        
    }
    
    public class QuoteDetails{
        public String REVENUE_RECOG_MODEL;
        public String CPQ_QUOTE_NUMBER;
        public String OPP_NUMBER;
        public String OPP_TYPE;
        public String SIGNED_BY_CUSTOMER;
        public String CPQ_ORDER_NO;
        public String QUICK_CONTRACT;
        public String RAMP_FLAG;
        public String RAMP_BRIDGE_FLAG;
        public string PAYMENT_TERMS;

    }
    
    public class QuoteDateDetails{
       public String INSTALLATION_DATE;
       public String DISMANTLING_DATE;
       
    }
    
    
    
    public class QuoteDealTeamDetails{
     
       public string ENT_ACCOUNT_ID;
       public string COMMISSIONABLE_VALUE;
       public String COMBINED_TRANSACTION;
      

        
    }
    public class QuoteBusinessPatners{
        public String SOLD_TO_BP_ID;
        public String SHIP_TO_BP_ID;
        public String BILL_TO_BP_ID='';
        public String EMPLOYEE_RESPONSIBLE;
        public String BILLING_CONTACT;
        public String SHIPPING_CONTACT;
        public String TECHNICAL_CONTACT;
        public string ENDUSER_BP_ID;
        public string RESELLER_BP_ID;
       
    }
    public class BillPlanDetails {
        public List<BillPlanList>  row;
         
       
       
    }
    
    public class BillPlanList{
        
        public String LINE_NUMBER;
        public String BILLPLAN_VALUE;
        public String BILLPLAN_DATE;
    }

    public class QuoteIteamDetails{
        public List<QuoteIteamList> row;
        
      
        
    }

    public class QuoteIteamList{
        public string LINE_NUMBER;
        public String MATERIAL;
        public String QUANTITY;
        public String INSTALLATION_DATE;
        public String DISMANTLING_DATE;
        public String RENEWABLE_ARR;
        public String PRODUCT_INSTANCE_ID;
        public String REPORTED_ARR;
        Public String FOC_FLAG;
        
        
    }    
    
     public class QuotePricingDetails{
         public List<Object> row=new List<Object>();
          
        
        
    }

   
    
    public class ListPriceValues{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;   
        
    }
    
  public class List_DiscountAmount{
       public string LINE_NUMBER;
        public String NAME;
        public String VALUE;  
        
        
    }
    
    public class Licence_Price{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;   
        
    }
    
    
    public class List_Maintaince{
         public string LINE_NUMBER;
        public String NAME;
        public String VALUE;
        
    }
    
    public class Maintain_Discount_Amount{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;
        
    }
    
    
    public class Maintains_Price{
         public string LINE_NUMBER;
        public String NAME;
        public String VALUE;
        
        
    }
    
    
    public class Renewal_Disc_Amount{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;  
        
    }
    
    public class Subscript_Disc_Amount{
       public string LINE_NUMBER;
        public String NAME;
        public String VALUE;  
        
    }
    
    public class Subscription_Price{
         public string LINE_NUMBER;
        public String NAME;
        public String VALUE;   
        
    }
    
     public class CA_LICENSECERT{
         public string LINE_NUMBER;
        public String NAME;
        public String VALUE;   
        
    }
    
     public class QuoteVariantConfigDetails {
       
         public List<Object> row=new List<Object>();
                
    }
    
    public class ZZOpsys{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE; 
        
    }
   public class ZZLICTYPE{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE; 
        
    }
   public class ZZMAINT{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;  
        
    }
   public class ZZBUSTYPE{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;   
        
    }
   public class ZZAUTHUSEMDL{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;
        
    }
    public class ZZLICINST{
         public string LINE_NUMBER;
        public String NAME;
        public String VALUE;  
        
    }
   public class ZZADDINST{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;  
        
    }
    
    public class ZZUpgradte{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;    
        
    }
     public class UserPack_100{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;     
        
    }
     public class UserPack_1000{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;     
        
    }
    
    public class ZZUnlimLicen{
        public string LINE_NUMBER;
        public String NAME;
        public String VALUE;    
        
        
    }
    
     
    public class SalesText{
        public string LINE_NUMBER;
        public String TEXT_NAME;
        public String TEXT_VALUE; 
        
    }
    
    







}