public class DealLinkgenerateController {
    public Id oppId{get;set;}
    public DealLinkgenerateController(){
        if(OppId == null && ApexPages.currentPage().getParameters().get('oppId') != null)
                    oppId = ApexPages.currentPage().getParameters().get('oppId');
    }
    public String getGeneratedLink(){
        String OppRecordUrl;
        Organization Organizationobj =[select id,issandbox,InstanceName from organization];
        if(Organizationobj.issandbox == true || Test.isRunningTest()){
            if(UserInfo.getUserType() == 'PowerPartner'){
                //OppRecordUrl = 'https://ca.my.salesforce.com/'+oppId;
                OppRecordUrl=URL.getSalesforceBaseUrl().getHost();
                String Boxname=OppRecordUrl.substringBeforeLast('-catech');
                OppRecordUrl='https://ca--'+Boxname+'.'+Organizationobj.InstanceName+'.my.salesforce.com/'+oppId;
                
            }else{
                OppRecordUrl=URL.getSalesforceBaseUrl().toExternalForm()+'/'+oppId;
            }
        }else{
            OppRecordUrl = 'https://ca.my.salesforce.com/'+oppId;
        }
       
        
        return OppRecordUrl;
    }
}