public class Renewal_FinanceReview {

   public List<OLD_RPD_Result__c> rpdResults;
       public List<Renewal_Scenario__c> lst {get;set;}
       public string msg{get;set;}  
       Id oppId;
       public integer npages{get;set;}    
       public integer remainder;
       public integer acpage {get;set;}
       public Integer PageSize = 10 ;
       public OLD_RPD_Result__c rp {get;set;} 
       public boolean showTotal {get;set;}
       public String comments {get;set;} 
              
    public Renewal_FinanceReview() {
        acpage =1;
        npages =0;
        oppId = System.currentPageReference().getParameters().get('Id');
         showTotal=false;
       
        rpdResults = [Select o.Total_Billed_in_LC__c, o.Sold_To_Site__c, o.Sales_Doc_Number__c,o.Sales_Doc_Item__c,o.Sales_doc_item_number__c, o.Realized_Revenue__c, 
        o.Product_text__c, o.Product_Code__c, o.Opportunity__c, o.Not_Realized_Revenue__c, o.Name, o.Last_Revenue_Post_Date__c, 
        o.Last_Bill_Date__c, o.Days_Remaining__c, o.Daily_Revenue__c, o.Currency_Code__c, o.Contract_End_Date__c, 
        o.Balance_of_Unbilled_Receivables__c, o.Balance_of_Deferred_Revenue__c,o.Total_Balance_of_Deferred_Revenue__c,
        o.Total_Balance_of_Unbilled_Receivables__c,o.Total_Bill_LC__c,o.Total_Daily_Revenue__c,o.Total_Not_Realized_Revenue__c,
        o.Total_Realized_Revenue__c,o.Opportunity__r.RPD_Comments__c From OLD_RPD_Result__c o  where o.Opportunity__c = :oppId order by o.Sold_To_Site__c,o.Sales_Doc_Number__c, Sales_doc_item_number__c];
        //based on Req.7.16 limit has been extended to 5 by subsa03
        lst = [Select name,r.Will_Existing_Contracts_be_Respread__c,r.Revenue_Neutral_with_Time_only_GAP__c,
              r.Proposed_Deal_Time_Only__c,r.Pro_Rated_Credit__c,
              r.New_Time_MFC_Rev_Str_Avg_Mth__c,r.New_Time_MFC_Rev_Str_Avg_Day__c,r.Proposed_Deal_Time_MFC__c,
              r.Revenue_Neutral_w_MFC_GAP__c,r.New_Time_MFC_NCV_Svcs_Rev_Str_Avg_Mth__c,r.New_Time_MFC_NCV_Svcs_Rev_Str_Avg_Day__c,
              r.Proposed_Deal_Time_MFC_NCV_Svcs__c,r.Revenue_Neutral_w_MFC_NCV_Svcs_GAP__c,r.Gross_Deal_Should_Be_Rev_Neutral_at__c, 
              r.Opportunity__c, r.Old_Rev_Stream_Avg_Month__c,r.Additional_Committed_Billing__c,Scenario_Approved__c, 
              r.Old_Rev_Stream_Avg_Day__c, r.New_Time_Rev_Stream_Avg_Month__c, r.New_Time_Rev_Stream_Avg_Day__c,   
              r.Months__c,r.New_Deal_Time_Amount__c,
              r.New_Deal_Services_Educ_Amount__c, r.New_Deal_Revenue_Date__c, New_Deal_NCV_MF_Capacity_Amount__c,
              r.New_Deal_End_Date__c,r.Difference_for_Whole_Deal__c, 
              r.Difference_Per_Year__c, r.Difference_Per_Month__c, r.Comments__c, r.Remaining_Billing_To_Be_Cancelled_Cred__c
             ,r.New_Time_MFC_NCV_Rev_Str_Avg_Mth__c, r.New_Time_MFC_NCV_Rev_Str_Avg_Day__c, r.Proposed_Deal_Time_MFC_NCV__c, r.Revenue_Neutral_w_MFC_NCV_GAP__c
              ,r.New_Deal_NCV_Amount__c, r.Finance_Approval__c  
               From Renewal_Scenario__c r where Opportunity__c = : oppId order by name limit 5];
               
      rp = new OLD_RPD_Result__c();    
       
        if(rpdResults.size()>0){
          showTotal = true;   
          rp = rpdResults[0];       
         /** rp.Total_Balance_of_Deferred_Revenue__c= rpdResults[0].Total_Balance_of_Deferred_Revenue__c;
          rp.Total_Balance_of_Unbilled_Receivables__c = rpdResults[0].Total_Balance_of_Unbilled_Receivables__c;
          rp.Total_Realized_Revenue__c = rpdResults[0].Total_Realized_Revenue__c;
          rp.Total_Not_Realized_Revenue__c = rpdResults[0].Total_Not_Realized_Revenue__c;
          rp.Total_Bill_LC__c = rpdResults[0].Total_Bill_LC__c;
          rp.Total_Daily_Revenue__c = rpdResults[0].Total_Daily_Revenue__c; **/
          //rp.Currency_Code__c = rpdResults[0].Currency_Code__c;
          comments = rpdResults[0].Opportunity__r.RPD_Comments__c;
          }
              
      if(lst == null || lst.size() == 0)
          for(integer i=1;i <=5; i++)
              lst.add(new Renewal_Scenario__c(name=string.valueof(i), opportunity__c= oppId ));
    }
    
