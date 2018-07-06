trigger OAECountReset on User_Skills__c(before insert) {
Map<id,String> UsrTmeZneMap = new Map<id,String>();
List<User> UsrLst = new List<User>();
set<id> UsrSet = new set<id>();
set<id> InsertUsrSet = new set<id>();
set<String> loc = new set<String>();
set<String> Comp= new set<String>();
set<String> Tops= new set<String>();
Map<ID,String> bhrTmzneMap= new Map<id,String>();
Map<ID,BusinessHours> bhMap;
  bhMap=new Map<ID,BusinessHours>([select id, MondayStartTime, MondayEndTime from BusinessHours]);
  List<BusinessHours> BhrList= new List<BusinessHours>(); 
  BhrList =[select id, MondayStartTime, MondayEndTime,TimeZoneSidKey from BusinessHours];
  List<Component_Release__c> Cmprls = new List<Component_Release__c>();
  //Cmprls=([select Component_Code__c from Component_Release__c where Component_Code__c!=null]);
  set<String> ComrelSet= new set<String>();
  List<Site_Association__c> SteList = new List<Site_Association__c>();
  //SteList=([select SC_TOPS_ID__c from Site_Association__c where SC_TOPS_ID__c!=null]);
  set<String> SteSet= new set<String>();
  
    for(User_Skills__c recUs :Trigger.new)
    {
        if(Trigger.isInsert || (Trigger.isupdate))
            UsrSet.add(recUs.User__c);
        if(Trigger.isInsert)
        {
            InsertUsrSet.add(recUs.User__c);
        }
    }

    if(InsertUsrSet.size() > 0)
    {
       List<User_Skills__c> insUS = [select id, user__c, Cases_Assigned__c, Cases_assigned_perday__c, Severity_1_cases_assigned__c from User_Skills__c where user__c IN: InsertUsrSet];
       Map<ID,User_Skills__c> insertUserCountMap = new Map<id,User_Skills__c>();       
       for(User_Skills__c tmp : insUS)
       {
           if(insertUserCountMap.containsKey(tmp.User__c))
           {
               User_Skills__c tmpUS = insertUserCountMap.get(tmp.User__c);
               if(tmp.Cases_Assigned__c > tmpUS.Cases_Assigned__c)
               {
                   insertUserCountMap.put(tmp.User__c, tmp);
               }
           }
           else
           {
               insertUserCountMap.put(tmp.User__c, tmp);
           }
       }       
       for(User_Skills__c recUs :Trigger.new)
       {
            if(Trigger.isInsert)
            {
                if(insertUserCountMap.containsKey(recUs.User__c))  
                {
                    User_Skills__c tmpUS = insertUserCountMap.get(recUs.User__c);
                    recUs.Cases_Assigned__c = tmpUS.Cases_Assigned__c;
                    recUs.Cases_assigned_perday__c = tmpUS.Cases_assigned_perday__c;
                    recUs.Severity_1_cases_assigned__c = tmpUS.Severity_1_cases_assigned__c;
                }  
            }
       }             
    }   
    
    if(UsrSet!=null && UsrSet.size()>0)
    UsrLst=[select id,TimeZoneSidKey from User where id in: UsrSet];


    if(UsrLst!=null && UsrLst.size()>0)
        for(User recUsr :UsrLst)
        {
            UsrTmeZneMap.put(recUsr.id,recUsr.TimeZoneSidKey);
        }
    
    if(BhrList !=null && BhrList.size()>0)
       for(BusinessHours bhrRec:BhrList)
       {
           bhrTmzneMap.put(bhrRec.id,bhrRec.TimeZoneSidKey);
       }
     
     if(Trigger.isInsert)
     {

if(UsrTmeZneMap.size()>0 && bhrTmzneMap.size()>0)
    for(User_Skills__c recUs:Trigger.new){
        Datetime dt = System.now();
        Datetime dtD = System.now();
        System.debug('Today Date - ' + dt);
        String dayOfWeek = dt.format('E',UsrTmeZneMap.get(recUs.User__c)); 
        System.debug('Day of Week - ' + dayOfWeek); 
        System.debug('Timezone - ' +  UsrTmeZneMap.get(recUs.User__c));     
        Datetime dt1 = System.today();
        Datetime dt2 = System.today();
        if(dayOfWeek == 'Mon')
        {
            dt1 = dt.addDays(6);
        }
        else if(dayOfWeek == 'Tue')
        {
            dt1 = dt.addDays(5);
        }
        else if(dayOfWeek == 'Wed')
        {
            dt1 = dt.addDays(4);
        }
        else if(dayOfWeek == 'Thu')
        {
            dt1 = dt.addDays(3);
        }  
        if(dayOfWeek == 'Fri')
        {
            dt1 = dt.addDays(2);
        }
        if(dayOfWeek == 'Sat')
        {
            dt1 = dt.addDays(1);
        }
        if(dayOfWeek == 'Sun')
        {
            dt1 = dt.addDays(7);
        }   
        
        system.debug('dt1:: '+dt1);
        
        //String formattedDt = dt1.format('MM/dd/yyyy');
        String formattedDt = dt1.format(' yyyy-MM-dd');
        
       
         system.debug('formattedDt :: '+formattedDt);
            //   Datetime myDate1 = datetime.valueOf(formattedDt);
         //formattedDt=formattedDt+' 12:00 AM';
        // system.debug('formattedDtmodified :: '+formattedDt);
        

                 // Datetime myDate = datetime.valueOf(formattedDt);
                
             //  Datetime myDate= Date.valueOf(formattedDt.replace('/','-'));
            Date myDate=Date.valueOf(formattedDt.replace('/','-'));
                  
         
          system.debug('1st part mydate 1111111111111 :: '+myDate);
        
     //   system.debug('1st part :: '+DateTime.parse(String.valueOf((dt1).format('MM/dd/yyyy'))+'12:00 AM'));
        
        
       // system.debug('3rd st part :: '+UsrTmeZneMap.get(recUs.User__c));      
        
       // system.debug('----line 122'+datetime.valueof(DateTime.parse(String.valueOf((dt1).format('MM/dd/yyyy'))+' 12:00 AM').format('yyyy-MM-dd HH:mm:ss',UsrTmeZneMap.get(recUs.User__c))));         
                                             
     //  recUs.Time_to_Reset_US__c= datetime.valueof(DateTime.parse(String.valueOf((dt1).format('yyyy-MM-dd'))+' 12:00 AM').format('yyyy-MM-dd HH:mm:ss',UsrTmeZneMap.get(recUs.User__c)));     
      recUs.Time_to_Reset_US__c= myDate;          
       // recUs.Time_to_Reset_US_Daily__c = datetime.valueof(DateTime.parse(String.valueOf((dt).format('yyyy-MM-dd'))+' 12:00 AM').format('yyyy-MM-dd HH:mm:ss',UsrTmeZneMap.get(recUs.User__c))); 
        
        
            dt2 = dtD.addDays(1);
            String formattedDtD = dt2.format(' yyyy-MM-dd');
            Date myDateD=Date.valueOf(formattedDtD.replace('/','-'));
             recUs.Time_to_Reset_US_Daily__c= myDateD;      
            
}
}
}