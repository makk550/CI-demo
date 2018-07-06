public class BusinessWeightageController {

    public BusinessWeightageController(ApexPages.StandardController controller) {

            this.scorePercentage = Lead__c.getInstance('Total Score');
      this.record=(Lead__c)controller.getRecord();
        DisplayRec=Lead__c.getValues('Total Score'); 
        pre_pps=String.valueOf(DisplayRec.PartnerProgramScore__c);
        pre_lhs=String.valueOf(DisplayRec.LoyalityHistorial__c);
        pre_pc=String.valueOf(DisplayRec.ProductCompetency__c);
        
    }

    public Lead__c scorePercentage{get; set;}
    Lead__c record;
    Lead__c DisplayRec;
    String score_LH{get;set;}
    
    public string getscore_LH(){
        return score_LH;
    }
    public void setscore_LH(string s1){
        score_LH=s1;
    }
    String score_PPS{get;set;}
    public string getscore_PPS(){
        return score_PPS;
    }
    public void setscore_PPS(string s1){
        score_PPS=s1;
    }
    String score_PC{get;set;}
    public string getscore_PC(){
        return score_PC;
    }
    public void setscore_PC(string s1){
        score_PC=s1;
    }
     public string pre_pps{get;set;}
     public string pre_lhs{get;set;}
     public string pre_pc{get;set;}
 
    
     public PageReference UpdateScores() 
    {
    
        try
        {
            if(decimal.valueOf(this.score_LH)>=0 && decimal.valueOf(this.score_PPS)>=0 && decimal.valueOf(this.score_PC)>=0){
        this.scorePercentage.LoyalityHistorial__c =decimal.valueOf(this.score_LH);  //this.score_LH;
        this.scorePercentage.PartnerProgramScore__c= decimal.valueOf(this.score_PPS); //this.score_PPS; 
        this.scorePercentage.ProductCompetency__c= decimal.valueOf(this.score_PC); //this.score_PC;
        update this.scorePercentage;
                
                
         return new PageReference('/'+ LeadRoutingMatrix__c.sObjectType.getDescribe().getKeyPrefix());  //+ this.scorePercentage.Id
          }
        
        }
         catch(Exception ex)
        {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter Proper Values');
                        ApexPages.addMessage(myMsg);
             ApexPages.addMessages(ex);
        }
       
        return null; 

    }
    
}