@isTest
public class testMethods_Leads
{
    static testmethod void testLeadRouting()
    {
        RecordType rectype = [select ID,Name from RecordType where Name='CA Global Lead'];
        if(rectype!=null)
        {
            APJ_Direct_Lead_Routing__c apjrout1 = new APJ_Direct_Lead_Routing__c(Name='APJ_LR_1',Business_Unit__c='ISBU',Country__c='CN - CHINA',Account_Owner__c = true);
            APJ_Direct_Lead_Routing__c apjrout2 = new APJ_Direct_Lead_Routing__c(Name='APJ_LR_2',Business_Unit__c='MAINFRAME',Country__c='AU - AUSTRALIA',Account_Owner__c = true);
            APJ_Direct_Lead_Routing__c[] apjrout = new APJ_Direct_Lead_Routing__c[]{apjrout1,apjrout2};
            insert apjrout;
            LA_Direct_Lead_Routing__c larout1 = new LA_Direct_Lead_Routing__c(Name='LA_LR_1',Business_Unit__c='AUTOMATION',Country__c='CO - COLOMBIA',Lead_Source__c='APRIMO',Tactic__c='Live Activity',Area__c='Brazil',Territory__c='FEDERAL',Account_Owner__c = true);
            LA_Direct_Lead_Routing__c larout2 = new LA_Direct_Lead_Routing__c(Name='LA_LR_2',Business_Unit__c='SECURITY',Country__c='AU - AUSTRALIA',Lead_Source__c='APRIMO',Tactic__c='Live Activity',Area__c='Brazil',Territory__c='FEDERAL',Account_Team_Role__c='Area Alliance VP');
            LA_Direct_Lead_Routing__c[] larout = new LA_Direct_Lead_Routing__c[]{larout1,larout2};
            insert larout;
            NA_Direct_Lead_Routing__c narout1 = new NA_Direct_Lead_Routing__c(Name='NA_LR_1',Business_Unit__c='PDI',Country__c='CA - CANADA',Lead_Source__c='APRIMO',Tactic__c='Live Activity',Area__c='Canada',Territory__c='CANADA',Account_Owner__c = true);
            NA_Direct_Lead_Routing__c narout2 = new NA_Direct_Lead_Routing__c(Name='NA_LR_2',Business_Unit__c='IT Governance',Country__c='US - UNITED STATES',Lead_Source__c='APRIMO',Tactic__c='Live Activity',Area__c='WEST',Territory__c='WEST PACNW',Account_Team_Role__c='Area Alliance VP');
            NA_Direct_Lead_Routing__c[] narout = new NA_Direct_Lead_Routing__c[]{narout1,narout2};
            insert narout;
            EMEA_Direct_Lead_Routing__c emearout1 = new EMEA_Direct_Lead_Routing__c(Name='EMEA_LR_1',Business_Unit__c='PDI',Sub_Tactic__c='Web Tour',Country__c='AT - AUSTRIA',Lead_Source__c='APRIMO',Tactic__c='Live Activity',Area__c='France',Territory__c='FRANCE',Account_Owner__c = true);
            EMEA_Direct_Lead_Routing__c emearout2 = new EMEA_Direct_Lead_Routing__c(Name='EMEA_LR_2',Business_Unit__c='IT Governance',Sub_Tactic__c='Web Tour',Country__c='DZ - ALGERIA',Lead_Source__c='APRIMO',Tactic__c='Live Activity',Area__c='Germany',Territory__c='GERMANY',Account_Team_Role__c='Area Alliance VP');
            EMEA_Direct_Lead_Routing__c[] emearout = new EMEA_Direct_Lead_Routing__c[]{emearout1,emearout2};
            insert emearout;
            
            RecordType accrec = [select ID,Name from RecordType where Name='Account Team Covered Account' and SObjectType='Account'];
            Account acc = new Account(Name='Acc 1',GEO__c='NA',RecordTypeId=accrec.Id,Customer_Category__c='Enterprise',Enterprise_ID__c='ACC001',Enterprise_Account_Name__c='Ent Acc');
            insert acc;
            Lead naLead1 = new Lead(FirstName='lead1',LastName='test1',RecordTypeId = rectype.Id,Geo__c='NA',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='CA - CANADA',MKT_Territory__c='Canada',Sales_Territory__c='CANADA',Tactic__c='Live Activity');
            Lead naLead2 = new Lead(FirstName='lead2',LastName='test2',RecordTypeId = rectype.Id,Geo__c='NA',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='CA - CANADA',MKT_Territory__c='Canada',Sales_Territory__c='CANADA');
            Lead laLead1 = new Lead(FirstName='lead3',LastName='test3',RecordTypeId = rectype.Id,Geo__c='LA',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='AUTOMATION',Country_Picklist__c='CO - COLOMBIA',MKT_Territory__c='Brazil',Sales_Territory__c='FEDERAL',Tactic__c='Live Activity');
            Lead apjLead1 = new Lead(FirstName='lead4',LastName='test4',RecordTypeId = rectype.Id,Geo__c='APJ',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='ISBU',Country_Picklist__c='CN - CHINA');
            Lead emeaLead1 = new Lead(FirstName='lead5',LastName='test5',RecordTypeId = rectype.Id,Geo__c='EMEA',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='DZ - ALGERIA',MKT_Territory__c='Germany',Sales_Territory__c='GERMANY',Tactic__c='Live Activity');
            Lead emeaLead2 = new Lead(FirstName='lead6',LastName='test6',RecordTypeId = rectype.Id,Geo__c='EMEA',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@hotmail.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='IT Governance',Country_Picklist__c='DZ - ALGERIA',MKT_Territory__c='Germany',Sales_Territory__c='GERMANY',Tactic__c='Live Activity');
            
            Lead[] newLeads = new Lead[]{naLead1,naLead2,lalead1,apjlead1,emeaLead1,emeaLead2};
            insert newLeads;
            newLeads[0].RouteLeads__c = true; 
            newLeads[1].RouteLeads__c = true;
            newLeads[2].RouteLeads__c = true;
            newLeads[3].RouteLeads__c = true;
            newLeads[4].RouteLeads__c = true;
            newLeads[5].RouteLeads__c = true;
            update newLeads;
        }
    }
    static testMethod void Lead_Share_TriggerTest(){
    	RecordType rectype = [select ID,Name from RecordType where Name='CA Global Lead'];
    	Profile pr = [select id from Profile where Name = 'System Administrator' ];
     
	    User usr = new User(Alias = 'Dummy', Email='standarduser@ca.com', 
	    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
	    LocaleSidKey='en_US', Profileid=pr.Id ,TimeZoneSidKey='America/Los_Angeles',Eligible_to_receive_leads__c = TRUE,
	    UserName='DummyUser@ca.com');
	    Insert Usr;
	      
	      
    	RecordType accrec = [select ID,Name from RecordType where Name='Account Team Covered Account' and SObjectType='Account'];
        Account acc = new Account(Name='Acc 1',GEO__c='NA',Solution_Provider_CAM_PMFKey__c='chasa16',Lead_Champion__c=Usr.Id,RecordTypeId=accrec.Id,Customer_Category__c='Enterprise',Enterprise_ID__c='ACC001',Enterprise_Account_Name__c='Ent Acc');
        insert acc;
        Campaign c1 = new Campaign(Name ='CA-ITC',Status ='Planned',IsActive =True);
        insert c1;
        Lead naLead1 = new Lead(Campaign_ID__c=c1.id,CAPOPUpdatingFirstTime__c=false,PartnerAccount_ID__c='Test1',FirstName='lead1',LastName='test1',RecordTypeId = rectype.Id,Geo__c='NA',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='CA POP',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='CA - CANADA',MKT_Territory__c='Canada',Sales_Territory__c='CANADA',Tactic__c='Live Activity');
        insert naLead1;
        Campaign c2 = new Campaign(Name ='CA-ITC1',IsActive =True, Status ='Planned');
        insert c2;
        CampaignMember cm = new CampaignMember();
        cm.LeadId = naLead1.id;
        cm.CampaignId= c1.id;
        insert cm;
        
        naLead1.Campaign_ID__c=c2.Id;
        naLead1.PartnerAccount_ID__c=acc.Id;
        
        Test.starttest();
        
        try{ 
               update naLead1; 
         }
        catch(exception e)
         {
          }  
        RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('CA Indirect Lead');
        Id recIndirectLeadId = rec.RecordType_Id__c;
        Lead naLead2 = new Lead(Campaign_ID__c=c1.id,RTM__c='Solution Provider',Is_Lead_Owner_Partner__c=true,Reseller__c=acc.Id,CAPOPUpdatingFirstTime__c=false,PartnerAccount_ID__c='Test1',FirstName='lead1',LastName='test1',RecordTypeId = recIndirectLeadId,Geo__c='NA',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='CA POP',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='CA - CANADA',MKT_Territory__c='Canada',Sales_Territory__c='CANADA',Tactic__c='Live Activity');
        
        try{ 
               insert naLead2;
         }
        catch(exception e)
         {
          } 
        
        Test.StopTest();
        
    	
    }
    
}