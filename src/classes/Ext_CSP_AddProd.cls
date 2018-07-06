public with sharing class Ext_CSP_AddProd {
    public  CSP_Product__c cp {get; set;}    
    public Customer_Success_Program__c csp{get;set;}
    Public List<ProdMaterials> lstPM{get;set;}
    Public Map<id,id> mcp;
    public boolean editProd {get;set;}
    public boolean editMaterial {get;set;}
    public boolean addError{get;set;}
    public string msg{get;set;}
    
    public class ProdMaterials
    { 
        public boolean isSelected{get;set;}
        public product_material__c pm{get;set;}
        public ProdMaterials(boolean sel, product_material__c pm_temp)
        {
            isSelected = sel;
            pm= pm_temp;
        }
     }     
    
    public pagereference Back()
    {
        PageReference acctPage = new  PageReference('/' + csp.id); //ApexPages.StandardController(csp).view();
        acctPage.setRedirect(true);
        return acctPage;
    }
    
    public Ext_CSP_AddProd(ApexPages.StandardController controller) {
        
         editMaterial = false;
         editProd = false;
                 
        
        if(ApexPages.currentPage().getParameters().get('cspid') <> null)
          {   cp = NEW    CSP_Product__c(Customer_Success_Program__c = ApexPages.currentPage().getParameters().get('cspid')); 
              csp = NEW   Customer_Success_Program__c (id = ApexPages.currentPage().getParameters().get('cspid')); 
          }
         else
           {
             cp = NEW    CSP_Product__c();
             csp = NEW   Customer_Success_Program__c ();
           }
           
          if(ApexPages.currentPage().getParameters().get('id') <> null)
            {   
            try{ cp = [ Select Product__c, Risk__c, Product_Material__c, Customer_Success_Program__c From  CSP_Product__c Where id =: ApexPages.currentPage().getParameters().get('id')];
            }
            catch(exception ex)
            {
            if(ApexPages.currentPage().getParameters().get('retURL') <> null)
                cp = new CSP_Product__c(customer_success_program__c = ApexPages.currentPage().getParameters().get('retURL').replace('%2F','').replace('/','').split('&')[0]);
            else    
               cp = new CSP_Product__c();
            }
                 csp = NEW   Customer_Success_Program__c (id =cp.Customer_Success_Program__c);
                 refreshValues();   
                 
                 editMaterial = (lstPM != null && lstPM.size() >0);
                 editProd = !editProd;
                 
                 
            }
            
           
    }
    
    public Pagereference refreshValues()
    { 
      addError = false;
        
      loadList(); 
      lstPM = new List<ProdMaterials>();
             
        if(cp <> null && cp.Product__c <> null)
            {
                for( product_material__c pm: [Select id, product__r.name, Platform_Category__c,Operational_BU__c, Material_Text__c, name from  product_material__c where product__c =:cp.Product__c LIMIT 1000 ])
                {
                     
                        lstPM.add(new ProdMaterials(SetOldSel.contains(pm.id), pm));
                
                }
                
            }
         if(lstPM.size() ==0)
             lstPM  = null; 
            
        return null;
    }
    
    public pagereference AddMaterial()
    {
        addError = false;
        
        integer count =0;
    
        List<CSP_Product__c> lst  =  new List<CSP_Product__c>();
        List<CSP_Product__c> lst_del  =  new List<CSP_Product__c>();
        
          {
              for(ProdMaterials pm_temp : lstPM)
                  {
                      if(pm_temp.isSelected )
                          count ++;
                          
                      if(pm_temp.isSelected && ! SetOldSel.contains(pm_temp.pm.id))
                          {
                                  lst.add(new CSP_Product__c(Customer_success_program__c = cp.Customer_success_program__c,  product__c = cp.product__c, product_material__c = pm_temp.pm.id,  risk__c=cp.risk__c));
                              
                          }
                        else if(! pm_temp.isSelected && SetOldSel.contains(pm_temp.pm.id))
                        {
                                   lst_del.add(new CSP_Product__c(id=mcp.get(pm_temp.pm.id)));
                                   
                        }   
                  }

            
          }
       
        if(count ==0 && cp.id <> null)
        {
          addError = true;
          msg = 'Please select at least one Material to Add !';
          return null;
          
        }            
        if(lst.size() > 0)    
                insert lst; 
       
        if(lst_del.size() > 0)    
                delete lst_del; 
                 
        PageReference acctPage = new  PageReference('/' + csp.id); //ApexPages.StandardController(csp).view();
        acctPage.setRedirect(true);
        return acctPage;
    }
    
     public pagereference AddProd()
    {
        
        
        
        if([Select id from CSP_Product__c where product__c =: cp.product__c and product_material__c = '' AND Customer_success_program__c = : cp.Customer_success_program__c].size() > 0)
        {
          addError = true;
          msg = 'Product already added to CSP. Please choose another!';
          return null;
          
        }  
        List<CSP_Product__c> lst  =  new List<CSP_Product__c>();
        lst.add(new CSP_Product__c(product__c = cp.product__c,Customer_success_program__c = cp.Customer_success_program__c, risk__c=cp.risk__c));
        if(lst.size() > 0)    
                insert lst; 
    
        
        PageReference acctPage = new  PageReference('/' + csp.id); //ApexPages.StandardController(csp).view();
        acctPage.setRedirect(true);
        return acctPage;
    }
    
    public pagereference UpdateRisk()
    {
   
        if(cp.id <> null)
        {
            update cp;
        }
    
        PageReference acctPage = new  PageReference('/' + csp.id); //ApexPages.StandardController(csp).view();
        acctPage.setRedirect(true);
        return acctPage;
    }    
    
    public pagereference UpdateProd()
    {
   
        if(cp.id <> null & cp.product__c <> null)
        {
            update cp;
        }
    
        PageReference acctPage = new  PageReference('/' + csp.id); //ApexPages.StandardController(csp).view();
        acctPage.setRedirect(true);
        return acctPage;
    }
    
      public Set<ID> SetOldSel = new Set<id>();

    public void loadList()
    {
          mcp = new Map<id,id>();
          SetOldSel = new Set<id>();
          
        
          for(CSP_Product__c cp_0: [ Select Product__c, Risk__c, Product_Material__c, Customer_Success_Program__c From  CSP_Product__c 
                                 Where Customer_Success_Program__c=: cp.Customer_Success_Program__c ])
            {   SetOldSel.add(cp_0.Product_Material__c);
                mcp.put(cp_0.Product_Material__c, cp_0.id); 
            
            }                         
    
    }

}