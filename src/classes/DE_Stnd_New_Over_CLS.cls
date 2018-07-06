public class DE_Stnd_New_Over_CLS {
    
       
    public DE_Stnd_New_Over_CLS(ApexPages.StandardController controller) {

    }
    
     public PageReference redir(){
     
     PageReference newPage = null; 
     
     String recid = ApexPages.currentPage().getParameters().get('RecordType');
     String TechRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Technology Partner').getRecordTypeId();
     String SupportRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Support Account').getRecordTypeId();
     String GenericRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Generic Record Type').getRecordTypeId();
     
     String TechRecId15Digit = TechRecId.substring(0, 15);
     String SupportRecId15Digit = SupportRecId .substring(0, 15);
     string GenericRecId15Digit = GenericRecId.substring(0, 15);
     
      if(recid!=null&& recid!=''&&recid.equals(TechRecId15Digit))
     {
      newPage = new Pagereference('/001/e?retURL=/001/o&RecordType='+ApexPages.currentPage().getParameters().get('RecordType')+'&ent=Account'); 
      newPage.getParameters().put('nooverride', '1');  
       
     } //included the else if condition to support Support Record type 
     else if(recid!=null&& recid!=''&&recid.equals(SupportRecId15Digit)) {
         newPage = new Pagereference('/001/e?retURL=/001/o&RecordType='+ApexPages.currentPage().getParameters().get('RecordType')+'&ent=Account'); 
         newPage.getParameters().put('nooverride', '1');  
         
     } //end of change related to Support record type .
     else if(recid!=null&& recid!=''&&recid.equals(GenericRecId15Digit)){
         newPage = new Pagereference('/001/e?retURL=/001/o&RecordType='+ApexPages.currentPage().getParameters().get('RecordType')+'&ent=Account'); 
         newPage.getParameters().put('nooverride', '1');
              	
     }
     else
     {
       //search page
       // revist second
      newPage = new PageReference('/apex/DE_AccSearch_VFP');
      newPage.setRedirect(false);
      newPage.getParameters().put('fromPage', 'StandNew');
      
     }
       return newPage;
    }


}