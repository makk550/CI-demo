Trigger PartnerEngagementProgramTrigger on Partner_Engagement_Program__c (before insert, before update) {


    Set<Id> oppId = new Set<Id>();
    Set<Id> contactIds = new Set<Id>();
    Set<Id> contactIdList = new Set<Id>();
    List<Contact> contactList = new List<Contact>();
    Map<id,Contact> contactIdMap = new Map<id,Contact>();
    Set<Id> oldParContactIds = new Set<Id>();
    Set<Id> oldPContUserIds = new Set<Id>();
    Map<ID, set<ID>> oppToOppSalesTeamMap = New Map<ID, set<ID>>();
    User usA=[select Alias from User where Id=:UserInfo.getUserId() limit 1];
     for(Partner_Engagement_Program__c per:trigger.new){
         if (per.Distributor_Contact__c != null)
                contactIdList.add( per.Distributor_Contact__c );
            else if( per.Partner_Contact__c != null ){
                contactIdList.add( per.Partner_Contact__c );
            } 
    }system.debug('contactIdList'+contactIdList);
    if(contactIdList!= null && contactIdList.size()>0) contactList=[select Id,Active_User__c FROM contact Where Id IN : contactIdList];
    system.debug('contactList'+contactList);
    for(contact con:contactList){
        if(con.Active_User__c){
            contactIdMap.put(con.id,con);
        }
    }
    system.debug('contactIdMap'+contactIdMap);
    if ( Trigger.isInsert ) {
        
        for ( Partner_Engagement_Program__c per : Trigger.new ) {
        system.debug('per.Parent_Opportunity__c'+per.Parent_Opportunity__c+' trigger '+Trigger.new);
        system.debug('per.Partner_Contact__c'+per.Partner_Contact__c);
            if( per.Parent_Opportunity__c != null ){
                oppId.add( per.Parent_Opportunity__c );
            }
            
            if (per.Distributor_Contact__c != null && contactIdMap!= null && contactIdMap.get(per.Distributor_Contact__c) !=null)
                contactIds.add( contactIdMap.get(per.Distributor_Contact__c).id );
            else if( per.Partner_Contact__c != null && contactIdMap!= null && contactIdMap.get(per.Partner_Contact__c) !=null ){
                contactIds.add( contactIdMap.get(per.Partner_Contact__c).id );
                
            }
        }

    } else if ( Trigger.IsUpdate ) {

        for( Partner_Engagement_Program__c per : Trigger.new ){
            system.debug('per.Parent_Opportunity__c'+per.Parent_Opportunity__c+' trigger '+Trigger.new);
            system.debug('per.Partner_Contact__c'+per.Partner_Contact__c);
            if( per.Status__c != Trigger.oldMap.get(per.Id).Status__c || per.Partner_Engagement_Type__c != Trigger.oldMap.get(per.Id).Partner_Engagement_Type__c ){

                    if( per.Parent_Opportunity__c != null ){
                    oppId.add( per.Parent_Opportunity__c );
                }
                if (per.Distributor_Contact__c != null && contactIdMap!= null && contactIdMap.get(per.Distributor_Contact__c) !=null)
                contactIds.add( contactIdMap.get(per.Distributor_Contact__c).id );
                 else if( per.Partner_Contact__c != null && contactIdMap!= null && contactIdMap.get(per.Partner_Contact__c) !=null ){
                contactIds.add( contactIdMap.get(per.Partner_Contact__c).id );
                 }
                //Yedra01 for 3137 & 3139
                if( Trigger.Isbefore && per.Status__c != Trigger.oldMap.get(per.Id).Status__c && per.Status__c == 'Approved'&&per.Partner_Contact__c ==null&&per.Partner__c==null ) {
                    per.adderror('Partner and Partner Contact should be filled in.Please press Backspace and provide Partner and Partner Contact to proceed');
                }

            }

            // Partner contact Blanked out or Partner contact changed 
            if( (per.Partner_Contact__c == NULL && per.Partner_Contact__c != Trigger.OldMap.get(per.id).Partner_Contact__c) || (per.Status__c == 'Partner Obligation Not Met' && per.Status__c != Trigger.OldMap.get(per.id).Status__c)|| (per.Status__c == 'Deal Changed to MSP' && per.Status__c != Trigger.OldMap.get(per.id).Status__c) || (per.Status__c == 'Conflict of Interest' && per.Status__c != Trigger.OldMap.get(per.id).Status__c)){

                oldParContactIds.add( Trigger.OldMap.get(per.id).Partner_Contact__c );
                oppToOppSalesTeamMap.put(per.Parent_Opportunity__c, oldParContactIds);
                //Added for US94234 :SINJY02
                
                    if(per.Distributor_Contact__c != null){
                        oldParContactIds.add( Trigger.OldMap.get(per.id).Distributor_Contact__c );
                        oppToOppSalesTeamMap.put(per.Parent_Opportunity__c, oldParContactIds);
                    }
                //US94234 ends here

            }else if( per.Partner_Contact__c != NULL && Trigger.OldMap.get(per.id).Partner_Contact__c != NULL && per.Partner_Contact__c != Trigger.OldMap.get(per.id).Partner_Contact__c ){

                oldParContactIds.add( Trigger.OldMap.get(per.id).Partner_Contact__c );
                oppToOppSalesTeamMap.put(per.Parent_Opportunity__c, oldParContactIds);

            } 
            //Added for US94234 :SINJY02
            if( per.Distributor_Contact__c != NULL && Trigger.OldMap.get(per.id).Distributor_Contact__c != NULL && per.Distributor_Contact__c != Trigger.OldMap.get(per.id).Distributor_Contact__c ){

                oldParContactIds.add( Trigger.OldMap.get(per.id).Distributor_Contact__c );
                oppToOppSalesTeamMap.put(per.Parent_Opportunity__c, oldParContactIds);

            }//US94234 ends here

        }

    }
    
    if( trigger.isBefore && (trigger.isInsert || trigger.isUpdate) ) {
    
        // Prepare a map of Opportunity ID to PER's for validation
        Map<Id,Opportunity> oppToPERsMap = new Map<Id,Opportunity>(
                [SELECT Id, (SELECT Id, Status__c FROM Partner_Engagement_Requests__r where (Status__c != null AND Status__c != '' AND Status__c =: 'Approved')) 
                    FROM Opportunity where ID in : oppId]);
    
        // Throw an error if there is already an PER with Status Approved associated to associated Opportunity
        for ( Partner_Engagement_Program__c per : trigger.new ) {
            if(per.status__c!='Partner Obligation Not Met'){
            if( oppToPERsMap.get(per.Parent_Opportunity__c) != null  ){
                
                if( oppToPERsMap.get(per.Parent_Opportunity__c).Partner_Engagement_Requests__r.size() != 0 ){
            
                   // per.addError('There already exists an PER with Approved Status');
        
                }

            }
            }
        }

    }
    
    // Prepare a map of Opportunity ID to Opportunity to traverse from PER to Opportunity.
    //Map<Id, Opportunity> OppMap = new Map<Id, Opportunity>([SELECT Id, Partner_Engagement__c FROM Opportunity WHERE Id IN :oppId]);
    Map<Id, Opportunity> OppMap = new Map<Id, Opportunity>([SELECT Id,isPEROpp__c, SkipPERValidation__c,Partner_Engagement__c,Distributor_6__c,Type,Transaction_Type_Test__c,Reseller__c,Reseller_Contact__c,Distributor__c,Distributor_Contact__c FROM Opportunity WHERE Id IN :oppId]);
    // Prepare a map of Partner Contact to User ID to use when Opportunity Sales Team to be created.
    Map<Id,Id> contactUserIdMap = new Map<Id,Id>();

    if ( contactIds.isEmpty() == false ) {
        system.debug('contactIds'+contactIds);
        for ( User u : [select Id, ContactID from User where ContactId IN :contactIds] ) {
            
            contactUserIdMap.put( u.ContactId, u.Id );
            
        }
        system.debug('contactUserIdMap'+contactUserIdMap);
    }
    
    if (oldParContactIds.isEmpty()== false &&usA.Alias!=Label.Damigration_User_Alias) {
        
        for(User u : [Select Id from User where ContactId IN :oldParContactIds ])
            
            oldPContUserIds.add(u.Id);

    }

    List<Opportunity> updateOppList = new List<Opportunity>();
    List<OpportunityTeamMember> insertOppMbrList = new List<OpportunityTeamMember>();
    Set<id> oppIdsForOppShrSet = new Set<id>(); 
    
    List <OpportunityContactRole> insertOppContactRoleList = new List<OpportunityContactRole>(); //AR 3503
    Set<Id> deleteContactFromOppContactRole = new Set<Id>(); //AR 3503
    Map<Id,boolean> oppPrimaryContactRoleMap = Opportunity_ContactRole_Class.oppPrimaryContactRole(oppId); //AR:3503

    for ( Partner_Engagement_Program__c per : Trigger.new ) {
        
        // Update Opportunity Partner Engagement Type to Pending, if PER Status is 'New' or 'Pending Approval' 
        if( per.Status__c == 'New' || per.Status__c == 'Pending Approval' ){
        
            if( OppMap.get(per.Parent_Opportunity__c) != null ){    
                OppMap.get(per.Parent_Opportunity__c).isPEROpp__c = true; 
                OppMap.get(per.Parent_Opportunity__c).SkipPERValidation__c = true; 
                OppMap.get(per.Parent_Opportunity__c).Partner_Engagement__c = 'Pending';
                updateOppList.add(OppMap.get(per.Parent_Opportunity__c));

            }
            
        // Update Opportunity Partner Engagement Type to Collaborative, if PER Status is 'Approved' and Partner Engagement Type is 'Collaborative' 
        } else if ( per.Status__c == 'Approved' && per.Distributor__c == null && per.Distributor_Contact__c == null ){
            system.debug('block number 1');
            if( OppMap.get(per.Parent_Opportunity__c) != null ){
                per.Approval_Notification_recipient__c = per.Partner_Contact__c;
                if(per.Partner_Engagement_Type__c == 'Collaborative')OppMap.get(per.Parent_Opportunity__c).Partner_Engagement__c = 'Collaborative';
                if(per.Partner_Engagement_Type__c == 'Fulfillment')OppMap.get(per.Parent_Opportunity__c).Partner_Engagement__c = 'Fulfillment-Only';
                OppMap.get(per.Parent_Opportunity__c).Type = '1 Tier'; 
                OppMap.get(per.Parent_Opportunity__c).Transaction_Type_Test__c = 'Resell without a distributor';
                 OppMap.get(per.Parent_Opportunity__c).SkipPERValidation__c = true; 
                if(per.Partner__c != null )OppMap.get(per.Parent_Opportunity__c).Reseller__c = per.partner__c;
                if(per.Partner_Contact__c != null )OppMap.get(per.Parent_Opportunity__c).Reseller_Contact__c = per.Partner_Contact__c;
                if(per.Status__c == 'Approved'&&per.Partner_Contact__c !=null&&per.Partner__c!=null )                
                updateOppList.add(OppMap.get(per.Parent_Opportunity__c));
            }
            
            // Partner Contact is added to the Opportunity Sales Team with Read/Write access with Partner Role 
            OpportunityTeamMember oppTeamMbr = new OpportunityTeamMember();
            oppTeamMbr.UserId = contactUserIdMap.get(per.Partner_Contact__c);
            oppTeamMbr.OpportunityId = per.Parent_Opportunity__c;
            oppTeamMbr.TeamMemberRole = 'Partner';
            if(per.Status__c == 'Approved'&&per.Partner_Contact__c !=null&&per.Partner__c!=null ) 
                system.debug('oppTeamMbr 1'+oppTeamMbr);
             if(oppTeamMbr.UserId != null)
             insertOppMbrList.add(oppTeamMbr);

            oppIdsForOppShrSet.add(per.Parent_Opportunity__c);

        // Update Opportunity Partner Engagement Type to Fulfillment, if PER Status is 'Approved' and Partner Engagement Type is 'Fulfillment' 
        }  
        else if ( per.Status__c == 'Approved' && per.Distributor__c != null && per.Distributor_Contact__c != null ){
            system.debug('block number 2');
            if( OppMap.get(per.Parent_Opportunity__c) != null ){
                per.Approval_Notification_recipient__c = per.Distributor_Contact__c;
                if(per.Partner_Engagement_Type__c == 'Collaborative')OppMap.get(per.Parent_Opportunity__c).Partner_Engagement__c = 'Collaborative';
                if(per.Partner_Engagement_Type__c == 'Fulfillment')OppMap.get(per.Parent_Opportunity__c).Partner_Engagement__c = 'Fulfillment-Only';
                //Jyoti : Commented for changed Req on 3137 3139,now Distributor and Distributor Contact are deciding factors for 1 tier & 2 tier
                //OppMap.get(per.Parent_Opportunity__c).Type = '1 Tier';   
                OppMap.get(per.Parent_Opportunity__c).Type = '2 Tier';
                OppMap.get(per.Parent_Opportunity__c).Transaction_Type_Test__c = 'Resell with a distributor';
                 OppMap.get(per.Parent_Opportunity__c).SkipPERValidation__c = true; 
                if(per.Partner__c != null )OppMap.get(per.Parent_Opportunity__c).Reseller__c = per.partner__c;
                if(per.Partner_Contact__c != null )OppMap.get(per.Parent_Opportunity__c).Reseller_Contact__c = per.Partner_Contact__c;
                
                if(per.Distributor__c != null )OppMap.get(per.Parent_Opportunity__c).Distributor_6__c = per.Distributor__c;
                if(per.Distributor_Contact__c != null )OppMap.get(per.Parent_Opportunity__c).Distributor_Contact__c = per.Distributor_Contact__c;
                if(per.Status__c == 'Approved'&&per.Partner_Contact__c !=null&&per.Partner__c!=null )                
                updateOppList.add(OppMap.get(per.Parent_Opportunity__c));
            }
            
            // Partner Contact is added to the Opportunity Sales Team with Read/Write access with Partner Role 
            OpportunityTeamMember oppTeamMbr = new OpportunityTeamMember();
            oppTeamMbr.UserId = contactUserIdMap.get(per.Distributor_Contact__c);
            oppTeamMbr.OpportunityId = per.Parent_Opportunity__c;
            oppTeamMbr.TeamMemberRole = 'Partner';
            system.debug('oppTeamMbr 2'+oppTeamMbr);
             if(oppTeamMbr.UserId != null)
             insertOppMbrList.add(oppTeamMbr);
            
            oppIdsForOppShrSet.add(per.Parent_Opportunity__c);

        // Update Opportunity Partner Engagement Type to BLANK, if PER Status is 'Rejected'
        } else if( per.Status__c == 'Rejected' || per.Status__c == 'Partner Obligation Not Met' || per.Status__c == 'Deal Changed to MSP' || per.Status__c == 'Conflict of Interest'){
            system.debug('block number 3');
            if( OppMap.get(per.Parent_Opportunity__c) != null ){
                OppMap.get(per.Parent_Opportunity__c).Partner_Engagement__c = '';
                if(per.Status__c == 'Partner Obligation Not Met'  || per.Status__c == 'Deal Changed to MSP' || per.Status__c == 'Conflict of Interest'){
                    OppMap.get(per.Parent_Opportunity__c).Type='Direct';
                    OppMap.get(per.Parent_Opportunity__c).Transaction_Type_Test__c='Direct';
                    OppMap.get(per.Parent_Opportunity__c).Reseller__c = null;
                    OppMap.get(per.Parent_Opportunity__c).Reseller_Contact__c = null;
                    OppMap.get(per.Parent_Opportunity__c).Distributor_6__c = null;
                    OppMap.get(per.Parent_Opportunity__c).Distributor_Contact__c = null;
                    
                    
                    
                }
                 OppMap.get(per.Parent_Opportunity__c).SkipPERValidation__c = true;
                //if(per.Status__c == 'Approved'&&per.Partner_Contact__c !=null&&per.Partner__c!=null )                
                updateOppList.add(OppMap.get(per.Parent_Opportunity__c));
            }
            
        }
    
    }
        
        
    //AR:3503 -- starts 
    
    System.debug('oppPrimaryContactRoleMap:'+oppPrimaryContactRoleMap);    
    boolean isDistiPrimary = false;
    if(Trigger.isBefore && Trigger.isUpdate ){
        
        for (Partner_Engagement_Program__c per : Trigger.new ) {
            
            if(Trigger.oldmap.get(per.Id).Status__c!= per.Status__c && per.Status__c == 'Approved'){
                            
                if(per.Distributor_Contact__c!= null){
                    OpportunityContactRole oppContactRole_disti = new OpportunityContactRole();
                    oppContactRole_disti.ContactId = per.Distributor_Contact__c;
                    oppContactRole_disti.OpportunityId = per.Parent_Opportunity__c;
                    oppContactRole_disti.Role = 'Partner';
                    if(oppPrimaryContactRoleMap.containsKey(per.Parent_Opportunity__c)){
                        oppContactRole_disti.IsPrimary = (oppPrimaryContactRoleMap.get(per.Parent_Opportunity__c)?false:true);
                    }
                    else{
                        oppContactRole_disti.IsPrimary = true;                        
                    }
                    isDistiPrimary = oppContactRole_disti.IsPrimary;                  
                    insertOppContactRoleList.add(oppContactRole_disti);
                }                   
                                        
                OpportunityContactRole oppContactRole = new OpportunityContactRole();
                oppContactRole.ContactId = per.Partner_Contact__c;     
                if(!isDistiPrimary){
                    if(oppPrimaryContactRoleMap.containsKey(per.Parent_Opportunity__c)){
                        oppContactRole.IsPrimary = (oppPrimaryContactRoleMap.get(per.Parent_Opportunity__c)?false:true);
                    }
                    else{
                        oppContactRole.IsPrimary = true;
                    }                   
                }        
               
                oppContactRole.OpportunityId = per.Parent_Opportunity__c;
                oppContactRole.Role = 'Partner';
                insertOppContactRoleList.add(oppContactRole);                 
                
         
                 
            }        
            if((Trigger.oldmap.get(per.Id).Status__c!= per.Status__c && per.Status__c == 'Partner Obligation Not Met') ||(Trigger.oldmap.get(per.Id).Status__c!= per.Status__c && per.Status__c == 'Deal Changed to MSP') || (Trigger.oldmap.get(per.Id).Status__c!= per.Status__c && per.Status__c == 'Conflict of Interest')){          
                deleteContactFromOppContactRole.add(per.Partner_Contact__c);
                if(per.Distributor_Contact__c!= null){
                    deleteContactFromOppContactRole.add(per.Distributor_Contact__c);
                }
            }               
        }           
    }
      
    if(insertOppContactRoleList.isEmpty() == false){
        try{
            System.debug('Adding Opp Contact Role');
            System.debug('insertOppContactRoleList:'+insertOppContactRoleList);
            Database.Insert(insertOppContactRoleList);
        }
        catch(Exception e){
            system.debug('*** PER Trigger ***: Exception while inserting Opp Contact Role on the Related Opportunity --> '+e );
        }
    }
    
    if(deleteContactFromOppContactRole.isEmpty() == false){
        try{
            System.debug('Deleting Opp Contact Role');
            System.debug('deleteContactFromOppContactRole -- ContactIds:'+deleteContactFromOppContactRole);
            
            List<OpportunityContactRole> deleteOppContactRoleList = [select id,contactId from OpportunityContactRole where ContactId IN :deleteContactFromOppContactRole];
            System.debug('deleteOppContactRoleList:'+deleteOppContactRoleList);
            Database.Delete(deleteOppContactRoleList);          
        }
        catch(Exception e){
            system.debug('*** PER Trigger ***: Exception while deleting Opp Contact Role on the Related Opportunity --> '+e );
        }
    }
    
    //AR:3503 -- ends
    
    
    // Update Opportunities
    if( updateOppList.isEmpty() == false ){
        
        try{
            system.debug('block number 4'+updateOppList);
            //Database.Update( updateOppList );
            update updateOppList;
            system.debug('block number 8'+updateOppList);

        }catch( DMLException ex ){
        
            system.debug('*** PERTrigger ***: Exception while updating Related Opportunity --> '+ex );

        }
        
    }
    
    if( insertOppMbrList.isEmpty() == false ){

        // Insert Opportunity Team Member
        try{
            system.debug('block number 5');
            system.debug('insertOppMbrList'+insertOppMbrList);
            Database.Insert( insertOppMbrList );
            
        }catch( DMLException ex ){
            trigger.new[0].adderror(ex);
            system.debug('*** PERTrigger ***: Exception while inserting Opp Sales Team on the Related Opportunity --> '+ex );

        }
        
        if( oppIdsForOppShrSet.isEmpty() == false ){
            system.debug('block number 6');
            List<OpportunityShare> shares = [select Id, OpportunityAccessLevel,RowCause from OpportunityShare where OpportunityId IN :oppIdsForOppShrSet 
                                            and RowCause = 'Team' and OpportunityAccessLevel!='Edit'];
            
            for ( OpportunityShare share : shares ){
            
                share.OpportunityAccessLevel = 'Edit';
                
            }    
            
            // Update Opportunity Share records for the Opportunity Team Member created.
            try{Update shares;
               }
            catch(DMLException ex){
                trigger.new[0].adderror(ex);
            }
            system.debug('block number 6 after update');
        }

    }
    
    if ( oppToOppSalesTeamMap.keyset().size() > 0&&usA.Alias!=Label.Damigration_User_Alias){
        system.debug('block number 7 delete oppteammember');
        List<OpportunityTeamMember> DeleteOppTeamMemberList = [ SELECT id, UserId FROM OpportunityTeamMember 
                                                                    WHERE OpportunityId IN : oppToOppSalesTeamMap.keyset()
                                                                            AND  UserId IN : oldPContUserIds 
                                                                            AND TeamMemberRole = 'Partner' ] ;
                                                                            
        if( DeleteOppTeamMemberList.isEmpty() == false ){
        
            try{
            system.debug('block number 7 delete execute');
                Database.Delete( DeleteOppTeamMemberList );
                
            }catch( DMLException ex ){
                trigger.new[0].adderror(ex);
                system.debug('*** PERTrigger ***: Exception while deleting Opp Sales Teams --> '+ex );
    
            }
            
        }

    }
    
     list<opportunity> resetSkipPERValidation1 = new List<opportunity>();
    for(opportunity opp:updateOppList){
       
        if(opp.SkipPERValidation__c){
            opp.SkipPERValidation__c = false;
            resetSkipPERValidation1.add(opp);
        }        
        
    }  system.debug('block number 7'+resetSkipPERValidation1); 
    if(resetSkipPERValidation1.size()>0) update resetSkipPERValidation1; 
    
}