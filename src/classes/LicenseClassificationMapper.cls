/*********************************************************************************************
 * Class Name -LicenseClassificationMapper
 * Created By - samap01
 * Created For - US370595/US370555,US370554 - To set license classification and license type
 * Used In 
 * Test Classes - TBD
 * ------------------------------------------------------------------------------------------
 * Modified By	Modified Date	User Story				Description 
 *  SAMAP01     26/10/2017      US370555/US370595      To set License Classification for OLI
* ********************************************************************************************/
public class LicenseClassificationMapper {

    public static String licclassification ; // {get;set;}     
    //For Add/Edit Mainframe Capacity - Passing Business Type instead of Business Unit through strbu as the BU vaule will not be available 
    public static OpportunityLineItem LicenseClassifcationset(OpportunityLineItem oli,string strbu,string strlicclassoverride)
    {
        string licenseclassification = '';  
       
        system.debug('samap01 - LicenseClassifcationset strbu' + strbu);
        system.debug('samap01 - LicenseClassifcationset oli' + oli);
        system.debug('samap01 - LicenseClassifcationset strlicclassoverride' + strlicclassoverride);
        if(oli != null )
        {
            if(oli.Business_Unit__c != null && oli.Business_Unit__c !='')
            	strbu = oli.Business_Unit__c;
             system.debug('samap01 - LicenseClassifcationset strbu' + strbu);
            if(oli.License__C =='Ratable' && (strbu== 'Mainframe' || strbu =='Mainframe Capacity' || strbu=='MF Capacity' || strbu=='MF Capacity Overage') && (strlicclassoverride !='UMF' && strlicclassoverride !='--Select--'))
            {
                licenseclassification = strlicclassoverride;
                oli.License_Classification_Override__c = strlicclassoverride;
                 system.debug('samap01 - is mainframe strlicclassoverride' + strlicclassoverride);
            }               
            	
            else
            {
                oli.License_Classification_Override__c ='';
                if( oli.Business_Type__c == 'MF Capacity' || strbu =='Mainframe Capacity' ) 
                {
                    if(oli.License__C !='' && oli.License__C != null )                    
                    {                    
                        if( oli.License__C =='Ratable' )
                            licenseclassification ='UMF';
                        if( oli.License__C =='Subscription' )
                            licenseclassification ='Subscription';
                    }
                } 
                else
                {
                    System.debug(' samap01 ll oli.Business_Unit__c' +oli.Business_Unit__c );
                    System.debug(' samap01 ll oli.Business_Type__c' +oli.Business_Type__c );
                    if(oli.License__C !='' && oli.License__C != null )                    
                    {
                        if( oli.License__C =='Upfront'   )
                            licenseclassification ='Perpetual';
                        else if( oli.License__C =='SAAS' )
                            licenseclassification ='SAAS';
                        else if( oli.License__C =='UMF' )
                            licenseclassification ='UMF';                   
                        else if( oli.License__C =='Ratable' && strbu !='Mainframe' )
                            licenseclassification ='Perpetual';
                        if( oli.License__C =='Ratable'  && strbu =='Mainframe') 
                            licenseclassification ='UMF';
                        if( oli.License__C =='Subscription' )
                            licenseclassification ='Subscription';
                    }
                }   
                
            }
            
            
            
        }
        system.debug('samap01 + licenseclassification' + licenseclassification);
        licclassification =   licenseclassification;
         return oli;
    }
    public static list<SelectOption> LicenseClassification() {
      
            list<SelectOption> st= new list<SelectOption>(); 
            st.add(new SelectOption('--Select--','--Select--')); 
            st.add(new SelectOption('UMF','UMF')); 
            st.add(new SelectOption('Perpetual','Perpetual'));
            st.add(new SelectOption('Subscription','Subscription')); 
            st.add(new SelectOption('SAAS','SAAS'));
            
            return st;
 }    
    
    public static list<SelectOption> LicenseClassificationOverride() {
        
            list<SelectOption> st= new list<SelectOption>(); 
            st.add(new SelectOption('UMF','UMF')); 
            st.add(new SelectOption('Perpetual','Perpetual'));
            return st;
       } 
    
    /* public LicenseClassificationMapper(ApexPages.Standardcontroller stdcontroller)
     {}*/
}