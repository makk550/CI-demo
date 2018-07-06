public class productComponentCon{
    
    public CA_Product_Component__c prodComp;
    ApexPages.StandardController GstdController;
    public boolean isEnabled{get;set;}
    public productComponentCon(ApexPages.standardController stdController){
        
        GstdController = stdController; 
        prodComp = (CA_Product_Component__c)stdController.getRecord();
        isEnabled = true;
           
    }
    
    public pageReference saveComp(){
       
        Id currentRecId = ApexPages.currentPage().getParameters().get('id') ;
        
        CA_Product_Component__c  prodContId = [SELECT Id,CA_Product_Controller__c,Default_Component_for_this_CA_Product__c,Default_Component_for_CA_Product__c FROM CA_Product_Component__c WHERE Id=:currentRecId limit 1];
           
       if(!prodComp.Default_Component_for_this_CA_Product__c && prodContId .Default_Component_for_this_CA_Product__c !=prodComp.Default_Component_for_this_CA_Product__c
           || !prodComp.Default_Component_for_CA_Product__c && prodContId .Default_Component_for_CA_Product__c !=prodComp.Default_Component_for_CA_Product__c ){   
         
               isEnabled =false;
               ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'You are trying to modify a default component and / or default product on a CA Product component record, please contact Product Analyst for a new substitute default component or default product.'));
       
        }
        else{
            
             PageReference pr = GstdController.save(); 
             pageReference pv = GstdController.view(); 
             return pv; 
        
        } 
        
        return null;
        
    }
   
}