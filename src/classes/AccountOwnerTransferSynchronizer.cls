public class AccountOwnerTransferSynchronizer {
    public static string INTEGRATION_ACCOUNT_TITLE = 'SAPXI';
    public static string ERROR_SOURCE_NAME = 'AccountOwnerTransferProcess';
    public static string DMLROW_LIMIT_EXCEEDED = 'DML Row limits exceeded';
     
    private ErrorLog__c[] errors;
    private AccountOwnerTransferRequest[] transferRequests;
      
    public integer maxDmlRows {get;set;}
    
    public boolean hasRequests {
        get {
            return (!transferRequests.isEmpty());
        }
    }
     
    public AccountOwnerTransferSynchronizer() {
        errors = new ErrorLog__c[0];
        transferRequests = new AccountOwnerTransferRequest[0];
        maxDmlRows = Limits.getLimitDmlRows();
    }
    
    public void addRequest(Account a, Id oldOwnerId, Id newOwnerId) {
        AccountOwnerTransferRequest request = new AccountOwnerTransferRequest();
        request.TargetAccount = a;
        request.OldOwnerId = oldOwnerId;
        request.NewOwnerId = newOwnerId;
        
        transferRequests.add(request);
    }
    
    public void executeTransferRequests() {
        map<Id, AccountOwnerTransferRequest> requestMap = new map<Id, AccountOwnerTransferRequest>();
        
        Id[] accountIds = new Id[0];
        for (AccountOwnerTransferRequest r : transferRequests) {
            requestMap.put(r.TargetAccount.Id, r);
            accountIds.add(r.TargetAccount.Id);
        } 
        System.debug('Accounts to transfer: ' + accountIds.size());
         
        // Retrieve Contacts 
        for(Contact[] contacts : [select id, ownerId, accountId, (select Id, ownerId, ParentId from Notes) from Contact where AccountId in : accountIds]) {
            for (Contact c : contacts) {
                AccountOwnerTransferRequest r = requestMap.get(c.AccountId);
                
                if (c.OwnerId == r.OldOwnerId) {
                    c.OwnerId = r.NewOwnerId;
                    r.Contacts.add(c);
                }
                
                for (Note n : c.Notes) {
                    if (n.OwnerId == r.OldOwnerId) {
                        n.OwnerId = r.NewOwnerId;
                        r.Notes.add(n);
                    }
                }
            }
        }
        
        // Retrieve Opportunities
        for (Opportunity[] opps : [select id, ownerId, accountId, (select Id, ownerId, ParentId from Notes) from Opportunity where AccountId in : accountIds and isClosed = false]) {
            for (Opportunity o : opps) {
                AccountOwnerTransferRequest r = requestMap.get(o.AccountId);
                
                if (o.OwnerId == r.OldOwnerId) {
                    o.OwnerId = r.NewOwnerId;
                    r.Opportunities.add(o);
                }
                System.debug('opp count: ' + r.Opportunities.size());
                for (Note n : o.Notes) {
                    if (n.OwnerId == r.OldOwnerId) {
                        n.OwnerId = r.NewOwnerId;
                        r.Notes.add(n);
                    }
                }
            }
        }
        
        // Retrieve Notes
        for (Note[] notes : [select id, ownerId, parentId from Note where ParentId in : accountIds]) {
            for (Note n : notes) {
                AccountOwnerTransferRequest r = requestMap.get(n.ParentId);
                
                if (n.OwnerId == r.OldOwnerId) {
                    n.OwnerId = r.NewOwnerId;
                    r.Notes.add(n);
                }           
            }
        }
        
        // Retrieve Tasks
        for (Task[] tasks : [select id, ownerId, accountId from Task where AccountId in : accountIds and isClosed = false]) {
            for (Task t : tasks) {
                AccountOwnerTransferRequest r = requestMap.get(t.AccountId);
                
                if (t.OwnerId == r.OldOwnerId) {
                    t.OwnerId = r.NewOwnerId;
                    r.Tasks.add(t);
                }           
            }
        }
        
        for (Event[] events : [select id, ownerId, accountId from Event where AccountId in : accountIds and ActivityDate >= : system.today()]) {
            for (Event e : events) {
                AccountOwnerTransferRequest r = requestMap.get(e.AccountId);
                
                if (e.OwnerId == r.OldOwnerId) {
                    e.OwnerId = r.NewOwnerId;
                    r.Events.add(e);
                }           
            }
        }
        
        // Verify which accounts can be updated within the context of governor limits
        integer totalRows = 0;
        
        AccountOwnerTransferRequest[] updateRequests = new AccountOwnerTransferRequest[0];
        AccountOwnerTransferRequest[] failedRequests = new AccountOwnerTransferRequest[0];

        for (AccountOwnerTransferRequest r : transferRequests) {
            totalRows += r.Contacts.size();
            totalRows += r.Notes.size();
            totalRows += r.Tasks.size();
            totalRows += r.Events.size();
            totalRows += r.Opportunities.size();
            
            integer rowLimits = Limits.getDmlRows();
            
            System.debug('Total Rows: ' + totalRows);
            System.debug('Row Limits: ' + rowLimits);
            System.debug('Max Rows' + maxDmlRows);
            
            boolean transferAllowed = maxDmlRows > (totalRows + rowLimits);
            if (transferAllowed) {
                updateRequests.add(r);
            }
            else {
                failedRequests.add(r);
            }
        }
        
    
        // Commit Updates
        this.executeTransferRequestUpdates(updateRequests);
        updateRequests.clear();
        
        // Report Failures
        this.reportTransferRequestFailures(failedRequests);
        failedRequests.clear();
        
    }
    
    private void executeTransferRequestUpdates(AccountOwnerTransferRequest[] requests) {
        OwnerTransferUpdateRequest[] contacts = new OwnerTransferUpdateRequest[0];
        OwnerTransferUpdateRequest[] notes = new OwnerTransferUpdateRequest[0];
        OwnerTransferUpdateRequest[] tasks = new OwnerTransferUpdateRequest[0];
        OwnerTransferUpdateRequest[] events = new OwnerTransferUpdateRequest[0];
        OwnerTransferUpdateRequest[] opps = new OwnerTransferUpdateRequest[0];
        
        for (AccountOwnerTransferRequest r : requests) {
            for (Contact c : r.Contacts) {
                OwnerTransferUpdateRequest ur = new OwnerTransferUpdateRequest();
                ur.AccountId = r.TargetAccount.Id;
                ur.UserId = r.TargetAccount.LastModifiedById;
                ur.TargetObject = c;
                
                contacts.add(ur);
            }
            
            for (Note n : r.Notes) {
                OwnerTransferUpdateRequest ur = new OwnerTransferUpdateRequest();
                ur.AccountId = r.TargetAccount.Id;
                ur.UserId = r.TargetAccount.LastModifiedById;
                ur.TargetObject = n;
                
                notes.add(ur);
            }
            
            for (Task t : r.Tasks) {
                OwnerTransferUpdateRequest ur = new OwnerTransferUpdateRequest();
                ur.AccountId = r.TargetAccount.Id;
                ur.UserId = r.TargetAccount.LastModifiedById;
                ur.TargetObject = t;
                
                tasks.add(ur);
            }
            
            for (Event e : r.Events) {
                OwnerTransferUpdateRequest ur = new OwnerTransferUpdateRequest();
                ur.AccountId = r.TargetAccount.Id;
                ur.UserId = r.TargetAccount.LastModifiedById;
                ur.TargetObject = e;
                
                events.add(ur);
            }
            
            for (Opportunity o : r.Opportunities) {
                OwnerTransferUpdateRequest ur = new OwnerTransferUpdateRequest();
                ur.AccountId = r.TargetAccount.Id;
                ur.UserId = r.TargetAccount.LastModifiedById;
                ur.TargetObject = o;
                
                opps.add(ur);
            }
        }
        
        integer resultCount = 0;
        
        resultCount = executeUpdateRequests(contacts, new Contact[0]);
        System.debug(resultCount + ' of ' + contacts.size() + ' contacts successfully updated.');
        
        resultCount = executeUpdateRequests(notes, new Note[0]);
        System.debug(resultCount + ' of ' + notes.size() + ' notes successfully updated.');
        
        resultCount = executeUpdateRequests(tasks, new Task[0]);
        System.debug(resultCount + ' of ' + tasks.size() + ' tasks successfully updated.');
        
        resultCount = executeUpdateRequests(events, new Event[0]);
        System.debug(resultCount + ' of ' + events.size() + ' events successfully updated.');
        
        resultCount = executeUpdateRequests(opps, new Opportunity[0]);
        System.debug(resultCount + ' of ' + opps.size() + ' opportunities successfully updated.');
        
    }
    
    private integer executeUpdateRequests(OwnerTransferUpdateRequest[] requests, sObject[] updates) {
        integer count = 0;
        
        mapUpdateRequestsToObjectArray(requests, updates);
        
        database.SaveResult[] results = database.update(updates, false);
        for (integer i=0; i < results.size(); i++) {
            database.SaveResult sr = results[i];
            
            if (sr.isSuccess()) {
                count++;
            } 
            else {
                Database.Error err = sr.getErrors()[0];
                Id recordId = updates[i].Id;
                Id AccountId = requests[i].AccountId;
                Id UserId = requests[i].UserId;
                
                string errSubject = 'Unable to update ownership for record id: ' + recordId;
                
                logError(errSubject, err.getMessage(),AccountId,UserId);
            }
        }
        
        return count;
    }
    
    private void mapUpdateRequestsToObjectArray(OwnerTransferUpdateRequest[] requests, sObject[] objects) {
        if (objects != null) {
            for (OwnerTransferUpdateRequest r : requests) {
                objects.add(r.TargetObject);
            }
        }
    }
        
    private void reportTransferRequestFailures(AccountOwnerTransferRequest[] failures) {    
        for (AccountOwnerTransferRequest f : failures) {
            string msg = 'Unable to update the some or all of the related contacts for this account due to dml row limits being exceeded.';
            this.LogError(DMLROW_LIMIT_EXCEEDED, msg, f.TargetAccount.Id, f.TargetAccount.LastModifiedById);
        }
    }
    
    public void commitErrorLog() {
        if (!errors.isEmpty()) {
            insert errors;
        }
    }
    
    public void logError(Exception ex) {
        ErrorLog__c err = new ErrorLog__c();
                    
        err.Source__c = ERROR_SOURCE_NAME;
        err.Name = 'Unexpected Exception';
        err.Description__c = ex.getMessage();
        
        errors.add(err);
    }
    
    public void logError(string error, string errorDesc, Id accountId, Id userId) {
        ErrorLog__c err = new ErrorLog__c();
        
        err.Name = error;
        err.Description__c = errorDesc;
        err.AccountId__c = accountId;
        err.UserId__c = userId;
        err.Source__c = ERROR_SOURCE_NAME;
        
        errors.add(err);
    }
    
    private class OwnerTransferUpdateRequest {
        public Id AccountId {get; set;}
        public Id UserId {get; set;}
        public sObject TargetObject {get; set;}
        
        public OwnerTransferUpdateRequest() {
            this.AccountId = null;
            this.UserId = null;
            this.TargetObject = null;
        }
        
    }
    
    private class AccountOwnerTransferRequest {
    
        public Account TargetAccount {get; set;}
        public Id OldOwnerId {get; set;}
        public Id NewOwnerId {get; set;}
        
        public Contact[] Contacts {get; set;}
        public Note[] Notes {get; set;}
        public Task[] Tasks {get; set;}
        public Event[] Events {get; set;}
        public Opportunity[] Opportunities {get; set;}
        
        public AccountOwnerTransferRequest() {
            this.TargetAccount = null;
            this.OldOwnerId = null;
            this.NewOwnerId = null;
            
            Contacts = new Contact[0];
            Notes = new Note[0];
            Tasks = new Task[0];
            Events = new Event[0];
            Opportunities = new Opportunity[0];
        }
        
    }
}