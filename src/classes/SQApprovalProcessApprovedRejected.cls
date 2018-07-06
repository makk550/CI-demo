public class SQApprovalProcessApprovedRejected
{  
   public String recID {get; set;}  
   public String approverID{set;get;}
   //public scpq__SciQuote__c SQ{set;get;}   
   public list<Quote_Product_Report__c> Approvalneeded;
   public list<Quote_Product_Report__c> AutoApproved;
   public scpq__SciQuote__c SQget(string recId1){
    scpq__SciQuote__c SQ=new scpq__SciQuote__c();
    SQ       =    [SELECT Id,Name,scpq__OpportunityId__r.name,CA_Customer_Name_Sold_To__c,CA_CPQ_Quote_Total__c,CA_Total_Total_Disc_Off_Vol_GSA_Price__c,                                           
                                            BU_and_Users__c,CA_Effective_Date__c,CA_Contract_End_Date__c,Net_Payment_Terms__c,
                                            L3_Approver__c,L1_Approver__c,Opportunity_Number__c,
                                           Approver1__c,Approver2__c,Approver3__c,Approver4__c,Approver5__c,Approver6__c,Approver7__c,Approver8__c,Approver9__c,Approver10__c
                                          
                                            
                                      FROM scpq__SciQuote__c 
                                      WHERE Id =:recID1  limit 1];
        
       return SQ;
   }

   public scpq__SciQuote__c Squote{
   get{
        return SQget(recID);
   }
   }
  
  
   public String isApproved
   {
   get
   {
        return getapproveorreject('approval');
   }
   }
   public String rejectedComments
   {
   get
   {
        return getapproveorreject('Comments');
   }
   }
   public String getapproveorreject(string type)
   {
       ProcessInstance p=[SELECT Id,targetobjectid,(SELECT Id,OriginalActorId,StepStatus, Comments FROM Steps where (StepStatus='Approved' or StepStatus='Rejected')  order By createddate desc )
           FROM ProcessInstance where targetobjectid=:recID order By createddate desc limit 1];
           String IsApproved;
           String rComments;
           system.debug(p.Steps);
            //system.debug(p.Steps[0].StepStatus);
           if(p.Steps.size()>0){
           if(p.Steps[0].StepStatus=='Approved'){
           IsApproved='Approved';
           }
           else if(p.Steps[0].StepStatus=='Rejected'){
           IsApproved='Rejected';
           rComments=p.Steps[0].Comments;
           }
           }
           system.debug(IsApproved);
           String finalString;
           if(type=='approval')
           finalString=IsApproved;
           else if(type=='Comments')
           finalString=rComments;
           return finalString;
           
   }
     public String urlStr{  
    get  
   {  
     return 'https://'+ System.URL.getSalesforceBaseUrl().getHost() +'/'+recID ; 
   }
   }  
   public list<User> ApproverorRejectuserid{
       get{
           list<user> userlist=new list<User>();
           ProcessInstance p=[SELECT Id,targetobjectid,(SELECT Id,OriginalActorId,StepStatus, Comments FROM Steps where (StepStatus='Approved' or StepStatus='Rejected')  order By createddate desc)
           FROM ProcessInstance where targetobjectid=:recID order By createddate desc limit 1];
           scpq__SciQuote__c SQ=new scpq__SciQuote__c();
           if(p.Steps.size()>0)
           {
        SQ       =    [SELECT Id,Name,scpq__OpportunityId__r.name,CA_Customer_Name_Sold_To__c,CA_CPQ_Quote_Total__c,CA_Total_Total_Disc_Off_Vol_GSA_Price__c,                                           
                                            BU_and_Users__c,Opportunity_Number__c,
                                            L3_Approver__c,L1_Approver__c,
                                           Approver1__c,Approver2__c,Approver3__c,Approver4__c,Approver5__c,Approver6__c,Approver7__c,Approver8__c,Approver9__c,Approver10__c
                                                                               
                                      FROM scpq__SciQuote__c 
                                      WHERE Id =:recID  limit 1];
                                      System.debug(recID  +'@@'+SQ);
           set<id> useridset=new set<id>();                         
           set<id> userset=new set<id>();
           if(SQ.Approver1__c!=null)
           useridset.add(SQ.Approver1__c);
           if(SQ.Approver2__c!=null)
           useridset.add(SQ.Approver2__c);
           if(SQ.Approver3__c!=null)
           useridset.add(SQ.Approver3__c);
           if(SQ.Approver4__c!=null)
           useridset.add(SQ.Approver4__c);
           if(SQ.Approver5__c!=null)
           useridset.add(SQ.Approver5__c);
           if(SQ.Approver6__c!=null)
           useridset.add(SQ.Approver6__c);
           if(SQ.Approver7__c!=null)
           useridset.add(SQ.Approver7__c);
           if(SQ.Approver8__c!=null)
           useridset.add(SQ.Approver8__c);
           if(SQ.Approver9__c!=null)
           useridset.add(SQ.Approver9__c);
           if(SQ.Approver10__c!=null)
           useridset.add(SQ.Approver10__c);
           if(SQ.L1_Approver__c==p.Steps[0].OriginalActorId)
           {
           userset.add(p.Steps[0].OriginalActorId);
           }
            if(SQ.L3_Approver__c==p.Steps[0].OriginalActorId)
           {
           userset.add(p.Steps[0].OriginalActorId);
           }
           
           if(useridset.contains(p.Steps[0].OriginalActorId))
           {
              if(p.Steps[0].StepStatus=='Approved'){
               for(ProcessInstanceStep SW:p.Steps){
               if(useridset.contains(SW.OriginalActorId))
               userset.add(SW.OriginalActorId);
               }
               }
               else
               {
                    userset.add(p.Steps[0].OriginalActorId);
               }

           }
           
           for(user u:[select id,Name,Title from user where id=:userset limit 50000])
           userlist.add(u);
           }
           return userlist;
   
       }
   }
}