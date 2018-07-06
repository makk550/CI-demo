/*
 
   This class has been written to Update the ownership of leads if CAM for Route is changed and there exists Reseller leads owned by old CAM.
   This class also Shares the leads to new CAM if there exists reseller leads created by partner. 
  
*/
public class UpdateChildOwnership{

public void UpdateChild( Map<Id,Map<String,Map<String,String>>> accntsMap,set<String> oldPmfKeys, set<String> newPmfKeys){
    
    Map<String,Id> oldUsrIds = new Map<String,Id>();
    if(oldPmfKeys.size()>0){
        List<User> oldUsr= [select id,pmfkey__c from user where PMFKey__c in:oldPmfKeys];
        for(User u: oldUsr){
         oldUsrIds.put(u.pmfkey__c,u.id); 
       }
    } 
        
    Map<String,Id> newUsrIds = new Map<String,Id>();
    if(newPmfKeys.size()>0){
        List<User> newUsr= [select id,pmfkey__c from user where PMFKey__c in:newPmfKeys];
        for(User u: newUsr){
         newUsrIds.put(u.pmfkey__c,u.id); 
       }
    }      
                      
                                 
   // Lead LeadShare  && Lead Owner Update
   List<Lead> LeadRecDetails= new List<Lead> ();                   
   List<LeadShare> leadShare = new List<LeadShare>();      
   for(Lead LeadRec: [select id,Name,RTM__c,OwnerId,RecordType.Name,Reseller__c,IsConverted from Lead where Reseller__c in: accntsMap.keySet() AND IsConverted != True ]){
                                
    Id acctId = Leadrec.Reseller__c;
    Map<String,Map<String,String>> routeMap =  accntsMap.get(acctId);  
    
     System.debug('Route'+Leadrec.RTM__c);
    if(routeMap!=null && routeMap.containsKey(Leadrec.RTM__c)){
       Map<String,String> pmfKeys = routeMap.get(Leadrec.RTM__c);
       String oldPmfKey;
       String newPmfKey;
       for(String pmfKey : pmfKeys.keySet()) {
              oldPmfKey = pmfKey;           
       }
       newPmfKey = pmfKeys.get(oldPmfKey);
       
       Id oldUsrId=oldUsrIds.get(oldPmfKey);                  
       Id newUsrId=newUsrIds.get(newPmfKey);       
     
       if(newUsrId!=null){
        if(Leadrec.OwnerId==oldUsrId){  
          Leadrec.OwnerId=newUsrId;
          LeadRecDetails.add(LeadRec);
        } 
        else{
          LeadShare leadShr = new LeadShare();
          leadShr.LeadAccessLevel='Edit';
          leadShr.LeadId=LeadRec.Id;
          leadShr.UserOrGroupId=newUsrId;    
          leadShare.add(leadShr); 
        }
       }                                
    }
  } 
      
   if(Limits.getDMLRows() +  LeadRecDetails.size() + leadShare.size() < Limits.getLimitDMLRows())
      {
        if(LeadRecDetails.size()>0)
            update LeadRecDetails; 
        if(leadShare.size()>0){
            system.debug('Insert Lead Share leadShare '+leadShare);
            Database.Insert(leadShare, false);
        }  
      }
    else
       {             
         Map<string,string> mLeadOwner = new Map<string, string>();
         for(Lead l:LeadRecDetails)
             mLeadOwner.put(l.id,l.ownerid);
            
         Map<string,string> mLeadShare = new Map<string, string>();
         for(LeadShare ls:leadShare)
            mLeadShare.put(ls.LeadId,ls.UserOrGroupId);
            
          UpdateLeads(mLeadOwner,mLeadShare);  
       }
  }   
 
