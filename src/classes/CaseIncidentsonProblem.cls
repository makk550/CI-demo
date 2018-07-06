//CaseProcessor
public class CaseIncidentsonProblem{
 
    
    @future
     public static void countcaseincident(List<Id> ProblemCaseIds, List<id> IncidentCaseIds) {
     
        // Set<Id> ProblemCaseIds = new Set<Id>();
        // Set<Id> IncidentCaseIdset = new Set<Id>();
         list<string> prtypelist = new list<string>();
         List<id> ProblemIdlist = new List<id>();
         List<id> IncidentIdlist = new List<id>();
         List<case> Incidentlist = new List<case>();
         List<case> ProbIncidentcountlist = new List<case>();
     
      List<case> problemtypelist = [Select Id, Case_Type__c, No_of_problem_or_standard_cases__c from case where Id in: ProblemCaseIds];
    
      for(case Probtype:problemtypelist){
        if(Probtype.Case_Type__c == 'Problem'){
            prtypelist.add(Probtype.Case_Type__c);
            system.debug('problem case type..!!'+prtypelist);
        }   
      }
     
     
    //Query on Parent Case Object
    List<Case> ProblemRecordslist = [Select Id, Case_Type__c, No_of_problem_or_standard_cases__c From Case where Id in: ProblemCaseIds AND Case_Type__c in: prtypelist];
    system.debug('Problem Case Rec..!!'+ProblemRecordslist);
    
    List<Case> IncidentRecordslist = [Select Id, Case_Type__c,ParentId from Case where Id in:IncidentCaseIds OR parentId in:ProblemCaseIds];
    system.debug('Incident Case Rec..!!'+IncidentRecordslist);
    
    
        for (Case ProblemRec: ProblemRecordslist) {
         
             for(case IncidentRec: IncidentRecordslist){
                    
                    If(ProblemRec.Id == IncidentRec.parentId && IncidentRec.Case_Type__c == 'Standard'){
                     Incidentlist.add(IncidentRec);
                     
                    }
             }
             system.debug('Incident Records to be..!!!!'+Incidentlist);
             If(Incidentlist.size()>0){
                ProblemRec.No_of_problem_or_standard_cases__c = Incidentlist.size();
                ProbIncidentcountlist.add(ProblemRec);
             }
             system.debug('Count to be..!!!!'+ProblemRec.No_of_problem_or_standard_cases__c);
             
             
        }
        system.debug('Problem Records to be..!!!!'+ProbIncidentcountlist);
        CheckRecursiveTrigger.recursiveflag = True; 
        If(Incidentlist.size()>0){      
            update ProbIncidentcountlist;
        }
        system.debug('case record is'+ProbIncidentcountlist.size());
    }
 }