    public String getComments(){
          return comments;
    }
    
    
    
   
      
     public List<OLD_RPD_Result__c> getRpdResults(){
        
        if(getResultSize() > pageSize)
     {
             List<OLD_RPD_Result__c> my_plist = new List<OLD_RPD_Result__c>();
             npages = getResultsize()/pagesize;
             remainder = getResultsize() - (pageSize*npages);   
                
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getResultsize())
                 my_plist.add(rpdResults[(acpage-1)* pageSize + i]); 
               }
               
               
               return my_plist;
     }
         
     return rpdResults; 
        
        //return lstAccount;
    } 
      public boolean getHasNext() {
         if(((npages == acpage)&&(remainder==0)) || getResultSize() == 0 || getResultSize() < pageSize || (acpage*pageSize) >=getResultSize())
            return false;
        else    
            return true;
    }

    public Boolean getHasPrevious() {
        if( getResultSize() == 0 || acpage == 1 )
            return false;
        else
            return true;    
    }
    
    public Integer getPageSize() {  
           return pageSize;   
    }  

    public void setPageSize(Integer ps) {
           if(ps != pageSize)
            {       
                acpage =1;
                pageSize = ps;
            }
   }
    public void next() {
           acpage +=1;
    }
  
    public void previous() {
           acpage-=1;
    }
    
    public Integer getResultSize() {
        if(rpdResults == null)
            return 0;
        else
            return rpdResults.size();
   }
    
    public PageReference returnToOpp() {
        //Id oppId = System.currentPageReference().getParameters().get('Id');
        PageReference ref = new PageReference('/'+oppId);
        return ref;
    }
    
    public PageReference ExportOLDRPDResult() {
        //Id oppId = System.currentPageReference().getParameters().get('Id');
        Report report =[Select r.Name,r.Id From Report r where DeveloperName=:'Old_RPD_Result'];
        PageReference ref = new PageReference('/'+report.Id+'?pv0='+String.ValueOf(oppId).Substring(0,15));
        return ref;
    }
    public PageReference ExportRenewalScenario() {
        //Id oppId = System.currentPageReference().getParameters().get('Id');
        Report report =[Select r.Name,r.Id, r.DeveloperName  From Report r where r.DeveloperName=:'Renewal_Scenario_Result' ];
        PageReference ref = new PageReference('/'+report.Id+'?pv0='+String.ValueOf(oppId).Substring(0,15));
        return ref;
    }
     
    public pagereference submit()
    {
        try{
                
     //   upsert lst;
        Opportunity opp;
        boolean atLeastOneApproved = false;
        integer flag=0;
        msg  = '';
        
        for(Renewal_Scenario__c r : lst)
        {
           system.debug('chk1****'+ r.Finance_Approval__c);
           
            if(r.Finance_Approval__c)
                {
                    
                 atLeastOneApproved = true;
                 flag +=1;  
             //   break;   
                }
        }
         system.debug('chk2****'+ flag );
          system.debug('chk3****'+ atLeastOneApproved );
        
        if(flag == 1 && atLeastOneApproved == true){
             upsert lst;
         opp = new Opportunity(id=oppId,RPD_Status__c = 'Scenario Approved');
            update opp;
            PageReference ref = new PageReference('/'+oppId);
            return ref; 
        }
        else if(flag > 1){
            
         msg+='Please approve only one Scenario!';
         return null;
        }else {
            msg += 'Please approve at least one Scenario';
                return null;}
        
         
      /*  if(atLeastOneApproved)
        {            
            opp = new Opportunity(id=oppId,RPD_Status__c = 'Scenario Approved');
            update opp;
            PageReference ref = new PageReference('/'+oppId);
            return ref;                  
        }
        else
        {
                msg += 'Please approve at least one Scenario';
                return null;
        } */
        
        
        }catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }      
    }
    @isTest
    public static void Renewal_FinanceReview_test() {
        RecordType recopp = [select Id from Recordtype where IsActive=true and SObjectType='Opportunity' and Name='New Opportunity'];
           recordtype[] recs = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType ='account' and r.name in ('SMB','Reseller/Distributor Account')];
                    id res;
                    id com;
                    for(recordtype rec: recs)
                        if(rec.name == 'SMB')
                                com = rec.id;
                        else
                                res = rec.id;
                    account a = new account(name ='we', recordtypeid =res);
                    a.customer_Category__c= 'Reseller';
                    a.hq__c= true;
                    a.Commercial_Account_Name__c='test 11111114'  ;
                    a.Commercial_ID__c= 'test 11111115';
                    a.Country_Picklist__c= 'JP - JAPAN';
                    a.GEO__c= 'JAPAN';
                    a.Sales_Area__c= 'JAPAN';
                    a.Sales_Region__c= 'JAPAN';
                    a.Billingstate= 'A';
                    a.Billingcity= 'B';
                    a.Billingstreet= 'C';
                    insert a;
        
        Opportunity opp = new Opportunity(RecordTypeId=recopp.Id,Reseller__c = a.Id,
         Name = 'TestOpp' ,
         StageName = 'test' , 
         CloseDate = Date.today(),
         New_Deal_Term_months__c = 12, 
         Stretch_Deal_Term_Months__c = 8,
         Stretch_Sales_Price_Gap_Reason__c = 'Technical Problems',
         Business_Type__c = 'High Touch',
         Projected_Renewal__c = 12345.0);
         insert opp;
        OLD_RPD_Result__c oldRPDR= new OLD_RPD_Result__c(Sold_To_Site__c = 'S 48407',Sales_Doc_Number__c = '40103010', Sales_Doc_Item__c = '150', Currency_Code__c = 'CAD', Product_Code__c = 'WKLSAP990', product_text__c= 'WORKLOAD AUTOMATION DE', Balance_of_Deferred_Revenue__c = 0, Balance_of_Unbilled_Receivables__c = 0,Realized_Revenue__c = 117323.9921875, Not_Realized_Revenue__c = 0, Total_Billed_in_LC__c = -1614, Days_Remaining__c = 60,Opportunity__c = opp.id);
        insert oldRPDR;
        OLD_RPD_Result__c oldRPD = [Select Id, Opportunity__c from OLD_RPD_Result__c limit 1];
        System.currentPageReference().getParameters().put('Id',oldRPD.Opportunity__c);
        Renewal_FinanceReview c = new Renewal_FinanceReview();
        c.getComments();
        c.getRpdResults();
        c.getHasNext();
        c.getHasPrevious();
        c.getPageSize();
        c.setPageSize(5);
        c.next();
        c.previous();
        c.getResultSize();
        c.returnToOpp();
        c.submit();
        c.ExportOLDRPDResult();
        c.ExportRenewalScenario();                                  
    }    
 
}