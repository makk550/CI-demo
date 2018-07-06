public class QuoteLineTriggerHandler extends CPQTriggerHandler {

    public QuoteLineTriggerHandler() {}

    /* context overrides */

    protected override void beforeInsert() {
        
        
        System.debug('In beforeInsert for Quote Lines');
        
        Boolean createGroups = false;
        Set <Id> quoteIds = new Set <Id>();
        
        //Only run this code if Quote Lines are being inserted for one Quote
        //Prevents running if Quote Lines are imported using a Data Loader tool
        for (SBQQ__QuoteLine__c ql : (List<SBQQ__QuoteLine__c>) Trigger.new)
        {
            if ( !quoteIds.contains(ql.SBQQ__Quote__c) )
            {
                quoteIds.add(ql.SBQQ__Quote__c);
            }
            if (ql.SBQQ__UpgradedSubscription__c != null)
            {
                createGroups = true;  //only runs when Quote Lines are created from subscriptions, which only happens during amend and renew
            }
        }
        
        if (quoteIds.size() == 1 && createGroups)
        {
            Id quoteId = (new list<Id>(quoteIds))[0];
            
            SBQQ__Quote__c quote = [select id, SBQQ__MasterContract__c, SBQQ__LineItemsGrouped__c, SBQQ__Type__c, SBQQ__LineItemCount__c from SBQQ__Quote__c where id =: quoteId];
            
            List <SBQQ__QuoteLineGroup__c> groupsCreated = [select id from SBQQ__QuoteLineGroup__c where SBQQ__Quote__c =: quote.id];
            
            if (quote.SBQQ__Type__c == 'Amendment')
            {
                if ( !quote.SBQQ__LineItemsGrouped__c || groupsCreated.size() == 0 )  //create groups on the new Quote
                {
                    System.debug('Groups not yet created, create Groups');
                    Id sourceQuoteId;
                    SBQQ__Quote__c sourceQuote;
                    
                    Map <String, Id> qlgMappingOldToNew = new Map <String, Id>();
                    Set <Id> qlgIds = new Set <Id>();
                
                    //Get last Amendment Quote or original Quote that created the Contract -> put into sourceQuote
                    try
                    {
                        System.debug('Searching for last Co-termed Quote');
                        List <SBQQ__Quote__c> prevQuote = new List <SBQQ__Quote__c>([select id, SBQQ__LineItemsGrouped__c from SBQQ__Quote__c where SBQQ__MasterContract__c =: quote.SBQQ__MasterContract__c and id !=: quote.id and Opportunity_Contracted__c = true and SBQQ__Primary__c = true order by id desc limit 1]); 
                        if ( prevQuote.size() > 0)
                        {
                            if ( prevQuote[0].SBQQ__LineItemsGrouped__c )
                            {
                                System.debug('Found Co-termed Quote');
                                sourceQuoteId = prevQuote[0].id;
                            }    
                        }
                        else
                        {
                            Id origQuoteId = [select SBQQ__Quote__c from Contract where id =: quote.SBQQ__MasterContract__c].SBQQ__Quote__c;
                            List <SBQQ__Quote__c> origQuote = new List <SBQQ__Quote__c>([select id, SBQQ__LineItemsGrouped__c from SBQQ__Quote__c where id =: origQuoteId]); 
                            if ( origQuote.size() > 0)
                            {
                                if ( origQuote[0].SBQQ__LineItemsGrouped__c )
                                {
                                    System.debug('Found original Quote');
                                    sourceQuoteId = origQuote[0].id;
                                }    
                            }
                        }
                        
                    }
                    catch (Exception e) {System.debug('Some catastrophic error occured: ' + e);}   
                    
                    if (sourceQuoteId != null)
                    {
                        System.debug('Source Quote used for Groups is ' + sourceQuoteId);
                        sourceQuote = [select id, SBQQ__LineItemsGrouped__c from SBQQ__Quote__c where id =: sourceQuoteId];
                        
                        if (sourceQuote.SBQQ__LineItemsGrouped__c)
                        {
                            //If Amendment Quote created from a Quote with Quote Line Groups, recreate the Quote Line Groups and assign Quote Lines to them
                            //First get all unique Quote Line Groups
                            
                            List <SBQQ__QuoteLine__c> sourceQuoteLines = new List <SBQQ__QuoteLine__c>([select id, SBQQ__Group__c from SBQQ__QuoteLine__c where SBQQ__Quote__c =: sourceQuoteId AND SBQQ__Quantity__c != 0]);
                            
                            for (SBQQ__QuoteLine__c ql : sourceQuoteLines)
                            {
                                if ( !qlgIds.contains(ql.SBQQ__Group__c) )
                                {
                                    System.debug('Adding source Quote Group Id to list from Quote Lines: ' + ql.SBQQ__Group__c);
                                    qlgIds.add(ql.SBQQ__Group__c);
                                }
                            }
                            
                            //Get Quote Line Groups from source Quote
                            List <SBQQ__QuoteLineGroup__c> qlgs = database.query( SOQLString( 'SBQQ__QuoteLineGroup__c', ' id in: qlgIds' ) );  
                            
                            //Clone groups, update new groups to new Quote, insert Groups
                            List <SBQQ__QuoteLineGroup__c> newQlgsToInsert = qlgs.deepclone(false, false, false);
                            Integer qlgnum = 0;
                            
                            for (SBQQ__QuoteLineGroup__c qlg : newQlgsToInsert)
                            {
                                qlg.SBQQ__Quote__c = quote.id;
                                qlg.Source_Group_ID__c = String.valueOf(qlgs[qlgnum].Id).left(15);
                                qlgnum++;
                            }
                            
                            System.debug('Inserting ' + newQlgsToInsert.size() + ' groups');
                            insert newQlgsToInsert;
                            
                            //Create map to map old Group Id's to new Group Id's
                            System.debug('Mapping old group to new group on each Quote Line, creating new groups');
                            for (Integer i = 0; i < newQlgsToInsert.size(); i++)
                            {
                                System.debug('Old Group ' + String.valueOf(qlgs[i].Id).left(15) + ' mapped to ' + newQlgsToInsert[i].Id);
                                qlgMappingOldToNew.put( String.valueOf(qlgs[i].Id).left(15), newQlgsToInsert[i].Id);
                            }
                            
                            for (SBQQ__QuoteLine__c ql : (List<SBQQ__QuoteLine__c>) Trigger.new)
                            {
                                //Map Quote Line old group Id's to new group Id's, update Quote Line
                                System.debug('Updating Quote Line Group ID from ' + ql.Quote_Group_Id__c.left(15) + ' to ' + qlgMappingOldToNew.get(ql.Quote_Group_Id__c.left(15)));
                                ql.SBQQ__Group__c = qlgMappingOldToNew.get(ql.Quote_Group_Id__c.left(15));
                            }
                            
                            quote.SBQQ__LineItemsGrouped__c = true;
                            update quote;
                            
                        }   //end if source Quote is grouped
                    
                    }   //end of if sourceQuoteId is not null
                }
                else  //don't create new groups, map to existing groups
                {
                    System.debug('Groups created, map to created Groups and update lines');
                    List <SBQQ__QuoteLineGroup__c> existingGroups = [select id, Source_Group_ID__c from SBQQ__QuoteLineGroup__c where SBQQ__Quote__c =: quote.id];
                    Map <String, ID> existingGroupsMap = new Map <String, ID>();
                    Set <String> existingGroupsSet = new Set <String>();
                
                    System.debug('Getting source group ids from groups already on Quote');
                    for (SBQQ__QuoteLineGroup__c qlg : existingGroups)
                    {
                        System.debug('Old Group ' + qlg.Source_Group_ID__c + ' mapped to ' + qlg.id);
                        existingGroupsMap.put(qlg.Source_Group_ID__c, qlg.id);
                        if ( !existingGroupsSet.contains(qlg.id) )
                        {
                            existingGroupsSet.add(qlg.id);
                        }
                    }
                    
                    System.debug('Mapping old group to new group on each Quote Line, not creating new groups');
                    for (SBQQ__QuoteLine__c ql : (List<SBQQ__QuoteLine__c>) Trigger.new)
                    {
                        if ( !existingGroupsSet.contains(ql.Quote_Group_Id__c) )   //final check to make sure Groups are only set if they are on the new Quote
                        {
                            System.debug('**Line Name/GroupId '+ql.Name+'/'+ql.Quote_Group_Id__c);
                            if(ql.Quote_Group_Id__c != null){
                                
                                //Map Quote Line old group Id's to new group Id's, update Quote Line
                                System.debug('Updating Quote Line Group ID from ' + ql.Quote_Group_Id__c.left(15) + ' to ' + existingGroupsMap.get(ql.Quote_Group_Id__c.left(15)));
                                ql.SBQQ__Group__c = existingGroupsMap.get(ql.Quote_Group_Id__c.left(15));
                                
                            }
                        }
                    }
                }   //end if Quote is already grouped
                
            }   //end of if Quote being created is an Amendment Quote and has lines
            
        }   //end of if only one Quote being modified
    }
    
    /*
    protected override void beforeUpdate() {
        
    }
    
    protected override void beforeDelete() {
    
    }
    
    protected override void afterInsert() {

    }
    
    protected override void afterUpdate() {
       
    }

    protected override void afterDelete() {
    
    }
    */
    
    public static string SOQLString(String objectName, String WhereClause) {
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
            query += ' ' + s + ', ';
        }
        // Strip off the last comma if it exists.
        query = query.trim().removeEnd(',');
        // Add FROM statement
        query += ' FROM ' + objectName;
        if (WhereClause != '')
            query += ' WHERE ' + WhereClause;
        
        return query;
    }
}