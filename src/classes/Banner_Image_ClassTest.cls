/**
Class Name: Banner_Image_ClassTest
Date: 1/3/2010
Project/Requirement: CA PRM R2/PLM
Author: Accenture
Description: This class is test class for Banner_Image_Class
*/

@isTest
private class Banner_Image_ClassTest { 
	
	static testMethod void testBannerClass(){  
		 Profile profileName=[Select Name From Profile where id=:UserInfo.getProfileId() limit 1];
		 //insert PRm Banner setup record.
		 PRM_Banner_Setup__c testBannerSetup = new  PRM_Banner_Setup__c();
		 testBannerSetup.Profile_Names__c= profileName.Name;
		 testBannerSetup.Name='test banner';
		 testBannerSetup.Image_Id__c='Test ID';
		 insert testBannerSetup;
		 
		 PageReference p = new PageReference('/apex/Banner_Image');		 
         Test.setCurrentPage(p);  
         Banner_Image_Class classVar= new Banner_Image_Class();
	}
}