@isTest
public class newDealDeskTest {
 @isTest static void testfun(){
        
        testOpportunityTriggersClass.createNewOpportunity();
        Opportunity opp = [select id,Name,AccountId,Closedate,StageName,CurrencyIsoCode,RecordTypeId from Opportunity limit 1];
         
         system.debug('opp id is:'+opp.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
         system.debug('opp id is:'+opp.id);
        // system.debug('printing apex pages id:'+ApexPages.currentPage().getParameters().put('id',opp.id));
        ApexPages.currentPage().getParameters().put('id',opp.id);
        newDealDesk obj=new newDealDesk(sc);


        obj.ApplySelectionfunction();
        obj.enableNDAtypefun();
        obj.Cancelfunction();
        obj.testOutside();
        obj.testfun();
      }

      @isTest static void testWithSterlingQuote(){

       
       

        testCreateAccOppandLineItemClass.insertSterlingQuote();
        Opportunity opp = [select id,Name,AccountId,Closedate,StageName,CurrencyIsoCode,RecordTypeId from Opportunity limit 1];

         system.debug('opp id is:'+opp.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
         system.debug('opp id is:'+opp.id);
        ApexPages.currentPage().getParameters().put('id',opp.id);


         

        

        newDealDesk obj=new newDealDesk(sc);
         obj.Quoteselected = 'testquote';
         obj.ApplySelectionfunction();
         obj.enableNDAtypefun();
         obj.Cancelfunction();
         obj.testOutside();
         obj.testfun();
       }



       
     }