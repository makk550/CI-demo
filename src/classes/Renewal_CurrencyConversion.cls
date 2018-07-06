public class Renewal_CurrencyConversion {
    Renewal__c rc;
    public Renewal_CurrencyConversion(ApexPages.StandardController controller) {
        List<Renewal__c> RenewalList = [select Projected_Renewal_USD__c,Renewal_Currency_Conversion_Rate__c
//,ATTRF_CRV_USD__c, Calculated_OCV_USD__c, Calculated_AOCV_USD__c, Raw_Maint_Calc_USD__c, name,Renewal_Currency_Conversion_Rate__c,
                                        //ATTRF_CRV__c,OCV__c,Annual_OCV_LC__c,Raw_Maint_Calc__c
                                        from Renewal__c where id =:ApexPages.currentPage().getParameters().get('Id')];
        if(RenewalList.size()>0)
           {   rc = RenewalList.get(0);                            
           
               /*ATTRFUSD =rc.ATTRF_CRV_USD__c;
               RawMaintUSD =rc.Calculated_OCV_USD__c;
               OCVUSD= rc.Calculated_AOCV_USD__c;
               AOCVUSD= rc.Raw_Maint_Calc_USD__c;*/
               projRenewalUSD = rc.Projected_Renewal_USD__c;
           }
    }
    /*public Decimal ATTRFUSD{get;set;}
    public Decimal RawMaintUSD{get;set;}
    public Decimal OCVUSD{get;set;} 
    public Decimal AOCVUSD{get;set;} */
    public Decimal projRenewalUSD{get;set;} 
    
    public pagereference Conversion(){
    try{
        if(rc.Renewal_Currency_Conversion_Rate__c <> 0){
            /*rc.ATTRF_CRV__c =  ATTRFUSD * rc.Renewal_Currency_Conversion_Rate__c;
            rc.Raw_Maint_Calc__c =  RawMaintUSD * rc.Renewal_Currency_Conversion_Rate__c;
            rc.OCV__c =  OCVUSD * rc.Renewal_Currency_Conversion_Rate__c;
            rc.Annual_OCV_LC__c =  AOCVUSD * rc.Renewal_Currency_Conversion_Rate__c;*/
            rc.Projected_Renewal__c = projRenewalUSD * rc.Renewal_Currency_Conversion_Rate__c;
        }
        //System.debug('Renewal '+rc);
        update rc; 
        PageReference pageRef = new PageReference('/'+rc.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    catch(Exception e){
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);
        ApexPages.addMessage(msg);
        return null;  
    } 
  }
  
  @isTest(SeeAllData=true)
  public static void Renewal_CurrencyConversion_test() {
        //Renewal__c ren = [Select Id from Renewal__c LIMIT 1];
        Renewal__c ren = new Renewal__c(name='Test Renewal');
        insert ren;
        ApexPages.StandardController controller = new ApexPages.StandardController(ren);
        ApexPages.currentPage().getParameters().put('Id',ren.Id);
        Renewal_CurrencyConversion c = new Renewal_CurrencyConversion(controller);
        c.Conversion(); 
  }     
}