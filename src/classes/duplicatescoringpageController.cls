public class duplicatescoringpageController {

    public Opportunity currentRecord{get; set;}
    public list<Opportunity> Matchedoptys{get;set;}
    public list<Opportunitywrapper> Accountmatchwrapper{get;set;}
    Public string currentrecAccountname{get;set;}
    Public Integer CurrentRecProdCount{get;set;}
    public Map<id,string> Currentrecordproductidsmap{get;set;}
    public static String Sortingorder;
    integer count{get;set;}
    String Products{get;set;}
    decimal twentyperamt{get;set;}
    decimal positiveamt{get;set;}
    decimal negtiveamt{get;set;}
    
    public duplicatescoringpageController() {
    Accountmatchwrapper=new list<Opportunitywrapper>();
    Currentrecordproductidsmap= new Map<id,string>();
    count=0;
    Products='';
        currentRecord = [SELECT Id, Name,Amount, Accountid,Account.name,Sales_Milestone_Search__c,Type,Service_Provider_Client__c,(select Product2id,Product2.Name from Opportunitylineitems) FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        currentrecAccountname=currentRecord.Account.name;
        CurrentRecProdCount=currentRecord.Opportunitylineitems.size();
        system.debug('CurrentRecProdCount============'+CurrentRecProdCount);
        for(Opportunitylineitem oplin:currentRecord.Opportunitylineitems){
        Currentrecordproductidsmap.put(oplin.Product2id,oplin.Product2.Name);
        
        }
        system.debug('Currentrecordproductidsmap============'+Currentrecordproductidsmap);
        system.debug('Transaction_Type__c========c====='+currentRecord.Type);
        if(currentRecord.Type=='xSP' && currentRecord.Service_Provider_Client__c!=null){
        Matchedoptys=[select id,Name,Accountid,Amount,Account.Name,Sales_Milestone_Search__c,Owner.Alias,Type,Service_Provider_Client__c,(select Product2id,Product2.Name from Opportunitylineitems) from Opportunity where (Accountid=:currentRecord.Accountid OR Account.name LIKE :('%' + currentrecAccountname + '%') OR Name LIKE :('%' + currentrecAccountname + '%')) and Sales_Milestone_Search__c!=:Label.Opp_Stage_Closed_Lost and Sales_Milestone_Search__c!=:Label.Opp_Stage_Closed_Won and Id != :ApexPages.currentPage().getParameters().get('id')];
        }else{
           Matchedoptys=[select id,Name,Accountid,Amount,Account.Name,Sales_Milestone_Search__c,Owner.Alias,Type,(select Product2id,Product2.Name from Opportunitylineitems) from Opportunity where (Accountid=:currentRecord.Accountid OR Account.name LIKE :('%' + currentrecAccountname + '%') ) and Sales_Milestone_Search__c!=:Label.Opp_Stage_Closed_Lost and Sales_Milestone_Search__c!=:Label.Opp_Stage_Closed_Won and Id != :ApexPages.currentPage().getParameters().get('id')];  
        }
        if(Matchedoptys.size()>0){
        for(Opportunity opp:Matchedoptys){
     
        system.debug('Transaction_Type__c========in loop====='+opp.Type);

            if(opp.Accountid==currentRecord.Accountid || opp.Name.contains(currentrecAccountname)){
            
            Opportunitywrapper opw= new Opportunitywrapper();
            opw.oppty=opp;
            
            
            if(opp.Name.contains(currentrecAccountname) && opp.Accountid==currentRecord.Accountid ){
            opw.ExactMatch=True;
            opw.rating=1.0;
            }else if(opp.Name.contains(currentrecAccountname) && opp.Accountid!=currentRecord.Accountid){
            
            opw.ExactMatch=False;
            opw.rating=0.5;
            }else if(opp.Accountid==currentRecord.Accountid){
            opw.ExactMatch=True;
            opw.rating=1.0;
            }
            if(opp.Opportunitylineitems.size()>0){
             for(Opportunitylineitem opli:opp.Opportunitylineitems){
            
            if(opli.Product2.Name==Currentrecordproductidsmap.get(opli.Product2id)){
                Products +=opli.Product2.Name+',';
            count++;
            
            }
            }
            }
          system.debug('count-----'+count);
                if(Products!=''&& Products!=null){
                    opw.Productsincommon=Products.removeend(',');
                    
                }
                system.debug('opp.Opportunitylineitems.size()----'+opp.Opportunitylineitems.size());
          if(opp.Opportunitylineitems.size()>0){
          //opw.Prodmatchcount=count*100/CurrentRecProdCount;
          opw.Prodmatchcount=count*100/opp.Opportunitylineitems.size();
          system.debug('opw.Prodmatchcount===='+opw.Prodmatchcount);
          }
          if(opw.Prodmatchcount==100){
          opw.ProductScore=0.8;
          
          }else if(opw.Prodmatchcount<100 && opw.Prodmatchcount>=75){
          
          opw.ProductScore=0.6;
          }else if(opw.Prodmatchcount<75 && opw.Prodmatchcount>=50){
          
          opw.ProductScore=0.4;
          }else if(opw.Prodmatchcount<50 && opw.Prodmatchcount>=25){
          
          opw.ProductScore=0.2;
          }else if(opw.Prodmatchcount<25 && opw.Prodmatchcount>0){
          
          opw.ProductScore=0.1;
          }else{
          
          opw.ProductScore=0;
          }
          system.debug('currentRecord.Amount====='+currentRecord.Amount);
         // system.debug('========opp===='+opp.Amount);
          //system.debug('============'+0.2*opp.Amount);
                system.debug('=opp.Sales_Milestone_Search__c==========='+opp.Sales_Milestone_Search__c);
          
              system.debug('in Contains');
               system.debug('opp.Name----'+opp.Name);
              system.debug('opp.Amount ----'+opp.Amount );
              system.debug('currentRecord.Amount ----'+currentRecord.Amount );
              
              twentyperamt=0.2*opp.Amount;
              system.debug('twentyperamt----'+twentyperamt);
              positiveamt=opp.Amount+twentyperamt;
              system.debug('positiveamt----'+positiveamt);
              negtiveamt=opp.Amount - twentyperamt;
              system.debug('negtiveamt----'+negtiveamt);
             
              if(currentRecord.Amount!=null && opp.Amount!=null){
          if(currentRecord.Amount >= negtiveamt && currentRecord.Amount <= positiveamt){
          
          opw.DealAmountMatch=0.2;
          system.debug('opw.DealAmountMatch======if02=========='+opw.DealAmountMatch);
          }
               else{
          
          opw.DealAmountMatch=0.0;
              system.debug('opw.DealAmountMatch======if00=========='+opw.DealAmountMatch);
               }
              }
           else{
          
          opw.DealAmountMatch=0.0;
              system.debug('opw.DealAmountMatch======else=========='+opw.DealAmountMatch);
          }
          system.debug('opw.ProductScore================='+opw.ProductScore);
          system.debug('opw.DealAmountMatch================'+opw.DealAmountMatch);
          opw.Secondryscore=opw.ProductScore + opw.DealAmountMatch;
          
         system.debug('opw.Secondryscore================'+opw.Secondryscore);
                system.debug('opw.rating================'+opw.rating);
          opw.Finalscore= opw.rating *opw.Secondryscore;
             system.debug('opw.Finalscore================'+opw.Finalscore);
             if(opw.Finalscore!=0)
             {   
            Accountmatchwrapper.add(opw);
            }
            count=0;
            Products='';
            }
        }
        
        
        } else {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There Are no Opportunitys Matching the Criteria'));

        }
        if(Accountmatchwrapper.size()>0){
        sortDirection = 'DESC';
        ViewData();
        } 
        
    }
    
    public class Opportunitywrapper  implements Comparable{
    
     public Opportunity oppty {get;set;}
     public decimal rating{get;set;}
     public Boolean ExactMatch{get;set;}
     public Integer Prodmatchcount{get;set;}
     public decimal ProductScore{get;set;}
     public decimal DealAmountMatch{get;set;}
     public decimal Secondryscore{get;set;}
     public decimal Finalscore{get;set;}
     public String Productsincommon{get;set;}
     
     Public Opportunitywrapper(){
    }
     public Integer compareTo(Object compareTo) {
            Opportunitywrapper jobsWrapper = (Opportunitywrapper) compareTo;
            if (Finalscore > jobsWrapper.Finalscore) {
                return Sortingorder == 'DESC' ? -1:1;
            } else if(Finalscore < jobsWrapper.Finalscore) {
                return Sortingorder == 'DESC' ? 1:-1;
            } else {
                return 0;
            }  
            return 0;       
        }
    
     }
     
     
     private String sortDirection = 'ASC';
     private String sortExp = 'Finalscore';

   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }
        
        public String getSortDirection()
 {
    //if not column is selected 
    if (sortExpression == null || sortExpression == '')
      return 'ASC';
    else
     return sortDirection;
 }

 public void setSortDirection(String value)
 {  
   sortDirection = value;
 }
        
        
     public PageReference ViewData() {
     Sortingorder =sortDirection ;
     Accountmatchwrapper.sort();
     return null;
     }

}