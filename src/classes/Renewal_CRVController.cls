/**
    Class Name: Renewal_CRVController
    Author: Sandeep D.S
    Description: This class is for CRV Process Implementation.  
    */
    public class Renewal_CRVController {
        //inner class to display ACP
        public class wrapperACP{
            public boolean sel {get;set;}
            public Active_Contract_Product__c acp {get;set;}
            public wrapperACP(Boolean sel, Active_Contract_Product__c acp){
              this.sel = sel;
              this.acp = acp;   
            }
        }
         
        // inner calss to display ACL   
        public class wrapperACL{
            public boolean selACL {get;set;}
            public Active_Contract_Line_Item__c acl {get;set;}
            public wrapperACL(Active_Contract_Line_Item__c acl){
              //this.selACL = selACL;Boolean selACL,
              this.acl = acl;
            }
        }
        //public Integer currentPage = 1;        
        public Decimal sumTot{set;get;}//danva10
        public integer npages{set;get;}
        public integer remainder{set;get;} 
        public integer TotalPagesDisp {set;get;}
        public integer acpage{set;get;}
        
        public Integer totalPages { get; set; }
        public Boolean errorFlag { get; set; }
        public Boolean limitFlag { get; set; }
        public Active_Contract__c activeContract {set;get;}
        public List<wrapperACP> lstACP;
        public List<wrapperACL> lstACL; 
        public List <Selectoption> lstRenewals{set;get;}
        public List <Selectoption> lstReasonForInvalidate{set;get;}
        public List <Selectoption> lstSegChangeReason{set;get;}
        public String selectedRenewal {set;get;}
        public String reasonForInvalidate {set;get;}
        public String SegChangeReason {set;get;}
        public String atvContSegmention {get;set;}
        public String valuationRule {set;get;}
        public double totalValuationAnnualized {set;get;}
        public Integer pages ;
        public List <Selectoption> recDisplayperPage{get;set;}
        public integer pageNO_restored {set;get;}
        public integer Total_pageNO_restored {set;get;}
       // to skip valuation status update when ACLI renewal valuation type changes
        public static boolean valuation_status_flag=false;  //merha02 --- US432438
          
       // Added by subsa03
       
       public Pagereference onload()
       {
         if(pageNO_restored == null)
         {
                pageNO_restored = 1;
         } 
         acpage = pageNO_restored;
          
         if(Total_pageNO_restored== null)
         {
                pages = 5;
         }else
         { 
          pages = Total_pageNO_restored;
         }       
         unload();
         return null;
      }
      
        public Integer getPages() {
            return pages;    
        }
                               
        public void setPages(Integer pages) {
            this.pages = pages;
             //acpage = 1;
        } 
        
         public Integer pageSize = pages;      
       
      
       public pagereference editHeaderValuation()
       {
           pagereference pr = new pagereference ('/apex/Renewal_EditHeaderValues?fromPage=finVal&id=' + activeContract.id );
           
           return pr;
       }
         public List<wrapperACP> getlstACP(){
        
                 TotalPagesDisp = 1;
               
               
            if(getACPResultSize() > pageSize)
           {
                 List<wrapperACP> my_plist = new List<wrapperACP>();
                 npages = getACPResultsize()/pagesize;
                 remainder = getACPResultsize() - (pageSize*npages);   
                 TotalPagesDisp = 1;
                    if(getACPResultsize() <= pageSize )
                    { 
                      TotalPagesDisp= 1; 
                    }          
                    else if(((getACPResultsize()/(pageSize*1.0) )  - (getACPResultsize()/pageSize )) > 0.0 )
                    {
                                               
                      //remainder = getACLResultsize() - (pageSize*npages);   
                         TotalPagesDisp = (getACPResultsize()/pageSize) + 1 ;
                    } 
                   else
                    {
                        TotalPagesDisp= getACPResultsize()/pageSize;
                    }
                 
                    
                  for (integer i=0; i<pagesize; i++)
                  {
                     system.debug('Sans1'+ acpage+'pg'+ pagesize+ 'size' + getACLResultsize());
                   
                     if(((acpage-1)*pagesize +i) < getACPResultsize())
                      
                     my_plist.add(lstACP[(acpage-1)* pageSize + i]); 
                   }
                return my_plist;
         } 
          return lstACP;
         }
         
         public List<wrapperACL> getlstACL(){
       
           TotalPagesDisp = 1;
           pageSize = pages;
              
            if(getACLResultSize() > pageSize)
           {                                     
                List<wrapperACL> my_plist = new List<wrapperACL>();
                
                 npages = getACLResultsize()/pagesize;
                 remainder = getACLResultsize() - (pageSize*npages);   
                 TotalPagesDisp =1;
                    if(getACLResultsize() <= pageSize )
                    { 
                      TotalPagesDisp= 1; 
                    }          
                    else if(((getACLResultsize()/(pageSize*1.0) )  - (getACLResultsize()/pageSize )) > 0.0 )
                    {
                      //remainder = getACLResultsize() - (pageSize*npages);   
                      TotalPagesDisp= (getACLResultsize()/pageSize) + 1 ; 
                    } 
                   else
                    {
                           TotalPagesDisp = getACLResultsize()/pageSize;
                    }
                    
                 for (integer i=0; i<pagesize; i++)
                  {
                        pageSize = pages; 
                       system.debug('Sans2'+ acpage+'pg'+ pagesize+ 'size' + getACLResultsize());                                        
                      if(acpage==0){acpage=1;}
                     if(((acpage-1)*pagesize +i) < getACLResultsize())
                       
                      my_plist.add(lstACL[(acpage-1)* pageSize + i]);
                      
                   } 
                return my_plist; 
         } 
          return lstACL;
         }      
             
        public Renewal_CRVController(ApexPages.StandardController controller) {
         
          pages = 5 ;   
          acpage = 1;

          npages = 1; 
          remainder = 0;   
          activeContract = (Active_Contract__c)controller.getRecord(); 
          lstACP = new List<wrapperACP>();
          if(activeContract.Id != NULL ){
            activeContract = [Select Id, name, Account__c, Sold_to_party__c,Renewal_Currency__c,Segmentation__c From Active_Contract__c where Id=:activeContract.Id ]; 
            if(activeContract.Account__c != NULL){
              fetchRenewals(activeContract.Account__c);
            }
            atvContSegmention =activeContract.Segmentation__c;
            //totalValuationAnnualized=activeContract.Valuation_Annualized__c;
            fetchACP();
            fetchACL();  
          }
          fetchReasonsForInvl();
          fetchSegChangeReason();
          
        }
        //Fetch all active contract products those are associated with active contract.
        public void fetchACP(){
          lstACP = new List<wrapperACP>();
          List<Active_Contract_Product__c> lst = [Select Renewal_Product__c, Renewal_Name__c, 
                                   Product__c, Renewal_Product__r.Renewal__c,Product__r.Name, OCV__c, Name, Segmentation__c, Expected_Close_Date__c, Active_Contract__c, 
                                   AOCV__c,Reason_for_invalidation__c,Segmentation_Change_Reason__c,Pre_Segmentation__c
                            From Active_Contract_Product__c 
                            where Active_Contract__c = : activeContract.Id];
                            
             for(Active_Contract_Product__c acp:lst){
               lstACP.add(new wrapperACP(false,acp));          
             }
        }

        // Fetch all Renewals that are associated to the same account and currency should be same at both levels.
        public void fetchRenewals(Id accountId){
            lstRenewals = new list<Selectoption>();
            lstRenewals.add(new Selectoption('None','--None--'));      
            Renewal__c[] rnwls = [Select Name, Id  From Renewal__c where Account__c=:accountId and Renewal_Currency__c = : activeContract.Renewal_Currency__c];
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
            lstReasonForInvalidate.add(new Selectoption('Invalid - Zero Dollar Contract','Invalid - Zero Dollar Contract'));       
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
       } 
       
       public List<SelectOption> getPageno() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('5','5'));
            options.add(new SelectOption('10','10'));
            options.add(new SelectOption('15','15'));
            options.add(new SelectOption('25','25'));
            options.add(new SelectOption('50','50'));
            options.add(new SelectOption('100','100'));
            options.add(new SelectOption('200','200'));
            
            return options;
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
         
         
         //Valuation_Annualized__c,
         public void fetchACL(){
          lstACL = new List<wrapperACL>();
             //added Material TARR merha02
          List<Active_Contract_Line_Item__c> lst = [Select Id,curr_ann_exist_maint_cont_ren_only__c,Sales_Document_Item__c,material__c,Name,Renewal_Valuation_Type__c,Contracted_Renewal_Amount__c,Increase_formula__c,
                                                    Raw_Maintenance_LC__c,Current_Annu_Existing_Maintenance__c,Contractual_Cap_Percentage__c,description__c,AOCV__c,
                                                    Material_TARR_LC__c,ATTRF_CRV__c,OCV__c,Installation_Date__c,Dismantling_Date__c,Business_Transaction_Type_for_FT_text__c,//Transaction_Type__c,
                                                    Raw_Maint_Calc_LC__c,Orig_Installation_Date__c,Orig_Dismantle_Date__c,Orig_Annual_OCV_LC__c,Adjusted_ATTRF_LC__c,Orig_ATTRF_LC__c, Contract_Product__r.Active_Contract__r.page_no__c,Contract_Product__r.Active_Contract__r.Total_Page_No__c                                                                                               
                                                    From Active_Contract_Line_Item__c  
                                                    where Contract_Product__r.Active_Contract__c = : activeContract.Id
                                                    order by Sales_Document_Item__c
                                                   ];
                           
                 for(Active_Contract_Line_Item__c acl:lst){
                    //if(acl.Raw_Maintenance_LC__c ==null )
                    //acl.Raw_Maintenance_LC__c=acl.Raw_Maint_Calc_LC__c;
                    //if(acl.TRR__c==null)
                    //acl.TRR__c=acl.AOCV__c;
                    lstACl.add(new wrapperACL(acl));//false,    
                    pageNO_restored =Integer.ValueOf(acl.Contract_Product__r.Active_Contract__r.page_no__c);
                    Total_pageNO_restored =Integer.ValueOf(acl.Contract_Product__r.Active_Contract__r.Total_Page_No__c);
                     
                 }
              }
        
        public string errMesg{get;set;} 
        
        public void unload(){
        
        List<Active_Contract__c> AC_list = new List<Active_Contract__c>();
        AC_list = [select Page_No__c,Total_Page_No__c from Active_Contract__c where id =: activeContract.Id];
        if(AC_list.size()>0){
        AC_list[0].Page_No__c =null;
        AC_list[0].Total_Page_No__c =null;
        update AC_list;} 
        }
         
        public Pagereference saveACL(){
            
             errMesg = '';  //danva1234
             //set<string> selACLs = new set<string>();
             List<Active_Contract_Line_Item__c> lst = new List<Active_Contract_Line_Item__c>();         
             List<Active_Contract__c> lstAC_New = new List<Active_Contract__c>();
             
            
               lstAC_New = [select Page_No__c,curr_ann_exist_maint_cont_ren_only__c,Contracted_Renewal_Amount_LC__c from Active_Contract__c where id =: activeContract.Id];
               lstAC_New[0].curr_ann_exist_maint_cont_ren_only__c = 0;
               lstAC_New[0].Page_No__c = acpage;
               lstAC_New[0].Total_Page_No__c = pages;
            sumTot = 0;
             for(wrapperACL wacl: lstACL)
               {           
                    //lst.add(wacl.acl); modfified by subsa03       
                    if(wacl.acl.Contracted_Renewal_Amount__c == null || wacl.acl.Contracted_Renewal_Amount__c == 0 )
                    {
                        //wacl.acl.Contract_Product__r.curr_ann_exist_maint_cont_ren_only__c=0;
                        //lstACP[0].curr_ann_exist_maint_cont_ren_only__c = 0;
                    }
                    else
                    {                      
                        lstAC_New[0].curr_ann_exist_maint_cont_ren_only__c = lstAC_New[0].curr_ann_exist_maint_cont_ren_only__c + wacl.acl.Current_Annu_Existing_Maintenance__c; 
                        sumTot = sumTot + wacl.acl.Contracted_Renewal_Amount__c;
                    }   
               }
        
            for(wrapperACL wacl: lstACL)
            {                   
                     wacl.acl.curr_ann_exist_maint_cont_ren_only__c =  lstAC_New[0].curr_ann_exist_maint_cont_ren_only__c ;                                          
                     wacl.acl.Contracted_Renewal_Amount_AC__c =  sumTot;
                     lst.add(wacl.acl);                                          
            }

            if(lst.size()>0){
                update lst; 
                         
            }

            if(lstAC_New.size() > 0)
            {
              update lstAC_New;
            }
            
            fetchACL();
          //  return  new pagereference('/apex/Renewal_CRV_Process?test=demo&id='+activeContract.Id);
            return null;   
        }
       /* //danva01
        public Pagereference GoToPageNumber(){        
            return null;   
        }    */       
         
           
                          
       public boolean getACLHasNext() {
             pageSize = pages;
                 system.debug('chk' + pageSize);           
             if(((npages == acpage)&&(TotalPagesDisp==0)) || getACLResultSize() == 0 || getACLResultSize() < pageSize || (acpage*pageSize) >=getACLResultSize()|| errorFlag == true)
                return false;
            else    
                return true;
        }

        public Boolean getACLHasPrevious() {
             pageSize = pages;        
            if( getACLResultSize() == 0 || acpage == 1 || errorFlag == true)
                return false;
            else
                return true;    
        }
        
        public boolean getACPHasNext() {
                 pageSize = pages;
             if(((npages == acpage)&&(remainder==0)) || getACPResultSize() == 0 || getACPResultSize() < pages || (acpage*pageSize) >=getACPResultSize()|| errorFlag == true)
                return false;
            else    
                return true;
        }

        public Boolean getACPHasPrevious() {
            if( getACPResultSize() == 0 || acpage == 1 || errorFlag == true)
                return false;
            else
                return true;    
        }
              //modified by subsa03                  
       public Integer getPageSize() {  
              // return pageSize;
              return pages;   
        }           
               
        public void setPageSize(Integer pages) {
               if(pages != pageSize)
                {       
                    acpage =1;
                    pageSize = pages;
                }
       } 
        public void next() {
               acpage +=1;
               
        }
      
        public void previous() {
               acpage-=1;
        }
        public Integer getACPResultSize() {
            if(lstACP == null)
                return 0;
            else
                return lstACP.size();
       }
       public Integer getACLResultSize() {
            if(lstACL == null)
                return 0;
            else
                return lstACL.size();
       }
     }