 @future
 public static void UpdateLeads(Map<string,string> mLead, Map<string,string> mLeadShare)
 {
        List<Lead> lstLead = new List<Lead>();
        for(String leadId: mLead.keySet())
                lstLead.add(new Lead(id=leadId, OwnerId= mLead.get(leadId)));
        
        List<LeadShare> lstLeadShare = new List<LeadShare>();
        for(String leadId: mLeadShare.keySet())
                lstLeadShare.add(new LeadShare(LeadAccessLevel='Edit',LeadId=leadId, UserOrGroupId= mLeadShare.get(leadId)));
                   
        if(lstLead.size() >0 )
            update lstLead;
        if(lstLeadShare.size() >0 )
            Database.Insert(lstLeadShare, false);
        
 }
 
 @future
 public static void Lead_Share( Map<string,string> mLeadShare){
    
    List<LeadShare> lstLeadShare = new List<LeadShare>();
        for(String leadId: mLeadShare.keySet())
                lstLeadShare.add(new LeadShare(LeadAccessLevel='Edit',LeadId=leadId, UserOrGroupId= mLeadShare.get(leadId)));
        if(lstLeadShare.size() >0 )
        {
             system.debug('Insert lstLeadShare in feature Method Lead Share 22 '+lstLeadShare);
            Database.Insert(lstLeadShare, false);
        }    
 }
 public static testmethod void methodforUpdateChildOwnership(){
    
    Set<string> accIds = new Set<string> ();
        List<User> lstUser=[Select id,pmfkey__c from user where PMFKey__c != null and isActive = true limit 3];
        user u1= lstUser[0];
        user u2= lstUser[1];
        user u3= lstUser[2];
      User[] u=[select id,AE_SE_PMFKey__c,PMFKey__c from user where isActive=true limit 9];
    
    List<Account> lstAcc = new List<Account>();
    
      
    //Account acc2 = new Account(Name='Test_Acc2',RecordTypeId='01230000000GaFd',Alliance__c=true,Service_Provider__c=true,Solution_Provider__c=true,Solution_Provider_Designation__c='FED',Solution_Provider_Program_Level__c='Platinum',Solution_Provider_Type__c='Reseller',Customer_Category__c='Reseller',Reseller_Disti_Regional_ID__c='101',Alliance_CAM_PMFKey__c= u1.pmfkey__c,Service_Provider_CAM_PMFKey__c=u2.pmfkey__c,Solution_Provider_CAM_PMFKey__c=u3.pmfkey__c,Enterprise_Account_Name__c='E_Acc1',GEO__c='NA');
    //insert acc2;
    //insert acc;
    Account acc = new Account(Name='Test_Acc1',RecordTypeId='01230000000GaFd',Customer_Category__c='Reseller',Reseller_Disti_Regional_ID__c='101', Alliance__c=true, Alliance_Designation__c='ISV', Alliance_Program_Level__c='Premier', Alliance_Type__c='Global Systems Integrator', Alliance_CAM_PMFKey__c=u1.pmfkey__c, Service_Provider__c=true, Service_Provider_CAM_PMFKey__c=u2.pmfkey__c, Service_Provider_Designation__c='CSP', Service_Provider_Program_level__c='Premier', Service_Provider_Type__c='CSP', Solution_Provider_CAM_PMFKey__c=u3.pmfkey__c, Solution_Provider__c=true, Solution_Provider_Designation__c='FED', Solution_Provider_Program_Level__c='Premier', Solution_Provider_Type__c='Reseller', Enterprise_Account_Name__c='E_Acc1',GEO__c='NA');

    Account acc2 = new Account(Name='Test_Acc2',RecordTypeId='01230000000GaFd',Alliance__c=true, Alliance_Designation__c='ISV', Alliance_Program_Level__c='Premier', Alliance_Type__c='Global Systems Integrator', Alliance_CAM_PMFKey__c=u1.pmfkey__c, Service_Provider__c=true, Service_Provider_CAM_PMFKey__c=u2.pmfkey__c, Service_Provider_Designation__c='CSP', Service_Provider_Program_level__c='Premier', Service_Provider_Type__c='CSP', Solution_Provider_CAM_PMFKey__c=u3.pmfkey__c, Solution_Provider__c=true, Solution_Provider_Designation__c='FED', Solution_Provider_Program_Level__c='Premier', Solution_Provider_Type__c='Reseller', Customer_Category__c='Reseller', Reseller_Disti_Regional_ID__c='101', Enterprise_Account_Name__c='E_Acc1',GEO__c='NA');

    lstAcc.add(acc);
    lstAcc.add(acc2);
    
    insert lstAcc;  
    
    
    List<Lead> lstLead = new List<Lead>();
    
    Map<String,String> pmfKeys = new Map<String,String>();
    pmfKeys.put(acc.Alliance_CAM_PMFKey__c,acc.Alliance_CAM_PMFKey__c);
    pmfKeys.put(acc.Service_Provider_CAM_PMFKey__c,acc.Service_Provider_CAM_PMFKey__c);
    pmfKeys.put(acc.Solution_Provider_CAM_PMFKey__c,acc.Solution_Provider_CAM_PMFKey__c);
    pmfKeys.put(acc.Velocity_Seller_CAM_PMFKey__c,acc.Velocity_Seller_CAM_PMFKey__c);
    
    pmfKeys.put(acc2.Alliance_CAM_PMFKey__c,acc2.Alliance_CAM_PMFKey__c);
    pmfKeys.put(acc2.Service_Provider_CAM_PMFKey__c,acc2.Service_Provider_CAM_PMFKey__c);
    pmfKeys.put(acc2.Solution_Provider_CAM_PMFKey__c,acc2.Solution_Provider_CAM_PMFKey__c);
    pmfKeys.put(acc2.Velocity_Seller_CAM_PMFKey__c,acc2.Velocity_Seller_CAM_PMFKey__c);
    
    
    set<String> oldPmfKeys = new set<String> ();
    oldPmfKeys.add(acc.Alliance_CAM_PMFKey__c);
    oldPmfKeys.add(acc.Service_Provider_CAM_PMFKey__c);
    oldPmfKeys.add(acc.Solution_Provider_CAM_PMFKey__c);
    
    oldPmfKeys.add(acc2.Alliance_CAM_PMFKey__c);
    oldPmfKeys.add(acc2.Service_Provider_CAM_PMFKey__c);
    oldPmfKeys.add(acc2.Solution_Provider_CAM_PMFKey__c);
    
    set<String> newPmfKeys = new set<String> ();
    newPmfKeys.add(acc.Alliance_CAM_PMFKey__c);
    newPmfKeys.add(acc.Service_Provider_CAM_PMFKey__c);
    newPmfKeys.add(acc.Solution_Provider_CAM_PMFKey__c);
    
    newPmfKeys.add(acc2.Alliance_CAM_PMFKey__c);
    newPmfKeys.add(acc2.Service_Provider_CAM_PMFKey__c);
    newPmfKeys.add(acc2.Solution_Provider_CAM_PMFKey__c);
    
    Map<String,Map<String,String>> mPmfKeys = new  Map<String,Map<String,String>> ();
    mPmfKeys.put('Alliance',pmfKeys);
    mPmfKeys.put('Service Provider',pmfKeys);
    mPmfKeys.put('Solution Provider',pmfKeys);
    mPmfKeys.put('Reseller',pmfKeys);
   
    Map<Id,Map<String,Map<String,String>>> accntsMap = new Map<Id,Map<String,Map<String,String>>> ();
    accntsMap.put(acc.Id,mPmfKeys);
    accntsMap.put(acc2.Id,mPmfKeys);
    
    RecordType rectype = [select ID,Name from RecordType where Id='01230000000Dhu2'];
    Lead testLead1 = new Lead(FirstName='lead1',LastName='test1',RecordTypeId = rectype.Id,Reseller__c=acc.Id,Geo__c='LA',IsConverted=false ,RTM__c='Alliance',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='CA - CANADA',MKT_Territory__c='Canada',Sales_Territory__c='CANADA',Tactic__c='Live Activity');
    insert testLead1;
     
    UpdateChildOwnership ChildOw = new UpdateChildOwnership();
    ChildOw.UpdateChild(accntsMap,oldPmfKeys,newPmfKeys);
    Map<String,Id> oldUsrIds = new Map<String,Id>();
    if(oldPmfKeys.size()>0){
      List<User> oldUsr= [select id,pmfkey__c from user where PMFKey__c in:oldPmfKeys];
        for(User u11: oldUsr){
          oldUsrIds.put(u11.pmfkey__c,u11.id); 
        }
    }
    Map<String,Id> newUsrIds = new Map<String,Id>();
    if(newPmfKeys.size()>0){
      List<User> newUsr= [select id,pmfkey__c from user where PMFKey__c in:newPmfKeys];
        for(User u11: newUsr){
          newUsrIds.put(u11.pmfkey__c,u11.id); 
        }
    }   
    Map<string,string> mLeadShare = new Map<string,string>();
     Map<string,string> mLeadShare1 = new Map<string,string>();
      List<Lead> LeadRecDetails= new List<Lead> ();
   
    //RecordType rectype = [select ID,Name from RecordType where Id='01230000000Dhu2'];
    Lead naLead1 = new Lead(FirstName='lead1',LastName='test1',RecordTypeId = rectype.Id,Reseller__c=acc.Id,Geo__c='LA',IsConverted=false ,RTM__c='Alliance',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='CA - CANADA',MKT_Territory__c='Canada',Sales_Territory__c='CANADA',Tactic__c='Live Activity');
    //insert naLead1;
    lstLead.add(naLead1);
     
    
    mLeadShare.put(naLead1.Id,naLead1.OwnerId);
    if(naLead1.OwnerId !=null)
    mLeadShare1.put(naLead1.Id,naLead1.OwnerId);
    
    Lead naLead2 = new Lead(FirstName='lead2',LastName='test2',RecordTypeId = rectype.Id,Reseller__c=acc.Id,Geo__c='NA',Company='SF1',RTM__c='Service Provider',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='CA - CANADA',MKT_Territory__c='Canada',Sales_Territory__c='CANADA');
    //insert naLead2;
    lstLead.add(naLead2);
    
    mLeadShare.put(naLead2.Id,naLead2.OwnerId);
    
    if(naLead2.OwnerId !=null)
    mLeadShare1.put(naLead2.Id,naLead2.OwnerId);
    
    Lead laLead1 = new Lead(FirstName='lead3',LastName='test3',RecordTypeId = rectype.Id,Reseller__c=acc2.Id,Geo__c='LA',RTM__c='Service Provider',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='AUTOMATION',Country_Picklist__c='CO - COLOMBIA',MKT_Territory__c='Brazil',Sales_Territory__c='FEDERAL',Tactic__c='Live Activity');
    //insert laLead1;
    lstLead.add(laLead1);
    
    mLeadShare.put(laLead1.Id,laLead1.OwnerId);
    if(laLead1.OwnerId !=null)
    mLeadShare1.put(laLead1.Id,laLead1.OwnerId);
    
    Lead apjLead1 = new Lead(FirstName='lead4',LastName='test4',RecordTypeId = rectype.Id,Reseller__c=acc2.Id,Geo__c='LA',RTM__c='Solution Provider',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='ISBU',Country_Picklist__c='CN - CHINA');
    //insert apjLead1;
    lstLead.add(apjLead1);
    
    mLeadShare.put(apjLead1.Id,apjLead1.OwnerId);
    if(apjLead1.OwnerId !=null)
    mLeadShare1.put(apjLead1.Id,apjLead1.OwnerId);
    
    Lead emeaLead1 = new Lead(FirstName='lead5',LastName='test5',RecordTypeId = rectype.Id,Reseller__c=acc.Id,Geo__c='EMEA',RTM__c='Service Provider',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@abc.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='PDI',Country_Picklist__c='DZ - ALGERIA',MKT_Territory__c='Germany',Sales_Territory__c='GERMANY',Tactic__c='Live Activity');
    //insert emeaLead1;
    lstLead.add(emeaLead1);
    
    
    mLeadShare.put(emeaLead1.Id,emeaLead1.OwnerId);
    if(emeaLead1.OwnerId !=null)
    mLeadShare1.put(emeaLead1.Id,emeaLead1.OwnerId);
    
    Lead emeaLead2 = new Lead(FirstName='lead6',LastName='test6',RecordTypeId = rectype.Id,Reseller__c=acc.Id,Geo__c='EMEA',RTM__c='Alliance',Company='SF1',Contact_Role__c='Datacenter',EAID__c='ACC001',Email='test@hotmail.com',LeadSource='APRIMO',Phone='1221231212',MKT_BU_Category__c='IT Governance',Country_Picklist__c='DZ - ALGERIA',MKT_Territory__c='Germany',Sales_Territory__c='GERMANY',Tactic__c='Live Activity');
    //insert emeaLead2;
    lstLead.add(emeaLead2);
    
    mLeadShare.put(emeaLead2.Id,emeaLead2.OwnerId);
    if(emeaLead2.OwnerId !=null)
    mLeadShare1.put(emeaLead2.Id,emeaLead2.OwnerId);
ChildOw.UpdateChild(accntsMap,oldPmfKeys,newPmfKeys);

   // Lead[] newLeads = new Lead[]{naLead2,lalead1,apjlead1,emeaLead1,emeaLead2};
   // insert newLeads;
    insert lstLead;
    
   update LeadRecDetails;
   Lead_Share(mLeadShare);
   UpdateLeads(mLeadShare1,mLeadShare);
    
    
    LeadShare leadShr1 = new LeadShare();
    leadShr1.LeadAccessLevel='Edit';
    leadShr1.LeadId=naLead1.Id;
    leadShr1.UserOrGroupId = u[0].Id ;
    insert leadShr1;
     List<LeadShare> leadShare = new List<LeadShare>();
    for(Lead LeadRec: [select id,Name,RTM__c,OwnerId,RecordType.Name,Reseller__c from Lead where Reseller__c != null AND IsConverted != True AND Reseller__c in : mLeadShare1.keyset() limit 2] )
    {
        Id acctId = LeadRec.Reseller__c;
    //  Id acctId = acc.Id;
        Map<String,Map<String,String>> routeMap = accntsMap.get(acctId);
        system.debug('************accntsMap.get(acc2.Id)********'+accntsMap.get(acc2.Id));
        if(routeMap.containsKey(Leadrec.RTM__c)){
            Map<String,String> pmfKeys1 = routeMap.get(Leadrec.RTM__c);
            String oldPmfKey;
            String newPmfKey;
            for(String pmfKey : pmfKeys1.keySet()) {
                if(pmfKey != null){
                    oldPmfKey = pmfKey ;
                }
            }
            Id oldUsrId=oldUsrIds.get(oldPmfKey);
            for(String pmfKey : pmfKeys1.values()) {
                if(pmfKey != null){
                    newPmfKey = pmfKey;
                }
            }
            Id newUsrId=newUsrIds.get(newPmfKey);
            if(newUsrId!=null && Leadrec.OwnerId==oldUsrId){
                Leadrec.OwnerId=newUsrId;
                LeadRecDetails.add(LeadRec);
            }else{
                LeadShare leadShr = new LeadShare();
                leadShr.LeadAccessLevel='Edit';
                leadShr.LeadId=LeadRec.Id;
                leadShr.UserOrGroupId=newUsrId;
                leadShare.add(leadShr);
            }
        }
        
    }
  }
}