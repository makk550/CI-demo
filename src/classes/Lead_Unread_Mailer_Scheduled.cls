global class Lead_Unread_Mailer_Scheduled implements Schedulable{

    public static boolean bIsTest=false;
    
    global void execute(SchedulableContext sc){
    
        Lead_Unread_Batch_Mailer mailer = new Lead_Unread_Batch_Mailer();
        if(bIsTest){
	        mailer.query = 'Select Id,FirstName,LastName,Company,MKT_BU_Category__c,'+
	        'MKT_Solution_Set__c,Description,CIDB_Campaign_Name__c,Title,Owner.Email,Owner.FirstName,Owner.Name from Lead '+
	        'where Age__c>14 and Owner.IsActive=true order by OwnerId limit 1';
        }else{
	        mailer.query = 'Select Id,FirstName,LastName,Company,MKT_BU_Category__c,'+
	        'MKT_Solution_Set__c,Description,CIDB_Campaign_Name__c,Title,Owner.Email,Owner.FirstName,Owner.Name from Lead '+
	        'where (GEO__c=\'NA\' or GEO__c = \'PS/CAN\') and Age__c=14 and Owner.IsActive=true order by OwnerId';
        }
        ID batchprocessid = Database.executeBatch(mailer,199);
    }
    
    private static testMethod void Lead_Unread_Mailer_Scheduled_test(){
        Test.startTest();
        String TestTime = '0 0 0 3 9 ? 2022';
        Lead_Unread_Mailer_Scheduled.bIsTest=true;
        Lead_Unread_Mailer_Scheduled objSch=new Lead_Unread_Mailer_Scheduled();
        
        String jobId = System.schedule('testLead_Unread_Mailer_Scheduled',
        TestTime, new Lead_Unread_Mailer_Scheduled());
        Test.stopTest(); 
    }
    
    private static testMethod void Lead_Unread_Batch_Mailer_test(){
        Test.StartTest();
        Lead_Unread_Batch_Mailer mailer = new Lead_Unread_Batch_Mailer();
        mailer.query = 'Select Id,FirstName,LastName,Company,MKT_BU_Category__c,'+
        'MKT_Solution_Set__c,Description,Owner.Email from Lead '+
        'where Age__c>=14 and Owner.IsActive=true order by OwnerId limit 1';
        ID batchprocessid = Database.executeBatch(mailer,199);
        Test.stopTest();
    }    
}