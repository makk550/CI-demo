trigger requestProcess on Access_Request__c (before insert, before Update,after update,after insert) {

Private List<SObject> sobj;
Private processURL pUrl;
Private String Namefield;
Integer resolutiontime,resolutionDays,resolutionMinutes,resolutionHours;
Long Days,Hours,minutes,milliseconds,seconds;
User ARDelegateApprover;
Id FolderId;
String FolderAccessType;

for(Access_Request__c ar : trigger.new)
{

            if(trigger.isInsert){
     
             if(trigger.isBefore){
                 if(ar.Access_for_URL__c != null){
					 pURL = new processURL(ar.Access_for_URL__c);
                     system.debug('pURL>'+pURL);
                     if(pURL.ObjectLabel!=null||pURL.ObjectName!=null){
				 if(pURL.key == '01Z'){
                     FolderId = [Select FolderId from Dashboard where Id =: pURL.RecordId].FolderId;
       				FolderAccessType = [Select accesstype from folder where id =:FolderId].accesstype;
                     if(FolderAccessType!='Hidden'){
					sobj = Database.query('Select Id, title from '+pURL.ObjectName+' where Id = \''+pURL.RecordId+'\' limit 1');
					System.debug('sobj'+sobj);
					Namefield = (String)sobj[0].get('Title');
                     }
                     else{
                        trigger.new[0].Access_for_URL__c.addError('To raise request for a private dashboard, please contact the dashboard owner.');
                     }
				}
                else if(pURL.key == '00O'){
                     FolderId = [Select OwnerId from Report where Id =: pURL.RecordId].OwnerId;
       				FolderAccessType = [Select accesstype from folder where id =:FolderId].accesstype;
                     if(FolderAccessType!='Hidden'){
					sobj = Database.query('Select Id, Name from '+pURL.ObjectName+' where Id = \''+pURL.RecordId+'\' limit 1');
					Namefield = (String)sobj[0].get('Name');
                     }
                     else{
                        trigger.new[0].Access_for_URL__c.addError('To raise request for a private report, please contact the report owner.');
                     }
				}
				else if(pURL.key == '500'){
					sobj = Database.query('Select Id, CaseNumber from '+pURL.ObjectName+' where Id = \''+pURL.RecordId+'\' limit 1');
					Namefield = (String)sobj[0].get('CaseNumber');
				}
				else{
					sobj = Database.query('Select Id, Name from '+pURL.ObjectName+' where Id = \''+pURL.RecordId+'\' limit 1');
					Namefield = (String)sobj[0].get('Name');
				}
				ar.Description__c = 'This is to request access for the '+pURL.ObjectLabel+' : '+'\''+Namefield+'\'';
                     }
                     else{
                         trigger.new[0].Access_for_URL__c.addError('Please select the right type of URL');
                     }
             }
			 else{
				ar.Description__c = ar.Comments__c;
                 system.debug('--description---'+ar.Description__c);
			 }
				ar.status__c = 'Draft';
				
				if(ar.Region__c == 'NA')
					ar.Approver__c = Label.Access_Approver_NA;
                else if (ar.Region__c == 'PS/CAN') //sunji03 - FY19, PS/CAN GEO is added.
                    ar.Approver__c = Label.Access_Approver_PSCAN;
				else if(ar.Region__c == 'LA')
					ar.Approver__c = Label.Access_Approver_LA;
				else if(ar.Region__c == 'APJ')
					ar.Approver__c = Label.Access_Approver_APJ;
				else if(ar.Region__c == 'EMEA')
					ar.Approver__c = Label.Access_Approver_EMEA;
                else if(ar.Region__c == 'Global')
                    ar.Approver__c = Label.Access_Approver_Global;
                 
                 if(pURL!=null){
                 if(pURL.key == '00O'||pURL.key == '01Z')	//assigning report and dashboard to global approver
                     ar.Approver__c = Label.Access_Approver_Global;
                 }
                 
                 /*ARDelegateApprover = [select DelegatedApproverId from User where Id = :ar.Approver__c];
                 if(ARDelegateApprover!=null)
                    ar.Approver__c = ARDelegateApprover.DelegatedApproverId; */
				 } 


               if(trigger.isAfter){
                   //AccessRequestSDTicketClass.reqIdSet = new List<String>();
				   try{
					    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
						req1.setObjectId(ar.id);
						req1.setSubmitterId(userInfo.getUserId()); 
						Approval.ProcessResult result = Approval.process(req1);
                       	
                       	if(ar.Type__c=='Create Service Desk Ticket')
                            AccessRequestSDTicketClass.createSDTicket(ar.id);
				   }
				   catch(exception e){
					    system.debug('exception'+e);
						throw e;
				   }
			   }				 
            
            }
            
            else if(Trigger.isUpdate){
             
             String messageToPost,approverId,L2Group;
               
                if(Trigger.isBefore){
                if(ar.Status__c == 'Rejected' && Trigger.Oldmap.get(ar.Id).Status__c != 'Rejected')
                ar.RecordTypeId = Schema.SObjectType.Access_Request__c.getRecordTypeInfosByName().get('AfterApproval').getRecordTypeId();
                if((ar.Status__c == 'Approved and Access Granted' && Trigger.Oldmap.get(ar.Id).Status__c != 'Approved and Access Granted')  || (ar.Status__c == 'Rejected' && Trigger.Oldmap.get(ar.Id).Status__c != 'Rejected')){
                     
                    milliseconds = DateTime.now().getTime()- ar.CreatedDate.getTime();
                    seconds = milliseconds / 1000;
                    minutes = seconds / 60;
                    hours = minutes / 60;
                    days = hours / 24;
                    
                    
                    resolutionDays= Integer.Valueof(days);
                    resolutionHours = Integer.Valueof(hours - days*24);
                    resolutionMinutes= Integer.Valueof(minutes- hours*60);
                    
                    ar.Total_Minutes_to_Resolve__c = resolutionMinutes;
                    System.debug('Hours'+Hours+'Days'+Days+'Minutes'+Minutes);
                
                    ar.Time_to_Resolve__c = '';
                   
                    if(Days != 0)
                    ar.Time_to_Resolve__c += resolutionDays+' Day(s) ';
                    
                    if(Hours != 0)
                    ar.Time_to_Resolve__c += resolutionHours+' Hour(s) ';
                    
                    ar.Time_to_Resolve__c += resolutionMinutes+' Minute(s) ';
                    
                    messageToPost = ' Your access request have been '+ar.Status__c;
                    chatterPost.mentionTextPost(ar.ID,ar.Request_For__c,messageToPost);
                    chatterPost.postFeedbackPoll(ar.ID, ar.Request_For__c);
                }
                
                
            }
            else if(Trigger.isAfter && Trigger.isUpdate) {
            
                if(ar.Status__c == 'Pending for Approval'){
                             
                    messageToPost = ' Access Request : '+ar.Name+' is submitted for your approval';
                    system.debug('ar.id and Approver > '+ar.ID+' '+ar.Approver__c);
                    chatterPost.mentionTextPost(ar.ID,ar.Approver__c ,messageToPost);
                
                }
            }
          
        }

}
}