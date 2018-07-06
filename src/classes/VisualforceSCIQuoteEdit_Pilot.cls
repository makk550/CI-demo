/*
class Name : VisualforceSCIQuoteEdit_Pilot
Modified By: Accenture
Modified Date: 04-12-2011
comments: 2.4.1 -  Ability to view SFDC side panel on CPQ UI
          BR-012.11   
          Ability to access Sterling page only when user’s country belongs to "allowed country list"
          and group must be pilot users group
*/

public class VisualforceSCIQuoteEdit_Pilot {
    
    /**
    * VisualforceSCIQuoteEdit_Pilot (): constroctor 
    *  
    *
    * @param ApexPages.StandardController
    * @return 
    * @throws 
    * 
    */
    public VisualforceSCIQuoteEdit_Pilot(ApexPages.StandardController controller) {
    }
    
    /**
    * urlRedirect (): Method used to navigate users on sterling page
    *  
    *
    * @param 
    * @return PageReference
    * @throws 
    * 
    */
    public pagereference urlRedirect()
    {
         /*
         //PageReference pageRef = new PageReference( ApexPages.currentPage().getURL().replace('VisualforceSCIQuoteEdit_Pilot','scpq__VisualforceSCIQuoteEdit'));
         Updated Date: 30 - 03 - 2011
         Comments: 2.4.1 -  Ability to view SFDC side panel on CPQ UI
              
         */
         //replace page to navigate on sterling if user belongs to cpq pilot users
         PageReference pageRef = new PageReference( ApexPages.currentPage().getURL().replace('VisualforceSCIQuoteEdit_Pilot','VisualforceSCIQuoteEditWithSidebar'));
         pageRef.setredirect(true);
         /*
             BR-012.11   
             Ability to access Sterling page only when user’s country belongs to "allowed country list"
             and group must be pilot users group
            if([Select g.UserOrGroupId, g.Group.Name, g.GroupId From GroupMember g where UserOrGroupId=: userinfo.getUserId() and group.name = 'cpq pilot users' ].size() > 0)
         */
         if(VisualforceSCIQuoteIdentifyCPQUser.isValidCPQUser())
            return pageRef;
         return null;     
    }    
    //getter property is used to set the height of iframe
    public String iframeHeight{
     get{
       if(IframeHeight == NULL){
         iframeHeight = '1200px';
          //query on  Sterling parameter object to find hight value
         for(scpq__Sterling_Parameter__c para:[select scpq__SFSiFrameHeight__c from scpq__Sterling_Parameter__c limit 1]){
            iframeHeight = para.scpq__SFSiFrameHeight__c;
         }   
       }
       return iframeHeight;
     }set;
    }   
    
}