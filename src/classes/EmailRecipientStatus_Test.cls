@isTest
private class EmailRecipientStatus_Test {
    
    static testMethod void validateRecipient(){
        
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
        
        DateTime dtd = DateTime.newInstance(2015, 07, 24, 17, 12, 00);
        DateTime dtsent = DateTime.newInstance(2015, 07, 27, 14, 32, 00);
        DateTime dts = DateTime.newInstance(2015, 07, 27, 18, 30, 00);
        
        dsfs__DocuSign_Recipient_Status__c docrep = new dsfs__DocuSign_Recipient_Status__c(
            name = 'Dorothy Urbancik', DSFS__DATE_DELIVERED__C = dtd, DSFS__DATE_SENT__C = dtsent,
            DSFS__DATE_SIGNED__C = dts, SA_BOOKING__C=saBooking.Id,
            dsfs__Parent_Status_Record__c = docStatus.Id,
            dsfs__DocuSign_Recipient_Id__c = '3BCD4EEB-8642-4249-804A-DC55965BCA97'
        );
        
        insert docrep;
        /*
        dsfs__DocuSign_Recipient_Status__c docrep = [select Id,Name, ,DSFS__DATE_DELIVERED__C,DSFS__DATE_SENT__C,DSFS__DATE_SIGNED__C,SA_BOOKING__C from 
                                                     dsfs__DocuSign_Recipient_Status__c where DSFS__DATE_DECLINED__C!=null AND SA_Booking__C!=null limit 1 ];
        
     */
        DateTime datedec = docrep.DSFS__DATE_SENT__C;
        datedec=datedec+1;
        docrep.DSFS__DATE_SENT__C= datedec;
            Update docrep;
            
        dsfs__DocuSign_Recipient_Status__c docrepres = [select Name,DSFS__DATE_DECLINED__C,DSFS__DATE_DELIVERED__C,DSFS__DATE_SENT__C,DSFS__DATE_SIGNED__C,SA_BOOKING__C from 
                                                     dsfs__DocuSign_Recipient_Status__c where id= :docrep.id ];
            
               
        
        System.assertEquals(datedec-1, docrepres.DSFS__DATE_SENT__C);
        
        
        
        
        
    }
    
    
    

}