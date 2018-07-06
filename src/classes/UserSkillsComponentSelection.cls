public class UserSkillsComponentSelection{
    
    public List<UserSkillProductCodeAssociation__c> Usercmplist{get;set;}
    public List<UserSkillProductCodeAssociation__c> Existingvalueslist{get;set;}  
     
    public List<CAProductComponentWrapper> CAProductWrapper{get;set;}
    public List<CA_Product_Component__c> CAProductComponentlist{get;set;}
    public List<CA_Product_Component__c> CAProductComponentfinallist{get;set;}
    public List<CA_Product_Component__c>  selectlist{get;set;}
    public  User_Skills__c CA_Product{get;set;}
    public boolean checkall{get;set;}
    public Set<id> oldids{get;set;}
    
    
    private final User_Skills__c USK;
    private Apexpages.StandardController controller;
    
    public UserSkillsComponentSelection(ApexPages.StandardController std){
        this.controller = std;
        USK= (User_Skills__c)std.getRecord();
        CA_Product=new User_Skills__c();
        selectlist = new List<CA_Product_Component__c>();
        Usercmplist = new List<UserSkillProductCodeAssociation__c>();
        checkall=false;
        Existingvalueslist=new List<UserSkillProductCodeAssociation__c>([select CA_Product_Component__c from UserSkillProductCodeAssociation__c where User_Skills__c=:this.USK.id]);
        oldids=new Set<id>();
        CAProductComponentfinallist=new List<CA_Product_Component__c>();
    }
    
  
    
    
    public void componentresult(){
        CAProductWrapper = new List<CAProductComponentWrapper>();
        CAProductComponentlist = [select Component_Code__c,Component_Text__c,CA_Product_Controller__r.name from CA_Product_Component__c where CA_Product_Controller__c=:CA_Product.CA_Product_Controller__c];
        if(CAProductComponentlist != null)
        {
            checkall=true;
        }
        else{
             
            checkall=false;
            
        }
        for(CA_Product_Component__c productcmp : CAProductComponentlist){
            CAProductWrapper.add(new CAProductComponentWrapper(productcmp));
        }
    }
    
    public PageReference save()
    {
        
        if(CAProductWrapper!=null){
            for(CAProductComponentWrapper wrapper : CAProductWrapper){
                if(wrapper.checkbox==true)
                    selectlist.add(wrapper.productcomponent);
            }}
        for(UserSkillProductCodeAssociation__c existingval : Existingvalueslist){
            oldids.add(existingval.CA_Product_Component__c);
        }
        
        
        for(CA_Product_Component__c productcomp : selectlist){
            if(!oldids.contains(productcomp.id))
                CAProductComponentfinallist.add(productcomp);
        }
        for(CA_Product_Component__c prodcompfinal : CAProductComponentfinallist){
            
            UserSkillProductCodeAssociation__c tmp = new UserSkillProductCodeAssociation__c(CA_Product_Component__c=prodcompfinal.id,User_Skills__c=this.USK.id,name=prodcompfinal.CA_Product_Controller__r.name+':'+prodcompfinal.Component_Code__c); 
            Usercmplist.add(tmp);
        }
        Database.upsert(Usercmplist,false);
        return controller.save();
    }
    
    
    public class CAProductComponentWrapper{
        public CA_Product_Component__c productcomponent{get;set;}
        public boolean checkbox {get;set;}
        public CAProductComponentWrapper(CA_Product_Component__c productcomponent){
            this.productcomponent=productcomponent;
            checkbox=false;
        }
    }
}