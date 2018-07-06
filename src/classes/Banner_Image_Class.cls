/**
*Description :display of the banner on the PRM portal home page dynamic.
*Methods Banner_Image_Class
*SOQl: 1
*DML: 0
*Client: CA technologies
*Developed By:  Accenture
*/
public class Banner_Image_Class {
    
    List<PRM_Banner_Setup__c> imageToProfilesList= [select name, Image_Id__c, Profile_Names__c,Country__c from PRM_Banner_Setup__c];
    Profile profileName;
    User currUser;
    public List<String> imageURL = new List<String>();
    
    //Constructor to show the Banner image to logged in parnter users.
    public Banner_Image_Class(){
        profileName=[Select Name From Profile where id=:UserInfo.getProfileId() limit 1];
    //    currUser = [Select id,Country from User where id =:UserInfo.getUserId() limit 1];
        for(PRM_Banner_Setup__c t:imageToProfilesList){
           // code commented to bypass the check for country not being used in Release 2
          //  if(t.Country__c != null && t.Country__c == currUser.Country){
                if(t.Profile_Names__c.contains(profileName.Name)){
                	System.debug('========'+ t.Image_Id__c);
                    imageURL.add('/servlet/servlet.FileDownload?file='+t.Image_Id__c);
                    
                    }
           //     }
          /*  else if(t.Country__c == null && t.Profile_Names__c.contains(profileName.Name)){
                imageURL.add('/servlet/servlet.FileDownload?file='+t.Image_Id__c);
            }  */
        }
    }
    
    public List<String> getimageURL(){
    	System.debug('------------------'+imageURL);
        return imageURL;
    }
    
}