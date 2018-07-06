public class Automic_VersionTriggerHelper
{
    public static void addVersionToJira(List<Automic_R_D_Component_Version__c > newRecords)
    {
        map<string,Map<string,string>> labelMap = new map<string,Map<string,string>>();
        for(Automic_R_D_Component_Version__c ACV: [select id,Component_Release__c,Component_Release__r.Component_Text__c,Component_Release__r.Component_Release__c,Problem__c,name from Automic_R_D_Component_Version__c where id IN: newRecords AND Problem__r.Jira_Issue_API_link__c != null AND Created_Internally__c=TRUE]){
            String name;
            if(ACV.Component_Release__c != null) {
                name = ACV.Component_Release__r.Component_Text__c.replace(' ','.')+'_'+ACV.Component_Release__r.Component_Release__c;
            } else {
                name = ACV.name;
            }
            if(!labelMap.containsKey(ACV.Problem__c)) {
                labelMap.put(ACV.Problem__c,new Map<string,string>{'addVersion' => name});
            }
            else{
                Map<string,string> tempMap = labelMap.get(ACV.Problem__c);
                if(tempMap.get('addVersion') != null){
                    string newVer = tempMap.get('addVersion')+'@@'+name;
                    tempMap.put('addVersion',newVer);
                }
                else
                    tempMap.put('addVersion',name);
                
                labelMap.put(ACV.Problem__c,tempMap ); 
            }   
        } 
        
        Integer i=1;
        for(string key: labelMap.keySet()){
            if(i<=5){
                JiraIntegrationHelper.updateJiraTicket(key,new map<string,string>(),labelMap.get(key),false);
                i++;
            }
            else{
                break;
            }
        }   
    }
    
    
    
    
    
    /*  public static void removeVersionToJira(map<Id,Product_Version__c> oldRecordMap)
{
map<string,Map<string,string>> labelMap = new map<string,Map<string,string>>();
for(Product_Version__c pv: [select id,Problem__c,name from Product_Version__c where id IN: oldRecordMap.keySet() AND Problem__r.Jira_Issue_API_link__c != null]){
if(!labelMap.containsKey(pv.Problem__c))
labelMap.put(pv.Problem__c,new Map<string,string>{'removeVersion' => pv.name});
else{
Map<string,string> tempMap = labelMap.get(pv.Problem__c);
if(tempMap.get('removeVersion') != null){
string newVer = tempMap.get('removeVersion')+'@@'+pv.name;
tempMap.put('removeVersion',newVer); 
}
else
tempMap.put('removeVersion',pv.name); 
labelMap.put(pv.Problem__c,tempMap); 
}
} 

Integer i=1;
for(string key: labelMap.keySet()){
if(i<=5){
JiraIntegrationHelper.updateJiraTicket(key,new map<string,string>(),labelMap.get(key),false);
i++;
}
else{
break;
}
}   
}*/
}