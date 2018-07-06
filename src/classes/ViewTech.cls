/***
@Controller class for VF page ViewTech Partner
@client CA Technology
@Author Accenture IDC , prmr2 team
***/
public class ViewTech {

    public PageReference redirect() {
PageReference pageRef = new PageReference('/'+leadId);
    pageRef.setRedirect(true);
    return pageRef;
    }


public string leadId{get;set;}

// define variables to store query returns
public string tCity{get;set;}

public ViewTech()
{
leadId=ApexPages.currentPage().getParameters().get('ldId');
}
     public Account getAccount() {
        return [SELECT id, name, phone, BillingCity, BillingState, BillingStreet, BillingPostalCode, BillingCountry, 
                Physical_City_Local__c, Physical_State_Prov_Local__c, Physical_Street_Local__c, Physical_Zip_Local__c, 
                Physical_Country_Local__c FROM Account
                WHERE id = :ApexPages.currentPage().getParameters().get('id')];
    }

}