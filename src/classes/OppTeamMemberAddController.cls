public class OppTeamMemberAddController {
 	public String TeamRole{get;set;}
    public String User_1{get;set;}
    public String OppAccess_1{get;set;}
    public String User_2{get;set;}
    public String OppAccess_2{get;set;}
    public String User_3{get;set;}
    public String OppAccess_3{get;set;}
    public String User_4{get;set;}
    public String OppAccess_4{get;set;}
    public String oppid{get;set;}
    public String currentuserid{get;set;}
    public OpportunityTeamMember opp;
    public List<User> AllActiveOtherUsers{get;set;}
    public map<String,String> usersandaccess{get;set;}
    
     public OppTeamMemberAddController(ApexPages.StandardController stdController){
         TeamRole='Partner';														
         oppid=System.currentPageReference().getParameters().get('OppId');  				//getting opportunity id from URL
         system.debug('%%%%'+oppid);
         currentuserid=System.currentPageReference().getParameters().get('userid'); 		//Getting User Id from URL
		 system.debug('Current User Id' + currentuserid);  
         List<User> AccountIdOfUser= [SELECT Related_Partner_Account__c from User Where Id =: currentuserid ];
         system.debug('Account Id' + AccountIdOfUser[0].Related_Partner_Account__c); 
         AllActiveOtherUsers = [SELECT Id,Name,IsActive,Email,UserRole.Name from User where Related_Partner_Account__c=: AccountIdOfUser[0].Related_Partner_Account__c AND IsActive= true ];
     	 system.debug('Active Users ' + AllActiveOtherUsers);
     }
    
    public PageReference Save(){
        
        String buttonName = System.currentPageReference().getParameters().get('buttonName'); 
        boolean temp= false;
        system.debug('button NAme: '+buttonName);
        usersandaccess = new map<String,String>();
        
        if(User_1 != null && User_1 != '' ){
            usersandaccess.put(User_1, OppAccess_1);
        }
        if(User_2 != null && User_2 != ''){
            usersandaccess.put(User_2, OppAccess_2);
        }
        if(User_3 != null && User_3 != ''){
            usersandaccess.put(User_3, OppAccess_3);
        }
        if(User_4 != null && User_4 != ''){
            usersandaccess.put(User_4, OppAccess_4);
        }
      	
        if(!usersandaccess.isEmpty()){
        	finalsave(usersandaccess);
        }
        if(usersandaccess.isEmpty()){
            
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please Select Atleast One User'));
            system.debug('inside usersandaccess.isEmpty function ');
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,'Kindly Select Atleast one user by clicking on Lookup Icon');
            ApexPages.addMessage(myMsg); 
            system.debug(myMsg);
            return null;
            //temp= true;
        }
 
        if(buttonName == 'saveButton' && temp == false){
            PageReference pageRef = new PageReference('/'+ oppid);
            return pageRef;
		}
        
        if(buttonName == 'saveAndMoreButton'  && temp == false){
       		PageReference pageRef = new PageReference('/partner/apex/OppTeamMemberAdd?OppId=' + oppid + '&userid=' + currentuserid);
        	return pageRef;
        }
    
        
       return null;
      
        
    }
    
    public PageReference finalsave(map<String, String> listofusersandaccess){
        System.debug('list of all users ' + listofusersandaccess);
       	map<String, String> updateusers = new map<String, String>();
        map<String, String> newusersinsert = new map<String, String>();
        
        //Separation of Update users and new User's List Code Starts
         for(String user : listofusersandaccess.keySet()){
              System.debug('UserId ' + user);
             if(user != null && user != ''){
              System.debug('UserId ' + user);
           	  String access = listofusersandaccess.get(user);
              System.debug('Users Access ' + access);
           
            list<OpportunityTeamMember> checkuserinteammemberalready;
        	checkuserinteammemberalready = [SELECT Id,userId, Name from OpportunityTeamMember where opportunityId=: oppid AND userId =: user];
            if(checkuserinteammemberalready.size()>0){
                updateusers.put(user, access);
            }
            else{
                newusersinsert.put(user, access);
            }
        }
         }
        
        //Separation of Update users and new User's List Code Ends
        
        
       //code for new User Insert starts
			
			if(!newusersinsert.isEmpty()){
			
			list<OpportunityTeamMember> ot = new List<OpportunityTeamMember>();
			for(String user : newusersinsert.keySet()){
                System.debug('UserId ' + user);
                if(user != null && user != ''){
                OpportunityTeamMember tempot = new OpportunityTeamMember();
				String Access = newusersinsert.get(user);
				System.debug('Access ' + Access);
                 tempot.opportunityId = oppid;
                 tempot.userId = user;
                 tempot.TeamMemberRole = TeamRole;
				if(Access == 'Read Only'){
              		tempot.OpportunityAccessLevel = 'Read';
            	}
            	if(Access == 'Read/Write'){
              		tempot.OpportunityAccessLevel = 'Edit';  
            	}
                    
				ot.add(tempot);
            	}
				}
				insert ot;
			}
			
			//code for new User Insert Ends
		
         //code for update starts
           
        if(updateusers.size() >0){
        list<OpportunityShare> os = new List<OpportunityShare>();
        for(String user : updateusers.keySet()){
            System.debug('UserId ' + user);
            if(user != null && user != ''){
            List<OpportunityShare> gettingid = [Select Id from OpportunityShare Where UserOrGroupId =: user AND OpportunityId =: oppid ];
            OpportunityShare op = new OpportunityShare(Id = gettingid[0].Id);
            String Access = updateusers.get(user);
            System.debug('Access ' + Access);
            if(Access == 'Read Only'){
              op.OpportunityAccessLevel = 'Read';
            }
            if(Access == 'Read/Write'){
              op.OpportunityAccessLevel = 'Edit';  
            }
            os.add(op);
            }
        }
            
           update os;
        }
        	//code for update ends
        
        
        return null;
        
    }
    
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/' + oppid);

        return pageRef;
        
    }
    
}