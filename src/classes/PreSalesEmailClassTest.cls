/*
 * For Class = PreSalesEmailClass
 * Coverage = 100%.
 * Updated by SAMTU01
*/
@istest
public class PreSalesEmailClassTest {
    
    public static testMethod void testforEmailing(){
        Test.startTest();
            
          preSalesEmailClass.emailsubject('NA', 'Apj', 'AG', 'USA', 'Partner-GSI');//added last parameter(cov model) in method as part of US334584 by SAMTU01
          preSalesEmailClass.emailsubjectAdd('NA', 'Apj', 'AG', 'USA', 'Partner-GSI');//added last parameter(cov model) in method as part of US334584 by SAMTU01
        
           preSalesEmailClass.emailsubjectcancel('NA', 'Apj', 'AG', 'USA', 'Partner-GSI');//added last parameter(cov model) in method as part of US334584 by SAMTU01
            preSalesEmailClass.emailsubjectremoval('NA', 'Apj', 'AG', 'USA', 'Partner-GSI');//added last parameter(cov model) in method as part of US334584 by SAMTU01
            preSalesEmailClass.emailbody('TestOpp', '1234', 'salman', 'testAccount', 'TestNum');//added last parameter (presales req number) in method as part of US331730 by SAMTU01
            preSalesEmailClass.presalesrequestpagelink('050024534567','');
            preSalesEmailClass.presalesremovepagelink('050024534567', '');
            preSalesEmailClass.presalescancelpagelink('050024534567', '');
       Test.stopTest();
        
        
        
    }

}