/**
*Description :Controller for partnerterms VF Page.
*SOQl: 3
*DML: 2 
*Client: CA technologies
*Developed By:  Accenture
*/
public class TermsHandler 
{ 
    boolean showDialog = false;

    public PageReference redirectPage() 
     {

        initProcesses();
        if(showDialog== true) //If the condition for displaying the dialog is not true, then take the user to the page
        {
            return null;
        
         }else{
         
            PageReference pageRef = KnownUser();
            pageRef.setRedirect(true);
            return pageRef;     
        }
}
  



  
public class MDF
{
public string MDFTermUrl{get;set;}  
public string strHtmlTerms{get;set;}
public string strName{get;set;}
public string strTCs{get;set;}
public Fund_Participant__c objFundPart{get;set;}
public Integer iCounter{get;set;}
}
public Map<Id,Attachment> mapMDFProgramDocument {get;set;}
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
public static Boolean boolCheck = true;
private User u;
public User getUser()
{
 return u;
}




/********vars for Hit count******/
public string LatestValue{get;set;}
public boolean bIsFirstClick{get;set;}
/********vars for Hit count******/
/********function for Hit count******/



public void CheckForFirstHit()
{
 System.debug('CheckForFirstHit....1.....');
 try
 {
    Pagereference pr=Apexpages.currentPage();
    List<Cookie> lstcookie=new List<Cookie>();
    LatestValue=UserInfo.getSessionId()+'######'+String.valueOf(DateTime.now().getTime());
   
   
    Map<string, System.Cookie> mpCookie=Apexpages.currentPage().getCookies(); 
       
    if(mpCookie!=null && mpCookie.containskey('lastLoginStamp'))
    {
        string currentValue=mpCookie.get('lastLoginStamp').getValue();
        if(currentValue.contains('######'))
        {
            String[] strArr=currentValue.split('######');
            if(strArr[0]==UserInfo.GetSessionId())
            {
                if(DateTime.now().getTime() - Long.valueof(strArr[1]) > 1000 )
                {
                    bIsFirstClick=false;
                }
                else
                {
                    bIsFirstClick=true;
                    lstcookie.add(new Cookie('lastLoginStamp',LatestValue,null,-1,false));
                    pr.setCookies(lstcookie);      
                }
            }
            else
            {
                bIsFirstClick=true;
                lstcookie.add(new Cookie('lastLoginStamp',LatestValue,null,-1,false));
                pr.setCookies(lstcookie);      
            }
        }
    }
    else
    {
        bIsFirstClick=true;
        lstcookie.add(new Cookie('lastLoginStamp',LatestValue,null,-1,false));
        pr.setCookies(lstcookie);   
         System.debug(' setCookies....1.....'+lstcookie);   
    }
    }
    catch(Exception ex){AddPageErrorMessage('Error In Cookie Handler',ex.getMessage());}
}
/********function for Hit count******/
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

