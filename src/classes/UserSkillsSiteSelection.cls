public class UserSkillsSiteSelection{

    public  Site_Association__c Site_Assocation {get;set;}
    public List<SiteAssociationWrapper> SiteWrapper {get;set;}
    private final User_Skills__c USK;
    private Apexpages.StandardController controller;
    public List<Site_Association__c> SiteAssociationlist{get;set;}
    public List<Site_Association__c> Sitelist{get;set;}
    public boolean checkall{get;set;}
    public boolean isResult{get;set;}       
    public boolean checkbox1{get;set;} 
    
    public UserSkillsSiteSelection(ApexPages.StandardController std) {
    this.controller = std;
    USK= (User_Skills__c)std.getRecord();
    Site_Assocation = new Site_Association__c();
    Sitelist =new List<Site_Association__c>();
    checkall=false;
    isResult =false;
    checkbox1 = false; 
    }  

  
     public void filterResult() {

         String name ='';
         String country='';
         String siteId ='';
         String city ='';
      
         SiteWrapper = new List<SiteAssociationWrapper>(); 
         if(Site_Assocation.Country_Picklist__c!=null)
         country = '\''+ Site_Assocation.Country_Picklist__c+'\'';
         if(Site_Assocation.Name != null )
         name = '\'%'+ Site_Assocation.Name+'%\'';  
         if(Site_Assocation.SC_TOPS_ID__c!= null)
         siteId= '\''+ Site_Assocation.SC_TOPS_ID__c +'\'';  
         if(Site_Assocation.City__c!= null)
         city= '\''+ Site_Assocation.City__c +'\'';  
         
            if((name == null || (name !=null && name.length() == 0))&&
             (country== null || (country!=null && country.length() == 0 ))&&
             (siteId== null || (siteId!=null && siteId.length() == 0))&&
             (city== null || (city!=null && city.length() == 0))) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select any of the filters'));
             }
             
         else {         
       
         String query = 'select SC_TOPS_ID__c, Name,City__c,Country_Picklist__c from Site_Association__c where SC_TOPS_ID__c!=null'; 
         if(name != null && name.length() > 0 )
         query += ' and Name like ' + name ;
         if(country !=null && country.length()> 0)
         query += ' and Country_Picklist__c= '+country;
         if(siteId !=null && siteId.length() > 0)
         query += ' and SC_TOPS_ID__c= '+siteId;
         if(city!=null && city.length() > 0 )
         query += ' and City__c= '+city;    
         query += ' limit 1000';     
         //System.debug('query:'+query);
         SiteAssociationlist =Database.query(query); 
         if(SiteAssociationlist.size() == 1000)
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Current Filter Criteria is returning more than 1000 records , System will allow to return only 1000, Please Add Additional filter criteria '));
           //System.debug( 'result: '+ SiteAssociationlist );                         
            if(SiteAssociationlist != null)
             {
                checkall=true;
             }
         else{
 
               checkall=false;
             }
             isResult = true;
          for(Site_Association__c siteassociation : SiteAssociationlist){
             SiteWrapper.add(new SiteAssociationWrapper(siteassociation));
             }
            
 }
  
}   

  public PageReference save(){    
  Boolean isChecked = checkbox1;
  System.debug('isChecke:'+isChecked);
     if(isChecked) {
              usk.Tops_Site_ID__c = '*';
              update usk;
              return Controller.save();
             }
      else if(isResult) {
        String SiteIds ='';
        for(SiteAssociationWrapper wrapper : SiteWrapper ){
           if(wrapper.checkbox==true)
           Sitelist.add(wrapper.siteassociation);
        }    
         //System.debug('Sitelist' + Sitelist);
         
        for(Site_Association__c  site : Sitelist){
        if(SiteIds==null)
        SiteIds =site.SC_TOPS_ID__c;
        else {
        if(!SiteIds.contains(site.SC_TOPS_ID__c))
        SiteIds  +=site.SC_TOPS_ID__c+';';        
        }
        }
       
        
        SiteIds = SiteIds.removeEnd(';');
         String topsid = [select Tops_Site_ID__c from User_Skills__c where id =:usk.id].Tops_Site_ID__c;
       if(topsid  == null){
       usk.Tops_Site_ID__c = SiteIds;
       }
       else {
         if(!(topsid.contains(SiteIds)))
       usk.Tops_Site_ID__c = topsid  + ';' + SiteIds;
         }
       update usk;
       return Controller.save();
        }
        else {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please select required Site Ids and click on save'));
        return null;
        }          
    }  
    

 public class SiteAssociationWrapper{
  public Site_Association__c siteassociation {get;set;}
  public boolean checkbox {get;set;}
  
  public SiteAssociationWrapper (Site_Association__c siteassociation){
  this.siteassociation = siteassociation ;
  checkbox=false;
  }
 }
 
 
 }