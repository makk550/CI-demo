/* Code Coverage 82% */

@isTest
public class ACL_Increase_calc_Test {
    
    static testMethod void CalculateIncStep1_2_3Test() 
    {
        Test.startTest();
        		Date Y07_M1=Date.newInstance(2007,1,2);
            	Date Y08_M4=Date.newInstance(2008,4,1);
                Date Y09_M10=Date.newInstance(2009,10,1);
                Date Y13_M1=Date.newInstance(2013,1,1);     //Used in Dismantling_Date__c comparisions
                Date Y08_M4_2=Date.newInstance(2008,4,2);
                Date Y13_M7=Date.newInstance(2013,7,1);     //Used in Dismantling_Date__c comparisions
                Date Y10_M7=Date.newInstance(2010,7,1);
                Date Y18_M4=Date.newInstance(2018,4,1);     //Used in Dismantling_Date__c comparisions
                Date Y10_M7_2=Date.newInstance(2010,7,2);
                Date Y10_M6=Date.newInstance(2010,6,30);
                Date Y18_M3=Date.newInstance(2018,3,31);
                Date Y13_M7_3=Date.newInstance(2013,7,3);
                Date Y08_M3=Date.newInstance(2008,3,31);   
                Date Y07_M1_1=Date.newInstance(2007,1,1);
                Date Y13_M7_2=Date.newInstance(2013,7,2);
        
         SystemIdUtility.skipAccount = true;
        SystemIdUtility.skipAccountOnMIPSUpdate = true;    
        FutureMethod_Assign_support_Generic.isFutureRunning = false;
        SystemIdUtility.skipProductTriggers = true;
        
        Schema.DescribeSObjectResult accresult = Schema.SObjectType.Account;        
        Map<String,Schema.RecordTypeInfo> accRecType = accresult.getRecordTypeInfosByName();          
        
        id res = accRecType.get('Reseller/Distributor Account').getRecordTypeId();
        // id res = accRecType.get('CA Enterprise Account').getRecordTypeId();
        account a = new account(name ='Test Account', recordtypeid =res);
        a.Region_Country__c='PS_FSI';
        
        a.customer_Category__c= 'Reseller';
        a.hq__c= true;
        a.Commercial_Account_Name__c='test 11111114'  ;
        a.Commercial_ID__c= 'test 11111115';
        a.Country_Picklist__c= 'APJ';
        a.GEO__c='APJ';
        a.Sales_Area__c= 'JAPAN01';
        a.Sales_Region__c= 'JAPAN01';
        a.Segment__c='xxx';
        
        insert a;
        
        account a2 = new account(name ='Test Account', recordtypeid =res);
        a2.Region_Country__c='PS_FSI';
        
        a2.customer_Category__c= 'Reseller';
        a2.hq__c= true;
        a2.Commercial_Account_Name__c='test 11111114'  ;
        a2.Commercial_ID__c= 'test 11111115';
        a2.Country_Picklist__c= 'APJ';
        a2.GEO__c='APJ';
        a2.Sales_Area__c= 'JAPAN';
        a2.Sales_Region__c= 'JAPAN';
        a2.Segment__c='xxx';
        
        insert a2;
        
        Renewal_Currency__c rc1=new Renewal_Currency__c(Name='test_dollar',CurrencyIsoCode='USD');
        insert rc1;
        Renewal_Currency__c rc2=new Renewal_Currency__c(Name='test_dollar',CurrencyIsoCode='EUR');
        insert rc2;
        
        List<Active_Contract__c> insertac=new list<Active_Contract__c>();
        
        Active_Contract__c ac1=new Active_Contract__c(Name='ACL_Test01',Header_Install_Date__c=Y07_M1);
        insertac.add(ac1);
        Active_Contract__c ac2=new Active_Contract__c(Name='ACL_Test02');
        insertac.add(ac2);
        // conditions satisfying data
        Active_Contract__c ac3=new Active_Contract__c(Name='ACL_Test03',Header_Install_Date__c=Y07_M1,Renewal_Currency__c=rc1.id,GSA_Pricing__c=false,Account__c=a.id);
        insertac.add(ac3);
         Active_Contract__c ac4=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4,Renewal_Currency__c=rc1.id,GSA_Pricing__c=true,Account__c=a.id);
        insertac.add(ac4);
        Active_Contract__c ac5=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4_2,Renewal_Currency__c=rc1.id,GSA_Pricing__c=true,Account__c=a.id);
        insertac.add(ac5);
        Active_Contract__c ac6=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4,Renewal_Currency__c=rc1.id,GSA_Pricing__c=true,Account__c=a.id);
        insertac.add(ac6);
        Active_Contract__c ac7=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4,Renewal_Currency__c=rc2.id,GSA_Pricing__c=true,Account__c=a.id);
        insertac.add(ac7);
        Active_Contract__c ac8=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4_2,Renewal_Currency__c=rc1.id,GSA_Pricing__c=true,Account__c=a2.id);
        insertac.add(ac8); 
        Active_Contract__c acx1=new Active_Contract__c(Name='ACL_Test03',Header_Install_Date__c=Y08_M4_2,Renewal_Currency__c=rc1.id,GSA_Pricing__c=false,Account__c=a.id);
        insertac.add(acx1);
        Active_Contract__c acx2=new Active_Contract__c(Name='ACL_Test03',Header_Install_Date__c=Y08_M4_2,Renewal_Currency__c=rc2.id,GSA_Pricing__c=true,Account__c=a2.id);
        insertac.add(acx2);
         Active_Contract__c acx3=new Active_Contract__c(Name='ACL_Test03',Header_Install_Date__c=Y08_M4_2,Renewal_Currency__c=rc2.id,GSA_Pricing__c=false,Account__c=a2.id);
         insertac.add(acx3);
        Active_Contract__c acx4=new Active_Contract__c(Name='ACL_Test03',Header_Install_Date__c=Y07_M1,Renewal_Currency__c=rc2.id,GSA_Pricing__c=false,Account__c=a.id);
         insertac.add(acx4);
        Active_Contract__c acx5=new Active_Contract__c(Name='ACL_Test03',Header_Install_Date__c=Y10_M7_2,GSA_Pricing__c=false,Account__c=a.id);
        insertac.add(acx5);
        Active_Contract__c acx6=new Active_Contract__c(Name='ACL_Test03',Header_Install_Date__c=Y10_M6,GSA_Pricing__c=true,Account__c=a2.id);
        insertac.add(acx6);
        Active_Contract__c st3ac1=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y07_M1_1,Renewal_Currency__c=rc1.id,GSA_Pricing__c=false,Account__c=a.id);
        insertac.add(st3ac1);
        Active_Contract__c st3ac2=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y07_M1_1,Renewal_Currency__c=rc2.id,GSA_Pricing__c=false,Account__c=a.id);
        insertac.add(st3ac2);
        Active_Contract__c st3ac3=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y09_M10,GSA_Pricing__c=true,Account__c=a.id);
        insertac.add(st3ac3);
        Active_Contract__c st3ac4=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y09_M10,GSA_Pricing__c=true,Account__c=a2.id);
        insertac.add(st3ac4);
        Active_Contract__c st3ac5=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4,GSA_Pricing__c=true,Account__c=a2.id,Renewal_Currency__c=rc1.id);
        insertac.add(st3ac5);
        Active_Contract__c st3ac6=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4,GSA_Pricing__c=true,Account__c=a2.id,Renewal_Currency__c=rc2.id);
        insertac.add(st3ac6);
        Active_Contract__c st3ac7=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4,GSA_Pricing__c=false,Account__c=a2.id,Renewal_Currency__c=rc2.id);
        insertac.add(st3ac7);
        Active_Contract__c st3ac8=new Active_Contract__c(Name='ACL_Test04',Header_Install_Date__c=Y08_M4,GSA_Pricing__c=false,Account__c=a.id,Renewal_Currency__c=rc1.id);
        insertac.add(st3ac8);
        
        insert insertac;
        
        list<Active_Contract_Product__c> insertacp=new list<Active_Contract_Product__c>();
        Active_Contract_Product__c acp1=new Active_Contract_Product__c(name='acp_test01',Active_Contract__c=ac1.id);
        insertacp.add(acp1);
        Active_Contract_Product__c acp2=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=ac2.id);
        insertacp.add(acp2);
        Active_Contract_Product__c acp3=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=ac3.id);
        insertacp.add(acp3);
        Active_Contract_Product__c acp4=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=ac4.id);
        insertacp.add(acp4);
        Active_Contract_Product__c acp5=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=ac5.id);
        insertacp.add(acp5);
        Active_Contract_Product__c acp6=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=ac6.id);
        insertacp.add(acp6);
        Active_Contract_Product__c acp7=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=ac7.id);
        insertacp.add(acp7);
        Active_Contract_Product__c acp8=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=ac8.id);
        insertacp.add(acp8);
        Active_Contract_Product__c acp9=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=acx6.id);
        insertacp.add(acp9);
        Active_Contract_Product__c st3acp1=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=st3ac1.id);
        insertacp.add(st3acp1);
        Active_Contract_Product__c st3acp2=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=st3ac2.id);
        insertacp.add(st3acp2);
        Active_Contract_Product__c st3acp3=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=st3ac3.id);
        insertacp.add(st3acp3);
        Active_Contract_Product__c st3acp4=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=st3ac4.id);
        insertacp.add(st3acp4);
        Active_Contract_Product__c st3acp5=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=st3ac5.id);
        insertacp.add(st3acp5);
        Active_Contract_Product__c st3acp6=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=st3ac6.id);
        insertacp.add(st3acp6);
        Active_Contract_Product__c st3acp7=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=st3ac7.id);
        insertacp.add(st3acp7);
        Active_Contract_Product__c st3acp8=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=st3ac8.id);
        insertacp.add(st3acp8);
        
        insert insertacp;
        
        Product_Material__c pm1=new Product_Material__c(name='pm_test01',Platform_Category__c='Mainframe');
        insert pm1; 
        Product_Material__c pm2=new Product_Material__c(name='pm_test01',Platform_Category__c='not Mainframe');
        insert pm2;
        
        list<Active_Contract_Line_Item__c> insertacl=new list<Active_Contract_Line_Item__c>();
        Active_Contract_Line_Item__c acl1=new Active_Contract_Line_Item__c(Contract_Product__c=acp1.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(acl1);
        Active_Contract_Line_Item__c acl2=new Active_Contract_Line_Item__c(Contract_Product__c=acp2.id,Name='acl_test02',Product_Material__c=pm1.id);
        insertacl.add(acl2);
        Active_Contract_Line_Item__c acl3=new Active_Contract_Line_Item__c(Contract_Product__c=acp3.id,Name='acl_test02',Product_Material__c=pm1.id);
        insertacl.add(acl3);
        Active_Contract_Line_Item__c acl4=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1 -1,Contract_Product__c=acp4.id,Name='acl_test02',Product_Material__c=pm1.id);
        insertacl.add(acl4);
        Active_Contract_Line_Item__c acl5=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1+1,Contract_Product__c=acp5.id,Name='acl_test02',Product_Material__c=pm1.id);
        insertacl.add(acl5);
        Active_Contract_Line_Item__c acl6=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M7,Contract_Product__c=acp6.id,Name='acl_test02',Product_Material__c=pm1.id);
        insertacl.add(acl6);
        Active_Contract_Line_Item__c acl7=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1-1,Contract_Product__c=acp5.id,Name='acl_test02',Product_Material__c=pm2.id);
        insertacl.add(acl7);
        Active_Contract_Line_Item__c acl8=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1+1,Contract_Product__c=acp5.id,Name='acl_test02',Product_Material__c=pm2.id);
        insertacl.add(acl8);
        Active_Contract_Line_Item__c acl9=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M7,Contract_Product__c=acp5.id,Name='acl_test02',Product_Material__c=pm2.id);
        insertacl.add(acl9);
        Active_Contract_Line_Item__c acl10=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M7,Contract_Product__c=acp7.id,Name='acl_test02',Product_Material__c=pm2.id);
        insertacl.add(acl10);
        Active_Contract_Line_Item__c acl11=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1+1,Contract_Product__c=acp8.id,Name='acl_test02',Product_Material__c=pm1.id);
        insertacl.add(acl11);
        Active_Contract_Line_Item__c acl12=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1-1,Contract_Product__c=acp8.id,Name='acl_test02',Product_Material__c=pm2.id);
        insertacl.add(acl12);
        
        
        
        
        Active_Contract_Product__c acpx1=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=acx1.id);
        insert acpx1;
        Active_Contract_Line_Item__c aclx1=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1-1,Contract_Product__c=acpx1.id,Name='acl_test01',Product_Material__c=pm1.id);
       insertacl.add(aclx1);
        
        
        Active_Contract_Product__c acpx2=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=acx2.id);
        insert acpx2;
        Active_Contract_Line_Item__c aclx2=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1+1,Contract_Product__c=acpx2.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(aclx2);
        
         
        Active_Contract_Product__c acpx3=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=acx3.id);
        insert acpx3;
        Active_Contract_Line_Item__c aclx3=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1+1,Contract_Product__c=acpx3.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(aclx3);
        
        
        Active_Contract_Product__c acpx4=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=acx4.id);
        insert acpx4;
        Active_Contract_Line_Item__c aclx4=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1-1,Contract_Product__c=acpx4.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(aclx4);
        
        
        Active_Contract_Product__c acpx5=new Active_Contract_Product__c(name='acp_test02',Active_Contract__c=acx5.id);
        insert acpx5;
        Active_Contract_Line_Item__c aclx5=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1+1,Contract_Product__c=acpx5.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(aclx5);
        
        Active_Contract_Line_Item__c aclx6=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1+1,Contract_Product__c=acp9.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(aclx6);    
    
        
        Active_Contract_Line_Item__c step3_1=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M1,Contract_Product__c=st3acp1.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(step3_1);
        Active_Contract_Line_Item__c step3_2=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y18_M4,Contract_Product__c=st3acp2.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(step3_2);
        Active_Contract_Line_Item__c step3_3=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y18_M4,Contract_Product__c=st3acp3.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(step3_3);
        Active_Contract_Line_Item__c step3_4=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y18_M4,Contract_Product__c=st3acp4.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(step3_4);
        Active_Contract_Line_Item__c step3_5=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y18_M4-1,Contract_Product__c=st3acp5.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(step3_5);
        Active_Contract_Line_Item__c step3_6=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y13_M7,Contract_Product__c=st3acp6.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(step3_6);
        Active_Contract_Line_Item__c step3_7=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y18_M4,Contract_Product__c=st3acp7.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(step3_7);
        Active_Contract_Line_Item__c step3_8=new Active_Contract_Line_Item__c(Dismantling_Date__c=Y18_M4,Contract_Product__c=st3acp8.id,Name='acl_test01',Product_Material__c=pm1.id);
        insertacl.add(step3_8);
        
        insert insertacl;
        
         Test.stopTest();  
        
        Set<id> cpids=new set<id>();
        cpids.add(acp1.id);
        cpids.add(acp2.id);
        cpids.add(acp3.id);
        cpids.add(acp4.id);
        cpids.add(acp5.id);
        cpids.add(acp6.id);
        cpids.add(acp7.id);
        cpids.add(acp8.id);
        
        list<Active_Contract_Line_Item__c> acllist=new list<Active_Contract_Line_Item__c>();
        //acllist.add(acl1);
        //acllist.add(acl2);
        
        //list<Active_Contract__c> pac_list=[select from Active_Contract__c];
        
        acllist=[select Name,Contract_Product__c,Product_Material__c,Renewal_Currency_Name__c,Platform__c,Dismantling_Date__c from Active_Contract_Line_Item__c];
        
       
        
        ACL_Increase_calc pp=new ACL_Increase_calc();
        pp.CalculateIncStep1_2_3(cpids,acllist);
        
    }

}