public class Renewal_AddRenewalProduct {
    String strOppId;
    String strAccName;
    public integer npages;    
    public integer remainder;
    public integer acpage = 1;
    public Integer PageSize = 10 ;
    public List<RenewalProductDetails> RenewalProductList = new List<RenewalProductDetails>();
    Opportunity opp;
    String currencyISOCode;
    public Renewal_AddRenewalProduct(ApexPages.StandardSetController controller) {
        strOppId=System.currentPageReference().getParameters().get('Id'); 
        System.debug('strOppId## '+strOppId);
        Set<Id> oppProdSet = new Set<Id>();
        opp = [Select o.Name, o.Id, o.Account.Name,o.CurrencyIsoCode, o.AccountId
                From Opportunity o where o.Id =: strOppId];
        System.debug('oppProdSet## '+oppProdSet);
        /*opp= [Select o.Account.Name,name,Id  From Opportunity o where 
                    o.Id =: strOppId];*/
        //System.debug('strAccName## '+strAccName);
        for(Active_Contract_Product__c ac: [Select a.Renewal_Currency_Name__c,a.Renewal_Product__r.Renewal__r.name, a.Renewal_Product__c,a.Active_Contract__r.name, 
            a.Name, a.Id, a.Converted_To_Opportunity__c, a.Active_Contract__r.Renewal_Currency__c,a.Active_Contract__c,a.AOCV__c,a.OCV__c,
            a.Active_Contract__r.Account__r.name,a.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c,a.Raw_Maint_Calc_LC__c
            From Active_Contract_Product__c a where a.Active_Contract__r.Account__c =:opp.AccountId //and a.Currency__c =:opp.Account.CurrencyIsoCode
           //and a.Renewal_Product__r.Renewal__r.name !=:opp.name
            and a.Converted_To_Opportunity__c = false   ]){
                if(oppProdSet!=null || oppProdSet.size()>0){
                    if(opp.CurrencyIsoCode == ac.Renewal_Currency_Name__c)
                        RenewalProductList.add(new RenewalProductDetails(ac)); 
                }                        
        }                                
        System.debug('RenewalProductList## '+RenewalProductList);                    
    }
    public pagereference addProduct(){
        List<CA_Product_Renewal__c> caProdList = new List<CA_Product_Renewal__c>();
        List<Active_Contract_Product__c> prodWithNewRenewalsList = new List<Active_Contract_Product__c>();
        try{
        for(RenewalProductDetails lstVal:RenewalProductList){
            if(lstVal.selected){
                CA_Product_Renewal__c ca = new CA_Product_Renewal__c();
                String RenewalName=lstVal.activeContractProd.Active_Contract__r.Name;
                String RenewalproductName=lstVal.activeContractProd.name;
                if(RenewalName.length()>20)
                {
                   RenewalName =RenewalName.Substring(0,20);
                }
            if(RenewalproductName.length()>60)
            {
               RenewalproductName =RenewalproductName.Substring(0,60);
            }
                ca.Name = RenewalName+ '-' +RenewalproductName;
                ca.Active_Contract_Product__c = lstVal.activeContractProd.id;
                ca.Contract__c = lstVal.activeContractProd.Active_Contract__c;
                ca.Raw_Maintenance__c=lstVal.activeContractProd.Raw_Maint_Calc_LC__c;
                ca.Renewal_Opportunity__c = opp.Id;
                ca.currencyIsoCode = opp.CurrencyIsoCode; 
                caProdList.add(ca);
                
                
                
                /*if(lstVal.activeContractProd.Renewal_Product__r.Renewal__r.Converted_To_Opportunity__c == false){
                   prodWithNewRenewalsList.add(lstVal.activeContractProd);
                }*/
                    
            }
        }
        if(caProdList.size()>0)
            insert caProdList;
        
       /* if(prodWithNewRenewalsList.size()>0){
            List<Renewal_Product__c> renProdList = new List<Renewal_Product__c>();
            Renewal__c ren =[select id from Renewal__c where Opportunity__c =: opp.Id];
            for(Active_Contract_Product__c cp:prodWithNewRenewalsList){
                System.debug('ren '+ren);
                Renewal_Product__c rp = new Renewal_Product__c
                (Id=cp.Renewal_Product__c,
                 Renewal__c = ren.Id); 
                 renProdList.add(rp);               
            }
            update renProdList;
         }*/
         PageReference pageRef = new PageReference('/'+opp.Id);
         pageRef.setRedirect(true);
         return pageRef;
        }
        catch(Exception e){
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception '+e);    
            ApexPages.addMessages(e);
            return null;
        }   
        
        
    }
    public List<RenewalProductDetails> getRenewalProductList(){
        
        if(getResultSize() > pageSize)
     {
             List<RenewalProductDetails> my_plist = new List<RenewalProductDetails>();
             npages = getResultsize()/pagesize;
             remainder = getResultsize() - (pageSize*npages);   
                
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getResultsize())
                 my_plist.add(RenewalProductList[(acpage-1)* pageSize + i]); 
               }
            return my_plist;
     }        
     return RenewalProductList;
        
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
        if(RenewalProductList== null)
            return 0;
        else
            return RenewalProductList.size();
   }
   
   public class RenewalProductDetails{
        public Active_Contract_Product__c activeContractProd{get; set;}
        public Boolean selected {get; set;}
        
        public RenewalProductDetails(Active_Contract_Product__c a){
            activeContractProd= a;
            selected = false;
        }
    }
}