public class TAQ_AutoCreation_PosID 
{
    Map<integer,String> jobPosID = new Map<integer,String>();

    public Map<integer,String> getAbbrevations(List<TAQ_Organization__c> lst)
    {
            System.debug('_____________IN FOR____'+lst.size());
        Set<String> Region = new Set<String>();
        Set<String> Area = new Set<String>();
        Set<String> Territory = new Set<String>();
        Set<String> Org = new Set<String>();
        Set<id> JobTitle = new Set<id>();
        Set<String> MgrPMFKey = new Set<String>();
        Set<String> PMFKey = new Set<String>();
        Map<id, string> MapJobTitle = new   Map<id, string>();
        try {
                for(TAQ_Organization__c taq: lst)        
                {
                
                   if((taq.process_step__c == 'Open HeadCount') ||(taq.process_step__c == 'New Hire') || (taq.process_step__c == 'Employee Change'))// &&  taq.position_id__c == null)
                    {    
                        Region.add(taq.Region__c);
                        Territory.add(taq.Territory__c);
                        Area.add(taq.Area__c);
                        Org.add(taq.Organization__c);
                        JobTitle.add(taq.JobTitle__c);
                        MgrPMFKey.add(taq.Manager_PMF_Key__c);
                        PMFKey.add(taq.PMFkey__c);
                    }
                }
        }
        catch(Exception e)
            { system.debug('____Exception in try Block1: '+e); }            
       System.debug('____________jobtitleee____'+jobtitle);
        for(TAQ_Job_Info__c ji : [Select name, id from TAQ_Job_Info__c where id in : JobTitle ])
            MapJobTitle.put(ji.id,ji.name);
        Map<String,String> MapMgrTitle = new Map<String,String>();
         Map<String,String> MapMgrJobNum = new Map<String,String>();
        try {
                for(TAQ_Organization__c taq1 : [Select PMFKey__c,  JobTitle__r.name, Position_Id__c from TAQ_Organization__c where PMFKey__c in : MgrPMFKey ])
                {   
                    MapMgrTitle.put(taq1.PMFKey__c.toUpperCase(), taq1.JobTitle__r.name); 
                    MapMgrJobNum.put(taq1.PMFKey__c.toUpperCase(),taq1.Position_Id__c);
                }    
        }
        catch(Exception e)
            { system.debug('____Exception in try Block2: '+e); }            
        Map<string, List<TAQ_Organization__c>> MapMgr = new Map<string, List<TAQ_Organization__c>>(); 
        try {
                for(TAQ_Organization__c taq1 : [Select PMFKey__c,Region__c,TAQ_Organization__c.JobTitle__r.Name,
                                                       Manager_PMF_Key__c, Position_id__c 
                                                from TAQ_Organization__c 
                                                where Manager_PMF_Key__c in : MgrPMFKey 
                                                AND JobTitle__r.name in : MapJobTitle.values() 
                                                AND Pmfkey__c not in : PMFKey 
                                                AND Region__c in : Region 
                                                AND Territory__c in : Territory
                                                AND Area__c in :Area 
                                                AND Organization__c in : Org
                //TBD --filter for Area in : Area__c or Market focus Area  or Business Unit
                                                ])
            {
                list<TAQ_Organization__c> lsttaq = MapMgr.get(taq1.Manager_PMF_Key__c.toUpperCase());
                if(lsttaq == null)
                    lsttaq = new List<TAQ_Organization__c>();
                lsttaq.add(taq1);
                MapMgr.put(taq1.Manager_PMF_Key__c.toUpperCase(), lsttaq);
            }
        }
        catch(Exception e)
        {            
            system.debug('____Exception Query2: '+e);            
        }
       //Block 3              
        try
        {
            List<TAQ_Abbreviations__c> lstAbbrev = [SELECT Name, FieldType__c, Field_Value__c FROM TAQ_Abbreviations__c WHERE 
                                                ( FieldType__c='Region' AND Field_Value__c in :Region) OR 
                                                ( FieldType__c='Territory' AND Field_Value__c in:Territory)  OR
                                                ( FieldType__c='Organization' AND Field_Value__c in :Org) OR
                                                ( FieldType__c='JobTitle' AND Field_Value__c in :MapJobTitle.values()) OR
                                                ( FieldType__c='JobTitle' AND Field_Value__c in :MapMgrTitle.Values()) OR
                                                ( FieldType__c='Area' AND Field_Value__c in :Area)
                                                ];
            
            map<string, string> mAbbrev = new map<string,string>();
            for(TAQ_Abbreviations__c abb:  lstAbbrev)
            {
                mAbbrev.put(abb.FieldType__c + '|' + abb.Field_Value__c.toUpperCase() , abb.name);
            }
            integer i =0;
            for(TAQ_Organization__c taq: lst)        
            {
                if((taq.process_step__c == 'Open HeadCount') ||(taq.process_step__c == 'New Hire') || (taq.process_step__c == 'Employee Change'))// &&  taq.position_id__c == null)
                {
                    string regabbrev = mAbbrev.get('Region' + '|' + taq.Region__c.toUpperCase());
                    string orgabbrev = mAbbrev.get('Organization' + '|' + taq.Organization__c.toUpperCase());
                    //when Organization = Direct and BU is not Blank, show BU, else Area
                   string areaabbrev; 
                    if(taq.Organization__c == 'Direct' && taq.Business_Unit__c != NULL)
                        areaabbrev = taq.Business_Unit__c;
                    else
                        areaabbrev = mAbbrev.get('Area' + '|' + taq.Area__c.toUpperCase());
                   //if it is different from Region, show VOL for RMDM and ISBU and others we show the Territory else blank
                 string terrabbrev;
                 
                   if(taq.Territory__c != taq.Region__c)
                   {
                       if(taq.Organization__c == 'RMDM' || taq.Organization__c == 'ISBU')
                        terrabbrev = 'VOL';
                       else    
                        if(taq.Territory__c!=null)
                            terrabbrev = mAbbrev.get('Territory' + '|' + taq.Territory__c.toUpperCase());
                        else
                            terrabbrev = NULL;
                       
                   }     
                   else  
                   {
                    terrabbrev = NULL;
                   }
                  string jobabbrev = NULL;
                   try{
                     jobabbrev = mAbbrev.get('JobTitle' + '|' + MapJobTitle.get(taq.JobTitle__c).toUpperCase());
                   }catch(NullPointerException ex){
                    //   taq.Position_Id__c.addError('Manager\'s JobTitle information is missing, to generate Position Id.');
                          taq.Position_Id_Error_Desc__C = 'User\'s Job Title Info is missing.';
                         // taq.Position_Id__c = NULL;
                          jobPosID.put(i, '');
                          break;
                   }
                    System.debug('_______--IDDDDDDDDDDD____________'+TAQ.ID+'____'+taq.Manager_PMF_Key__c);
                   string mgrjobabbrev = NULL;
                   taq.Position_Id_Error_Desc__c = NULL;
                    try{
                       mgrjobabbrev = mAbbrev.get('JobTitle' + '|' + (MapMgrTitle.get(taq.Manager_PMF_Key__c.toUpperCase()).toUpperCase()));
                    }catch(nullPointerException e){
                    //  taq.Position_Id__c.addError('Manager\'s JobTitle information is missing, to generate Position Id.');
                        if(!MapMgrTitle.containsKey(taq.Manager_PMF_Key__c.toUpperCase())){
                             taq.Position_Id_Error_Desc__c = 'Manager Info does n\'t exist in TAQ Org..';
                        }
                        else if(MapMgrTitle.get(taq.Manager_PMF_Key__c.toUpperCase()) == NULL){
                             taq.Position_Id_Error_Desc__c = 'Manager\'s Job Title Info is missing.';
                        } 
                       //taq.Position_Id__c = NULL;
                         jobPosID.put(i, '');
                         break;
                    }
                    list<TAQ_Organization__c> lsttaq = MapMgr.get(taq.Manager_PMF_Key__c.toUpperCase());
                   
                    integer subordinatecount = 0;
                    String managercount = null;
                    if(lsttaq <> null && lsttaq.size() > 0)
                        for(TAQ_Organization__c taq1: lsttaq)
                        {
                            if(taq1.Region__c == taq.Region__c && taq1.JobTitle__c == taq.JobTitle__c)
                                subordinatecount ++;
                        }
                        
                          if( MapMgrJobNum.get(taq.Manager_PMF_Key__c) != null){
                           for(String s: MapMgrJobNum.get(taq.Manager_PMF_Key__c.toUpperCase()).split('_',-2))
                           {
                             if(s.contains(mgrjobabbrev)){
                                 String[] splitCode = s.split(mgrjobabbrev,-2);
                                 if(splitCode.size()>0){
                                   managercount=splitCode[splitCode.size()-1];
                                }
                             }
                            
                           }
                     }  
                    
                     jobPosID.put(i,(regabbrev == NULL ?'': (regabbrev)) + (orgabbrev == NULL ?'': ('_'+orgabbrev)) +(areaabbrev == NULL ?'': ('_'+areaabbrev)) + (terrabbrev == NULL ?'': ('_'+terrabbrev)) +(mgrjobabbrev == NULL ?'': ('_'+mgrjobabbrev+(managercount==null?'':managercount)))+(jobabbrev == NULL ?'': ('_'+jobabbrev+string.valueOf(subordinatecount+1))));
             }
             else
               { 
                System.debug('Else executed_________');                                                                                                                                                                                                   
                   jobPosID.put(i,'');
               }
            
            i++;
            }
        }
        catch(Exception e)
        {            
            system.debug('____Exception in PosID Creation: '+e);            
        }
        system.debug('Auto Created PosID ID: '+jobPosID);        
        return jobPosID;      
    }
    
 public static testMethod void getAbbrevationsTest()
{
        TAQ_AutoCreation_PosID  Obj = new TAQ_AutoCreation_PosID();
        List<TAQ_Organization__c>  OrgLst = [Select id, organization__c, process_step__c , Region__c,Territory__c,Area__c , JobTitle__c , Manager_PMF_Key__c , PMFkey__c From TAQ_Organization__c where Region__c != Null And Territory__c != null And Area__c != null And JobTitle__c != null And Manager_PMF_Key__c != null And PMFkey__c != null And ( process_step__c = 'Open HeadCount' Or process_step__c = 'New Hire' Or process_step__c = 'Employee Change')  limit 150 ]; 
        Test.startTest();
        Obj.getAbbrevations(OrgLst);
        Test.stopTest();
}       

    
}