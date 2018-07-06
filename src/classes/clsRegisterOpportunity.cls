public with sharing class clsRegisterOpportunity{

public Opportunity Opp;
public List<Opportunity_Registration__c> oppRegTotal = new  List<Opportunity_Registration__c>();
public List<Opportunity_Registration__c> pirlist = new  List<Opportunity_Registration__c>();

public List<Opportunity_Registration__c> oppRegTotalApp = new  List<Opportunity_Registration__c>(); //AR 3031
public List<PIR_Product_Price__c> pirChildList = new  List<PIR_Product_Price__c>();
public List<Opportunity> Opps = new List<Opportunity>();
public Opportunity_Registration__c RegOpportunity;
public Id oppId{get;set;}
public boolean regStatus{get;set;}
public boolean regStatus1{get;set;}
public  Id  OppReg{get;set;}
public boolean showAlliance{get;set;}
public boolean showAlliance2{get;set;} //Ar 3031
public boolean showTechnology{get;set;}
public boolean showReadOnly{get;set;}
public boolean showEdit{get;set;}
public boolean showApproverSectionEdit{get;set;}
public boolean showValidation{get;set;}
public String[] existingProducts { get; set; }
public SelectOption[] selectedProducts { get; set; }
public SelectOption[] availableProducts { get; set; }
public String ProductstoUpdate {get; set;}
public Boolean firstIteration {get; set;}
public boolean isapprovededit{set;get;}
public string selectedstatus{get;set;}
public List<OpportunityLineItem> oppLineitems {get; set;}
public Boolean isEditable{get; set;}
 
     public clsRegisterOpportunity(ApexPages.StandardController stdController) 
     { 
        OppReg =  ApexPages.currentPage().getParameters().get('oppReg');
        oppId= ApexPages.currentPage().getParameters().get('oppId');
        showValidation =false;
       isapprovededit=false;
       
       
       
       
       
        RegOpportunity = (Opportunity_Registration__c)stdController.getrecord(); 
        
        pirlist =[SELECT id,CreatedById FROM Opportunity_Registration__c where id=:RegOpportunity.id];
        //-----PONSE01----------start----------------
        set<id> createrandapproverids= new set<id>();
        if(RegOpportunity.id!=Null){
            
            createrandapproverids.add(pirlist[0].CreatedByid);
        }
        if(RegOpportunity.id!=Null && RegOpportunity.First_Approver__c!=Null){
            
            createrandapproverids.add(RegOpportunity.First_Approver__c);
        }
        if(RegOpportunity.id!=Null && RegOpportunity.Second_Approver__c!=Null){
            
            createrandapproverids.add(RegOpportunity.Second_Approver__c);
        }
        if(RegOpportunity.id!=Null && RegOpportunity.Third_Approver__c!=Null){
            
            createrandapproverids.add(RegOpportunity.Third_Approver__c);
        }
        
       set<id> usridset= new set<id>();
        list<GroupMember> publicgrplist=[select group.name,group.DeveloperName,UserOrGroupId from GroupMember where  group.DeveloperName='PIR_Terminated_access'];

        for(GroupMember gpm:publicgrplist){


                usridset.add(gpm.UserOrGroupId);

            }
        system.debug('---usridset-----'+usridset);

        if( createrandapproverids.contains(UserInfo.getUserId()) || usridset.contains(UserInfo.getUserId())){

            isEditable=true;
        }              
        //-----PONSE01----------End----------------
         showReadOnly =true;
         showEdit =true;  
         showApproverSectionEdit = false;          
                 
        if(RegOpportunity.Registration_Status__c == 'Pending Approval' && (RegOpportunity.First_Approver__c == UserInfo.getUserId() || RegOpportunity.Second_Approver__c == UserInfo.getUserId() || UserInfo.getProfileId() == '00e30000000oou3'))
        {
            showReadOnly = false;
            showEdit =true;
        } 
        else if(RegOpportunity.Registration_Status__c == 'Pending Approval' && RegOpportunity.First_Approver__c != UserInfo.getUserId() && RegOpportunity.Second_Approver__c != UserInfo.getUserId() && UserInfo.getProfileId() != '00e30000000oou3' )
        {
            showReadOnly = true;
            showEdit =false;
        }                  
        else if(RegOpportunity.Registration_Status__c == 'Rejected' )
        {
            showReadOnly = false;
            showEdit =true; 
        }
        else if(RegOpportunity.Registration_Status__c == 'Approved')
        {
            showApproverSectionEdit = true;
            showReadOnly = false;
            showEdit =false;  
            isapprovededit=true;           
        }else if(RegOpportunity.Registration_Status__c == 'Terminated'){
            showReadOnly = true;
            showEdit =false;
        }
        else
        {
         showEdit =true;    
         showReadOnly = false;
        }
        if(oppId == null)
        {
           oppId = RegOpportunity.Opportunity_Name__c;
        }
        if(oppId != null)       
        {
        opp = [select stagename,closedate from Opportunity where Id= :oppId ] ;
        }
        if(opp != null)
        {
            if(Label.Opp_Stage_Closed_Won == opp.StageName || Label.Opp_Stage_Closed_Lost == opp.StageName || opp.CloseDate <  Date.today()) 
            { 
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'In order to create a Partner Influence Request, the Opportunity Sales Milestone cannot be /' +Label.Opp_Stage_Closed_Lost+ '/ or /' +Label.Opp_Stage_Closed_Won+ '/ and the /Close Date/ of the Opportunity cannot be in the past.');            
                ApexPages.addMessage(msg);
                showReadOnly = true;
                showEdit =false; 
                showApproverSectionEdit=false;

            } 
        }
        if(oppId != null)
        {
         oppRegTotal = [SELECT Id, Alliance_Partner__c,Registration_Status__c FROM Opportunity_Registration__c WHERE Opportunity_Name__c =:oppId AND Alliance_Partner__c != NULL and  Registration_Status__c != 'Rejected' and Registration_Status__c != 'Terminated'];
         showAlliance  = true;  
         system.debug('-----------oppRegTotal.size()-----------'+oppRegTotal.size());      
         if(oppRegTotal.size() > 0)
        {
           if(oppRegTotal[0].Id != RegOpportunity.Id)
            showAlliance  = false;
            
        }
          else 
             showAlliance  = true;
        }
        else
            showAlliance  = true;
        system.debug('showAlliance  --> ' + showAlliance  ); 
        
        if(oppId != null)
        {
         oppRegTotalApp = [SELECT Id,Alliance_Partner__c FROM Opportunity_Registration__c WHERE Opportunity_Name__c = :oppId and Alliance_Partner__c != null and Registration_Status__c = 'Approved' ];
         showAlliance2  = true; 
         system.debug('-----------oppRegTotalApp.size()-----------'+oppRegTotalApp.size());       
        if(oppRegTotalApp.size() > 0)
        {
           if(oppRegTotalApp[0].Id != RegOpportunity.Id)
            showAlliance2  = true;
            
        }
          else 
             showAlliance2  = false;
        }
        else
            showAlliance2  = false;
        system.debug('showAlliance2  --> ' + showAlliance2  ); 
        
        
        availableProducts = new SelectOption[]{};
       selectedProducts = new SelectOption[]{};
        existingProducts = new String[]{};
        Set<String> prodNames = new Set<String>();
        
        oppLineitems = [Select Id, PriceBookEntry.Name,UnitPrice from OpportunityLineItem where OpportunityId =: oppId and Business_Type__c != 'Renewal'];
        
        if(oppLineitems != null && oppLineitems.size() == 0){
          
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Product Line items must exist on the opportunity prior to creating a PIR');            
                ApexPages.addMessage(msg);
                showReadOnly = true; 
                showEdit =false; 
               
          
        }
         System.debug('oppLineitems'+oppLineitems);
        for (OpportunityLineItem oppProd : oppLineitems)
        {
          prodNames.add(oppProd.PriceBookEntry.Name);
        }
        
        for (String prodName : prodNames){
          
          
          if(RegOpportunity.List_Influence_Products_in_Opportunity__c ==null || !(RegOpportunity.List_Influence_Products_in_Opportunity__c.contains(prodName)))
            availableProducts.add(new SelectOption(prodName,prodName));
        
        }
        
       
        
        if(RegOpportunity.List_Influence_Products_in_Opportunity__c != NULL) {
          existingProducts = RegOpportunity.List_Influence_Products_in_Opportunity__c.split(';');
       
           for(String existingProduct : existingProducts){
             selectedProducts.add(new SelectOption(existingProduct,existingProduct));
           }  
       
        }
        
        
        
     }
     
     public PageReference save()
     {     
       Integer count;  
       count = 0;
                 
       if(RegOpportunity.Alliance_Partner__c == null &&  showAlliance == true)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Alliance partner is required.');            
                ApexPages.addMessage(msg);
                return null;
       }
       if( RegOpportunity.Alliance_Partner_2__c == null && showAlliance == false)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ' Alliance partner 2 is required.');            
                ApexPages.addMessage(msg);
                return null;
       }
       if(showAlliance == false && RegOpportunity.Alliance_Partner__c != null)
       {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please utilize the Alliance Partner 2 and Field Alliance Lead 2 fields when requesting an additional Influence Partner. An Alliance Partner has already been requested.');            
                ApexPages.addMessage(msg);
                return null;           
       }       
       if(RegOpportunity.Alliance_Partner__c != null)
       {
         if(RegOpportunity.Field_Alliance_Leader__c == null)
         {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Field Alliance lead cannot be empty  when Alliance Partner is populated');            
           ApexPages.addMessage(msg);
           return null;
         }
         if(RegOpportunity.Partner_Engagement_Phase__c == null)
         {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Partner Engagement Phase 1 cannot be empty when Alliance Partner is populated');            
           ApexPages.addMessage(msg);
           return null;
         }
         if(RegOpportunity.JSO_Name__c == null)
         {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'JSO Name 1 cannot be empty when Alliance Partner is populated');            
           ApexPages.addMessage(msg);
           return null;
         }         
       }
       if(RegOpportunity.Alliance_Partner_2__c != null && RegOpportunity.Field_Alliance_Lead_2__c == null)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Field Alliance Lead 2 is required when Alliance Partner 2 is filled.');            
                ApexPages.addMessage(msg);
                return null;
       }

       if(RegOpportunity.Alliance_Partner_2__c != null && RegOpportunity.Partner_Engagement_Phase_2__c == null)
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Partner Engagement Phase 2 cannot be empty when Alliance Partner 2 is filled');            
           ApexPages.addMessage(msg);
           return null;
       }
       if(RegOpportunity.Alliance_Partner_2__c != null && RegOpportunity.JSO_Name_2__c == null)
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'JSO Name 2 cannot be empty when Alliance Partner 2 is filled');            
           ApexPages.addMessage(msg);
           return null;
       }

       
      
       
        if(RegOpportunity.Alliance_Partner__c != null)
            count = count + 1;
        if(RegOpportunity.Alliance_Partner_2__c != null)
            count = count + 1;
        
       
       if(count > 1)    
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Only 1 Partner can be requested per Partner Influence Request form.');            
           ApexPages.addMessage(msg);
           return null;         
       }
       
       if(RegOpportunity.First_Approver__c == null)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'First Approver can not be empty');            
                ApexPages.addMessage(msg);
                return null;
       }
    /*   if(RegOpportunity.Second_Approver__c == null)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Second Approver can not be empty');            
                ApexPages.addMessage(msg);
                return null;
       }*/
       
       existingProducts = new String[]{};
       
       Boolean Required = true;
       
       for ( SelectOption selectedproduct : selectedProducts ) {
         
         existingProducts.add(selectedproduct.getValue());
         Required = false;
         
       }
       
       if(Required)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'List Influence Products in Opportunity can not be empty');            
                ApexPages.addMessage(msg);
                return null;
       }
       
        firstIteration = true;
       List<PIR_Product_Price__c> delPirChild = [Select id from PIR_Product_Price__c where Partner_Influence_Request__c = :RegOpportunity.Id ];
       if(delPirChild != null) delete delPirChild ;
       for ( String Product : existingProducts ) {
           
           if(firstIteration) {
                    ProductstoUpdate = Product;
                    firstIteration = false;
            }
            else {               
                    ProductstoUpdate+= ';' + Product;
                }
       }
       
       //oppId= ApexPages.currentPage().getParameters().get('oppId');
       Opp = [select Id,Name from Opportunity where Id =:oppId ] ;
       RegOpportunity.List_Influence_Products_in_Opportunity__c = ProductstoUpdate;
      RegOpportunity.Opportunity_Name__c = opp.Id;
      
       if(selectedstatus!=null && selectedstatus!=''){
       RegOpportunity.Registration_Status__c=selectedstatus;
      }
       
       upsert RegOpportunity;
         for ( String Product : existingProducts ) {
           for( OpportunityLineItem OpplineItem : oppLineitems){
               if(OpplineItem.PricebookEntry.Name == Product){
                   PIR_Product_Price__c pirChild = new PIR_Product_Price__c();
                   pirChild.Partner_Influence_Request__c = RegOpportunity.Id;
                   pirChild.Product__c = OpplineItem.PricebookEntry.Name;
                   pirChild.Sales_Price__c = OpplineItem.UnitPrice ;
                   pirChildList.add(pirChild);
               }
           }
         }
         upsert pirChildList;
        

       Opp.Opportunity_Registration__c = RegOpportunity.Id;
       Opp.Registration_Status__c = RegOpportunity.Registration_Status__c ;
            

       try
       {
          upsert Opp; 
       }
       catch(Exception e)
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());            
           ApexPages.addMessage(msg);
           return null;
       }
       
       
       RegOpportunity = [select Id,Name,PIR_Name__c  from Opportunity_Registration__c where Id = :RegOpportunity.Id] ;
       
       
       RegOpportunity.Name =  RegOpportunity.PIR_Name__c;
       upsert RegOpportunity;
       
       PageReference pref = new PageReference('/'+ oppId);
       pref.setRedirect(true); 
       return pref;       
     }
     public PageReference saveNsubmit()
     {     
         
              Integer count;  
       count = 0;
                 
       if(RegOpportunity.Alliance_Partner__c == null && showAlliance == true)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Alliance partner is required.');            
                ApexPages.addMessage(msg);
                return null;
       }
       if( RegOpportunity.Alliance_Partner_2__c == null && showAlliance == false)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Alliance partner 2 is required.');            
                ApexPages.addMessage(msg);
                return null;
       }
       if(showAlliance == false && RegOpportunity.Alliance_Partner__c != null)
       {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please utilize the Alliance Partner 2 and Field Alliance Lead 2 fields when requesting an additional Influence Partner. An Alliance Partner has already been requested.');            
                ApexPages.addMessage(msg);
                return null;           
       }       
       if(RegOpportunity.Alliance_Partner__c != null)
       {
         if(RegOpportunity.Field_Alliance_Leader__c == null)
         {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Field Alliance lead cannot be empty  when Alliance Partner is populated');            
           ApexPages.addMessage(msg);
           return null;
         }
         if(RegOpportunity.Partner_Engagement_Phase__c == null)
         {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Partner Engagement Phase 1 cannot be empty when Alliance Partner is populated');            
           ApexPages.addMessage(msg);
           return null;
         }
                if(RegOpportunity.JSO_Name__c == null)
         {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'JSO Name 1 cannot be empty when Alliance Partner is populated');            
           ApexPages.addMessage(msg);
           return null;
         }         
       }
       if(RegOpportunity.Alliance_Partner_2__c != null && RegOpportunity.Field_Alliance_Lead_2__c == null)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Field Alliance Lead 2 is required when Alliance Partner 2 is filled.');            
                ApexPages.addMessage(msg);
                return null;
       }

       if(RegOpportunity.Alliance_Partner_2__c != null && RegOpportunity.Partner_Engagement_Phase_2__c == null)
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Partner Engagement Phase 2 cannot be empty when Alliance Partner 2 is filled');            
           ApexPages.addMessage(msg);
           return null;
       }
       if(RegOpportunity.Alliance_Partner_2__c != null && RegOpportunity.JSO_Name_2__c == null)
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'JSO Name 2 cannot be empty when Alliance Partner 2 is filled');            
           ApexPages.addMessage(msg);
           return null;
       }


       
      
       
        if(RegOpportunity.Alliance_Partner__c != null)
            count = count + 1;
        if(RegOpportunity.Alliance_Partner_2__c != null)
            count = count + 1;
       
       
       if(count > 1)    
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Only 1 Partner can be requested per Partner Influence Request form.');            
           ApexPages.addMessage(msg);
           return null;         
       }
       
       if(RegOpportunity.First_Approver__c == null)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'First Approver can not be empty');            
                ApexPages.addMessage(msg);
                return null;
       }
      /* if(RegOpportunity.Second_Approver__c == null)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Second Approver can not be empty');            
                ApexPages.addMessage(msg);
                return null;
       }*/
       
       existingProducts = new String[]{};
       
       Boolean Required = true;
       
       for ( SelectOption selectedproduct : selectedProducts ) {
         
         existingProducts.add(selectedproduct.getValue());
         Required = false;
         
       }
       
       if(Required)
       {
         ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'List Influence Products in Opportunity can not be empty');            
                ApexPages.addMessage(msg);
                return null;
       }
       
        firstIteration = true;
       List<PIR_Product_Price__c> delPirChild = [Select id from PIR_Product_Price__c where Partner_Influence_Request__c = :RegOpportunity.Id ];
       if(delPirChild != null) delete delPirChild ;
       for ( String Product : existingProducts ) {
           
           if(firstIteration) {
                    ProductstoUpdate = Product;
                    firstIteration = false;
            }
            else {               
                    ProductstoUpdate+= ';' + Product;
                }
       }
       
       //oppId= ApexPages.currentPage().getParameters().get('oppId');
       Opp = [select Id,Name from Opportunity where Id =:oppId ] ;
       RegOpportunity.List_Influence_Products_in_Opportunity__c = ProductstoUpdate;
       RegOpportunity.Opportunity_Name__c = opp.Id;
       
        if(selectedstatus!=null && selectedstatus!=''){
       RegOpportunity.Registration_Status__c=selectedstatus;
      }
       
       upsert RegOpportunity;
         for ( String Product : existingProducts ) {
         for( OpportunityLineItem OpplineItem : oppLineitems){
               if(OpplineItem.PricebookEntry.Name == Product){
                   PIR_Product_Price__c pirChild = new PIR_Product_Price__c();
                   pirChild.Partner_Influence_Request__c = RegOpportunity.Id;
                   pirChild.Product__c = OpplineItem.PricebookEntry.Name;
                   pirChild.Sales_Price__c = OpplineItem.UnitPrice ;
                   pirChildList.add(pirChild);
               }
           }
         }
       upsert pirChildList;

       Opp.Opportunity_Registration__c = RegOpportunity.Id;
       Opp.Registration_Status__c = RegOpportunity.Registration_Status__c ;

       try
       {
          upsert Opp; 
       }
       catch(Exception e)
       {
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());            
           ApexPages.addMessage(msg);
           return null;
       }
       
       RegOpportunity = [select Id,Name,PIR_Name__c  from Opportunity_Registration__c where Id = :RegOpportunity.Id] ;
       
       RegOpportunity.Name =  RegOpportunity.PIR_Name__c;
       upsert RegOpportunity;

       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            //req.setComments('Submitted for approval. Please approve.');//Commented for 3031 - this comment was getting into email templates 
            req.setObjectId(RegOpportunity.Id);
            system.debug('approval process'+req );
            Approval.ProcessResult result = Approval.process(req);
            
        PageReference pref = new PageReference('/'+ oppId);
        pref.setRedirect(true); 
        return pref;
     }
     public PageReference cancel()
     {
        PageReference pref = new PageReference('/'+ oppId);
        pref.setRedirect(true); 
        return pref;
     }

     
}