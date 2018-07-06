public class ExecProfControllerExtension {

    private final Executive_Profile__c execProf;
    private Apexpages.StandardController controller; 
    public Account_Plan3__c myAccountPlan { get; set; }
    public List<HVN_Educational_Background__c> myHVNEdu { get; set; }
    public List<HVN_Professional_Experience__c> myHVNProfExp {get; set; }
    public List<HVN_Affiliation__c> myHVNAff { get; set; }
    public List<Opportunity> wonOpps {get; set;}
    public List<Opportunity> lostOpps {get; set;}
    public String myAccountId {get; set;}
    public boolean showCIOEvent {get; set;}
    public boolean showExecMeeting {get; set;}
    public boolean showEBC {get; set;}
    public String imageBase64 {get; set;}
    public String myReference {get; set;}
    public String HVNAffStr {get; set;}
    Document myDoc;
    List<Document> documentList;
    public String myDocId {get; set;}
    boolean acctLogoDocExists=false;
    Document myHVNDoc;
    List<Document> hvnDocumentList;
    public String myHVNDocId {get; set;}
    boolean hvnPhotoDocExists=false;
    Document hvnStatusGraphicLogo;
    String custName;
    String recordTypeId;
    String externalPicURL;
    String europeHVNPicURL;
    String developerName='';
    public String meetingType {get; set;}

    public ExecProfControllerExtension(ApexPages.StandardController stdController) {
        this.controller = stdController;
        this.execProf = (Executive_Profile__c)stdController.getRecord();
        String HVNId;
        String myId = ApexPages.CurrentPage().getParameters().get('id');
        String meetingDate;
        date myDate;
        String meetingTypeStr;
        String[] meetingTypes;

        Contact contact;
        Account myAccount;        
        
        myDate = execProf.Meeting_Date__c;
        meetingTypeStr = execProf.Meeting_Type__c;
        meetingType = execProf.Meeting_Type__c;
        if(meetingType != null)
        {
            meetingType = meetingType.replace(';','/'); 
        }
        if(meetingTypeStr!=null)
        {
            meetingTypes = meetingTypeStr.split(';');
        }
        
        if( meetingTypes!= null ){
            for( String type: meetingTypes){
                if( type != null && type.equalsIgnoreCase('CIO Event'))
                {
                    showCIOEvent = true;
                }
                
                if( type != null && type.equalsIgnoreCase('Executive Meeting'))
                {
                    showExecMeeting = true;
                }
                
                if( type != null && type.equalsIgnoreCase('EBC'))
                {
                    showEBC = true;
                }                                
            }
        }        

        
        if(contact == null)
            contact = [SELECT Id, AccountId, HVN_ID__c, HVN__c, Name FROM Contact WHERE Id = :execProf.Customer__c][0];
       
  
       if(contact != null)
       {
           myAccount = [SELECT Id, Company_Overview__c, Company_Logo__c, Account_Owner_Name__c, Company_Logo_ID__c, (SELECT Id, Name FROM Attachments) FROM Account WHERE Id = :contact.AccountId][0];
           myAccountId = contact.AccountId;
           custName = contact.Name;
           /*
           if(contact.Reference_Contact__c)
           {
               myReference = 'Yes';
           }
           */
           String ChildFieldValue1='';
           String ChildFieldValue2='';

            SObject[] childRecordsFromParent = myAccount.getSObjects('Attachments');
            if (childRecordsFromParent != null) 
            {
                for (SObject childRecord : childRecordsFromParent)
                {
                  ChildFieldValue1 = (String)childRecord.get('Id');
                  ChildFieldValue2 = (String)childRecord.get('Name');
                  if(ChildFieldValue1 != null && ChildFieldValue1.equals(myAccount.Company_Logo_ID__c))
                  {
                      break;
                  }
                  else
                  {
                      ChildFieldValue1 = '';
                      ChildFieldValue2 = '';
                  }
                }
             }
                 
            list<Attachment> docs = [select id, body from Attachment where id = :ChildFieldValue1 limit 1]; 
/*            if(!docs.isEmpty())
            {
                imageBase64 = EncodingUtil.base64Encode(docs[0].body); 
            } */
           
           String myAccountImgName = 'AccountLogo.'+myAccount.Company_Logo_ID__c;
           documentList = [select id from Document where Name =:myAccountImgName limit 1 ];
           if(ChildFieldValue1!= '' && !docs.isEmpty() && documentList.isEmpty())
           {
                myDoc = new Document();
                myDoc.Name = myAccountImgName;
                myDoc.Body = docs[0].body;
                myDoc.ContentType = 'image/jpg';
                myDoc.Type = 'jpg';
                myDoc.IsPublic = true;
                myDoc.FolderId = System.Label.ExecutiveProfFolder;
            }
            else if(ChildFieldValue1!='' && !documentList.isEmpty())
            {
                myDoc = documentList[0];
                myDocId = myDoc.Id;
                acctLogoDocExists = true;
            }
            else
            {
                documentList = [select id from Document where Name = 'nologo2.JPG' limit 1 ];
                if(!documentList.isEmpty())
                {
                    myDoc = documentList[0];
                    myDocId = myDoc.Id;
                    acctLogoDocExists = true;                    
                }
            }
           Integer fYear = Date.Today().Month() < 4 ? Date.today().year() : Date.today().year() + 1;
           AggregateResult[] groupedResults = [SELECT SUM(PNCV__c)aver FROM Opportunity WHERE AccountId = :myAccountId AND FiscalYear = :fYear AND 
                StageName IN ('20% - Researching','30% - Solution Design','40% - Plan Confirmed','60% - Proposal',
                '60% - Initial Proposal','80% - Preliminary Agreement','90% - Commitment','90% - Agreement Finalized')
                AND Opportunity_Type__c IN ('PNCV', 'PNCV w/Education', 'PNCV w/Education & Support',
                            'PNCV w/Services', 'PNCV w/Services, Education & Support', 'PNCV w/Services & Education', 'PNCV w/Services & Support', 'PNCV w/Support', 'Support', 'Services w/Education & Support', 'Services w/Support')];
           execProf.Total_PNCV_Pipeline__c = (Decimal)groupedResults[0].get('aver');       
           
           wonOpps = [SELECT Id, Name, Amount, CloseDate, CurrencyIsoCode FROM Opportunity WHERE AccountId = :myAccountId and (FiscalYear = :fYear OR FiscalYear = :fYear-1) and StageName='100% - Contract Signed' and Amount>100000 ORDER BY CloseDate DESC, Amount DESC];
           lostOpps = [SELECT Id, Name, Amount, ReasonField__c, Deal_Lost_to__c, CloseDate, CurrencyIsoCode FROM Opportunity WHERE AccountId = :myAccountId and (FiscalYear = :fYear OR FiscalYear = :fYear-1) and StageName='Closed - Lost' and Amount>100000 and ReasonField__c IN ('Competitor Bias','Pricing/ROI','Relationship','Product Functionality') ORDER BY CloseDate DESC, Amount DESC];                      
       }
       
       if(contact != null)
       {
           List<Account_Plan3__c> myAccPlanList = [SELECT Id, Capex_Budget__c, Stated_Business_Priorities__c FROM Account_Plan3__c WHERE Account__c = :contact.AccountId];
           if(!myAccPlanList.isEmpty())
           { 
               myAccountPlan = myAccPlanList[0];
           }
       }       
        
       if(contact != null && contact.HVN_ID__c != null && contact.HVN__c == true)
          HVNId = contact.HVN_ID__c;
      
       List<HVN__c> myHVN = [SELECT Id, RecordTypeId, External_Picture__c, Awards_Recognition__c,
       Birthday_Year__c, Birthday_Month__c, College_Fraternity_Sorority__c, Family_Information__c, 
       Favorite_Charity__c, Favorite_Movie__c, Favorite_TV_Show__c, Hobbies__c,
       Hobbies_Other__c, Holiday_Celebrations__c, Holiday_Celebrated_Other__c, Military_Service__c,
       Movie_Genre__c, Music_Style__c, Public_Speaker__c, Sport_Other__c, Sports__c, Subscription__c, 
       Subscription_Other__c, TV_Genre__c, Book_Preference__c, Culinary_Preference__c, HVN_Contact_Photo_ID__c, HVN_Contact_Photo__c, Relationship_Status__c,
       (SELECT Id, Name FROM Attachments), Relationship_Status_Graphic__c FROM HVN__c WHERE Id = :HVNId];
       

       
       
       if(!myHVN.isEmpty())
       {
           execProf.HVN__r = myHVN[0];
           HVN__c myHVNRec = myHVN[0];
           recordTypeId = myHVNRec.RecordTypeId;
           externalPicURL = myHVNRec.External_Picture__c;

           RecordType hvnRecType = [Select DeveloperName FROM RecordType where Id = :recordTypeId][0];
           developerName = hvnRecType.DeveloperName;
           
           System.debug('SKG DeveloperName -> ' + developerName);
       
           String graphicName;
           List<Document> graphicDocList;
           if(myHVNRec.Relationship_Status__c != null)
           {
               if(myHVNRec.Relationship_Status__c.equals('Frequent Engagements/ Collaborative relationship') ||
                      myHVNRec.Relationship_Status__c.equals('Achieved High Value Contact Status/Strong Relationship'))
               {
                   graphicName='ExecProfGreen';
               }
               else if(myHVNRec.Relationship_Status__c.equals('Relationship Strengthening/ Collaborative Relationship') ||
                      myHVNRec.Relationship_Status__c.equals('Inconsistent/Sporadic Contact with Account team and Executives'))
               {
                   graphicName='ExecProfYellow';
               }
               else if(myHVNRec.Relationship_Status__c.equals('Historically Non-Responsive') ||
                      myHVNRec.Relationship_Status__c.equals('New Relationship/No Previous Contact'))
               {
                   graphicName='ExecProfRed';
               }
           }
       
           if(graphicName!=null && graphicName.trim()!='')
           {       
               graphicDocList = [select id from Document where Name =:graphicName limit 1 ];    
               hvnStatusGraphicLogo = graphicDocList[0];
           }
       
           String HVNIdVal='';
           String HVNNameVal='';

            if(developerName != null && developerName.equals('Europe'))
            {
                if(externalPicURL != null && externalPicURL.trim() != '')
                {
                    europeHVNPicURL = '<img src=\''+externalPicURL+'\' width=\"72\" height=\"90\">';
                }
                else
                {
                    List<Document> hvnDocumentList1 = [select id from Document where Name = 'NoPicSmall.JPG' limit 1 ];
                    if(!hvnDocumentList1.isEmpty())
                    {
                        Document myHVNDoc1 = hvnDocumentList1[0];
                        String myHVNDocId1 = myHVNDoc1.Id;
                        String orgId = UserInfo.getOrganizationId();
                        europeHVNPicURL = '';
                        if(myHVNDocId1!=null && myHVNDocId1.trim()!='')
                        {
                            europeHVNPicURL = europeHVNPicURL + URL.getSalesforceBaseUrl().toExternalForm();
                            europeHVNPicURL = europeHVNPicURL +'/servlet/servlet.ImageServer?id='+myHVNDocId1+'&oid='+orgId;  
                            europeHVNPicURL = '<img src=\'' + europeHVNPicURL +'\' width=\"72\" height=\"90\">';
                        }
                    }                
                } 
            }
            else
            {
                SObject[] childRecordsFromParent1 = myHVNRec.getSObjects('Attachments');
                if (childRecordsFromParent1 != null) 
                {
                    for (SObject childRecord1 : childRecordsFromParent1)
                    {
                      HVNIdVal= (String)childRecord1.get('Id');
                      HVNNameVal= (String)childRecord1.get('Name');
                      if(HVNIdVal != null && HVNIdVal.equals(myHVNRec.HVN_Contact_Photo_ID__c))
                      {
                          break;
                      }
                      else
                      {
                         HVNIdVal=''; 
                         HVNNameVal='';
                      }
                    }
                 }
                     
               list<Attachment> hvnDocs = [select id, body from Attachment where id = :HVNIdVal limit 1]; 
               
               String myHVNImgName = 'HVNPhoto.'+myHVNRec.HVN_Contact_Photo_ID__c;
       
               hvnDocumentList= [select id from Document where Name =:myHVNImgName limit 1 ];
               if(HVNIdVal!='' && !hvnDocs.isEmpty() && hvnDocumentList.isEmpty())
               {
                    myHVNDoc= new Document();
                    myHVNDoc.Name = myHVNImgName;
                    myHVNDoc.Body = hvnDocs[0].body;
                    myHVNDoc.ContentType = 'image/jpg';
                    myHVNDoc.Type = 'jpg';
                    myHVNDoc.IsPublic = true;
                    myHVNDoc.FolderId = System.Label.ExecutiveProfFolder;
                }
                else if(HVNIdVal!='' && !hvnDocumentList.isEmpty())
                {
                    myHVNDoc= hvnDocumentList[0];
                    myHVNDocId = myHVNDoc.Id;
                    hvnPhotoDocExists = true;
                }
                else
                {
                    hvnDocumentList = [select id from Document where Name = 'NoPicSmall.JPG' limit 1 ];
                    if(!hvnDocumentList.isEmpty())
                    {
                        myHVNDoc = hvnDocumentList[0];
                        myHVNDocId = myHVNDoc.Id;
                        hvnPhotoDocExists = true;                    
                    }
                }
              }                   
       
           myHVNEdu = [SELECT Id, Alma_Mater__c, Field_of_Studies__c, Year__c FROM HVN_Educational_Background__c WHERE HVN_Contact__c = :HVNId];
           myHVNProfExp = [SELECT Id, Company_Name__c, Role_Description__c, Status__c, Tenure__c, Title__c FROM HVN_Professional_Experience__c WHERE HVN_Contact__c = :HVNId];
           myHVNAff = [SELECT Id, Name FROM HVN_Affiliation__c WHERE HVN_Contact__c = :HVNId];
           
           System.debug('SKG_Prof_Exp :: ' + myHVNProfExp);
           
           HVNAffStr = '';
           
           if(execProf.HVN__r.Awards_Recognition__c!=null && execProf.HVN__r.Awards_Recognition__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Awards & Recognition: ' + execProf.HVN__r.Awards_Recognition__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Birthday_Year__c!=null && execProf.HVN__r.Birthday_Year__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Birth Day: ' + execProf.HVN__r.Birthday_Year__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Birthday_Month__c !=null && execProf.HVN__r.Birthday_Month__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Birth Month: ' + execProf.HVN__r.Birthday_Month__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.College_Fraternity_Sorority__c!=null && execProf.HVN__r.College_Fraternity_Sorority__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'College Fraternity/Sorority: ' + execProf.HVN__r.College_Fraternity_Sorority__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Family_Information__c!=null && execProf.HVN__r.Family_Information__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Family Information: ' + execProf.HVN__r.Family_Information__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Favorite_Charity__c!=null && execProf.HVN__r.Favorite_Charity__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Favorite Charity: ' + execProf.HVN__r.Favorite_Charity__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Favorite_Movie__c!=null && execProf.HVN__r.Favorite_Movie__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Favorite Movie: ' + execProf.HVN__r.Favorite_Movie__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Favorite_TV_Show__c!=null && execProf.HVN__r.Favorite_TV_Show__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Favorite TV Show: ' + execProf.HVN__r.Favorite_TV_Show__c.trim() + '<br></br>';
           } 
           if(execProf.HVN__r.Hobbies__c!=null && execProf.HVN__r.Hobbies__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Hobbies: ' + execProf.HVN__r.Hobbies__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Hobbies_Other__c!=null && execProf.HVN__r.Hobbies_Other__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Hobbies(Other): ' + execProf.HVN__r.Hobbies_Other__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Holiday_Celebrations__c!=null && execProf.HVN__r.Holiday_Celebrations__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Holiday Celebrated: ' + execProf.HVN__r.Holiday_Celebrations__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Holiday_Celebrated_Other__c!=null && execProf.HVN__r.Holiday_Celebrated_Other__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Holiday Celebrated (Other): ' + execProf.HVN__r.Holiday_Celebrated_Other__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Military_Service__c!=null && execProf.HVN__r.Military_Service__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Military Service: ' + execProf.HVN__r.Military_Service__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Movie_Genre__c!=null && execProf.HVN__r.Movie_Genre__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Movie Genre: ' + execProf.HVN__r.Movie_Genre__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Music_Style__c!=null && execProf.HVN__r.Music_Style__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Music Style: ' + execProf.HVN__r.Music_Style__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Public_Speaker__c!=null && execProf.HVN__r.Public_Speaker__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Public Speaker: ' + execProf.HVN__r.Public_Speaker__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Sports__c!=null && execProf.HVN__r.Sports__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Sports: ' + execProf.HVN__r.Sports__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Sport_Other__c!=null && execProf.HVN__r.Sport_Other__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Sports Other: ' + execProf.HVN__r.Sport_Other__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Subscription__c!=null && execProf.HVN__r.Subscription__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Subscription: ' + execProf.HVN__r.Subscription__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Subscription_Other__c!=null && execProf.HVN__r.Subscription_Other__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Subscription (Other): ' + execProf.HVN__r.Subscription_Other__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.TV_Genre__c!=null && execProf.HVN__r.TV_Genre__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'TV Genre: ' + execProf.HVN__r.TV_Genre__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Book_Preference__c!=null && execProf.HVN__r.Book_Preference__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Book Preference: ' + execProf.HVN__r.Book_Preference__c.trim() + '<br></br>';
           }
           if(execProf.HVN__r.Culinary_Preference__c!=null && execProf.HVN__r.Culinary_Preference__c.trim()!='')
           {
               HVNAffStr = HVNAffStr + 'Culinary Preference: ' + execProf.HVN__r.Culinary_Preference__c.trim() + '<br></br>';
           }       
         }                                                                                                                                                  
       
    }

    public PageReference Save()
    {
        execProf.Name = custName + '_' + execProf.Meeting_Type__c;
        return controller.save();
    }
    
    public String getAccountLogoURL()
    {
        String orgId = UserInfo.getOrganizationId();
        String accountLogoUrl='';
        if(myDocId!=null && myDocId.trim()!='')
        {
            accountLogoUrl = accountLogoUrl + URL.getSalesforceBaseUrl().toExternalForm();
            accountLogoUrl=accountLogoUrl+'/servlet/servlet.ImageServer?id='+myDocId+'&oid='+orgId;
            accountLogoUrl= '<img src=\''+accountLogoUrl+'\' width=\"180\" height=\"70\">';             
        }       
        return accountLogoUrl; 
    }   
    
    public String getHVNPhotoURL()
    {
        String orgId = UserInfo.getOrganizationId();
        String HVNPhotoUrl='';
        if(developerName != null && developerName.equals('Europe'))
        {
            HVNPhotoUrl = europeHVNPicURL;
        }
        else if(myHVNDocId!=null && myHVNDocId.trim()!='')
        {
            HVNPhotoUrl = HVNPhotoUrl + URL.getSalesforceBaseUrl().toExternalForm();
            HVNPhotoUrl=HVNPhotoUrl+'/servlet/servlet.ImageServer?id='+myHVNDocId+'&oid='+orgId;  
            HVNPhotoUrl= '<img src=\''+HVNPhotoUrl+'\' width=\"72\" height=\"90\">';
        }      
        return HVNPhotoUrl; 
    }
    
    
    public String getimgURL()
    {
        String orgId = UserInfo.getOrganizationId();
        String HVNGraphicUrl=URL.getSalesforceBaseUrl().toExternalForm();
        String imgURL='';
        if(hvnStatusGraphicLogo!=null)  // && hvnStatusGraphicLogo.Id.trim()!='')
        {
            HVNGraphicUrl=HVNGraphicUrl+'/servlet/servlet.ImageServer?id='+hvnStatusGraphicLogo.Id+'&oid='+orgId;
            imgURL = '<img src=\''+HVNGraphicUrl+'\' width=\"32\" height=\"32\">';
        }
        System.debug(imgURL);
        return imgURL; 
    }  
        
    public PageReference printView() 
    {
        PageReference oPageRef = Page.ExecutiveProfileDoc;
        return oPageRef;
    }
    
    
    public void insertLogoDoc()
    {
        if(!acctLogoDocExists && myDoc!=null)
        {
            insert myDoc;
            myDocId = myDoc.Id;
        }
        if(!hvnPhotoDocExists && myHVNDoc!=null)
        {
            insert myHVNDoc;
            myHVNDocId = myHVNDoc.Id;
        }
    }
    
    public list<Opportunity> getTopOpps() 
    {
        Integer fYear = Date.Today().Month() < 4 ? Date.today().year() : Date.today().year() + 1;
        /*
        return [SELECT Name, OwnerId, CurrencyIsoCode, Opportunity_Number__c, Sales_Milestone_Search__c, Amount, RoadmapToPlan__c, Total_Upfront_Lic_Fee__c, Inside_Outside__c, CloseDate
                FROM Opportunity
                WHERE AccountId = :myAccountId AND FiscalYear = :fYear AND Amount!=0 AND 
                StageName IN ('20% - Researching','30% - Solution Design','40% - Plan Confirmed','60% - Proposal',
                '60% - Initial Proposal','80% - Preliminary Agreement','90% - Commitment','90% - Agreement Finalized') 
                ORDER BY CloseDate ASC, Amount DESC
                LIMIT 5];
        */
        return [SELECT Name, OwnerId, CurrencyIsoCode, Opportunity_Number__c, Sales_Milestone_Search__c, PNCV__c, RoadmapToPlan__c, Total_Upfront_Lic_Fee__c, Inside_Outside__c, CloseDate
                FROM Opportunity
                WHERE AccountId = :myAccountId
                    AND FiscalYear = :fYear AND PNCV__c!=0
                    AND Opportunity_Type__c IN ('PNCV', 'PNCV w/Education', 'PNCV w/Education & Support',
                            'PNCV w/Services', 'PNCV w/Services, Education & Support', 'PNCV w/Services & Education', 'PNCV w/Services & Support', 'PNCV w/Support', 'Support', 'Services w/Education & Support', 'Services w/Support') 
                    AND StageName IN ('20% - Researching','30% - Solution Design','40% - Plan Confirmed','60% - Proposal', '60% - Initial Proposal','80% - Preliminary Agreement','90% - Commitment','90% - Agreement Finalized') 
                ORDER BY CloseDate DESC, PNCV__c  DESC 
                LIMIT 5];
        
    }   
    
}