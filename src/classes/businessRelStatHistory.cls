/*
*SFDC CRM 7.1 Req#495 : Class to set the business relationship status history.
*This class will call from businessRelStatHistory trigger.
*/
public class businessRelStatHistory {
    
    public void setStatus(List<HVN__C> newHVN, List<HVN__C> oldHVN){
        
        List<Business_Relationship_Status_History__c> businessRelStatHisList = new List<Business_Relationship_Status_History__c>();
        for(integer i=0; i<newHVN.size(); i++){
            //System.debug('old businessRelStatHisList='+oldHVN[i].Relationship_Status__c);
            System.debug(' new businessRelStatHisList='+newHVN[i].Relationship_Status__c);
        
            //Create history 
            Business_Relationship_Status_History__c bRelStatHis = new Business_Relationship_Status_History__c();
            bRelStatHis.Business_Relationship_Status_History_HVN__c = newHVN[i].Id;
            /*if(newHVN[i].Relationship_Date__c != null){
                bRelStatHis.Business_Relationship_Date__c = newHVN[i].Relationship_Date__c;
            }
            else if (newHVN[i].Relationship_Date__c == null){
                newHVN[i].Relationship_Date__c=date.Today();
            }*/
            if(Trigger.isInsert){
                if(newHVN[i].Relationship_Date__c != null){
                bRelStatHis.Business_Relationship_Date__c = newHVN[i].Relationship_Date__c;
                }
                 else if (newHVN[i].Relationship_Date__c == null){
                bRelStatHis.Business_Relationship_Date__c =date.Today();
            }
                
                //On creation of HVN record the history record in Business Relationship Status History object is created.
                bRelStatHis.Business_Relationship_Status_History__c = 'Created HVN with Status \"'+newHVN[i].Relationship_Status__c+'\"';
                businessRelStatHisList.add(bRelStatHis);
            }else{
                //Create history on Update
                if(newHVN[i].Relationship_Date__c != oldHVN[i].Relationship_Date__c && newHVN[i].Relationship_Date__c != null){
                    bRelStatHis.Business_Relationship_Date__c = newHVN[i].Relationship_Date__c;
                }
                else if (newHVN[i].Relationship_Date__c == null || newHVN[i].Relationship_Date__c == oldHVN[i].Relationship_Date__c){
                    newHVN[i].Relationship_Date__c=date.Today();
                    bRelStatHis.Business_Relationship_Date__c = newHVN[i].Relationship_Date__c;
                }
                if(oldHVN[i].Relationship_Status__c != null && newHVN[i].Relationship_Status__c != null){
                    if(newHVN[i].Relationship_Status__c <> oldHVN[i].Relationship_Status__c) {
                        //If status is changed insert the history record in Business Relationship Status History object.
                        bRelStatHis.Business_Relationship_Status_History__c = 'Changed from \"'+ oldHVN[i].Relationship_Status__c+'\" to \"'+newHVN[i].Relationship_Status__c+'\"';
                        businessRelStatHisList.add(bRelStatHis);
                    } 
                }
               else if (oldHVN[i].Relationship_Status__c == null && newHVN[i].Relationship_Status__c != null){
                    bRelStatHis.Business_Relationship_Status_History__c = 'Changed from \"NONE\" to \"'+newHVN[i].Relationship_Status__c+'\"';
                    businessRelStatHisList.add(bRelStatHis);
               }
            }
        }
    
        if(businessRelStatHisList.size() > 0){
            System.debug('businessRelStatHisList='+businessRelStatHisList);
            try{
                insert businessRelStatHisList;
                System.debug('businessRelStatHisList ids='+businessRelStatHisList);
            }Catch(DMLException exp){
        System.debug('businessRelStatHisList error='+exp);

            }
        }
    }
    @isTest(SeeAllData=true)
    private static void BusinessRelStatHistory_Class() {        
        Test.startTest();  
        //Create new HVN object
        Account acc = new Account();         
        acc.RecordTypeId  = SystemIdUtility.getAccountTeamAcctRecordTypeId(); 
        //Commercial Account        
        acc.Name = 'sample';        
        acc.Customer_Category__c = 'Commercial';        
        acc.Account_Status__c = 'Submitted';        
        acc.GEO__c = 'NA';        
        insert acc; 
        
        Contact newCnt = new Contact();        
        newCnt.LastName = 'Sandip';        
        newCnt.Country_Picklist__c = 'India';        
        insert newCnt;        
        
        Date myDate = date.newinstance(2010, 09, 13);
        HVN__c newHVN = new HVN__c();
        newHVN.Relationship_Date__c = myDate;
        newHVN.Relationship_Status__c = 'New Relationship/No Previous Contact';
        newHVN.Contact__c = newCnt.Id;
        insert newHVN;
        newHVN.Relationship_Date__c = System.today();
        newHVN.Relationship_Status__c = 'test';
        update newHVN;
        /*//Update existing HVN object      
        HVN__c existingHVN = [SELECT ID,Name,Contact__c FROM HVN__c WHERE ID NOT IN (SELECT HVN_Contact__c FROM HVN_Touchpoint__c) LIMIT 1];    
        existingHVN.Relationship_Status__c = 'Achieved High Value Contact Status/Strong Relationship';
        update existingHVN;*/
    }
}