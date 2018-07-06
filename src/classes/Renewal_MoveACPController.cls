/**
Class Name: Renewal_MoveACPController
Author: Sandeep D.S
Description: This class is to move Active contract products from one renewal to other renewal. 
Modifications:
   CR:191723423 (12/13/2011) Replaced references to Renewal_Currency__c with Renewal_Currency__r.CurrencyIsoCode, because there 
                is a new Renewal_Currency__c record each year, but the Renewal_Currency__r.CurrencyIsoCode is always the same.
*/

public class Renewal_MoveACPController {
    //inner class to display ACP
    public class wrapperACP{
        public boolean sel {get;set;}
        public Active_Contract_Product__c acp {get;set;}
        public wrapperACP(Boolean sel, Active_Contract_Product__c acp){
          this.sel = sel;
          this.acp = acp;
        }
    }
    public Active_Contract__c activeContract {set;get;}
    public List<wrapperACP> lstACP; 
    public List <Selectoption> lstRenewals{set;get;}
    public List <Selectoption> lstReasonForInvalidate{set;get;}
    public List <Selectoption> lstSegChangeReason{set;get;}
    public String selectedRenewal {set;get;}
    public String reasonForInvalidate {set;get;}
    public String SegChangeReason {set;get;}
    public integer npages;    
    public integer remainder;
    public integer acpage = 1;
    public Integer PageSize = 10 ;
    public Boolean errorFlag { get; set; }
    public Boolean limitFlag { get; set; }
    
