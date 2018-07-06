public class PRM_ChannelManager {

public String  accntId{set;get;}
public String  accntOwner{set;get;}

public String  camEmail{set;get;}
public String  camName{set;get;}

public String  alliancePAMEmail{set;get;}
public String  alliancePAMName{set;get;}
public string  alliancePAMPHone{set;get;}
public boolean alliancePAMNameContainsPARTN{set;get;}

public String  solutionProviderPAMEmail{set;get;}
public String  solutionProviderPAMName{set;get;}
public string  solutionProviderPAMPhone{set;get;}
public boolean solutionProviderPAMNameContainsPARTN{set;get;}

public String  serviceProviderPAMEmail{set;get;}
public String  serviceProviderPAMName{set;get;}
public String  serviceProviderPAMPhone{set;get;}
public boolean  serviceProviderPAMNameContainsPARTN{set;get;}

public String  velocitySellerPAMEmail{set;get;}
public String  velocitySellerPAMName{set;get;}

public Integer AccountTeamPamPadCount { set;get;}
public LIst<AccountTeamMember> AccntTeamMemeberList {set;get;}
public List<User> AccntTeamMemebers {set;get;}

public boolean AllRTMContainsPARTNorBlank {set;get;}

public string PartnerAccountId {set;get;}

List<String> accntCam = new List<String>();
   Public PRM_ChannelManager(){
    
      User usr =  [select Name,Email,Id,Username,ContactId  from User  where Id=: userInFo.getUserId() ];    
     
      if(usr.ContactId != null){
         List<Contact>  cont = [Select Name,Email,OwnerId,Id,AccountId From Contact where Id =: usr.ContactId ] ;
         if(cont.size()>0) accntId = cont[0].AccountId; 
       if(accntId != null)
       {
       System.debug(' cont is ' + cont);
           
         Account accnt = [Select Enterprise_id__c, Name,OwnerId,Owner.Name,Solution_Provider_CAM_PMFKey__c,Alliance_CAM_PMFKey__c,Service_Provider_CAM_PMFKey__c,Velocity_Seller_CAM_PMFKey__c,Id,Owner.Email From Account  where Id =: Cont[0].AccountId ] ;
         accntOwner = accnt.Owner.Name ;
         PartnerAccountId = accnt.Enterprise_id__c;
 	   System.debug(' accnt is ' + accnt);
         if(accnt.Solution_Provider_CAM_PMFKey__c != null){
              accntCam.add(accnt.Solution_Provider_CAM_PMFKey__c);
         }
         if(accnt.Alliance_CAM_PMFKey__c != null){
              accntCam.add(accnt.Alliance_CAM_PMFKey__c);
         }
          if(accnt.Service_Provider_CAM_PMFKey__c != null){
              accntCam.add(accnt.Service_Provider_CAM_PMFKey__c);
         }
          if(accnt.Velocity_Seller_CAM_PMFKey__c != null){
              accntCam.add(accnt.Velocity_Seller_CAM_PMFKey__c);
         }
        System.debug(' accntCam is ' + accntCam);
         List<User> camUsr = [Select Name,Id,Email,phone,PMFKey__c From User where PMFKey__c in: accntCam] ;
      
        alliancePAMNameContainsPARTN = false;
        solutionProviderPAMNameContainsPARTN = false;
        serviceProviderPAMNameContainsPARTN = false;
        AllRTMContainsPARTNorBlank = false;
        AccountTeamPamPadCount = 0;
		System.debug(' camUsr is ' + camUsr);
           
          if (camUsr.size() > 0)
          {
           for(User usrPam : camUsr ){
               if(usrPam.PMFKey__c == accnt.Alliance_CAM_PMFKey__c){
                   alliancePAMEmail = usrPam.Email ;
                   alliancePAMName  = usrPam.Name ;
                   alliancePAMPHone = FormatPhone(usrPam.Phone);
                   alliancePAMNameContainsPARTN = accnt.Alliance_CAM_PMFKey__c.contains('PARTN'); 
               }
                if(usrPam.PMFKey__c == accnt.Solution_Provider_CAM_PMFKey__c){
                   solutionProviderPAMEmail= usrPam.Email ;
                   solutionProviderPAMName= usrPam.Name ;
                   solutionProviderPAMPhone = FormatPhone(usrPam.Phone);
                   solutionProviderPAMNameContainsPARTN = accnt.Solution_Provider_CAM_PMFKey__c.contains('PARTN');
               }
                if(usrPam.PMFKey__c == accnt.Service_Provider_CAM_PMFKey__c){
                   serviceProviderPAMEmail = usrPam.Email ;
                   serviceProviderPAMName = usrPam.Name ;
                   serviceProviderPAMPhone = FormatPhone(usrPam.Phone);
                   serviceProviderPAMNameContainsPARTN = accnt.Service_Provider_CAM_PMFKey__c.contains('PARTN');

               }
                if(usrPam.PMFKey__c == accnt.Velocity_Seller_CAM_PMFKey__c){
                   velocitySellerPAMEmail = usrPam.Email ;
                   velocitySellerPAMName = usrPam.Name ;
               }
            }   
          }
          if ((alliancePAMNameContainsPARTN || alliancePAMName == null)
               && 
              (solutionProviderPAMNameContainsPARTN || solutionProviderPAMName == null) 
               && 
               (serviceProviderPAMNameContainsPARTN || serviceProviderPAMName == null))
            {
              AllRTMContainsPARTNorBlank = true;
            }
        }
        else
        {
          AllRTMContainsPARTNorBlank = true;
        }
       }

       
       AccntTeamMemebers = new List<User>();
        
        if (AllRTMContainsPARTNorBlank) //if none of the RTM can be used, either it's all blank or all contains PARTN
        {

                        AccntTeamMemeberList = [select User.Name,User.Email,User.Phone from AccountTeamMember where accountid =: accntId and TeamMemberRole in ('PAM/PAD','PAD/PAM') and (not User.Name like '% partner')];
            AccountTeamPamPadCount = accntTeamMemeberList.size();


            if (AccountTeamPamPadCount > 0)
            {
              for (AccountTeamMember atm : AccntTeamMemeberList)
              {
                  if (atm.User.Phone != null)
                  {
                    atm.User.Phone = FormatPhone(atm.User.Phone);
                  }
                  AccntTeamMemebers.add(atm.User);
              }
            }
        }
   }

   public static String FormatPhone(String Phone) {
    if (String.isBlank(Phone))
    {
      return Phone;
    }

      string nondigits = '[^0-9]';
      string PhoneDigits;
      
      // remove all non numeric
      PhoneDigits = Phone.replaceAll(nondigits,'');
      
      // 10 digit: reformat with dashes
      if (PhoneDigits.length() == 10) 
        return PhoneDigits.substring(0,3) + '-' +
               PhoneDigits.substring(3,6) + '-' +
               PhoneDigits.substring(6,10);
      // 11 digit: if starts with 1, format as 10 digit 
      if (PhoneDigits.length() == 11) {
        if (PhoneDigits.substring(0,1) == '1') {
          return  PhoneDigits.substring(1,4) + '-' +
                  PhoneDigits.substring(4,7) + '-' +
                  PhoneDigits.substring(7,11);
        }
      }
     
      // if it isn't a 10 or 11 digit number, return the original because
      // it may contain an extension or special information
      return( Phone );
  }
   /*
public static testmethod void methodforUpdateChannelManager(){
     test.starttest();
     User partnerUser = [Select Id from User where IsActive = true and UserType='PowerPartner' and IsPortalEnabled= true LIMIT 1];
     System.runAs(partnerUser) {
        PRM_ChannelManager pcm = new PRM_ChannelManager();
     }
     String accntId ;
     List<String> accntCam = new List<String>();
     Account acc =new Account(Name='Test method account', Account_Status__c='Approved');
    acc.RecordTypeId=[Select r.Name, r.Id From RecordType r where r.Name='Reseller/Distributor Account' limit 1].Id;
    acc.Reseller_Disti_Regional_ID__c='testId';
    acc.Reseller_Distributor_Name__c='test Dist name';
    insert acc;
    acc.IsPartner=true;
    update acc;
    Contact ct=new Contact(LastName='test last Name ',AccountId=acc.Id,Email='testmethod@ca.com.test',Country_Picklist__c='US- UNITED STATES');
    insert ct;
    User p=new User();
   p.ContactId=ct.Id;
    p.FirstName='frst Name';
    p.LastName='last Name';
    p.Alias='testca';
    p.Username='testmeth1od@ca.com.test';
    p.Email='testmethod@ca.com.test';
    p.LocaleSidKey='ar';
    p.ProfileId=[Select Id from Profile where Name = 'Partner Champion' limit 1].Id;
    p.EmailEncodingKey='UTF-8';
    p.TimeZoneSidKey='Pacific/Fiji';
    p.LanguageLocaleKey='en_US';
    p.TermsAccepted__c=false;
    insert p;
    
    ct.Portal_Champion__c = true ;
    
    update ct ;
    
    acc.Eligible_for_MDF__c=true;
    acc.Portal_Champion__c=p.Id;
    update acc;
    test.stoptest();
   
   }
   */
   
   

}