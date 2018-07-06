public class sterlingQuoteApprovalProcessforRenewal
{  
   public String recID {get; set;}  
/*   public scpq__SciQuote__c Squote{
   get{
        return SQget(recID,approverID);
   }
   }
*/
   public scpq__SciQuote__c Squote{get;set;}
   public String approverID{set;get;}
   public boolean approverornot{get;set;}
   public list<Quote_Product_Report__c> AutoApproved1{get;set;}
   public list<Quote_Product_Report__c> Approvalneeded;
   public list<Quote_Product_Report__c> AutoApproved;
   public scpq__SciQuote__c SQget(string recId1,string approverID1){
    scpq__SciQuote__c SQ=new scpq__SciQuote__c();
    SQ       =    [SELECT Id,Name,scpq__OpportunityId__r.name,CA_Customer_Name_Sold_To__c,CA_CPQ_Quote_Total__c,CA_Total_Total_Disc_Off_Vol_GSA_Price__c,                                           
                                            BU_and_Users__c,CA_Effective_Date__c,CA_Contract_End_Date__c,Net_Payment_Terms__c  ,
                                            L3_Approver__c,L1_Approver__c,Opportunity_Number__c,CA_Realization_Rate__c,
                                           Approver1__c,Approver2__c,Approver3__c,Approver4__c,Approver5__c,Approver6__c,Approver7__c,Approver8__c,Approver9__c,Approver10__c,CA_Brief_Deal_Desc__c
                                          
                                            
                                      FROM scpq__SciQuote__c 
                                      WHERE Id =:recID1  limit 1];
        
     
      
       
       return SQ;
   }
   public Map<string,list<Quote_Product_Report__c>> sterlingQuoteApprovalProcess_maker(string recId1,string approverID1)
   {
            system.debug('-------entered this block-------');
       		Approvalneeded=new list<Quote_Product_Report__c>();
            AutoApproved=new list<Quote_Product_Report__c>();
       		AutoApproved1=new List<Quote_Product_Report__c>();
            scpq__SciQuote__c SQ=new scpq__SciQuote__c();
			Squote = new scpq__SciQuote__c();
            SQ       =    [SELECT Id,Name,scpq__OpportunityId__r.name,CA_Customer_Name_Sold_To__c,CA_CPQ_Quote_Total__c,CA_Total_Total_Disc_Off_Vol_GSA_Price__c,                                      
                                            BU_and_Users__c,Opportunity_Number__c,CA_Realization_Rate__c,
                                            L3_Approver__c,L1_Approver__c,Deal_Desk_Approver__c,Special_Metric_on_Template__c,Migration_Upgrade_On_Template__c,Royalty_For_Template__c,
                           					CA_Effective_Date__c,CA_Contract_End_Date__c,Net_Payment_Terms__c, 
                                           Approver1__c,Approver2__c,Approver3__c,Approver4__c,Approver5__c,Approver6__c,Approver7__c,Approver8__c,Approver9__c,Approver10__c,CA_Brief_Deal_Desc__c,
                                             (select Id,Name,
                                                 Business_Unit__c, 
                                                 Bus_Transaction_Type__c,
                                                 CA_Pricing_Group__c,  
                                                 Product_Name__c,
												 No_Charge_Product__c,
                                                 Total_Discount_off_Volume_GSA_Price__c,
                                                 Total_Disc_off_List__c,                                                 
                                                 Total_Proposed_Price__c,
                                                 Target_Disc_Percent__c,
                                                 Target_Disc__c,
                                                 Floor_Disc__c,
                                                 Sales_Mgmt_Approval__c,
                                                 Floor_Disc_Percent__c,Existing_Quantity__c,  
                                                 Discount_off_Volume_GSA_Lic_Sub_Fee__c,
                                                 Lic_Sub_Off_List__c,Global_Paid_Seats__c,License_Metric__c, Global_Paid_Seats_Used__c,New_Additional_Quantity__c,                                             
                                                 Reason_for_Discount__c,Max_Royalty_Discount_Percent__c,Disc_off_List_License_Subs__c,
                                                 Level_of_Approval_Required__c,Effective_Date__c,End_Date__c,License_Type__c,
                                                 Sales_Mgmt_Approval_Percent__c,royalty_product__c,Auth_Use_Model__c 
                                              FROM Quote_Products_Reporting__r where No_Charge_Product__c!='Y')
                                            
                                      FROM scpq__SciQuote__c 
                                      WHERE Id =:recID1 limit 1];
                                      //and (L1_Approver__c=:approverID1 or L3_Approver__c=:approverID1 OR Approver1__c=:approverID1 OR Approver2__c=:approverID1 or Approver3__c=:approverID1 OR Approver4__c=:approverID1 OR Approver5__c=:approverID1 OR Approver6__c=:approverID1 or Approver7__c=:approverID1 OR Approver8__c=:approverID1 OR Approver9__c=:approverID1 OR Approver10__c=:approverID1) 
		Squote = SQ;
        if(sQ.id!=null){
            
        for(Quote_Product_Report__c product:SQ.Quote_Products_Reporting__r)
        {
                
                if(SQ.L1_Approver__c==approverID1){
                    approverornot=true;
                    if(product.Level_of_Approval_Required__c!='No Level'&&product.Level_of_Approval_Required__c!='Auto Approve')
                    Approvalneeded.add(product); 
                    if(product.Level_of_Approval_Required__c=='Auto Approve')
                    AutoApproved.add(product);
                 }
                 
                 else if(SQ.Deal_Desk_Approver__c==approverID1){
                     approverornot=true;
                    if(product.Level_of_Approval_Required__c!='No Level'&&product.Level_of_Approval_Required__c!='Auto Approve')
                    Approvalneeded.add(product); 
                    if(product.Level_of_Approval_Required__c=='Auto Approve')
                    AutoApproved.add(product);
                 }
                 else if(SQ.L3_Approver__c==approverID1){
                     approverornot=true;
                    if(product.Level_of_Approval_Required__c!='No Level'&&product.Level_of_Approval_Required__c!='Auto Approve')
                    Approvalneeded.add(product); 
                    if(product.Level_of_Approval_Required__c=='Auto Approve')
                    AutoApproved.add(product);
                 }
                 else if(SQ.Approver1__c==approverID1||SQ.Approver2__c==approverID1||SQ.Approver3__c==approverID1||SQ.Approver4__c==approverID1||SQ.Approver5__c==approverID1||SQ.Approver6__c==approverID1||SQ.Approver7__c==approverID1||SQ.Approver8__c==approverID1||SQ.Approver9__c==approverID1||SQ.Approver10__c==approverID1)
                {
                    approverornot=true;
                    System.debug(approverID1+'$$'+'@'+product.Business_Unit__c+'$'+product.Level_of_Approval_Required__c);
                    
                    if(product.Level_of_Approval_Required__c!='No Level'&&(product.Level_of_Approval_Required__c=='L2'||product.Level_of_Approval_Required__c=='L3')){
                        Approvalneeded.add(product);
                    }
                    if(product.Level_of_Approval_Required__c=='Auto Approve'){
                        AutoApproved.add(product);
                    
                    }
                    
                }
        }
        
   }
   map<string,list<Quote_Product_Report__c>> resultsmap=new map<String,list<Quote_Product_Report__c>>();
   resultsmap.put('Approval',Approvalneeded);
   resultsmap.put('auto',AutoApproved);
   
   AutoApproved1.addall(AutoApproved);
   
   return resultsmap;
   
   }
   
    
	
    


   public list<Quote_Product_Report__c> Approvalneeded1{
   get{
       
           map<string,list<Quote_Product_Report__c>> resultsmap=sterlingQuoteApprovalProcess_maker(recID,approverID);
           if(resultsmap.get('Approval')!=null)           
           return resultsmap.get('Approval');
           else
           return new list<Quote_Product_Report__c>();
       }
   }
 
	
    public String urlStr{  
    get  
   {  
     return generateApprovalURL(recID);  
   }
   }
   public String SQurlStr{  
    get  
   {  
     
       String SQurl = 'https://'+ System.URL.getSalesforceBaseUrl().getHost() + '/'+recID;
       return SQurl;  
   }
   }   
    
   @TestVisible 
   private String generateApprovalURL(String recordID){  
      String url='';  
        
      List<ProcessInstanceWorkitem> workItemLst =   
        [  SELECT id  
      FROM ProcessInstanceWorkitem  
      WHERE processInstance.TargetObjectId=:recordID];   
        
      if(workItemLst.size() > 0)  
      {  
         
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost() +   
         '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + workItemLst[0].id;      
     }  
     return url;  
   }  
   public boolean EAIuser{
   get
   {
        Boolean Submitter=false; 
        for(scpq__SciQuote__c sqc:[SELECT Id                                  
                                      FROM scpq__SciQuote__c 
                                      WHERE Id =:recID and Deal_Desk_Approver__c=:approverID limit 1])                                     
          Submitter=true;
       
       return Submitter;
       
   }
   }

}