    public List<wrapperACP> getlstACP(){
        
        if(getResultSize() > pageSize)
     {
             List<wrapperACP> my_plist = new List<wrapperACP>();
             npages = getResultsize()/pagesize;
             remainder = getResultsize() - (pageSize*npages);   
                
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getResultsize())
                 my_plist.add(lstACP[(acpage-1)* pageSize + i]); 
               }
            System.debug('my_plist '+my_plist);   
            return my_plist;
     } 
      return lstACP;
     }        
     
        
        //return lstAccount;
     
    
    public Renewal_MoveACPController(ApexPages.StandardController controller) {
      activeContract = (Active_Contract__c)controller.getRecord(); 
      lstACP = new List<wrapperACP>();
      if(activeContract.Id != NULL ){
        activeContract = [Select Id, name, Account__c, Sold_to_party__c,Renewal_Currency__r.CurrencyIsoCode From Active_Contract__c where Id=:activeContract.Id ]; 
        if(activeContract.Account__c != NULL){
          fetchRenewals(activeContract.Account__c);
        }
        fetchACP(); 
      }
      fetchReasonsForInvl();
      fetchSegChangeReason();
    }
    //Fetch all active contract products those are associated with active contract.
    public void fetchACP(){
      lstACP = new List<wrapperACP>();
      List<Active_Contract_Product__c> lst = [Select Renewal_Product__c, Renewal_Name__c, 
                               Product__c, Renewal_Product__r.Renewal__c,Product__r.Name, OCV__c, Name, Segmentation__c, Expected_Close_Date__c, Active_Contract__c, 
                               AOCV__c,Reason_for_invalidation__c,Segmentation_Change_Reason__c,Pre_Segmentation__c,Invalid__c
                        From Active_Contract_Product__c 
                        where Active_Contract__c = : activeContract.Id];//---***---Queried Invalid__c field
                        
         for(Active_Contract_Product__c acp:lst){
           lstACP.add(new wrapperACP(false,acp));          
         }
    }

    // Fetch all Renewals that are associated to the same account and currency should be same at both levels.
    public void fetchRenewals(Id accountId){
        lstRenewals = new list<Selectoption>();
        lstRenewals.add(new Selectoption('None','--None--'));      
        Renewal__c[] rnwls = [Select Name, Id  From Renewal__c where Account__c=:accountId and Renewal_Currency__r.CurrencyIsoCode = : activeContract.Renewal_Currency__r.CurrencyIsoCode];
        for(Renewal__c renw:rnwls){
            lstRenewals.add(new Selectoption(renw.id,renw.Name));
        }
        
    }
   public void fetchReasonsForInvl(){
        lstReasonForInvalidate = new List<Selectoption>();
        lstReasonForInvalidate.add(new Selectoption('None','--None--'));
        lstReasonForInvalidate.add(new Selectoption('Invalid - Active No Maintenance','Invalid - Active No Maintenance'));
        lstReasonForInvalidate.add(new Selectoption('Invalid - Cancelled','Invalid - Cancelled'));  
        lstReasonForInvalidate.add(new Selectoption('Invalid - Education','Invalid - Education'));
        lstReasonForInvalidate.add(new Selectoption('Invalid - Professional Services','Invalid - Professional Services'));
        lstReasonForInvalidate.add(new Selectoption('Invalid - Renewal not valid this FY','Invalid - Renewal not valid this FY'));
        lstReasonForInvalidate.add(new Selectoption('Invalid – RMDM/ISBU','Invalid – RMDM/ISBU'));
        lstReasonForInvalidate.add(new Selectoption('Invalid - Superseded','Invalid - Superseded'));
        lstReasonForInvalidate.add(new Selectoption('Invalid - Zero Dollar Product','Invalid - Zero Dollar Product'));       
    }
   public void fetchSegChangeReason(){
    lstSegChangeReason=new List<Selectoption>();
    lstSegChangeReason.add(new Selectoption('None','--None--'));
    lstSegChangeReason.add(new Selectoption('Completed with HT Opp for same customer ','Completed with HT Opp for same customer'));
    lstSegChangeReason.add(new Selectoption('Difficult Negotiation to be handled by HT','Difficult Negotiation to be handled by HT'));  
    lstSegChangeReason.add(new Selectoption('Strong Relationship/Customer preference is HT Rep','Strong Relationship/Customer preference is HT Rep'));
    lstSegChangeReason.add(new Selectoption('Customer Moving Off Mainframe – Move to MT','Customer Moving Off Mainframe – Move to MT'));
    lstSegChangeReason.add(new Selectoption('Cancelling Products Sets-move to MT','Cancelling Products Sets-move to MT'));
    lstSegChangeReason.add(new Selectoption('Moving to Outsourcer-move to MT','Moving to Outsourcer-move to MT'));
    lstSegChangeReason.add(new Selectoption('Deal won\'t meet HT $ threshold-move to MT','Deal won\'t meet HT $ threshold-move to MT'));
    lstSegChangeReason.add(new Selectoption('Acquisition/Indirect-move to MT','Acquisition/Indirect-move to MT'));
    lstSegChangeReason.add(new Selectoption('Move to Autobill','Move to Autobill'));    
    lstSegChangeReason.add(new Selectoption('Moved from LT to MT','Moved from LT to MT'));
    } 
    public pagereference moveRenewals(){
    
        //1. Check for corresponding Renewal Product ( RP with same Product as the CP to be moved) in Renwal2
        
        //2.i. If 1 exists, change the association of the Contract Product to the renewal product in renewal 2
        //2.ii if 1 does not exist then create a new Renewal product with the same product as rp and change change the association of the Contract Product to the new renewal product in renewal 2
        list<Active_Contract_Product__c> lstUpdate = new List<Active_Contract_Product__c>(); 
        
        map<id,id> mapnewRP = new map<id,id>(); 
        set<string> prods = new set<string>();
        set<string> selRnwls = new set<string>();
        set<string> preSegmentation = new set<string>();
         
         if(selectedRenewal == Null || selectedRenewal.trim() == '' || selectedRenewal.trim()=='None'){
             Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please select target Renewal for move'));
              return null;
          }
        //check for the renewal products that are selected. 
        for(wrapperACP wacp: lstACP)
           {
                if(wacp.sel)
                {                                                    
                  prods.add(wacp.acp.product__c);   
                  selRnwls.add(wacp.acp.Renewal_Product__r.Renewal__c);
                  preSegmentation.add(wacp.acp.Pre_Segmentation__c);
                }
           }
           
           //validations
           if(prods.isEmpty()){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please select active contract products that needs to be moved.'));
             return null;
            }
           
           if(preSegmentation.size()!=1){
             Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please select Active Contracts Products with the same pre-segmentation value.'));
             return null;
            }
           
        Renewal__c renewal= [select Id, Segmentation__c from Renewal__c where Id=:selectedRenewal];   
   
        Renewal_Product__c[] rp = [Select r.Renewal__c, r.id, r.Product__c From Renewal_Product__c r where r.product__c in : prods and Renewal__c =: selectedRenewal ];
        for(Renewal_Product__c r: rp)
        mapnewRP.put(r.product__c,r.id);
        List<Id>  rpToDelete = new List<Id>();  
        for(wrapperACP wacp: lstACP)
           {
            if(wacp.sel)
            {  
                if(wacp.acp.Pre_Segmentation__c!=renewal.Segmentation__c){                  
                    if(SegChangeReason==null || SegChangeReason=='None'){
                        Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please select Segmentation Change reason for Active Contract Product '+wacp.acp.name));
                        return null;
                    }  
                    wacp.acp.Segmentation_Change_Reason__c =SegChangeReason;                        
                }  
                else {
                    wacp.acp.Segmentation_Change_Reason__c =null;
                 }  
                
                  if(mapnewRP.get(wacp.acp.product__c) != null)
                 {
                    rpToDelete.add(wacp.acp.Renewal_Product__c);                  
                    wacp.acp.Renewal_Product__c =  mapnewRP.get(wacp.acp.product__c);
                    wacp.acp.Reason_for_invalidation__c=null;
                    lstUpdate.add(wacp.acp);    
                 }  
                 else
                 {
                    Renewal_Product__c rp_temp = new Renewal_Product__c(name = wacp.acp.Product__r.Name, renewal__c=selectedRenewal ,product__c=wacp.acp.product__c);
                    insert rp_temp;
                    rpToDelete.add(wacp.acp.Renewal_Product__c);
                    wacp.acp.Renewal_Product__c =  rp_temp.id;
                    wacp.acp.Reason_for_invalidation__c=null;
                    lstUpdate.add(wacp.acp);
                                            
                 }
        
             }
           }
    if(!lstUpdate.isEmpty()){
        update lstupdate;    
    }                       
    if(!rpToDelete.isEmpty()){
       deleteRnwlPrdcts(rpToDelete);
    } 
        
    //search for Renewal Product Contracts(junction object) with target Renewal and selected contract.    
    List<Renewal_Contracts__c> rnwlContract = [select id from Renewal_Contracts__c where Active_Contract__c = : activeContract.Id and Renewal__c =: selectedRenewal];    
    if(rnwlContract.isEmpty()){
       //create junction object.
       Renewal_Contracts__c rc_temp = new Renewal_Contracts__c(Name=activeContract.name,Active_Contract__c=activeContract.Id,Renewal__c =selectedRenewal);
       insert rc_temp;     
    }
    
     //get all the active contract products that are assoicated to selected renewal and active contract.
     // if the size is 0 then delte the Renewal produc contract if exists.
     map<id,id> actvContProd = new map<id,id>();
     List<Id>  rnwlWithNoACP = new List<Id>(); 
     List<Active_Contract_Product__c> lst = [Select Id, Renewal_Name__c,Renewal_Product__r.Renewal__c
                                                From Active_Contract_Product__c 
                                                where Active_Contract__c = : activeContract.Id and Renewal_Product__r.Renewal__c in :selRnwls];
                                                
     for(Active_Contract_Product__c actvCP: lst)
        actvContProd.put(actvCP.Renewal_Product__r.Renewal__c,actvCP.id);


        for(string rnwl: selRnwls){
            if(actvContProd.get(rnwl) != null){
                //do nothing
            }
            else{
                rnwlWithNoACP.add(rnwl);
            }       
        }
       
       Renewal_Contracts__c[] delRnwlCont=[select id from Renewal_Contracts__c where Renewal__c in: rnwlWithNoACP and Active_Contract__c=:activeContract.Id];
       
       if(delRnwlCont!=null && !delRnwlCont.isEmpty()){
           Database.delete(delRnwlCont);
       }
         
       //refresh the active contract product list
       fetchACP();
       return null;
    }
    
    //Renewal__c
    public void deleteRnwlPrdcts(List<Id> rpIds){
        List<Id>  rnwlpToDelete = new List<Id>();
                    
        for(Renewal_Product__c rnwlprd:[Select Id,(Select Id From Contract_Products__r) From Renewal_Product__c where Id in:rpIds]){
        System.debug('_____________rnwlprd'+rnwlprd);        
            Boolean isACPExist = false;
            for(Active_Contract_Product__c acp:rnwlprd.Contract_Products__r){
                isACPExist = true;
                break;
            }
            if(!isACPExist){
             rnwlpToDelete.add(rnwlprd.id); 
            }
        } 
         if(!rnwlpToDelete.isEmpty()){
             Database.delete(rnwlpToDelete);
         }      
    } 
    
    
   public pagereference InvalidateACP(){
        
        //disassociate selected contract producct from renewal product. 
        list<Active_Contract_Product__c> invContract = new List<Active_Contract_Product__c>();
        List<Id>  verifRP = new List<Id>();
        
        if(reasonForInvalidate == Null || reasonForInvalidate.trim() == '' || reasonForInvalidate.trim()=='None'){
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please enter reason why is this contract product invalid?'));
            return null;
         }
        //check for the renewal products that are selected.
        for(wrapperACP wacp: lstACP)
        {
            if(wacp.sel)
            {               
                wacp.acp.Reason_for_invalidation__c = reasonForInvalidate;                
                //delete renewal product if there are no acp's. 
                verifRP.add(wacp.acp.Renewal_Product__c);  
                wacp.acp.Renewal_Product__c =null;                
                invContract.add(wacp.acp);                                  
            }
        }
               
               
         if(!invContract.isEmpty()){
            update invContract;    
         } else {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please select active contract products that needs to be Invalidated.'));           
         } 
                 
           //Renewal product should be deleted if there are are no active contract products associated with this.          
          if(!verifRP.isEmpty()){
             deleteRnwlPrdcts(verifRP);
          }        
          fetchACP();
          return null;  // new pagereference('/apex/newpagename');       
     }
     


