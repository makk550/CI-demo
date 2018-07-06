@isTest
public class testEmailRule_Ext{
   public static testmethod void testMeth_EmailRule(){
        List<User> uL = [select id,email from user where isActive=true and email like '%@ca.com%' limit 1000];              
        Deal_Registration_Program__c drp = new Deal_Registration_Program__c();
        drp.Name='asdfssd';
        drp.Partner_Friendly_Name__c = 'asdassdasdasdadasasd';
        drp.Description__c = 'aasdasdadassdasdsd';
        drp.Program_Manager__c = uL[0].Id;
        drp.First_Approver__c = null;
        for(User u:uL){
                drp.Program_Manager__c = u.Id;
                drp.First_Approver__c = drp.Program_manager__c;
                if(drp.Program_Manager__c == null)
                  drp.Program_Manager__c = '00530000003s5E2';
        }
        drp.Min_Deal_Value__c = 123;
        drp.Max_Deal_value__c = 4562;
        drp.Start_Date__C = system.today();
        drp.End_Date__C = system.today()+1;
        drp.Expiry_Days__c = 2;
        
        drp.CurrencyISOCode = 'PLN';
        drp.Opp_type__c = '1 Tier';
        drp.Deal_Program_Type__c = 'Solution Provider';
        drp.Geography__c = 'NA';
        insert drp;
        
        
        Email_Rule__c erObj = new Email_rule__c();
              erObj.Email_Capability__c = 'Deal Registration';
              erObj.Action__c = 'Approved';
			  erObj.Object__c = 'Opportunity';
              erObj.Deal_Registration_Program__c = drp.id;
        
        try{     
        insert erObj;
         Email_Recipient_Information__c eriObj = new Email_Recipient_Information__c();
         eriObj.Email_Rule__c = erObj.Id;
         eriObj.Field_API__c = 'End_User_Contact_E_mail__c';
         eriObj.Field_Label__c = 'End User Contact E-mail';
         insert eriObj;
        
        
        
        
        
        }catch(Exception e){
        System.debug('___d______'+e.getMessage());
        }
      ApexPages.StandardController email_ctrl = new Apexpages.StandardController(erObj);
      Email_Rule_Ext emailObj = new Email_Rule_Ext(email_ctrl);
 
         emailObj.addValues();
      emailObj.getsize1();
      emailObj.getsize2();
      emailObj.getMyPersonalTemplateOptions();
       emailObj.saverule();
    
     // emailObj.showFields();
      emailObj.removeValues();
     // emailObj.saveERI(erObj);
     
     erObj.Email_Capability__c = 'Deal Registration';
      emailObj.getMyPersonalTemplateOptions();
      
      
     erObj.Email_Template__c = 'Deal Reg Email to partner';
    
      erObj.Language__c = 'English';
      erObj.Action__c = 'Deal Won';
      
      emailObj.addValues();
      erObj.Object__c = 'Opportunity';
     
      emailObj.eri.Recipient_Type__c = 'Field';
      emailObj.showFields();
       emailObj.eri.Recipient_Type__c = 'User';
      emailObj.showFields();
     // emailObj.recipientString = 'raosu01';
      emailObj.addValues();
      emailObj.getsize1();
      emailObj.getsize2();
        emailObj.removeRecipents();
      //     emailObj.saverule();
        emailObj.saveERI(erObj.Id);
   }
}