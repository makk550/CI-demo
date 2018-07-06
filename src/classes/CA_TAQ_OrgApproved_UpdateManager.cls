/**
* Description  : this Apex class contains methods related to trigger CA_TAQ_OrgApprovedUpdateManger
* It will retrive Its Managers Details (Managers Position Id and Managers Role and update this information in TAQ)
* Also will update all corresponding subordinates records with above data
* Class contains Test Method coverage
* SOQL      #3
* DML methods #1
* # Future methods 1       
* Author       : Balasaheb Wani
* Company      : Accenture IDC
* Client       : Computer Associates
* Last Update  : Sept, 2010
**/

public  class CA_TAQ_OrgApproved_UpdateManager 
{
/** Test methods for trigger **/
/****Test methods starts ****/
static testMethod void testUpdateManagerInfo()
  {
    User[] ur=[select Id,PMFKey__c,IsActive,TAQ_Position_ID__c from User where IsActive = true limit 200];

    TAQ_Organization_Approved__c taq= new TAQ_Organization_Approved__c();
         taq.Name='Test TAQ ORG AP1';
         taq.Business_Unit__c='INFRASTRUCTURE MANAGEMENT';
         taq.Job_Code__c='TESTJC';
         taq.Is_Latest_Record__c=true;
         taq.PMFKey__c=ur[5].PMFKey__c;
         taq.Position_Id__c=ur[5].TAQ_Position_ID__c;
         taq.Manager_PMFKey__c='LASTE01';
    
    TAQ_Organization_Approved__c taq5= new TAQ_Organization_Approved__c();
         taq5.Name='Test TAQ ORG AP1';
         taq5.Business_Unit__c='INFRASTRUCTURE MANAGEMENT';
         taq5.Job_Code__c='LAST';
         taq5.Is_Latest_Record__c=true;
         taq5.PMFKey__c=ur[15].PMFKey__c;
         taq5.Position_Id__c=ur[15].TAQ_Position_ID__c+'X_C';
         taq5.Manager_PMFKey__c='LASTx01';
    
    TAQ_Organization_Approved__c taq9= new TAQ_Organization_Approved__c();
    taq9.Name='Test TAQ ORG AP9';
    taq9.Business_Unit__c='INFRASTRUCTURE MANAGEMENT';
    taq9.Job_Code__c='TESTJC';
    taq9.Is_Latest_Record__c=true;
    taq9.PMFKey__c=ur[51].PMFKey__c;
    taq9.Manager_Updated_on__c=DateTime.Now().addDays(-10);
    taq9.Manager_PMFKey__c=ur[60].PMFKey__c;
    taq9.Position_Id__c=ur[60].TAQ_Position_ID__c+'X_C';
    List<TAQ_Organization_Approved__c> lsQ=new List<TAQ_Organization_Approved__c>();
    lsQ.add(taq5);
    lsQ.add(taq);
lsQ.add(taq9);
         insert lsQ;

    Test.startTest();
    List<TAQ_Organization_Approved__c> lst=new List<TAQ_Organization_Approved__c>();
    TAQ_Organization_Approved__c taq1= new TAQ_Organization_Approved__c();
    taq1.Name='Test TAQ ORG AP1';
    taq1.Business_Unit__c='INFRASTRUCTURE MANAGEMENT';
    taq1.Job_Code__c='TESTJC';
    taq1.Is_Latest_Record__c=true;
    taq1.PMFKey__c='TAQFI01';
    taq1.Manager_Updated_on__c=DateTime.Now();
    taq1.Manager_PMFKey__c=ur[15].PMFKey__c;
    TAQ_Organization_Approved__c taq2= new TAQ_Organization_Approved__c();
    taq2.Name='Test TAQ ORG AP2';
    taq2.Business_Unit__c='INFRASTRUCTURE MANAGEMENT';
    taq2.Job_Code__c='TESTJC';
    taq2.Is_Latest_Record__c=true;
    taq2.PMFKey__c='TAQFI03';
    taq2.Manager_Updated_on__c=DateTime.Now().addDays(-1);
    taq2.Manager_PMFKey__c=ur[5].PMFKey__c;
    
    TAQ_Organization_Approved__c taq6= new TAQ_Organization_Approved__c();
    taq6.Name='Test TAQ ORG AP2 6';
    taq6.Business_Unit__c='INFRASTRUCTURE MANAGEMENT';
    taq6.Job_Code__c='TESTui';
    taq6.Is_Latest_Record__c=true;
    taq6.PMFKey__c='TAmhI03';
    taq6.Manager_PMFKey__c=ur[50].PMFKey__c;
    taq6.Position_Id__c='pao1';
    
    TAQ_Organization_Approved__c taq19= new TAQ_Organization_Approved__c();
    taq19.Name='Test TAQ ORG AP9';
    taq19.Business_Unit__c='INFRASTRUCTURE MANAGEMENT';
    taq19.Job_Code__c='TESTJC';
    taq19.Is_Latest_Record__c=true;
    taq19.PMFKey__c='TAmbI03';
    taq19.Manager_Updated_on__c=DateTime.Now().addDays(-20);
    taq19.Manager_PMFKey__c=ur[51].PMFKey__c;
    taq19.Position_Id__c='pao1';
    lst.add(taq2);
    lst.add(taq1);
    lst.add(taq6);
    lst.add(taq19);
    insert lst;
    Test.stopTest();
  }
  /****Test methods starts ****/
  
  
  /*** This future method will update all subordinates records for Particular TAQ **/
  @future
  public static void FutureUpdateManagerRoleAndPosition(Set<String> setManagerPMFKeys,Map<String,String> mapManagerAndRole)
  {
      SystemIdUtility.isFutureUpdate = true;
      FutureUpdateManagerRoleAndPosition_NonFuture(setManagerPMFKeys,mapManagerAndRole);
  }
  
