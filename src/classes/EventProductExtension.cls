public class EventProductExtension {

    private final Event event;
    public string eventId {get; set;}
    public List<TSO_Event_Product_Selection__c> products  {get; set;}

    public EventProductExtension(ApexPages.StandardController stdController){
        this.event = (Event)stdController.getRecord();

        eventId = ApexPages.currentPage().getParameters().get('id'); //'00UQ0000001ZW6Y'; //
        if(eventId==null)
            eventId = event.Id;
        
        eventId += '%';
        System.debug(eventId); 
        //products = [Select SystemModstamp, Product__c, Product_Family__c, OwnerId, Name, LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Id, Event_Id__c, CurrencyIsoCode, CreatedDate, CreatedById, BU__c From TSO_Event_Product_Selection__c where Event_Id__c=:eventId order by Name];
        products = [Select Id,ProductId__c,ProductId__r.Name, ProductFamily__c, Event_Id__c, Business_Unit__c From TSO_Event_Product_Selection__c where Event_Id__c like:eventId and ProductId__c!=null order by Name];
        System.debug(products);
    }

    static testmethod void myUnitTest(){
        Event newEvt = new Event();
        newEvt.ActivityDateTime = System.now();
        newEvt.DurationInMinutes = 40;
        newEvt.Subject = 'TSO EVENT';
        //newEvt.Additional_Request_Details__c = 'This is testing by developer.';
        insert newEvt;
        ApexPages.StandardController QController = new ApexPages.StandardController(newEvt);
        // Open extension
        EventProductExtension qe = new EventProductExtension(QController);
    }

}