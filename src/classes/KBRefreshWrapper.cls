public class KBRefreshWrapper{
    public cls_d d;
    class cls_d {
        public cls_results[] results;
    }
    class cls_results {
        public cls_CACurrentAuthor CACurrentAuthor;
        public String CA_x0020_Doc_x0020_ID;  //TEC1023762
        public String CA_x0020_Doc_x0020_Title;  //Test KB Creation in Chrome in QA 
        public String Workflow_x0020_Status;  //Draft
        public String Modified;  //2015-01-14T13:43:07Z
        public String Created;
        public cls_CACurrentAuthor Editor;
    }
    
    class cls_CACurrentAuthor {
        public String Title;  //Yerramilli, Archana
    }
    public static KBRefreshWrapper parse(String json){
        return (KBRefreshWrapper) System.JSON.deserialize(json, KBRefreshWrapper.class);
    }
    public static List<KB_Article__c> parseResponse(String response) {
    
        List<KB_Article__c> kbList=new List<KB_Article__c>();
        KBRefreshWrapper obj = KBRefreshWrapper.parse(response);
        for(KBRefreshWrapper.cls_results kbWrap:obj.d.results){
        System.debug('=====kbWrap==='+kbWrap);
            KB_Article__c kb=new KB_Article__c();
            kb.KB_Article_Title__c=kbWrap.CA_x0020_Doc_x0020_Title;
            kb.KB_Article_No__c=kbWrap.CA_x0020_Doc_x0020_ID;
            kb.Status__c=kbWrap.Workflow_x0020_Status;
            kb.Status_Change_Date__c=DateTime.valueofGMT(kbWrap.Modified.replace('T', ' '))   ;
            kb.Author__c=kbWrap.CACurrentAuthor.Title;
            kb.ECM_created_Date__c = DateTime.valueofGMT(kbWrap.Created.replace('T', ' '))   ;
            kb.ECM_Last_Modified_By__c =kbWrap.Editor.Title ;
            kbList.add(kb);            
        }
        return kbList;    
    }   
}