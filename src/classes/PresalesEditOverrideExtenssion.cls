public class PresalesEditOverrideExtenssion {
    private Presales_Request__c preRec;
    public PresalesEditOverrideExtenssion(ApexPages.StandardController controller){
        
      this.preRec = (Presales_Request__c)controller.getRecord();

        
    }
    
    
    public PageReference redirectEdit(){
        PageReference pg=new PageReference('/'+preRec.id);
        pg.setRedirect(true);
        
        return pg;
        
        
    }

}