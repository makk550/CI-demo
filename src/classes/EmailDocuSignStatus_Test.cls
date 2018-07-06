@isTest
private class EmailDocuSignStatus_Test {
    static testMethod void validateStatus(){
        
        SA_BOOKING__C saBooking = new SA_BOOKING__C( Geo__c = 'NA',Region__c = 'Canada', CPQ_Quote__c = 'Y112233445',
        CurrencyIsoCode = 'USD', Deal_Desk_Review_DDR__c='a0Wa000000IbAvd', Quick_Contract__c = 'Yes' );
        
        insert saBooking;
        
        DateTime dfs1 = DateTime.newInstance(2015, 07, 26, 17, 12, 00);
        DateTime dfs2 = DateTime.newInstance(2015, 06, 24, 14, 32, 00);
        DateTime dfs3 = DateTime.newInstance(2015, 06, 24, 17, 08, 00);
        DateTime dfs4 = DateTime.newInstance(2015, 06, 24, 17, 25, 00);
        DateTime dfs5 = DateTime.newInstance(2015, 06, 24, 14, 46, 00);
        
        dsfs__DocuSign_Status__c docStatus = new dsfs__DocuSign_Status__c(DSFS__COMPLETED_DATE_TIME__C = dfs1,
                                                                      
                                                                      DSFS__DECLINED_DATE_TIME__C = dfs2,
                                                                       DSFS__SENT_DATE_TIME__C = dfs3,
                                                                       DSFS__VIEWED_DATE_TIME__C = dfs4,
                                                                       DSFS__VOIDED_DATE_TIME__C = dfs5,
                                                                       SA_BOOKING__C = saBooking.Id
                                                                      );
        
        insert docStatus;
  
        
        /*
        dsfs__DocuSign_Status__c docrep = [select Id,NAME,DSFS__COMPLETED_DATE_TIME__C,DSFS__DECLINED_DATE_TIME__C,DSFS__SENT_DATE_TIME__C,DSFS__VIEWED_DATE_TIME__C,DSFS__VOIDED_DATE_TIME__C,
                                           SA_BOOKING__C from dsfs__DocuSign_Status__c where DSFS__SENT_DATE_TIME__C!=null AND SA_Booking__C!=null limit 1 ];
        */
     
        DateTime datedec = docStatus.DSFS__SENT_DATE_TIME__C;
        datedec=datedec+1;
        docStatus.DSFS__SENT_DATE_TIME__C= datedec;
            Update docStatus;
            
        dsfs__DocuSign_Status__c docrepres = [select NAME,DSFS__COMPLETED_DATE_TIME__C,DSFS__DECLINED_DATE_TIME__C,DSFS__SENT_DATE_TIME__C,DSFS__VIEWED_DATE_TIME__C,DSFS__VOIDED_DATE_TIME__C,
                                           SA_BOOKING__C from dsfs__DocuSign_Status__c where id= :docStatus.id ];
            
               
        
        System.assertEquals(datedec-1, docrepres.DSFS__SENT_DATE_TIME__C);
        
        
        
        
        
    }
    
    
    
    
    

}