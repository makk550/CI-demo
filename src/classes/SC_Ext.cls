/************************************************************************** \ 
   @ Author : Vamshi Rajarapu. 
   @ Date : 16/04/14 
   @ Test File :Initial Version 
   @ Description : This class is to display Case details on console.
 
 @ Audit Trial : Repeating block for each change to the code
       @ Last Modified By   : D.S Sandeep Reddy    
       @ Last Modified On   :  06/07/14 
       @ Last Modified Reason     :  Updated code for pagination.
       

  @Last Modified on 06/07/14 by D.S Sandeep Reddy to Update pagination.
 ****************************************************************************/

Public class SC_Ext {
    
 Public case caRec {get;set;}
 Public Integer CountTotalRecords =0;
 Public Integer OffsetSize = 0;
 Private Integer QueryLimit = 10;
 Public String blkRender{get;set;}
 Public String titleHeader{get;set;}
 
   public SC_Ext(ApexPages.StandardController controller) {
     String parentUrl = ApexPages.currentPage().getParameters().get('parentUrl');
     String url = ApexPages.currentPage().getParameters().get('id');
     blkRender=ApexPages.currentPage().getParameters().get('blkRender');
     caRec =(Case)controller.getRecord();        
     if(blkRender=='SC'){              
        CountTotalRecords=[select count() from Special_Conditions__c where Site_Association__c =:caRec.Site_Association__c];
        titleHeader ='Special Conditions';
     }   
     else if(blkRender=='CTS'){              
        CountTotalRecords=[select count() from Case where Site_Association__c =:caRec.Site_Association__c AND CreatedDate = LAST_N_DAYS:180];
        titleHeader ='Cases with same Site';
     }   
     else if(blkRender=='CTC'){     
          CountTotalRecords=[select count() from Case where ContactId =:caRec.Contactid AND CreatedDate = LAST_N_DAYS:180];
          titleHeader ='Cases with same Contact';
     }       
     else if(blkRender=='CTSP'){
         CountTotalRecords=[select count() from Case where Site_Association__c =:caRec.Site_Association__c and Product__c=:caRec.Product__c AND CreatedDate = LAST_N_DAYS:180];
         titleHeader ='Cases with same Site/Product';  
     }     
     else if(blkRender=='EOS'){           
         CountTotalRecords=[select count() from Product_EOS_EOL_Calendar__c where name =:caRec.Product_Code__c];
         titleHeader ='EOS and EOL Calendar'; 
     }                           
    } 


    Public List<Special_Conditions__c> getSpecialConditions() {
      List<Special_Conditions__c > splCondLst=[select Site_Association__c,Active__c,Start_Date__c,End_Date__c,Special_Condition__c,SPC_Description__c,SPC_Details__c from Special_Conditions__c where Site_Association__c =:caRec.Site_Association__c ORDER BY Active__c DESC, Start_Date__c ASC limit :QueryLimit offset :OffsetSize] ; 
      return splCondLst;
    }
    
    Public List<Case> getCasesTiedToSite() {
       List<Case> caseLst =[select CaseNumber,Description,Site_Association__c,Title__c,Severity__c,CreatedDate,Status,Owner.Name,Contact.name,Next_Action__c,CA_Product_Controller__c,Component_Code__c,Product_Release__c,Product_Service_Pack__c,Age_of_a_case__c,Subject,Business_Impact__c,ClosedDate from Case where Site_Association__c =:caRec.Site_Association__c AND CreatedDate = LAST_N_DAYS:180 ORDER BY CreatedDate DESC limit :QueryLimit offset :OffsetSize];
        return caseLst;
    }
    
    Public List<Case> getCasesTiedToContact() {
        List<Case> caseLst =[select CaseNumber,Contactid,Site_Association__c,Title__c,Severity__c,CreatedDate,Status,Owner.Name,Contact.name,Next_Action__c,CA_Product_Controller__c,Component_Code__c,Product_Release__c,Product_Service_Pack__c,Age_of_a_case__c,Subject,Business_Impact__c,ClosedDate from Case where ContactId =:caRec.Contactid AND CreatedDate = LAST_N_DAYS:180 ORDER BY CreatedDate DESC limit :QueryLimit offset :OffsetSize];
        return caseLst;
    }
    
    Public List<Case> getCasesTiedToSiteNdPrd() {
        List<Case> caseLst =[select CaseNumber,Product__c,Description,Site_Association__c,Title__c,Severity__c,CreatedDate,Status,Owner.Name,Contact.name,Next_Action__c,CA_Product_Controller__c,Component_Code__c,Product_Release__c,Product_Service_Pack__c,Age_of_a_case__c,Subject,Business_Impact__c,ClosedDate from Case where Site_Association__c =:caRec.Site_Association__c and Product__c=:caRec.Product__c AND CreatedDate = LAST_N_DAYS:180 ORDER BY CreatedDate DESC limit :QueryLimit offset :OffsetSize];
        return caseLst;
    }
    
    Public List<Product_EOS_EOL_Calendar__c> getEosNdEol() {
        List<Product_EOS_EOL_Calendar__c> eosLst=[select Id,Name,Drop_Support_Date_or_Stabilization_Date__c,Event_Type__c,Notice_Date__c,New_Release__c,New_Release_GA_Date__c,Notice_Link__c,Product_Analyst__c,Product_Material__c,Product_Name__c,Release__c,SAP_ID__c,Special_Notes__c,
                             Support_Contact_Level_2_Manager__c,Support_Contacts_Level_1_Manager__c from Product_EOS_EOL_Calendar__c where name =:caRec.Product_Code__c limit :QueryLimit offset :OffsetSize];
        return eosLst;
    }
    
    public Boolean getDisablePrevious(){
            if(OffsetSize>0){
                return false;
            }
            else return true;
        }
     
    public Boolean getDisableNext() {
        if (OffsetSize + QueryLimit < CountTotalRecords){
            return false;
        }
        else return true;
    }
 
    public void Next() {
        OffsetSize = OffsetSize+QueryLimit;
    }
    
    public void Previous() {
        OffsetSize = OffsetSize-QueryLimit;
    }
    
    public void FirstPage()
    {
     OffsetSize = 0;
    }
    public void LastPage()
    {
     OffsetSize = CountTotalRecords-math.mod(CountTotalRecords,QueryLimit);
    }   
}