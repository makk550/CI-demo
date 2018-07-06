@IsTest(SeeAllData=true)

Public Class TestPartnerOpptySalesTeam {
  public static testmethod void TestMethodForPartnerOpptySalesTeam(){
            
        Schema.DescribeSObjectResult oppresult = Schema.SObjectType.Opportunity;
        Map<String,Schema.RecordTypeInfo> oppRecType = oppresult.getRecordTypeInfosByName();
        Id oppRecId = oppRecType.get('Deal Registration').getRecordTypeId();
        Set<string> accIds = new Set<string> ();
        List<User> lstUser=[Select id,pmfkey__c from user where PMFKey__c <> null and isActive = true limit 3];
        user u1= lstUser[0];
        user u2= lstUser[1];
        user u3= lstUser[2];

        Account acc = new Account(Name='Test_Acc1',RecordTypeId='01230000000GaFd',Customer_Category__c='Reseller',Reseller_Disti_Regional_ID__c='101',Alliance__c=true,Alliance_Designation__c='ISV',Alliance_Program_Level__c='Premium',Alliance_Type__c='Global Systems Integrator',Service_Provider__c=true,Solution_Provider__c=true,Service_Provider_Program_level__c='Premium',Solution_Provider_Designation__c='FED',Solution_Provider_Program_Level__c='Premium',Solution_Provider_Type__c='Reseller',Alliance_CAM_PMFKey__c=u1.pmfkey__c,Service_Provider_CAM_PMFKey__c=u2.pmfkey__c,Solution_Provider_CAM_PMFKey__c=u3.pmfkey__c,Enterprise_Account_Name__c='E_Acc1',GEO__c='NA');
        Account acc2 = new Account(Name='Test_Acc2',RecordTypeId='01230000000GaFd',Alliance__c=true, Alliance_Program_Level__c='Premium',Service_Provider__c=true,Solution_Provider__c=true,Solution_Provider_Designation__c='FED',Solution_Provider_Program_Level__c='Premium', Service_Provider_Program_level__c='Premium',Solution_Provider_Type__c='Reseller',Customer_Category__c='Reseller',Reseller_Disti_Regional_ID__c='101',Alliance_CAM_PMFKey__c= u1.pmfkey__c,Service_Provider_CAM_PMFKey__c=u2.pmfkey__c,Solution_Provider_CAM_PMFKey__c=u3.pmfkey__c,Enterprise_Account_Name__c='E_Acc1',GEO__c='NA');
        insert acc2;
        insert acc;
        accIds.add(acc.Id);
        accIds.add(acc2.Id);

        //Manikandan Raju
        Contact con = new Contact(LastName = 'TestCon1',AccountId = acc.Id); 
        Contact con2 = new Contact(LastName = 'TestCon2',AccountId = acc2.Id); 
        insert con;
        insert con2;
        
        
        Set<String> newpmfKeys = new Set<String>();
        newpmfKeys.add(acc.Alliance_CAM_PMFKey__c);
        newpmfKeys.add(acc.Service_Provider_CAM_PMFKey__c);
        newpmfKeys.add(acc.Solution_Provider_CAM_PMFKey__c);
        newpmfKeys.add(acc2.Alliance_CAM_PMFKey__c);
        newpmfKeys.add(acc2.Service_Provider_CAM_PMFKey__c);
        newpmfKeys.add(acc2.Solution_Provider_CAM_PMFKey__c);
        Map<String,Id> usrlst= new Map<String,Id>();
        
        Set<String> oldpmfKeys = new Set<String>();
        oldpmfKeys.add(acc.Alliance_CAM_PMFKey__c);
        oldpmfKeys.add(acc.Service_Provider_CAM_PMFKey__c);
        oldpmfKeys.add(acc.Solution_Provider_CAM_PMFKey__c);
        oldpmfKeys.add(acc2.Alliance_CAM_PMFKey__c);
        oldpmfKeys.add(acc2.Service_Provider_CAM_PMFKey__c);
        oldpmfKeys.add(acc2.Solution_Provider_CAM_PMFKey__c);
        
        Opportunity opp1 = new Opportunity(Name='Opp1',Reseller__c=acc2.Id,Partner__c=acc2.Id, Partner_1__c=acc2.Id,RecordTypeId=oppRecId,CloseDate=System.today()+3,StageName=Label.Opp_Stage_10_Percent,Initial_Billing__c=2,Ent_Comm_Account__c=acc.Id);
        Opportunity opp2 = new Opportunity(Name='Opp2',Reseller__c=acc.Id,RecordTypeId=oppRecId,Partner_1__c=acc.Id,Partner__c=acc.Id,CloseDate=System.today()+5,StageName=Label.Opp_Stage_10_Percent,Initial_Billing__c=2);
        Opportunity[] listopp = new Opportunity[]{opp1,opp2};
        insert listopp; 

        OpportunityContactRole OppConRole1 = new OpportunityContactRole(ContactId = con.id, OpportunityId = opp1.id, IsPrimary = true, Role = 'Advisor');
        OpportunityContactRole OppConRole2 = new OpportunityContactRole(ContactId = con2.id, OpportunityId = opp2.id, IsPrimary = true, Role = 'Advisor');
        OpportunityContactRole[] OpportunityContactRoleList = new OpportunityContactRole[]{OppConRole1,OppConRole2};
        //try{insert OpportunityContactRoleList;}catch(Exception e){}
        
        
          Map<String,String> pmfKeys = new Map<String,String>();
          pmfKeys.put(acc.Alliance_CAM_PMFKey__c,acc.Alliance_CAM_PMFKey__c);
          pmfKeys.put(acc.Service_Provider_CAM_PMFKey__c,acc.Service_Provider_CAM_PMFKey__c);
          pmfKeys.put(acc.Solution_Provider_CAM_PMFKey__c,acc.Solution_Provider_CAM_PMFKey__c);
          pmfKeys.put(acc.Velocity_Seller_CAM_PMFKey__c,acc.Velocity_Seller_CAM_PMFKey__c);
          
          pmfKeys.put(acc2.Alliance_CAM_PMFKey__c,acc2.Alliance_CAM_PMFKey__c);
          pmfKeys.put(acc2.Service_Provider_CAM_PMFKey__c,acc2.Service_Provider_CAM_PMFKey__c);
          pmfKeys.put(acc2.Solution_Provider_CAM_PMFKey__c,acc2.Solution_Provider_CAM_PMFKey__c);
          pmfKeys.put(acc2.Velocity_Seller_CAM_PMFKey__c,acc2.Velocity_Seller_CAM_PMFKey__c);
    
    
        Map<String,Map<String,String>> mPmfKeys = new  Map<String,Map<String,String>> ();
        mPmfKeys.put('Alliance',pmfKeys);
        mPmfKeys.put('Service Provider',pmfKeys);
        mPmfKeys.put('Solution Provider',pmfKeys);
        mPmfKeys.put('Reseller',pmfKeys);
    
        Map<Id,Map<String,Map<String,String>>> accntsMap = new Map<Id,Map<String,Map<String,String>>> ();
        accntsMap.put(acc.Id,mPmfKeys);
        accntsMap.put(acc2.Id,mPmfKeys);

        List<OpportunityTeamMember> newOpportunityTeamMemberList = new List<OpportunityTeamMember>();
         CreatePartnerOpptySalesTeam crtOppsalesTeam = new CreatePartnerOpptySalesTeam();
        crtOppsalesTeam.updateOpportunitySalesTeam(accntsMap,oldpmfKeys,newpmfKeys);
        List<User> usr= [select id,pmfkey__c from user where PMFKey__c in:newpmfKeys];
        for(User u: usr){
            usrlst.put(u.pmfkey__c,u.id); 
        }
         Map<String,Id> Oldusrlst= new Map<String,Id>();
        List<User> Oldusr= [select id,pmfkey__c from user where PMFKey__c in:oldpmfKeys];
        for(User u: usr){
            Oldusrlst.put(u.pmfkey__c,u.id); 
        }
         Id usrId = usrlst.get(u1.pmfkey__c) ;
         if(usrId!=null){
         OpportunityTeamMember oppTeam = new OpportunityTeamMember(OpportunityId = Opp1.Id ,TeamMemberRole = 'TAQ-PARTN SOLPROV',UserId = usrId);   
         newOpportunityTeamMemberList.add(oppTeam);
         }
         
         if(Opp1.Partner__c != null ){
           OpportunityTeamMember oppTeam = new OpportunityTeamMember();
           oppTeam.OpportunityId = Opp1.Id ;
           Id usrId1 = usrlst.get(u2.pmfkey__c) ;
           if(usrId1!=null){
           oppTeam.TeamMemberRole = 'TAQ-PARTN SERPROV';
           oppTeam.UserId = usrId1;
        //   insert oppTeam;
           newOpportunityTeamMemberList.add(oppTeam);
           }
         }
        if(Opp1.Partner_1__c != null ){
            OpportunityTeamMember oppTeam = new OpportunityTeamMember();
            oppTeam.OpportunityId = Opp1.Id ;
            Id usrId2 = usrlst.get(u3.pmfkey__c) ;
            if(usrId!=null){
                oppTeam.TeamMemberRole = 'TAQ-PARTN ALLIANCE';
                oppTeam.UserId = usrId2;
            //      insert oppTeam;
                newOpportunityTeamMemberList.add(oppTeam);
            }
        }
        if(newOpportunityTeamMemberList.size()>0){
          Integer i = 0;
          if(newOpportunityTeamMemberList.size() < i )
          {
            Test.startTest();
            Insert newOpportunityTeamMemberList;
            Test.stopTest();
            i++ ;
          }else{
            List<String> OppDetails = new List<String>();
            List<String> userDetails = new List<String>();
            List<String> roleDetails = new List<String>();
            for(OpportunityTeamMember OppTeemMember :newOpportunityTeamMemberList)
            {
              OppDetails.add(OppTeemMember.OpportunityId);
              userDetails.add(OppTeemMember.UserId);
              roleDetails.add(OppTeemMember.TeamMemberRole);
            }
            
             //obj = new CreatePartnerOpptySalesTeam();
            CreatePartnerOpptySalesTeam.UpdateTeamMember(OppDetails,userDetails,roleDetails);
          }
        }
        
       
        
  }
}