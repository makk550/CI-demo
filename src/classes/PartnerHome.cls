/**
*Description :Controller for partnerterms VF Page.
*SOQl: 4
*DML: 2 
*Client: CA technologies
*Developed By:  Accenture
*/
public class PartnerHome
{   
    public class MDF
    {
        public string MDFTermUrl{get;set;}
        public string strHtmlTerms{get;set;}
        public string strName{get;set;}
        public Fund_Participant__c objFundPart{get;set;}
        public Integer iCounter{get;set;}
    }
        public Map<Id,Attachment> mapMDFProgramDocument {get;set;}    
        public string strCPMSparams{get;set;}
        public string SelectedIDs{get;set;}
        public Integer iTotalMdf{get;set;}
        public List<MDF> lstMDFs {get;set;}
        public boolean bShowError{get;set;}
        public string strErrorMessage{get;set;}
        public string strHomeURL{get;set;}
        public string serUrl{get;set;}
        public Boolean bTermsAccepted{get;set;}
        public string strUserName{get;set;}
        public string strTermUrl{get;set;}
        public Boolean bProcess{get;set;}
        public Boolean bIsPortalChamp{get;set;}
        public Boolean bIsAnyTermsPending{get;set;}
        public Account acct{get;set;}
        public List<Fund_Participant__c> lstFP{get;set;}
        public Map<string,string> mpUserTerms{get;set;}
        private final User u;
        public User getUser()
        {
             return u;
        }
public void GetTermUrl(User u)
{
    mpUserTerms=new Map<String,Id>();
    List<Document> lsd=[Select Id,name from document where name like 'term%'];
    for(Document d :lsd)
    {
        mpUserTerms.put(d.Name,d.Id);
    }
    if(mpUserTerms.containsKey('Terms_'+u.LanguageLocaleKey))
    {
        strTermUrl='https://'+serUrl+'/servlet/servlet.FileDownload?file='+mpUserTerms.get('Terms_'+u.LanguageLocaleKey);
    }
    else
    {
        strTermUrl='https://na1.salesforce.com/servlet/servlet.FileDownload?file=01530000001fswW';
    }
}
public PartnerHome()
{
try
 {
if(ApexPages.currentPage().getParameters() !=null && ApexPages.currentPage().getParameters().get('CPMS_TO_SF') !=null)
    {
        strCPMSparams=ApexPages.currentPage().getParameters().get('CPMS_TO_SF');
    }
    else
    {
         strCPMSparams='/home/home.jsp';
    }
       strErrorMessage='';
       serUrl=ApexPages.currentPage().getHeaders().get('Host');
       strHomeURL='https://'+ serUrl + strCPMSparams;
       u=[Select ur.Contact.AccountId,ur.Name,ur.Id,ur.TermsAccepted__c,ur.TermsAcceptedOn__c,ur.Email,ur.LanguageLocaleKey from User ur where ur.Id =: UserInfo.getUserId()];
        if(u.Contact!=null && u.Contact.AccountId!=null)
        {
            acct=[Select a.Fund_Champion__r.Id,a.Fund_Champion__c,a.Portal_Champion__r.Id, a.Portal_Champion__c, a.Id From Account a where a.Id =:u.Contact.AccountId];
            if(acct!= null)
            {
                if(acct.Portal_Champion__r.Id==UserInfo.getUserId() || acct.Fund_Champion__r.Id==UserInfo.getUserId() )
            bIsPortalChamp=true;
            if(bIsPortalChamp==true)
            {
                lstFP =[Select f.TCAcceptedOn__c,f.TCAccepted__c,f.Partner__r.Id, f.Partner__c, f.Name, f.MDF_Program__r.Name,f.MDF_Program__r.Terms_and_Conditions__c, f.MDF_Program__r.Id, f.MDF_Program__c, f.Id From Fund_Participant__c f where f.Partner__r.Id =:u.Contact.AccountId and f.TCAccepted__c= false];
                /*********** document attachment code **********/
                if(lstFP.size() > 0)
                {
                    Set<Id> mdfPrograms=new set<Id>();
                    for(Fund_Participant__c m:lstFP)
                    {
                        mdfPrograms.add(m.MDF_Program__r.Id);
                    }
                   List<Attachment> lstAttach=[Select a.ParentId, a.Name, a.Id From Attachment a where a.Name like 'MDF_Terms_Conditions%' and  a.ParentId in :mdfPrograms];
                   mapMDFProgramDocument=new Map<Id,Attachment>();
                   for(Fund_Participant__c mdf :lstFP )
                    {
                        for(Attachment at:lstAttach)
                        {
                            if(mdf.MDF_Program__r.Id == at.ParentId)
                            {
                                mapMDFProgramDocument.put(mdf.MDF_Program__r.Id,at);
                                break;
                            }   
                        }
                    }
                }
                /************document attachment code  ends*********/
                if(lstFP!=null && lstFP.size() > 0)
                {
                    bIsAnyTermsPending=true;
                    integer iCount=1;
                    lstMDFs=new List<MDF>();
                        for(Fund_Participant__c md :lstFP )
                        {
                        MDF mf=new MDF();
                        mf.iCounter=iCount;
                        mf.strHtmlTerms=md.MDF_Program__r.Terms_and_Conditions__c;
                        mf.strName=md.MDF_Program__r.Name;
                        mf.objFundPart=md;
                        /********Dynamic link generation ***********/
                        if(mapMDFProgramDocument.containskey(md.MDF_Program__r.Id))
                        {
                            Attachment doc=mapMDFProgramDocument.get(md.MDF_Program__r.Id);
                            mf.MDFTermUrl='https://'+serUrl+'/servlet/servlet.FileDownload?file='+doc.Id;
                        }
                        else
                        {
                            mf.MDFTermUrl='';
                        }
                        /********Dynamic link generation ***********/
                        lstMDFs.add(mf);
                        iTotalMdf=iCount;
                        iCount++;
                        }
                } 
            }
            }
        }
        strUserName=u.Name;
        bTermsAccepted=NeedToRegister(u);
        if(bTermsAccepted==true)
        {
            GetTermUrl(u);
        }

}
catch(Exception ex)
{
        AddPageErrorMessage( 'Error In User Update',ex.getMessage());  
}    
}
public boolean NeedToRegister(User u)
{
    Boolean bRet=false;
    if(u.TermsAccepted__c == false || u.TermsAcceptedOn__c==null)
    {
     bRet=true;
    }
    return bRet;
}
public PageReference Register() 
{
    try
    {
        u.TermsAccepted__c=true;
        u.TermsAcceptedOn__c=DateTime.Now();
        Database.Saveresult sr = Database.update(u);
        PageReference pageRef = KnownUser();
        pageRef.setRedirect(true);
        return pageRef;
    }
    catch(Exception ex)
    {
        AddPageErrorMessage('Error In User Update',ex.getMessage());  
        return null;
    }
}
public PageReference KnownUser() 
{
    PageReference pageRef = new PageReference('https://'+serUrl+ strCPMSparams );
    pageRef.setRedirect(true);
    return pageRef;
}
public PageReference LogoutUser() 
{
    PageReference pageRef = new PageReference('https://www.ca.com/us/register/logout.aspx');
    pageRef.setRedirect(true);
    return pageRef;
}
public PageReference RegisterAndMDFHandler() 
{
try
    {
        u.TermsAccepted__c=true;
        u.TermsAcceptedOn__c=DateTime.Now();
        Database.Saveresult sr = Database.update(u);
        UpdateMDFsTerms();
        PageReference pageRef =new PageReference('https://'+serUrl+strCPMSparams);
        pageRef.setRedirect(true);
        return pageRef; 
        }
    catch(Exception ex)
    {
        AddPageErrorMessage('Error In User Update  ',ex.getMessage());
        return null;   
    }
 }
 public void UpdateMDFsTerms()
 {
    try
    {
    List<Fund_Participant__c> lstTpUpdate=new List<Fund_Participant__c>();
    if(SelectedIDs!=null)
    {
    if(SelectedIDs.contains('==='))
    {
    String[] Ids=SelectedIDs.split('===');
    for(string str:Ids)
    {
    Fund_Participant__c md=new Fund_Participant__c(Id=str);
    md.TCAccepted__c=true;
    md.TCAcceptedOn__c=DateTime.now();
    md.T_C_Accepted_By__c=UserInfo.getUserId();
    lstTpUpdate.add(md);
    }
    }
    }
     if(lstTpUpdate.size() > 0)
         update lstTpUpdate;
    } catch(Exception ex)
    {
        AddPageErrorMessage('Error In MDF TERM UPDATE  ',ex.getMessage());  
    }
 }
public PageReference  MDFHandlerOnly()
{
UpdateMDFsTerms();
PageReference pageRef =new PageReference('https://'+serUrl+strCPMSparams);
pageRef.setRedirect(true);
return pageRef;
}
public void AddPageErrorMessage(string strLocation,string strError)
{
		bShowError=true;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,strErrorMessage + strLocation+' =='+strError);  
        ApexPages.addMessage(myMsg);
}
}