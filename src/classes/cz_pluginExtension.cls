@RestResource(urlMapping='/QuoteLine/*')
global class cz_pluginExtension {
    @HttpPost 
    global static List<SBQQ__QuoteLine__c> updateQuoteLines(){
        String postBody = RestContext.request.requestBody.toString().remove('\\').removeStart('"').removeEnd('"');
        system.debug(postBody);
        List<SBQQ__QuoteLine__c> lines = (List<SBQQ__QuoteLine__c>)JSON.deserialize(postBody,List<SBQQ__QuoteLine__c>.class);
		
        //added by Piyush - BAJPI01
        lines = cz_GlobalSeatCountExtension.getSeatCountForQuoteLines(lines);
        
        /* - Commented by Piyush - BAJPI01
        List<Id> quoteIds = new List<Id>();
        for (SBQQ__QuoteLine__c line : lines){
            quoteIds.add(line.SBQQ__Quote__c);
            line.global_parent_Seat_count__c = 100;
        }
        List<SBQQ__Quote__c> quotes = [select id, SBQQ__Account__c from SBQQ__Quote__c where id in :quoteIDs];
        for (SBQQ__Quote__c quote : quotes)
            system.debug(quote.SBQQ__Account__c);
        //set the Global parent seat count, return seat count and unique identifier (product code)
        */
        
        return lines;
    }
}