public class TestData {
    private static final Integer MAX_INSERT_ROW_NUMBER=150;

    public static void ensureVariableExists(String key, String value){
        Configuration_Variable__c var = null;
        try{
            var = [select id from Configuration_Variable__c where name = :key];
        }catch(QueryException e){}
        if(var == null){
            var = new Configuration_Variable__c();
            var.name = key;
        }
        var.value__c = value;
        Try{
          if(var.id == null){
            insert var;
         } else {
            update var;
         }
        }
        Catch(Exception e){
            System.debug('Exception'+e);
        }
    } 
    
    public static Account createTestPartner(){
        Account acct = new Account();
        acct.Name='Test Account 123 ABC';
        acct.Profile_Published_to_Partner_Finder__c='Yes';
        acct.BillingStreet = 'Arlington';
        acct.BillingCountry = 'US';
        acct.BillingCity = 'VA';
        acct.Approved_for_Partner_Finder__c=true;
        acct.Partner_User_Agreed_to_PF_Terms_Cond__c=UserInfo.getUserId();
        acct.Partner_Date_Agreed_to_PF_Terms_Cond__c=Datetime.now();
        acct.Commercial_ID__c = 'asd';
        
        insert acct;
        acct.IsPartner = true;
        update acct;
        return acct;
    }
    
    private static Double random(Double min, Double max){
        return min + (Math.random() * (max - min));
    }
    
    public static List<Partner_Location__c> createTestPartnerLocations(Account acc, 
                                                                        Integer count){
        List<Partner_Location__c> records = new List<Partner_Location__c>();
        List<Partner_Location__c> recordBatch= new List<Partner_Location__c>();
        Integer i=0;
        while(i<count){
            i++;
            if(i>=count){
                break;
            }
            Partner_Location__c loc = new Partner_Location__c();
            loc.Name = acc.Name + ' - Test Location ' + String.valueOf(i);
            loc.Latitude__c =  random(-90, 90);
            loc.Longitude__c =  random(-180,180);
            loc.Account__c = acc.Id;
            loc.Point_of_Contact_Email__c = 'tloc'+ String.valueOf(i)+'@testlocation.com';
            
            if(i==1){
                loc.Is_Primary__c=true;
            } else {
                loc.Is_Primary__c=false;
            }
            recordBatch.add(loc);
            if(recordBatch.size()==MAX_INSERT_ROW_NUMBER){
                System.debug('Batch Size :' + recordBatch.size());
                insert(recordBatch);
                records.addAll(recordBatch);
                recordBatch.clear();
            }
        }
        if(recordBatch.size()>0){
            insert(recordBatch);
            records.addAll(recordBatch);
        }
        return records;
    }
}