public pagereference UnAttachACP(){
        
        system.debug ('In UnattachACP');
        //disassociate selected contract producct from renewal product. 
        list<Active_Contract_Product__c> invContract = new List<Active_Contract_Product__c>();
        List<Id>  verifRP = new List<Id>();
        
        //check for the renewal products that are selected.
        for(wrapperACP wacp: lstACP)
        {
           // if(wacp.acp.Segmentation__c=='Invalid')
        system.debug ('In forloop');            
                if(wacp.sel)
                { 
                    if(wacp.acp.Segmentation__c=='Invalid')
                    {                              
                        //delete renewal product if there are no acp's. 
                        verifRP.add(wacp.acp.Renewal_Product__c);  
                        wacp.acp.Renewal_Product__c =null;                
                        //wacp.acp.Pre_Segmentation__c = wacp.acp.Segmentation__c;
                        reasonForInvalidate=null;
                        wacp.acp.Reason_for_invalidation__c  =null;
                        //wacp.acp.Segmentation__c = 'Unattached';
                        invContract.add(wacp.acp); 
                                system.debug ('end of if');            
                    }
                    else
                    {
                       Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Only Invalid Contract Products can be unattached'));  
                       return null;
                    }                                 
                }
    
        }
        
               
               
         if(!invContract.isEmpty()){
            update invContract;    
         } else {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Please select active contract products that needs to be Unattached.'));           
         } 
                 
           //Renewal product should be deleted if there are are no active contract products associated with this.          
          //if(!verifRP.isEmpty()){
            // deleteRnwlPrdcts(verifRP);
          //}        
          fetchACP();
          return null;  // new pagereference('/apex/newpagename');       
     }
     
      public boolean getHasNext() {
         if(((npages == acpage)&&(remainder==0)) || getResultSize() == 0 || getResultSize() < pageSize || (acpage*pageSize) >=getResultSize()|| errorFlag == true)
            return false;
        else    
            return true;
    }

    public Boolean getHasPrevious() {
        if( getResultSize() == 0 || acpage == 1 || errorFlag == true)
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
        if(lstACP == null)
            return 0;
        else
            return lstACP.size();
   }
 
 }