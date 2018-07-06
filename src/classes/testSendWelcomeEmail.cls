@istest
public class testSendWelcomeEmail {

    static testMethod void testWelcomeEmail(){
    
      User[] listUserInsert = new User[]{};
      User[] listUserUpdate = new USer[]{};
                

          
      for(integer i=0;i<5;i++){
          
          User newUser = new User(Alias='CAUser'+i, Email= 'noreply@ca.com' ,isActive=true, 
                                 emailencodingkey='UTF-8', languagelocalekey='en_US',
                                 LastName='CAusername'+i,localesidkey='en_US',  ProfileId=UserInfo.getProfileId(), 
                                 timezonesidkey='America/Los_Angeles',Username =  'CATestuser'+i+'@ca.com'
                                 );
          if(i/2==0)
              newUser.isactive=false;                       
          listUserInsert.add(newUser);
          
          //u.isActive = false;
          //listUserUpdate.add(u);
                          
      }
      
      insert listUserInsert;
      
      
      for( User u:listUserInsert ){
      
          u.IsActive = true;
          
      }
     
      update listUserInsert;
      
      
    
    }

}

      /*
      // code commented by Accenture IDC on Jul 30 2010 for successful Deployment
      public class testSendWelcomeEmail {

    static testMethod void testWelcomeEmail(){
    
      User[] listUserInsert = new User[]{};
      User[] listUserUpdate = new USer[]{};
                
      for(User u:[SELECT isActive, Alias, Email, EmailEncodingKey, LanguageLocaleKey, LastName,LocaleSidKey, ProfileId, 
                          TimeZoneSidKey, Username, UserPermissionsMarketingUser
                          FROM User LIMIT 5]){
          
          User newUser = new User(Alias=u.Alias , Email= 'noreply@ca.com' , EmailEncodingKey=u.EmailEncodingKey, LanguageLocaleKey=u.LanguageLocaleKey,
                                   LastName=u.LastName,LocaleSidKey=u.LocaleSidKey, ProfileId=u.ProfileId, TimeZoneSidKey=u.TimeZoneSidKey,
                                   Username = u.Username + 'Test', UserPermissionsMarketingUser=u.UserPermissionsMarketingUser);
          listUserInsert.add(newUser);
          
          u.isActive = false;
          listUserUpdate.add(u);
                          
      }
      
      insert listUserInsert;
      update listUserUpdate;
      
      for( User u:listUserUpdate ){
      
          u.IsActive = true;
          
      }
      
      update listUserUpdate;
      
      
    
    }

    }
      
      */