  /*** This future method will update all subordinates records for Particular TAQ **/
  public static void FutureUpdateManagerRoleAndPosition_NonFuture(Set<String> setManagerPMFKeys,Map<String,String> mapManagerAndRole)
  {
  //System.Debug('Future Method Called------------------------' + setManagerPMFKeys);
  //System.Debug('Future Map -----------------------' + mapManagerAndRole);
  // added a static variable for keeping count of future method calls in same transaction - Heena sept-29
  TAQOrgAdmin.inFutureContext=true;
  List<TAQ_Organization_Approved__c> lstTQForUpdate=new List<TAQ_Organization_Approved__c>();
   for(TAQ_Organization_Approved__c TQFuture:[Select t.Manager_Updated_on__c,t.Position_Id__c, t.Position_ID_F__c, t.PMFKey__c, t.Name, t.Managers_Role__c, t.Managers_Position_ID__c, t.Manager_PMFKey__c, t.Is_Latest_Record__c, t.Id From TAQ_Organization_Approved__c t where Is_Latest_Record__c=true and t.Manager_PMFKey__c in : setManagerPMFKeys limit 100])
      {
        if(mapManagerAndRole.containskey(TQFuture.Manager_PMFKey__c))
        {
            String strRole='';
            String strPositionId='';
            String[] strArr=mapManagerAndRole.get(TQFuture.Manager_PMFKey__c).split('===');
            if(strArr !=null &&  strArr.size() > 1)
            {
            strRole=strArr[1];
            strPositionId=strArr[0];
            }
            if(TQFuture.Managers_Position_ID__c != TQFuture.Managers_Role__c)
            {
                System.Debug('Time In future Method------------'+TQFuture.Manager_Updated_on__c+'-------For---------'+TQFuture.PMFKey__c);
                if(IsRecordEligibleToUpdate(TQFuture.Manager_Updated_on__c))
                {
                    TQFuture.Managers_Role__c=strRole;
                    TQFuture.Managers_Position_ID__c=strPositionId;
                    TQFuture.Manager_Updated_on__c=Datetime.now();
                    lstTQForUpdate.add(TQFuture);
                }
            }
            else if(TQFuture.Managers_Position_ID__c == TQFuture.Managers_Role__c )
            {
                if(TQFuture.Managers_Position_ID__c != mapManagerAndRole.get(TQFuture.Manager_PMFKey__c))
                {
                        if(IsRecordEligibleToUpdate(TQFuture.Manager_Updated_on__c))
                        {
                            TQFuture.Managers_Role__c=strRole;
                            TQFuture.Managers_Position_ID__c=strPositionId;
                            TQFuture.Manager_Updated_on__c = Datetime.now();
                            lstTQForUpdate.add(TQFuture);
                        }
                }
            }
        }
      }
      if(lstTQForUpdate.size() > 0)
      {
         try
         {
            Database.Saveresult[] res=Database.update(lstTQForUpdate);
         }
         catch(Dmlexception ex)
         {
           System.debug('Exception occured in future method' + ex);
         }
     }
}
  public static boolean IsRecordEligibleToUpdate( DateTime dt)
  {
    Boolean bRet=false;
    Long lComaparisionFactor=86400000;  
    //set this comparision factor to 86400000 miliseconds== 1 Day for Production
    //set this comparision factor to 10000 miliseconds == 10 sec Day for Sandbox (Test only)  and So on   
    if(dt==null)
    {
        bRet=true;
    }
    else
    {
        Long lTimeStampDifference =0;
        lTimeStampDifference = DateTime.Now().getTime() - ((DateTime)dt).getTime();
        if(lTimeStampDifference > lComaparisionFactor)
        {
            bRet=true;
        }
    }
    return bRet;
  } 
  public static void UpdateManagerInfo(List<TAQ_Organization_Approved__c> lstOrgApproved)
  {
    Integer intCount=0;
    Set<String> setFuturePMFKeysManagers = new Set<String>();
    Set<String> setPMFKeys=new Set<String>();
    Set<String> setPMFKeysManagers=new Set<String>();
    Map<String,String> mapMangerPMF_Vs_ROLE_AND_POSITIONID_ID=new Map<String,String>();
    Map<String,User> mapPMFTaqOrgApprovedAndUser=new Map<String ,User>(); 
    Map<String,TAQ_Organization_Approved__c> mapPMFTaqOrgApprovedAndManager =new Map<String,TAQ_Organization_Approved__c>(); 
    Map<String,User> mapPMFUserForFutureUpdate=new Map<String,User>(); 
    for(TAQ_Organization_Approved__c TQ: lstOrgApproved)
    {
        if(TQ.Is_Latest_Record__c==true)
        {
            setPMFKeys.add(TQ.Manager_PMFKey__c);
        }
    }
    for(TAQ_Organization_Approved__c TQ:[Select t.Position_Id__c, t.Position_ID_F__c, t.PMFKey__c, t.Name, t.Managers_Role__c, t.Managers_Position_ID__c, t.Manager_PMFKey__c, t.Is_Latest_Record__c, t.Id From TAQ_Organization_Approved__c t where Is_Latest_Record__c=true and t.PMFKey__c in : setPMFKeys limit 100])
    {
        for(TAQ_Organization_Approved__c TQSource: lstOrgApproved)
        {
            if(TQSource.Manager_PMFKey__c == TQ.PMFKey__c &&(TQSource.Is_Latest_Record__c==true))
                {
                    mapPMFTaqOrgApprovedAndManager.put(TQSource.PMFKey__c,TQ);
                    setPMFKeysManagers.add(TQ.PMFKey__c);
                    break;
                }
        }
    }
    for(User u :[Select u.Alias, u.IsActive, u.PMFKey__c, u.UserRoleId, u.UserRole.Id, u.UserRole.Name from User u where u.IsActive =true and u.PMFkey__c in : setPMFKeysManagers limit 1000])
    {
        for(TAQ_Organization_Approved__c TQS: lstOrgApproved)
        {
            if(TQS.Manager_PMFKey__c==u.PMFKey__c && (TQS.Is_Latest_Record__c==true))
            {
                mapPMFTaqOrgApprovedAndUser.put(TQS.Manager_PMFKey__c+'==='+TQS.PMFKey__c,u);
            } 
        }
    }
    for(TAQ_Organization_Approved__c TQToUpdate: lstOrgApproved)
    {
        if(mapPMFTaqOrgApprovedAndManager.containsKey(TQToUpdate.PMFKey__c))
        {
            //if(IsRecordEligibleToUpdate(TQToUpdate.Manager_Updated_on__c))
            //{
                String strRolename='';
                TAQ_Organization_Approved__c taqTemp=mapPMFTaqOrgApprovedAndManager.get(TQToUpdate.PMFKey__c);
                TQToUpdate.Managers_Position_ID__c=taqTemp.Position_Id__c;
                TQToUpdate.Manager_Updated_on__c=Datetime.now();
                if(mapPMFTaqOrgApprovedAndUser.containsKey(TQToUpdate.Manager_PMFKey__c+'==='+TQToUpdate.PMFKey__c))
                {
                    strRoleName=mapPMFTaqOrgApprovedAndUser.get(TQToUpdate.Manager_PMFKey__c+'==='+TQToUpdate.PMFKey__c).UserRole.Name;
                }
                TQToUpdate.Managers_Role__c=strRolename;
                setFuturePMFKeysManagers.add(TQToUpdate.Manager_PMFKey__c);
                mapMangerPMF_Vs_ROLE_AND_POSITIONID_ID.put(TQToUpdate.Manager_PMFKey__c,taqTemp.Position_Id__c+'==='+strRolename);
                intCount=intCount + 1; 
           // }
        }
    }
    if(intCount > 0)
    {
        if(SystemIdUtility.isFutureUpdate)
            FutureUpdateManagerRoleAndPosition_NonFuture(setPMFKeysManagers, mapMangerPMF_Vs_ROLE_AND_POSITIONID_ID);
        else    
            FutureUpdateManagerRoleAndPosition(setPMFKeysManagers, mapMangerPMF_Vs_ROLE_AND_POSITIONID_ID);
    }
  }
}