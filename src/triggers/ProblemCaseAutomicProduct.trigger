//Checking Automic Product in Custom Setting for Problem Case Creation.
Trigger ProblemCaseAutomicProduct on Case(Before Insert,Before Update, Before Delete, After Insert, After Update, After Delete, After undelete) {

public list<id> ProductContIdlist = new list<id>();
Public Set<string> automicproset = new Set<string>();
public list<case> caselist = new list<case>();

//list of Problem Case Ids
Public List<Id> ProblemCaseIds = new List<Id>();
Public List<Id> IncidentCaseIds = new List<Id>();
public list<case> rcount = new list<case>();
public list<string> probtypelst = new list<string>();
Public List<id> rcountid = new List<id>();
Public List<id> inccountid = new List<id>();
Public List<case> increcordlst = new List<case>();
Public Map<string,List<case>> problemIncidentMap = new Map<string,List<case>>();
Public List<case> incidentlstcount = new List<case>();


//Automic Products are added in custom setting. get the Automic products from custom settings
List<Problem_Case_Products__c> automicpro = Problem_Case_Products__c.getall().values();
system.debug('custom setting product...'+automicpro);

for(Problem_Case_Products__c Prob:automicpro)
{
    automicproset.add(Prob.CA_Product_Controller_Name__c);
}

   If(Trigger.isBefore){
        system.debug('Before Event..');
        If(Trigger.isInsert){
            for(case cs:Trigger.New){

                If(cs.CA_Product_Controller__c != NULL){
                    ProductContIdlist.add(cs.CA_Product_Controller__c);
                    caselist.add(cs);
                }
                If(cs.CA_Product_Controller__c == NULL && cs.Case_Type__c=='Problem')
                {
                    cs.CA_Product_Controller__c.adderror('Please Select the Product Controller.');
                }
            }
        }
        
        
        If(Trigger.isUpdate){
            for(case cs:Trigger.Newmap.values()){
                If(cs.CA_Product_Controller__c != NULL){
                    ProductContIdlist.add(cs.CA_Product_Controller__c);
                    caselist.add(cs);
                }
                If(cs.CA_Product_Controller__c == NULL && cs.Case_Type__c=='Problem')
                {
                    cs.CA_Product_Controller__c.adderror('Please Select the Product Controller.');
                }
            }  
        } 
    }


    If( !caselist.isempty()){
       if (caselist[0].Case_Type__c=='Problem'){ 
         Map<Id,CA_Product_Controller__c> Productcontmap = new Map<Id,CA_Product_Controller__c>(
          [Select Name from CA_Product_Controller__c where Id in: ProductContIdlist]
          );
          for(case cse:caselist){
              If(cse.CA_Product_Controller__c != NULL){
                  CA_Product_Controller__c ProdController = Productcontmap.get(cse.CA_Product_Controller__c);
                  system.debug('product rec...!!!!'+ProdController.Name);
                  If(cse.Case_Type__c=='Problem'){
                      system.debug('Case Product..!!' +cse.CA_Product_Controller__r.Name);
                      If(!(automicproset.contains(ProdController.Name))){
                          system.debug('ProdController Name result...'+ProdController.Name);
                          system.debug('automic records...'+automicproset);
                          cse.addError('Problem Case can not be created for the selected CA Product.');
                          break;
                      }
                  }
              }
          }
       }   
    }

    

if(!CheckRecursiveTrigger.recursiveflag){

If(Trigger.isAfter){
      system.debug('After Event..!!');
      If (trigger.isinsert || trigger.isupdate) {
       //if Incident case has Problem Case, add to set of ParentProblemCaseId
        for (Case c: Trigger.Newmap.values()){
            if(c.ParentId != null){
            ProblemCaseIds.add(c.ParentId);
            IncidentCaseIds.add(c.Id);
            system.debug('New Problem Case Ids..!!'+ProblemCaseIds);
            system.debug('New Incident Case Ids..!!'+IncidentCaseIds);
            }
        }
      }
    
      if (trigger.isdelete) {
        for (Case c: Trigger.Old) {
          if(c.ParentId != null) {
          ProblemCaseIds.add(c.ParentId);
          IncidentCaseIds.add(c.Id);
          system.debug('existing Problem Case Ids..!!'+ProblemCaseIds);
          system.debug('existing Incident Case Ids..!!'+IncidentCaseIds);
          }
        }
      }
  }

   
    If(!ProblemCaseIds.isempty()){
            CheckRecursiveTrigger.recursiveHelper(true);
            CaseIncidentsonProblem.countcaseincident(ProblemCaseIds,IncidentCaseIds);
    }  
    
  }  
  

    If(Trigger.isAfter && Trigger.isUpdate){
        //CheckRecursiveTrigger.recursiveHelper(true);
        system.debug('Update isafter..!!!');
        system.debug('Case New records'+Trigger.new);
        system.debug('Case new record size'+Trigger.new.size());
        system.debug('Case oldmap be'+Trigger.oldmap.values());
        system.debug('Case oldmap size'+Trigger.oldmap.size());
        //Update Severity, Number of Incidents and Component Release 
        JiraCaseTriggerUpdate.JiraUpdateFieldFutureCallout((Case)Trigger.new[0], (Case)Trigger.old[0]);
    }
}