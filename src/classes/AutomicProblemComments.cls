public with sharing class AutomicProblemComments
{
    Public Case c {get; set;}

    public String ccomments { get; set; }

    public Boolean isError{get;set;}
    public AutomicProblemComments(){}
    
    public void sendProblemComments()
    {
            List<Case> cList = [select id,parentID,case_type__c from Case where id =:c.id];
            if (cList[0].case_type__c=='Problem'){
                List<Case> childList = new List<Case>([select id,parentID from Case where parentID =:c.id ]);
                if (!childList.isEmpty()){
                    for(Case pc:childList){
                        System.debug('Problem Case Comments='+ccomments);    
                        Casecomment cm=new Casecomment(parentID=pc.id,isPublished=false,commentbody='OK'+ccomments);
                        insert cm;
                    }    
                }

            }else if (cList[0].case_type__c=='Standard'){
                //List<Case> cList = [select id,parentID from Case where id =:c.id];
                if (!cList.isEmpty()){
                    System.debug('Problem Case Comments='+ccomments);    
                    Casecomment cm=new Casecomment(parentID=cList[0].parentID,isPublished=false,commentbody=ccomments);
                    insert cm;
                }
            }   
    }


}