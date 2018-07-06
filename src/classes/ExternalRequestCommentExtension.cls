public class ExternalRequestCommentExtension{

    private  External_Request_Comments__c comment;
 
        // controller.
        public ExternalRequestCommentExtension(ApexPages.StandardController stdController) {
            this.comment= (External_Request_Comments__c)stdController.getRecord();
           
        }
        
    public pageReference save(){
        upsert comment; 
        return  New PageReference('/'+comment.ParentId__c);
    }
    public pageReference cancel(){
        return  New PageReference('/'+comment.ParentId__c);
    }       
}