    public void initProcesses()
    {
        try
 {
     
    strErrorMessage='';
    CheckForFirstHit();
    
    bIsFirstClick=true;
    if(bIsFirstClick==true)
    {
    
    
        serUrl=ApexPages.currentPage().getHeaders().get('Host');
        strHomeURL='https://'+serUrl+'/home/home.jsp';
       
      
        //'00530000005oHk2']; / UserInfo.getUserId()];
        u=[Select ur.Contact.AccountId,ur.Name,ur.Id,ur.TermsAccepted__c,ur.TermsAcceptedOn__c,ur.Email,ur.LanguageLocaleKey from User ur where ur.Id =:  UserInfo.getUserId()]; 
                        
        if(u.Contact!=null && u.Contact.AccountId!=null)
        {
            acct=[Select a.Fund_Champion__r.Id,a.Fund_Champion__c,a.Portal_Champion__r.Id, a.Portal_Champion__c, a.Id From Account a where a.Id =: u.Contact.AccountId];  //='0013000000NwmtY' ]; // :u.Contact.AccountId];
            
            if(acct!= null)
            {
                if(acct.Portal_Champion__r.Id == UserInfo.getUserId() || acct.Fund_Champion__r.Id==UserInfo.getUserId() )
                bIsPortalChamp=true;
            
            if(bIsPortalChamp==true)
            {
                lstFP =[Select f.TCAcceptedOn__c,f.TCAccepted__c,f.Partner__r.Id, f.Partner__c, f.Name, f.MDF_Program__r.Name,f.MDF_Program__r.Terms_and_Conditions__c, f.MDF_Program__r.Id, f.MDF_Program__c, f.Id From Fund_Participant__c f where f.Partner__r.Id =:u.Contact.AccountId and f.TCAccepted__c= false]; //  '0013000000NwmtY'
                /*********** document attachment code **********/
                System.debug(' TermsHandler....1.....'+lstFP );
                
            if(lstFP!=null && lstFP.size() > 0)
            {
                Set<Id> mdfPrograms=new set<Id>();
                SelectedIDs='';
                for(Fund_Participant__c m:lstFP)
                {
                    mdfPrograms.add(m.MDF_Program__r.Id);
                    SelectedIDs += m.id + '===';
                }
               
                List<Attachment> lstAttach=[Select a.ParentId, a.Name, a.Id From Attachment a where a.Name like '%MDF%' and a.ParentId in :mdfPrograms];
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
                        if (mf.strName != null)
                            mf.strName = mf.strName.replace('\'','');
                        mf.strTCs = md.MDF_Program__r.Terms_and_Conditions__c;
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
                            if (iCount>0) 
                                    showDialog= true;
                           
                        }
                } 
            }
            }
        }
        
         System.debug('showDialog.....'+ showDialog);
        strUserName=u.Name;
        bTermsAccepted=NeedToRegister(u);
        if(bTermsAccepted==true)
        {
            GetTermUrl(u);
        }
    }
}
catch(Exception ex)
{
      AddPageErrorMessage('Error In User Update',ex.getMessage());  
}
    }


public TermsHandler()
{
 redirectPage();
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
    //PageReference pageRef = new PageReference('https://'+serUrl+'/a2J/o');
    PageReference pageRef = new PageReference('/a2J/o');
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
        PageReference pageRef =new PageReference('https://'+serUrl+'/home/home.jsp');
        pageRef.setRedirect(true);
        return pageRef; 
        }
    catch(Exception ex)
    {
        AddPageErrorMessage('Error In User Update',ex.getMessage());  
        return null;   
    }
 }
 public void UpdateMDFsTerms()
 {
    try
    {
    List<Fund_Participant__c> lstTpUpdate=new List<Fund_Participant__c>();
    
     system.debug('SelectedIDs......'+SelectedIDs);
     
    if(SelectedIDs!=null)
    {
        if(SelectedIDs.contains('==='))
         {
           String[] Ids=SelectedIDs.split('===');
            for( string str:Ids)
            {
                 if (str != null) {
                    Fund_Participant__c md=new Fund_Participant__c(Id=str );
                    md.TCAccepted__c=true;
                    md.TCAcceptedOn__c=DateTime.now();
                    md.T_C_Accepted_By__c=UserInfo.getUserId();
                    lstTpUpdate.add(md);
                    system.debug('SelectedIDs......'+md);
                }
            }//end for
        }//end if 
    }//end if 
     if(lstTpUpdate.size() > 0)
         update lstTpUpdate;
    } catch(Exception ex)
    {
        AddPageErrorMessage('Error In MDF TERM UPDATE ',ex.getMessage());  
    }
 }
public PageReference  MDFHandlerOnly()
{
UpdateMDFsTerms();
PageReference pageRef = KnownUser();
pageRef.setRedirect(true);
return pageRef;
}


public PageReference  skipreject()
{
    PageReference pageRef =new PageReference('https://'+serUrl+'/home/home.jsp');
        pageRef.setRedirect(true);
        return pageRef; 
}

public  PageReference AddPageErrorMessage(string strLocation,string strError)
{
        bShowError=true;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,strErrorMessage + strLocation+' =='+strError);  
        ApexPages.addMessage(myMsg);
        return null;
}
}