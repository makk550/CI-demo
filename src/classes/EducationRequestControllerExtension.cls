public class EducationRequestControllerExtension
{
    private ApexPages.StandardController ext;

    public EducationRequestControllerExtension(ApexPages.StandardController sc)
    {
        ext=sc;
    }

    public PageReference updateStatus()
    {
        Education_Request__c eduReq = (Education_Request__c)ext.getRecord();
    
        System.debug('field updateable: ' + Schema.sObjectType.Education_Request__c.fields.Education_Request_Status__c.isUpdateable());
        System.debug('object updateable: ' + Education_Request__c.sObjectType.getDescribe().isUpdateable() );
    
        if(!Schema.sObjectType.Education_Request__c.fields.Education_Request_Status__c.isUpdateable() || !Education_Request__c.sObjectType.getDescribe().isUpdateable() )
        {
            eduReq.Education_Request_Status__c.addError('You do not have access to perform that opperation');
            return null;
        }
    
        Map<String, String> nextStatusMap = new Map<String, String>{'Pending Approval' => 'Ready for Registration', 'Ready for Registration' => 'Registration Complete', 'Registration Complete' => 'Ready for Registration'};
        eduReq.Education_Request_Status__c = nextStatusMap.get(eduReq.Education_Request_Status__c);
        
        System.debug(ext.save());
        System.debug(ext.view());

        return ext.view();
    }
}