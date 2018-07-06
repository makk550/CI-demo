public with sharing class Ext_RFP {

    //For Question Search
    public string BU{get;set;}
    public string prod{get;set;}
    public List<SelectOption> ListProd{get;set;}
    
    
    //For Answer Search
    public string BU_Answer{get;set;}
    public string prod_Answer{get;set;}
    public List<SelectOption> ListProd_Answer{get;set;}
    
    public Ext_RFP() 
    {
         ListProd = new List<SelectOption>();   
         ListProd.add(new SelectOption('','--None--'));
         ListProd_Answer = new List<SelectOption>();   
         ListProd_Answer.add(new SelectOption('','--None--'));
    }    
    public Ext_RFP(ApexPages.StandardController controller) {
         ListProd = new List<SelectOption>();   
         ListProd.add(new SelectOption('','--None--'));
         ListProd_Answer = new List<SelectOption>();   
         ListProd_Answer.add(new SelectOption('','--None--'));
     
    }
    
    public List<SelectOption> getListBU() 
     {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            /*Schema.DescribeFieldResult F = Product2.Market_Focus_Area__c.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
            for(Schema.PicklistEntry pe:P)
            {    
                 options.add(new SelectOption(pe.getLabel(),pe.getValue()));
            }*/
            options.add(new SelectOption('MAINFRAME','MAINFRAME'));
            options.add(new SelectOption('OTHER','OTHER'));
            options.add(new SelectOption('PPM','PPM'));
            options.add(new SelectOption('SA','SA'));
            options.add(new SelectOption('SEC','SEC'));
            options.add(new SelectOption('VSA','VSA'));
            return options;
     }
    
    public void getProdList()
    {
                     ListProd= new List<SelectOption>();   
                     ListProd.add(new SelectOption('','--None--'));
                     if(   BU <> null)
                         for(Product2 p:[Select id, name from Product2 where Salesforce_CPQ_Product__c=false and Market_Focus_Area__c = : BU and isActive = true])
                             ListProd.add(new SelectOption(p.id,p.name));
    
    }

     public List<SelectOption> getListBU_Answer() 
     {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','--None--'));
            /*Schema.DescribeFieldResult F = Product2.Market_Focus_Area__c.getDescribe();
            List<Schema.PicklistEntry> P = F.getPicklistValues();
            for(Schema.PicklistEntry pe:P)
            {    
                 options.add(new SelectOption(pe.getLabel(),pe.getValue()));
            }*/
            options.add(new SelectOption('MAINFRAME','MAINFRAME'));
            options.add(new SelectOption('OTHER','OTHER'));
            options.add(new SelectOption('PPM','PPM'));
            options.add(new SelectOption('SA','SA'));
            options.add(new SelectOption('SEC','SEC'));
            options.add(new SelectOption('VSA','VSA'));
            return options;
     }
    
    public void getProdList_Answer()
    {
                     ListProd_Answer= new List<SelectOption>();   
                     ListProd_Answer.add(new SelectOption('','--None--'));
                     if(BU_Answer <> null)
                         for(Product2 p:[Select id, name from Product2 where Salesforce_CPQ_Product__c=false and Market_Focus_Area__c = : BU_Answer and isActive = true])
                             ListProd_Answer.add(new SelectOption(p.id,p.name));
    
    }


}