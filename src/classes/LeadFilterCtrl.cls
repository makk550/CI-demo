public class LeadFilterCtrl {

public string sAction {set;get;}
public List<Lead> lsitActiveLeads = new List<Lead>();
public List<lead> lstLead{set;get;}
public  id acntId {set;get;}
// get the queue id from Custom Label and use it in query
String QueueId = System.Label.Enterprize_UnassignedQueue;
String QueueId1 = System.Label.Enterprise_Untouched_Queue;

Set<String> sQueues = new set<String>();



public  LeadFilterCtrl(ApexPages.StandardController controller) {
   sQueues.add(QueueId);
   sQueues.add(QueueId1) ;
 
   acntid= ((Account)controller.getRecord()).id;
   sAction='Action';
   //pick only active/Open leads of the accociated account & owner should not be Enterprise Unassigned Queue
    lstLead = [select lastmodifieddate, Name  , Company, Phone,MKT_BU_Category__c  from Lead where  Commercial_Account__c =: acntId and  Status <> 'Closed' and ownerid not In :sQueues  order by lastmodifieddate desc ,createddate desc limit 1000 ];


}//end of function public  LeadFilterCtrl(

public static testMethod void LeadFilterCtrlTest(){
    
     String QueueId = System.Label.Enterprize_UnassignedQueue;
     String QueueId1 = System.Label.Enterprise_Untouched_Queue; 
     Account ac =  new Account(Name='TestAcc');    

     id acntId = ac.id;  //((Account)testPage.getRecord()).id;
     Lead ld = new Lead(Commercial_Account__c =acntId  ); 
     ApexPages.StandardController testPage = new ApexPages.StandardController(ac);
     LeadFilterCtrl obj = new LeadFilterCtrl(testPage); 
    
     obj.sAction='Action';
     obj.lstLead =[ select lastmodifieddate, Name  , Company, Phone,MKT_BU_Category__c  from Lead where  Commercial_Account__c =: acntId and  Status <> 'Closed' and ownerid  != : QueueId  order by lastmodifieddate desc limit 2];    
   }


}/// end class Renewal_MoveACPController