public class PreSalesEditController {
    
    public Presales_Request__c presale {set;get;}
    public PreSales_Comm__c presalCom {set;get;}
    public Id presalesId;
    public Boolean resourceSection1 {set;get;}
    public Boolean resourceSection2 {set;get;}
    public Boolean resourceSection3 {set;get;}
    
    public Boolean resourceSectionReadOnly1 {set;get;}
    public Boolean resourceSectionReadOnly2 {set;get;}
    public Boolean resourceSectionReadOnly3 {set;get;}
    
    public boolean resorceRequired1 {set;get;}
    public boolean resorceRequired2 {set;get;}
    public boolean resorceRequired3 {set;get;}
    
    public boolean approveButton {set;get;}
    public boolean rejectButton {set;get;}
    public boolean submitButton {set;get;}
    
    public boolean removalReason1 {set;get;}
    public boolean removalReason2 {set;get;}
    public boolean removalReason3 {set;get;}
    
    public boolean commResorce1 {set;get;}
    public boolean commResorce2 {set;get;}
    public boolean commResorce3 {set;get;}
    
    public boolean addpage{set;get;}
    public boolean newpage{set;get;}
    
    RecordTypes_Setting__c rec = RecordTypes_Setting__c.getValues('Presales Fulfilled');
    Id Fulfilledrecordtypeid = rec.RecordType_Id__c;
    RecordTypes_Setting__c rec2 = RecordTypes_Setting__c.getValues('Presales Cancelled Request');
    Id cancelledrecordtypeid = rec2.RecordType_Id__c;
    
    List<OpportunityTeamMember> oppteammember = new List<OpportunityTeamMember>();
    
    public Boolean resorce_commission_Role_1 {set;get;}
    public Boolean resorce_commission_Role_2 {set;get;}
    public Boolean resorce_commission_Role_3 {set;get;}
    public string numberofpresal {set;get;}
    Set < id > preSalId = new Set < id > ();        
	
	public static Boolean canDeletePresales = false; //boolean to allow deletion of team member from presales process- US390579 - BAJPI01
    
    public List < SelectOption > listop {
        get {
            listop = getNumberOfPreSlesResouce();
            
            return listop;
            
        }
        set; 
        
    }
    
    public PreSales_Comm__c comRecord {set;get;}
    
    public List < SelectOption > getNumberOfPreSlesResouce() {
        List < SelectOption > selectval = new List < SelectOption > ();
        selectval.add(new SelectOption('-None-', '-None-'));
        selectval.add(new SelectOption('1', '1'));
        selectval.add(new SelectOption('2', '2'));
        selectval.add(new SelectOption('3', '3'));
        
        return selectval;
        
        
    }
    
    public String cancellValue{set;get;}
    public boolean cancellApproveButton{set;get;}
    public boolean removeApproveButton{set;get;}
    
    public string cancelationReason{set;get;}
    
    
    public PreSalesEditController() {
        System.debug('----------------------------------Contractor');
        addpage = false;
        newpage = false;
        presale=new Presales_Request__c();
        comRecord=new PreSales_Comm__c();
        
        presalesId = ApexPages.currentPage().getParameters().get('id');
        cancellValue = ApexPages.currentPage().getParameters().get('cancelApprove');
        if(cancellValue=='true'){
            cancellApproveButton=true;
        }else{
            removeApproveButton=true;
        }
        if(presalesId!=null){
            presale = [select id,Action__c,Activity__c,Cancellation_Reason__c, CreatedById, PreSales_Commission__c,Removal_Reason1__c,Removal_Reason2__c,Removal_Reason3__c,Opportunity__c, Duration__c, Request_Status__c, Commission_BU__c, Start_Date__c, Number_of_PreSales_Resource__c, Presales_Resource1__c, Presales_Resource2__c, Presales_Resource3__c, Role1__c,
                       Role2__c, Role3__c, PreSales_Commission__r.Presales_Resource1__c, PreSales_Commission__r.Presales_Resource2__c, PreSales_Commission__r.Presales_Resource3__c, PreSales_Commission__r.Commission_Split1__c,
                       PreSales_Commission__r.Commission_Split2__c, PreSales_Commission__r.Commission_Split3__c,PreSales_Commission__r.Commission_BU__c from Presales_Request__c where id = : presalesId];
            
        }
        if(presale!=null){
            if(presale.Action__c=='New')
                newpage = true;
            if(presale.Action__c=='Add')
                addpage = true;
        }
        cancelationReason=presale.Cancellation_Reason__c;
        System.debug('------presale------' + presale);
        if(!String.isEmpty(presale.PreSales_Commission__c)){
            comRecord = [select id, Commission_BU__c, Commission_Split1__c, Commission_Split2__c, Commission_Split3__c, Presales_Resource1__c, Presales_Resource2__c, Presales_Resource3__c from PreSales_Comm__c where id = : presale.PreSales_Commission__c];
            
        }
        
        
        
    }
    
    
    public PageReference save() {
        Integer value = 0;
        // New Added logic
            
            if(commResorce1 == true && commResorce2 == false && commResorce3 == false){
                if(comRecord.Presales_Resource1__c!=null&&(comRecord.Commission_Split1__c==0||comRecord.Commission_Split1__c==null)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_1_Resource));
                    return null;
                }
            }
            
            if(commResorce1 == true && commResorce2 == true && commResorce3 == false){
                if((comRecord.Presales_Resource1__c!=null&&(comRecord.Commission_Split1__c==0||comRecord.Commission_Split1__c==null)) ||
                   (comRecord.Presales_Resource2__c!=null&&(comRecord.Commission_Split2__c==0||comRecord.Commission_Split2__c==null))){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_2_Resources));
                       return null;
                   }  
            }
            
            if(commResorce1 == true && commResorce2 == true && commResorce3 == true){
                if((comRecord.Presales_Resource1__c!=null&&(comRecord.Commission_Split1__c==0||comRecord.Commission_Split1__c==null)) ||
                   (comRecord.Presales_Resource2__c!=null&&(comRecord.Commission_Split2__c==0||comRecord.Commission_Split2__c==null)) ||
                   (comRecord.Presales_Resource3__c!=null&&(comRecord.Commission_Split3__c==0||comRecord.Commission_Split3__c==null))){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_3_Resources));
                       return null;
                   }  
            }
            
            
            //check for 1 resource
            
            if((comRecord.Presales_Resource1__c!=null&&comRecord.Presales_Resource2__c==null&&comRecord.Presales_Resource3__c==null)){
                if(comRecord.Commission_Split1__c==100){
                    value += Integer.valueOf(comRecord.Commission_Split1__c);
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_1_Resource));
                    return null;
                }
            }
            
            
            if((comRecord.Presales_Resource1__c==null&&comRecord.Presales_Resource2__c!=null&&comRecord.Presales_Resource3__c==null)){
                if(comRecord.Commission_Split2__c==100){
                    value += Integer.valueOf(comRecord.Commission_Split2__c);
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_1_Resource));
                    return null;
                }
            }
            
            if((comRecord.Presales_Resource1__c==null&&comRecord.Presales_Resource2__c==null&&comRecord.Presales_Resource3__c!=null)){
                if(comRecord.Commission_Split3__c==100){
                    value += Integer.valueOf(comRecord.Commission_Split3__c);
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_1_Resource));
                    return null;
                }
            }
            
            //check for 1 resource ends here
            
            //check for 2 resources
            
            if((comRecord.Presales_Resource1__c!=null&&comRecord.Presales_Resource2__c!=null&&comRecord.Presales_Resource3__c==null)){
                
                if(((comRecord.Commission_Split1__c==75&&comRecord.Commission_Split2__c==25)||(comRecord.Commission_Split1__c==50&&comRecord.Commission_Split2__c==50)||(comRecord.Commission_Split1__c==90&&comRecord.Commission_Split2__c==10)
                    || (comRecord.Commission_Split1__c==25&&comRecord.Commission_Split2__c==75) || (comRecord.Commission_Split1__c==10&&comRecord.Commission_Split2__c==90))){
                        value += Integer.valueOf(comRecord.Commission_Split1__c);
                        value += Integer.valueOf(comRecord.Commission_Split2__c); 
                    }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_2_Resources));
                    return null;
                }
                
            }
            
            if((comRecord.Presales_Resource1__c==null&&comRecord.Presales_Resource2__c!=null&&comRecord.Presales_Resource3__c!=null)){
                
                if(((comRecord.Commission_Split2__c==75&&comRecord.Commission_Split3__c==25)||(comRecord.Commission_Split2__c==50&&comRecord.Commission_Split3__c==50)||(comRecord.Commission_Split2__c==90&&comRecord.Commission_Split3__c==10)
                    || (comRecord.Commission_Split2__c==25&&comRecord.Commission_Split3__c==75) || (comRecord.Commission_Split2__c==10&&comRecord.Commission_Split3__c==90))){
                        value += Integer.valueOf(comRecord.Commission_Split2__c);
                        value += Integer.valueOf(comRecord.Commission_Split3__c); 
                    }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_2_Resources));
                    return null;
                }
                
            }
            
            if((comRecord.Presales_Resource1__c!=null&&comRecord.Presales_Resource2__c==null&&comRecord.Presales_Resource3__c!=null)){
                if(((comRecord.Commission_Split1__c==75&&comRecord.Commission_Split3__c==25)||(comRecord.Commission_Split1__c==50&&comRecord.Commission_Split3__c==50)||(comRecord.Commission_Split1__c==90&&comRecord.Commission_Split3__c==10)
                    || (comRecord.Commission_Split1__c==25&&comRecord.Commission_Split3__c==75) || (comRecord.Commission_Split1__c==10&&comRecord.Commission_Split3__c==90))){
                        value += Integer.valueOf(comRecord.Commission_Split1__c);
                        value += Integer.valueOf(comRecord.Commission_Split3__c); 
                    }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_2_Resources));
                return null;
            }
        }
        
        
        //check for 2 resources ends here
        
        //check for 3 resources starts here
        
        if((comRecord.Presales_Resource1__c!=null&&comRecord.Presales_Resource2__c!=null&&comRecord.Presales_Resource3__c!=null)){
            if((comRecord.Commission_Split1__c==33&&comRecord.Commission_Split2__c==33&&comRecord.Commission_Split3__c==33)||(comRecord.Commission_Split1__c==60&&comRecord.Commission_Split2__c==30&&comRecord.Commission_Split3__c==10)||(comRecord.Commission_Split1__c==60&&comRecord.Commission_Split2__c==10&&comRecord.Commission_Split3__c==30) || (comRecord.Commission_Split1__c==10&&comRecord.Commission_Split2__c==60&&comRecord.Commission_Split3__c==30)||(comRecord.Commission_Split1__c==10&&comRecord.Commission_Split2__c==30&&comRecord.Commission_Split3__c==60)|| (comRecord.Commission_Split1__c==30&&comRecord.Commission_Split2__c==60&&comRecord.Commission_Split3__c==10)||(comRecord.Commission_Split1__c==30&&comRecord.Commission_Split2__c==10&&comRecord.Commission_Split3__c==60) || (comRecord.Commission_Split1__c==50&&comRecord.Commission_Split2__c==25&&comRecord.Commission_Split3__c==25)||(comRecord.Commission_Split1__c==25&&comRecord.Commission_Split2__c==50&&comRecord.Commission_Split3__c==25) || (comRecord.Commission_Split1__c==25&&comRecord.Commission_Split2__c==25&&comRecord.Commission_Split3__c==50)){
                value += Integer.valueOf(comRecord.Commission_Split1__c);
                value += Integer.valueOf(comRecord.Commission_Split2__c); 
                value += Integer.valueOf(comRecord.Commission_Split3__c); 
                
                
                
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Commission_3_Resources));
                return null;
            }
        }
        
        
   
        
        
        if (presale != null) {
            presale.OwnerId = presale.CreatedById;
            if(presale.Action__c=='Remove'||presale.Action__c=='Add'||presale.Action__c=='New'){
                presale.Request_Status__c = 'Fulfilled';
                presale.RecordTypeId = Fulfilledrecordtypeid;
            }else if(presale.Action__c=='Cancel'){
                presale.Request_Status__c = 'Cancel';
                presale.RecordTypeId = cancelledrecordtypeid;
            }
            if(presale!=null)
               update presale;
            if(presale.Action__c=='Add'||presale.Action__c=='New'){
                eventCreation(presale);
                addOppteammember(presale);
            }
            
            if(oppteammember.size()>0){
                canDeletePresales = true;	//setting boolean to true to allow deletion of team member - US390579 - BAJPI01
                delete oppteammember; 
            }
        }
        
        if (comRecord != null) {
            update comRecord;
        }
        
        System.debug('-----------------------'+preSalId);
       
        
        PageReference pg = new PageReference('/' + presale.Id);
        pg.setRedirect(true);
        Return pg;
        
    }
    
    private void eventCreation(Presales_Request__c pre){
        Date dat=pre.Start_Date__c;        
        DateTime eventdate = DateTime.newInstance(dat.year(), dat.month(), dat.day()); 
          System.debug('-----------------dat'+dat);
          System.debug('-----------------pre.Start_Date__c'+pre.Start_Date__c);
          System.debug('-----------------dt'+eventdate);
         //New change for the start date
        if(pre!=null){    
            List<Event> listevent=[select ownerId,id,Type from Event where Presales_Request__c=:pre.id];
            Map<id,event> eveMap=new Map<id,event>();
            for(Event eve:listevent){
                eveMap.put(eve.OwnerId, eve);
                
            }
            List<Event> eventInsertList=new List<Event>();
            
            If(pre.Presales_Resource1__c!=null){
                if(!eveMap.containsKey(pre.Presales_Resource1__c)){
                    Event eve=new Event();
                    eve.OwnerId=pre.Presales_Resource1__c;
                    eve.Presales_Request__c=pre.id;
                    //eve.Duration_Hours__c=pre.Duration__c;
                    eve.DurationInMinutes=Integer.valueOf(pre.Duration__c*60);
                    eve.Event_Type__c=pre.Activity__c;
                    eve.RecordTypeId=RecordTypes_Setting__c.getValues('Presales_event_RecordType').RecordType_Id__c;
                    eve.WhatId=pre.Opportunity__c;
                    eve.StartDateTime=eventdate;                   //pre.Start_Date__c;
                    eventInsertList.add(eve) ;
                }
            }
            
            
            If(pre.Presales_Resource2__c!=null){
                if(!eveMap.containsKey(pre.Presales_Resource2__c)){
                    Event eve=new Event();
                    eve.OwnerId=pre.Presales_Resource2__c;
                     eve.Presales_Request__c=pre.id;
                    //eve.Duration_Hours__c=pre.Duration__c;
                    eve.DurationInMinutes=Integer.valueOf(pre.Duration__c*60);
                    eve.Event_Type__c=pre.Activity__c;
                    eve.RecordTypeId=RecordTypes_Setting__c.getValues('Presales_event_RecordType').RecordType_Id__c;
                    eve.WhatId=pre.Opportunity__c;
                    eve.StartDateTime=eventdate;             //pre.Start_Date__c;
                    eventInsertList.add(eve) ;
                }
            }
            
            
            If(pre.Presales_Resource3__c!=null){
                if(!eveMap.containsKey(pre.Presales_Resource3__c)){
                    Event eve=new Event();
                    eve.OwnerId=pre.Presales_Resource3__c;
                    eve.Presales_Request__c=pre.id;
                    eve.Event_Type__c=pre.Activity__c;
                    //eve.Duration_Hours__c=pre.Duration__c;
                    eve.RecordTypeId=RecordTypes_Setting__c.getValues('Presales_event_RecordType').RecordType_Id__c;
                    eve.DurationInMinutes=Integer.valueOf(pre.Duration__c*60);
                    eve.WhatId=pre.Opportunity__c;
                    eve.StartDateTime=eventdate;                 //pre.Start_Date__c;
                    eventInsertList.add(eve) ;
                }
            }
            
            
            if(eventInsertList.size()>0){
                insert   eventInsertList;
                
            } 
        }
        
        
        
    } 
    
    private void addOppteammember(Presales_Request__c pre){
        if(pre!=null) {
            List<OpportunityTeamMember> listTeamembers=[select id,UserId,TeamMemberRole,OpportunityId from OpportunityTeamMember where OpportunityId=:pre.Opportunity__c];
            Map<Id,OpportunityTeamMember> mapteam=new  Map<id,OpportunityTeamMember> ();
            for(OpportunityTeamMember mem:listTeamembers){
                mapteam.put(mem.UserId, mem);
                
            }
            List<OpportunityTeamMember> listTeam=new List<OpportunityTeamMember>();
            if(presale.Presales_Resource1__c!=null){
                if(!mapteam.containsKey(presale.Presales_Resource1__c)){
                    OpportunityTeamMember oppteam1=new OpportunityTeamMember();
                    oppteam1.CanAddPresales__c=true;
                    //oppteam1.CanDeletePreSales__c=true;
                    oppteam1.UserId =presale.Presales_Resource1__c;
                    oppteam1.OpportunityAccessLevel='Edit';
                    oppteam1.TeamMemberRole=presale.Role1__c;
                    oppteam1.OpportunityId=presale.Opportunity__c;
                    
                    listTeam.add(oppteam1); 
                    
                }
            }
            if(presale.Presales_Resource2__c!=null){
                if(!mapteam.containsKey(presale.Presales_Resource2__c)){
                    OpportunityTeamMember oppteam2=new OpportunityTeamMember();
                    oppteam2.CanAddPresales__c=true;
                    //oppteam2.CanDeletePreSales__c=true;
                    oppteam2.UserId =presale.Presales_Resource2__c;
                    oppteam2.OpportunityAccessLevel='Edit';
                    oppteam2.TeamMemberRole=presale.Role2__c;
                    oppteam2.OpportunityId=presale.Opportunity__c;
                    
                    listTeam.add(oppteam2); 
                    
                }
            }
            if(presale.Presales_Resource3__c!=null){
                if(!mapteam.containsKey(presale.Presales_Resource3__c)){
                    OpportunityTeamMember oppteam3=new OpportunityTeamMember();
                    oppteam3.CanAddPresales__c=true;
                    //oppteam3.CanDeletePreSales__c=true;
                    oppteam3.UserId =presale.Presales_Resource3__c;
                    oppteam3.OpportunityAccessLevel='Edit';
                    oppteam3.TeamMemberRole=presale.Role3__c;
                    oppteam3.OpportunityId=presale.Opportunity__c;
                    
                    listTeam.add(oppteam3); 
                    
                }
            } 
            if(listTeam.size()>0){
                Upsert listTeam; 
            }
        }    
        
    }
    public boolean resource1Readonly{set;get;}
    public boolean resource2Readonly{set;get;}
    public boolean resource3Readonly{set;get;}
    
    public void resorcesRenderingMethod() {
        
        
       if (numberofpresal == '-None-') {
            resourceSection1 = false;
            resourceSection2 = false;
            resourceSection3 = false;
            
        } else if (numberofpresal == '1') {
            
            resourceSection1 = true;
            resourceSection2 = false;
            resourceSection3 = false;
            
            resorceRequired1 = true;
            resorceRequired2 = false;
            resorceRequired3 = false;
    if(presale.Action__c=='Add'){
            if(presale.Presales_Resource1__c!=null){
              if(presale.Presales_Resource1__c==comRecord.Presales_Resource1__c||presale.Presales_Resource1__c==comRecord.Presales_Resource2__c||presale.Presales_Resource1__c==comRecord.Presales_Resource3__c)
                resource1Readonly=true; 
            }else {
                presale.Presales_Resource1__c=null;
                 presale.Role1__c=null;
                resorce_commission_Role_1 = true;
            }
    } else if(presale.Action__c=='New'){
      presale.Presales_Resource1__c=null;
            presale.Role1__c=null;
       resorce_commission_Role_1 = true;
      
    } 
            resorce_commission_Role_2 = false;
            resorce_commission_Role_3 = false;
            
            
        } else if (numberofpresal == '2') {
            resourceSection1 = true;
            resourceSection2 = true;
            resourceSection3 = false;
          if(presale.Action__c=='Add'){ 
            if(presale.Presales_Resource1__c!=null){
                if(presale.Presales_Resource1__c==comRecord.Presales_Resource1__c||presale.Presales_Resource1__c==comRecord.Presales_Resource2__c||presale.Presales_Resource1__c==comRecord.Presales_Resource3__c){
                     resource1Readonly=true;
                }
                else{
                presale.Presales_Resource1__c=null;
                presale.Role1__c=null;
                resorce_commission_Role_1 = true; 
                }
               
            }else {
                presale.Presales_Resource1__c=null;
                presale.Role1__c=null;
                resorce_commission_Role_1 = true;
            }
            
            if(presale.Presales_Resource2__c!=null){
               if(presale.Presales_Resource2__c==comRecord.Presales_Resource1__c||presale.Presales_Resource2__c==comRecord.Presales_Resource2__c||presale.Presales_Resource2__c==comRecord.Presales_Resource3__c){
                   System.debug('----------------enter'); 
                   resource2Readonly=true; 
                }else{
                presale.Presales_Resource2__c=null;
                presale.Role2__c=null;
                resorce_commission_Role_2 = true; 
                }
            }else {
                presale.Presales_Resource2__c=null;
                presale.Role2__c=null;
                resorce_commission_Role_2 = true;
            }
      } else if(presale.Action__c=='New'){
          presale.Presales_Resource1__c=null;
                  presale.Role1__c=null;
          presale.Presales_Resource2__c=null;
                  presale.Role2__c=null;
          resorce_commission_Role_1 = true;
        resorce_commission_Role_2 = true;
        
        
      } 
            resorceRequired1 = true;
            resorceRequired2 = true;
            resorceRequired3 = false;
            
            // resorce_commission_Role_1 = true;
            //resorce_commission_Role_2 = true;
            resorce_commission_Role_3 = false;                
            
            
        } else if (numberofpresal == '3') {
            resourceSection1 = true;
            resourceSection2 = true;
            resourceSection3 = true;
            
            resorceRequired1 = true;
            resorceRequired2 = true;
            resorceRequired3 = true;
     if(presale.Action__c=='Add'){  
         if(presale.Presales_Resource1__c!=null){
             if(presale.Presales_Resource1__c==comRecord.Presales_Resource1__c||presale.Presales_Resource1__c==comRecord.Presales_Resource2__c||presale.Presales_Resource1__c==comRecord.Presales_Resource3__c){
                 resource1Readonly=true;     
             }else{
                 presale.Presales_Resource1__c=null;
                presale.Role1__c=null;
                resorce_commission_Role_1 = true;   
             }
             

            }else {
                presale.Presales_Resource1__c=null;
                presale.Role1__c=null;
                resorce_commission_Role_1 = true;
            }
            
            if(presale.Presales_Resource2__c!=null){
               if(presale.Presales_Resource2__c==comRecord.Presales_Resource1__c||presale.Presales_Resource2__c==comRecord.Presales_Resource2__c||presale.Presales_Resource2__c==comRecord.Presales_Resource3__c){
                 resource2Readonly=true;     
             }else{
                 presale.Presales_Resource2__c=null;
                presale.Role2__c=null;
                resorce_commission_Role_2 = true;   
             }  
                
            }else {
                 presale.Presales_Resource2__c=null;
                presale.Role2__c=null;
                resorce_commission_Role_2 = true;
            }
            
            if(presale.Presales_Resource3__c!=null){
             if(presale.Presales_Resource3__c==comRecord.Presales_Resource1__c||presale.Presales_Resource3__c==comRecord.Presales_Resource2__c||presale.Presales_Resource3__c==comRecord.Presales_Resource3__c){
                 resource3Readonly=true;     
             }else{
                 presale.Presales_Resource3__c=null;
                presale.Role3__c=null;
                resorce_commission_Role_3 = true;   
             } 
            }else {
                 presale.Presales_Resource3__c=null;
                presale.Role3__c=null;
                resorce_commission_Role_3 = true;
            }
      }else if(presale.Action__c=='new'){
        presale.Presales_Resource1__c=null;
              presale.Role1__c=null;
        presale.Presales_Resource2__c=null;
              presale.Role2__c=null;
        presale.Presales_Resource3__c=null;
              presale.Role3__c=null;
        resorce_commission_Role_1 = true;
        resorce_commission_Role_2 = true;
        resorce_commission_Role_3 = true;
        
        
        
      }               
            //resorce_commission_Role_1 = true;
            //resorce_commission_Role_2 = true;
            //resorce_commission_Role_3 = true;
            
            
        }
        
        
        
    
        
        
    }
    
    public void preSalesResourceInform() {
        resorcesRenderingMethod();
        
    }
    
    
    
    
    
    public PageReference approveResource() {
        
        if(numberofpresal!='-None-'){
            if (numberofpresal == '1') {
                if (presale.Presales_Resource1__c == null) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_First_Resource_Null));
                    return null;
                }
            }
            
            if (numberofpresal == '2') {
                if (presale.Presales_Resource1__c == null || presale.Presales_Resource2__c == null) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Second_Resource_Null));
                    return null;
                }else if(presale.Presales_Resource1__c ==presale.Presales_Resource2__c){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Same_Resource_Multiple_Times));
                    return null;  
                    
                }
            }
            if (numberofpresal == '3') {
                if (presale.Presales_Resource1__c == null || presale.Presales_Resource2__c == null || presale.Presales_Resource3__c == null) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Third_Resource_Null));
                    return null;
                }else if(presale.Presales_Resource1__c ==presale.Presales_Resource2__c||presale.Presales_Resource1__c ==presale.Presales_Resource3__c||presale.Presales_Resource2__c ==presale.Presales_Resource3__c){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Same_Resource_Multiple_Times));
                    return null;  
                    
                }
            }
            
            
            if (presale.Presales_Resource1__c != null && presale.Role1__c == null) {
                system.debug('entered role 1');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Role_Blank));
                return null;
            }
            
            if (presale.Presales_Resource2__c != null && presale.Role2__c == null) {
                system.debug('entered role 2');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Role_Blank));
                return null;
            }
            
            if (presale.Presales_Resource3__c != null && presale.Role3__c == null) {
                system.debug('entered role 3');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Role_Blank));
                return null;
            }
            
            
            if (numberofpresal == '1') {
                
                if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c==null && comRecord.Presales_Resource3__c==null){
                    comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                }
                else{
                    if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c==null && comRecord.Presales_Resource3__c==null){
                        if(comRecord.Presales_Resource1__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                        }
                        else{
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c!=null && comRecord.Presales_Resource3__c==null){
                        if(comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                        }
                        else{
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c==null && comRecord.Presales_Resource3__c!=null){
                        if(comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else{
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c!=null && comRecord.Presales_Resource3__c==null){
                        if(comRecord.Presales_Resource1__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource1__c != presale.Presales_Resource1__c && comRecord.Presales_Resource2__c != presale.Presales_Resource1__c){
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c==null && comRecord.Presales_Resource3__c!=null){
                        if(comRecord.Presales_Resource1__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource1__c != presale.Presales_Resource1__c && comRecord.Presales_Resource3__c != presale.Presales_Resource1__c){
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c!=null && comRecord.Presales_Resource3__c!=null){
                        if(comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource2__c != presale.Presales_Resource1__c && comRecord.Presales_Resource3__c != presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c!=null && comRecord.Presales_Resource3__c!=null){
                        if(comRecord.Presales_Resource1__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                            return null;
                        }
                    }
                }
            }
            
            if (numberofpresal == '2') {
                
                if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c==null){
                    comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                    comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                }
                else{
                    if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c==null){
                        if(comRecord.Presales_Resource1__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                        }   
                        else if(comRecord.Presales_Resource1__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource3__c==null){
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource3__c!=null){
                            if(comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                                comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                                comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                            }
                            else if(comRecord.Presales_Resource3__c == presale.Presales_Resource2__c){
                                comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                                comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                            }
                            else{
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                                return null;
                            }
                        }
                    }
                    else if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c!=null){
                        if(comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                        }   
                        else if(comRecord.Presales_Resource2__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource3__c==null){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource3__c!=null){
                            if(comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                                comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                                comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                            }
                            else if(comRecord.Presales_Resource3__c == presale.Presales_Resource2__c){
                                comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                                comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                            }
                            else{
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                                return null;
                            }
                        }
                    }
                    else if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c!=null){
                        if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c && comRecord.Presales_Resource2__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c && comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c && comRecord.Presales_Resource2__c != presale.Presales_Resource2__c){
                            if(comRecord.Presales_Resource3__c==null){
                                comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                                comRecord.Presales_Resource3__c = presale.Presales_Resource2__c; 
                            }
                            else{
                                if(comRecord.Presales_Resource3__c==presale.Presales_Resource2__c){
                                    comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                                    comRecord.Presales_Resource3__c = presale.Presales_Resource2__c; 
                                }
                                else{
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                                    return null;
                                }
                            }
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c && comRecord.Presales_Resource2__c != presale.Presales_Resource1__c){
                            if(comRecord.Presales_Resource3__c==null){
                                comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                                comRecord.Presales_Resource3__c = presale.Presales_Resource1__c; 
                            }
                            else{
                                if(comRecord.Presales_Resource3__c==presale.Presales_Resource1__c){
                                    comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                                    comRecord.Presales_Resource3__c = presale.Presales_Resource1__c; 
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                                    return null;
                                }
                            }
                        }
                        else if(comRecord.Presales_Resource1__c!=presale.Presales_Resource1__c && comRecord.Presales_Resource2__c == presale.Presales_Resource2__c){
                            if(comRecord.Presales_Resource3__c==null){
                                comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                                comRecord.Presales_Resource3__c = presale.Presales_Resource1__c; 
                            }
                            else{
                                if(comRecord.Presales_Resource3__c==presale.Presales_Resource1__c){
                                    comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                                    comRecord.Presales_Resource3__c = presale.Presales_Resource1__c; 
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                                    return null;
                                }
                            }
                        }
                        else if(comRecord.Presales_Resource1__c!=presale.Presales_Resource2__c && comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            if(comRecord.Presales_Resource3__c==null){
                                comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                                comRecord.Presales_Resource3__c = presale.Presales_Resource2__c; 
                            }
                            else{
                                if(comRecord.Presales_Resource3__c==presale.Presales_Resource2__c){
                                    comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                                    comRecord.Presales_Resource3__c = presale.Presales_Resource2__c; 
                                }
                                else{
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                                    return null;
                                }
                            }
                        }
                        else if((comRecord.Presales_Resource1__c!=presale.Presales_Resource1__c && comRecord.Presales_Resource2__c != presale.Presales_Resource2__c)
                                ||(comRecord.Presales_Resource1__c!=presale.Presales_Resource2__c && comRecord.Presales_Resource2__c != presale.Presales_Resource1__c) ){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                                    return null;
                                }
                    }
                }
                
                
                
                
                
            }
            if (numberofpresal == '3') {
                if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c == null && comRecord.Presales_Resource3__c == null){
                    comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                    comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                    comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                }
                else{
          system.debug('entered 3 resources');
            if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c == null && comRecord.Presales_Resource3__c == null){
              if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
              }
              else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
              }
              else if(comRecord.Presales_Resource1__c==presale.Presales_Resource3__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
              }
              else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                return null;
              }
            }
            else if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c != null && comRecord.Presales_Resource3__c == null){
              if(comRecord.Presales_Resource2__c==presale.Presales_Resource1__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
              }
              else if(comRecord.Presales_Resource2__c==presale.Presales_Resource2__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
              }
              else if(comRecord.Presales_Resource2__c==presale.Presales_Resource3__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
              }
              else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                return null;
              }
            }
            else if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c == null && comRecord.Presales_Resource3__c != null){
              if(comRecord.Presales_Resource3__c==presale.Presales_Resource1__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
              }
              else if(comRecord.Presales_Resource3__c==presale.Presales_Resource2__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
              }
              else if(comRecord.Presales_Resource3__c==presale.Presales_Resource3__c){
                comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
              }
              else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                return null;
              }
            }
            else if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c != null && comRecord.Presales_Resource3__c == null){
                        if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c && comRecord.Presales_Resource2__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c && comRecord.Presales_Resource2__c == presale.Presales_Resource3__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c && comRecord.Presales_Resource2__c == presale.Presales_Resource3__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource3__c && comRecord.Presales_Resource2__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource3__c && comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c && comRecord.Presales_Resource2__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                        }
                        else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                            return null;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c == null && comRecord.Presales_Resource3__c != null){
                        if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c && comRecord.Presales_Resource3__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c && comRecord.Presales_Resource3__c == presale.Presales_Resource3__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c && comRecord.Presales_Resource3__c == presale.Presales_Resource3__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource3__c && comRecord.Presales_Resource3__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource3__c && comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c && comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                            return null;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c==null && comRecord.Presales_Resource2__c != null && comRecord.Presales_Resource3__c != null){
                        if(comRecord.Presales_Resource2__c==presale.Presales_Resource1__c && comRecord.Presales_Resource3__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource2__c==presale.Presales_Resource1__c && comRecord.Presales_Resource3__c == presale.Presales_Resource3__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                        }
                        else if(comRecord.Presales_Resource2__c==presale.Presales_Resource2__c && comRecord.Presales_Resource3__c == presale.Presales_Resource3__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                        }
                        else if(comRecord.Presales_Resource2__c==presale.Presales_Resource3__c && comRecord.Presales_Resource3__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource2__c==presale.Presales_Resource3__c && comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource2__c==presale.Presales_Resource2__c && comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                            return null;
                        }
                    }
                    else if(comRecord.Presales_Resource1__c!=null && comRecord.Presales_Resource2__c != null && comRecord.Presales_Resource3__c != null){
            
                        if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c && comRecord.Presales_Resource2__c == presale.Presales_Resource2__c && comRecord.Presales_Resource3__c == presale.Presales_Resource3__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource1__c && comRecord.Presales_Resource2__c == presale.Presales_Resource3__c && comRecord.Presales_Resource3__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c && comRecord.Presales_Resource2__c == presale.Presales_Resource1__c && comRecord.Presales_Resource3__c == presale.Presales_Resource3__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource3__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource2__c && comRecord.Presales_Resource2__c == presale.Presales_Resource3__c && comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource3__c && comRecord.Presales_Resource2__c == presale.Presales_Resource1__c && comRecord.Presales_Resource3__c == presale.Presales_Resource2__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource1__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource2__c;
                        }
                        else if(comRecord.Presales_Resource1__c==presale.Presales_Resource3__c && comRecord.Presales_Resource2__c == presale.Presales_Resource2__c && comRecord.Presales_Resource3__c == presale.Presales_Resource1__c){
                            comRecord.Presales_Resource1__c = presale.Presales_Resource3__c;
                            comRecord.Presales_Resource2__c = presale.Presales_Resource2__c;
                            comRecord.Presales_Resource3__c = presale.Presales_Resource1__c;
                        }
                        else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Max_3_Per_CBU));
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Pre_Sales_Resources_Maxed_Out));
                            return null;
                        }
                    }
                }
                
                
            }
            
            if(comRecord.Presales_Resource1__c!=null)
                commResorce1 = true;
            else
                commResorce1 = false;
            if(comRecord.Presales_Resource2__c!=null)
                commResorce2 = true;
            else
                commResorce2 = false;
            if(comRecord.Presales_Resource3__c!=null)
                commResorce3 = true;
            else
                commResorce3 = false;
            
            
            if((commResorce1 == true && commResorce2 == false && commResorce3 == false)||(commResorce1 == false && commResorce2 == true && commResorce3 == false)
               || (commResorce1 == false && commResorce2 == false && commResorce3 == true)){
                   ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_1_Resource));
               }
            else if((commResorce1 == true && commResorce2 == true && commResorce3 == false)||(commResorce1 == true && commResorce2 == false && commResorce3 == true)
                    || (commResorce1 == false && commResorce2 == true && commResorce3 == true)){
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_2_Resources));
                    }
            else if(commResorce1 == true && commResorce2 == true && commResorce3 == true)
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_3_Resources));
            
            PageReference pg = new PageReference('/apex/CommissionPage?id=' + presale.Id);
            pg.setRedirect(false);
            Return pg;
        }
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please select the number of presales resources first, to proceed further.'));
            return null;
        }
        
        
    }
    
    public PageReference rejectedRequest() {
        presale.Request_Status__c = 'Rejected';
        presale.OwnerId = presale.CreatedById;
        presale.RecordTypeId = Fulfilledrecordtypeid;
        update presale;
        PageReference pg = new PageReference('/' + presale.Id);
        pg.setRedirect(true);
        Return pg;
        
        
    }
    
    public PageReference removeResource() {
        commResorce1 = false;
        commResorce2 = false;
        commResorce3 = false;
        Map < Id, Presales_Request__c > presalesreqopp = new Map < id, Presales_Request__c > ([select Activity__c,Removal_Reason1__c,Removal_Reason2__c,Removal_Reason3__c, Opportunity__c, Duration__c, Request_Status__c, Commission_BU__c, Start_Date__c, Number_of_PreSales_Resource__c, Presales_Resource1__c, Presales_Resource2__c, Presales_Resource3__c, Role1__c,
                                                                                               Role2__c, Role3__c, PreSales_Commission__r.Presales_Resource1__c, PreSales_Commission__r.Presales_Resource2__c, PreSales_Commission__r.Presales_Resource3__c, PreSales_Commission__r.Commission_Split1__c,
                                                                                               PreSales_Commission__r.Commission_Split2__c, PreSales_Commission__r.Commission_Split3__c from Presales_Request__c where Opportunity__c = : presale.Opportunity__c and id!=:presalesId]);
        
        
        Map < string, List<Presales_Request__c >> CBUandpresalesMap = new Map < string, List<Presales_Request__c >> ();
        
        for (Presales_Request__c preRes: presalesreqopp.values()) {
            if(CBUandpresalesMap.containsKey(preRes.Commission_BU__c)){
                List<Presales_Request__c> presaleslist = CBUandpresalesMap.get(preRes.Commission_BU__c);
                presaleslist.add(preRes);
                CBUandpresalesMap.put(preRes.Commission_BU__c,presaleslist);
            }
            else{
                List<Presales_Request__c> presaleslist = new List<Presales_Request__c>();
                presaleslist.add(preRes);
                CBUandpresalesMap.put(preRes.Commission_BU__c,presaleslist);
            }
        }
        system.debug('---cbu map size----'+CBUandpresalesMap);
        Map<string,id> resourceCBUmap=new Map<string,id>();
        if(!String.isEmpty(presale.Removal_Reason1__c)){
            resourceCBUmap.put(presale.Presales_Resource1__c, presale.PreSales_Commission__c);
        }
        if(!String.isEmpty(presale.Removal_Reason2__c)){
            resourceCBUmap.put(presale.Presales_Resource2__c,presale.PreSales_Commission__c);
        }
        if(!String.isEmpty(presale.Removal_Reason3__c)){
            resourceCBUmap.put(presale.Presales_Resource3__c,presale.PreSales_Commission__c);
        }
        system.debug('---cbu map size----'+resourceCBUmap);
        Map<Id,Presales_Request__c> resourcepresalesmap=new  Map<Id,Presales_Request__c>();
        if(CBUandpresalesMap.size()>0&&CBUandpresalesMap.get(presale.Commission_BU__c)!=null){
            for(Presales_Request__c pre:CBUandpresalesMap.get(presale.Commission_BU__c)){
                if(pre.Presales_Resource1__c!=null){
                    resourcepresalesmap.put(pre.Presales_Resource1__c,pre);
                    
                }
                if(pre.Presales_Resource2__c!=null){
                    resourcepresalesmap.put(pre.Presales_Resource2__c,pre);
                    
                    
                    
                }
                if(pre.Presales_Resource3__c!=null){
                    resourcepresalesmap.put(pre.Presales_Resource3__c,pre);
                    
                    
                    
                }
                
                
            }
            Map<String,Boolean> resourceexistsornotmap = new Map<String,Boolean>();
            
            for(string puser:resourceCBUmap.keySet()){
                
                if(!resourcepresalesmap.ContainsKey(puser)){
                    resourceexistsornotmap.put(puser,false);
                    
                    
                }
                else{
                    resourceexistsornotmap.put(puser,true);
                }
            }
            system.debug('---cbu map size----'+resourceexistsornotmap);    
            
            for(String resource:resourceexistsornotmap.keyset()){
                Boolean flag= resourceexistsornotmap.get(resource);
                if(presale.PreSales_Commission__r.Presales_Resource1__c!=null && resource!=null){
                    if(presale.PreSales_Commission__r.Presales_Resource1__c==resource && flag==false){
                        preSalId.add(comRecord.Presales_Resource1__c);
                        comRecord.Presales_Resource1__c = null;
                        comRecord.Commission_Split1__c = 0;
                    }
                }
                if(presale.PreSales_Commission__r.Presales_Resource2__c!=null && resource!=null){
                    if(presale.PreSales_Commission__r.Presales_Resource2__c==resource && flag==false){
                        preSalId.add(comRecord.Presales_Resource2__c);
                        comRecord.Presales_Resource2__c = null;
                        comRecord.Commission_Split2__c = 0;
                    }
                }
                if(presale.PreSales_Commission__r.Presales_Resource3__c!=null && resource!=null){
                    if(presale.PreSales_Commission__r.Presales_Resource3__c==resource && flag==false){
                        system.debug('removing salman');
                        preSalId.add(comRecord.Presales_Resource3__c);
                        comRecord.Presales_Resource3__c = null;
                        comRecord.Commission_Split3__c = 0;
                    }
                }
                
                if(presale.Presales_Resource1__c==resource){
                    presale.Presales_Resource1__c=null;
                    presale.Role1__c=null;
                    
                }
                if(presale.Presales_Resource2__c==resource){
                    presale.Presales_Resource2__c=null;
                    presale.Role2__c=null;
                    
                }
                if(presale.Presales_Resource3__c==resource){
                    presale.Presales_Resource3__c=null;
                    presale.Role3__c=null;
                    
                }
                
            }
        }
        else{
            if(!String.isEmpty(presale.Removal_Reason1__c)){
                if(comRecord.Presales_Resource1__c ==presale.Presales_Resource1__c){
                     preSalId.add(comRecord.Presales_Resource1__c);
                    comRecord.Presales_Resource1__c=null;
                    comRecord.Commission_Split1__c = 0;
                }else if(comRecord.Presales_Resource2__c ==presale.Presales_Resource1__c){
                      preSalId.add(comRecord.Presales_Resource2__c);
                    comRecord.Presales_Resource2__c=null;
                    comRecord.Commission_Split2__c = 0;
                }else if(comRecord.Presales_Resource3__c ==presale.Presales_Resource1__c){
                     preSalId.add(comRecord.Presales_Resource3__c);
                    comRecord.Presales_Resource3__c=null;
                    comRecord.Commission_Split3__c = 0;
                }
                presale.Presales_Resource1__c=null;
                presale.Role1__c=null;
                
            } 
            if(!String.isEmpty(presale.Removal_Reason2__c)){
                if(comRecord.Presales_Resource1__c ==presale.Presales_Resource2__c){
                    preSalId.add(comRecord.Presales_Resource1__c);
                    comRecord.Presales_Resource1__c=null;
                    comRecord.Commission_Split1__c = 0;
                }else if(comRecord.Presales_Resource2__c ==presale.Presales_Resource2__c){
                     preSalId.add(comRecord.Presales_Resource2__c);
                    comRecord.Presales_Resource2__c=null;
                    comRecord.Commission_Split2__c = 0;
                }else if(comRecord.Presales_Resource3__c ==presale.Presales_Resource2__c){
                   preSalId.add(comRecord.Presales_Resource3__c);
                    comRecord.Presales_Resource3__c=null;
                    comRecord.Commission_Split3__c = 0;
                }
                presale.Presales_Resource2__c=null;
                presale.Role2__c=null; 
            } 
            
            if(!String.isEmpty(presale.Removal_Reason3__c)){
                if(comRecord.Presales_Resource1__c ==presale.Presales_Resource3__c){
                      preSalId.add(comRecord.Presales_Resource1__c);
                    comRecord.Presales_Resource1__c=null;
                    comRecord.Commission_Split1__c = 0;
                }else if(comRecord.Presales_Resource2__c ==presale.Presales_Resource3__c){
                   preSalId.add(comRecord.Presales_Resource2__c);
                    comRecord.Presales_Resource2__c=null;
                    comRecord.Commission_Split2__c = 0;
                    //commResorce2=false;
                }else if(comRecord.Presales_Resource3__c ==presale.Presales_Resource3__c){
                   preSalId.add(comRecord.Presales_Resource3__c);
                    comRecord.Presales_Resource3__c=null;
                    comRecord.Commission_Split3__c = 0;
                }
                presale.Presales_Resource3__c=null;
                presale.Role3__c=null; 
            } 
            
        }
        system.debug('---cbu map size----'+resourcepresalesmap);
        
        
        system.debug('--pre sales comm---'+presale);
        
        
        System.debug('---------------------------+remove1');
        
        System.debug('---------------------------+remove2');
        
        oppteammember=[select id,UserId,TeamMemberRole,OpportunityId from OpportunityTeamMember where OpportunityId=:presale.Opportunity__c And UserId=:preSalId];
       
        // update comRecord;
        
        
        // update presale;
        
        if(comRecord.Presales_Resource1__c!=null)
            commResorce1 = true;
        else
            commResorce1 = false;
        if(comRecord.Presales_Resource2__c!=null)
            commResorce2 = true;
        else
            commResorce3 = false;
        if(comRecord.Presales_Resource3__c!=null)
            commResorce3 = true;
        else
            commResorce3 = false;
        
        
        if((commResorce1 == true && commResorce2 == false && commResorce3 == false)||(commResorce1 == false && commResorce2 == true && commResorce3 == false)
           || (commResorce1 == false && commResorce2 == false && commResorce3 == true)){
               ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_1_Resource));
           }
        else if((commResorce1 == true && commResorce2 == true && commResorce3 == false)||(commResorce1 == true && commResorce2 == false && commResorce3 == true)
                || (commResorce1 == false && commResorce2 == true && commResorce3 == true)){
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_2_Resources));
                }
        else if(commResorce1 == true && commResorce2 == true && commResorce3 == true)
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_3_Resources));
        else if(commResorce1 == false && commResorce2 == false && commResorce3 == false){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_No_Resource));
        }
        
        PageReference pg = new PageReference('/apex/CommissionPage?id=' + presale.Id);
        pg.setRedirect(false);
        Return pg;
        
        
    }
    
    public PageReference cancellationRequest(){
        commResorce1 = false;
        commResorce2 = false;
        commResorce3 = false;
        if(cancelationReason!=null){
            
            
            Map < Id, Presales_Request__c > presalesreqopp = new Map < id, Presales_Request__c > ([select Activity__c,Removal_Reason1__c,Removal_Reason2__c,Removal_Reason3__c, Opportunity__c, Duration__c, Request_Status__c, Commission_BU__c, Start_Date__c, Number_of_PreSales_Resource__c, Presales_Resource1__c, Presales_Resource2__c, Presales_Resource3__c, Role1__c,
                                                                                                   Role2__c, Role3__c, PreSales_Commission__r.Presales_Resource1__c, PreSales_Commission__r.Presales_Resource2__c, PreSales_Commission__r.Presales_Resource3__c, PreSales_Commission__r.Commission_Split1__c,
                                                                                                   PreSales_Commission__r.Commission_Split2__c, PreSales_Commission__r.Commission_Split3__c from Presales_Request__c where Opportunity__c = : presale.Opportunity__c and id!=:presalesId]);
            
            
            Map < string, List<Presales_Request__c >> CBUandpresalesMap = new Map < string, List<Presales_Request__c >> ();
            
            Set < id > preSalId = new Set < id > ();
            Set < id > teamId = new Set < id > ();
            
            for (Presales_Request__c preRes: presalesreqopp.values()) {
                if(CBUandpresalesMap.containsKey(preRes.Commission_BU__c)){
                    List<Presales_Request__c> presaleslist = CBUandpresalesMap.get(preRes.Commission_BU__c);
                    presaleslist.add(preRes);
                    CBUandpresalesMap.put(preRes.Commission_BU__c,presaleslist);
                }
                else{
                    List<Presales_Request__c> presaleslist = new List<Presales_Request__c>();
                    presaleslist.add(preRes);
                    CBUandpresalesMap.put(preRes.Commission_BU__c,presaleslist);
                }
            }
            System.debug('---------------------------+remove1'); 
            Map<Id,Presales_Request__c> resourcepresalesmap=new  Map<Id,Presales_Request__c>();
            if(CBUandpresalesMap.size()>0&&CBUandpresalesMap.get(presale.Commission_BU__c)!=null){
                                System.debug('--------------------CBUandpresalesMap'+CBUandpresalesMap);
                System.debug('--------------------CBUandpresalesMap1'+CBUandpresalesMap.get(presale.Commission_BU__c));
                for(Presales_Request__c pre:CBUandpresalesMap.get(presale.Commission_BU__c)){
                    if(pre.Presales_Resource1__c!=null){
                        resourcepresalesmap.put(pre.Presales_Resource1__c,pre);      
                    }
                    if(pre.Presales_Resource2__c!=null){
                        resourcepresalesmap.put(pre.Presales_Resource2__c,pre);               
                    }
                    if(pre.Presales_Resource3__c!=null){
                        resourcepresalesmap.put(pre.Presales_Resource3__c,pre);              
                        
                    }
                } 
                Map<string,id> resourceCBUmap=new Map<string,id>();
                resourceCBUmap.put(presale.Presales_Resource1__c, presale.PreSales_Commission__c);
                resourceCBUmap.put(presale.Presales_Resource2__c,presale.PreSales_Commission__c);
                resourceCBUmap.put(presale.Presales_Resource3__c,presale.PreSales_Commission__c);
                Map<String,Boolean> resourceexistsornotmap = new Map<String,Boolean>();
                
                for(string puser:resourceCBUmap.keySet()){
                    
                    if(!resourcepresalesmap.ContainsKey(puser)){
                        resourceexistsornotmap.put(puser,false);
                        
                        
                    }
                    else{
                        resourceexistsornotmap.put(puser,true);
                    }
                }
                system.debug('---cbu map size----'+resourceexistsornotmap);    
                
                for(String resource:resourceexistsornotmap.keyset()){
                    Boolean flag= resourceexistsornotmap.get(resource);
                    if(presale.PreSales_Commission__r.Presales_Resource1__c!=null && resource!=null){
                        if(presale.PreSales_Commission__r.Presales_Resource1__c==resource && flag==false){
                            preSalId.add(comRecord.Presales_Resource1__c);
                            comRecord.Presales_Resource1__c = null;
                            comRecord.Commission_Split1__c = 0;
                        }
                    }
                    if(presale.PreSales_Commission__r.Presales_Resource2__c!=null && resource!=null){
                        if(presale.PreSales_Commission__r.Presales_Resource2__c==resource && flag==false){
                            preSalId.add(comRecord.Presales_Resource2__c);
                            comRecord.Presales_Resource2__c = null;
                            comRecord.Commission_Split2__c = 0;
                        }
                    }
                    if(presale.PreSales_Commission__r.Presales_Resource3__c!=null && resource!=null){
                        if(presale.PreSales_Commission__r.Presales_Resource3__c==resource && flag==false){
                            system.debug('removing salman');
                            preSalId.add(comRecord.Presales_Resource3__c);
                            comRecord.Presales_Resource3__c = null;
                            comRecord.Commission_Split3__c = 0;
                            break;
                        }
                    }
                    
                    if(presale.Presales_Resource1__c==resource){
                        presale.Presales_Resource1__c=null;
                        presale.Role1__c=null;
                        
                    }
                    if(presale.Presales_Resource2__c==resource){
                        presale.Presales_Resource2__c=null;
                        presale.Role2__c=null;
                        
                    }
                    if(presale.Presales_Resource3__c==resource){
                        presale.Presales_Resource3__c=null;
                        presale.Role3__c=null;
                        
                    }
                    
                }
                
                
                
            }else{
                
                comRecord.Presales_Resource1__c=null;
                preSalId.add(comRecord.Presales_Resource1__c);
                comRecord.Commission_Split1__c = 0;
                comRecord.Presales_Resource2__c=null;
                preSalId.add(comRecord.Presales_Resource2__c);
                comRecord.Commission_Split2__c = 0;
                preSalId.add(comRecord.Presales_Resource3__c);
                comRecord.Presales_Resource3__c=null;
                comRecord.Commission_Split3__c = 0; 
                presale.Presales_Resource1__c=null;
                presale.Role1__c =null;
                presale.Presales_Resource2__c=null;
                presale.Role2__c = null;
                presale.Presales_Resource3__c=null;
                presale.Role3__c = null;
                
            }
            
            
            oppteammember=[select id,UserId,TeamMemberRole,OpportunityId from OpportunityTeamMember where OpportunityId=:presale.Opportunity__c And UserId=:preSalId];       
            
        }
        
        
        if(comRecord.Presales_Resource1__c!=null)
            commResorce1 = true;
        else
            commResorce1 = false;
        if(comRecord.Presales_Resource2__c!=null)
            commResorce2 = true;
        else
            commResorce3 = false;
        if(comRecord.Presales_Resource3__c!=null)
            commResorce3 = true;
        else
            commResorce3 = false;
        
        system.debug('------1------'+commResorce1);
        system.debug('------2------'+commResorce2);
        system.debug('------3------'+commResorce3);
        
        if((commResorce1 == true && commResorce2 == false && commResorce3 == false)||(commResorce1 == false && commResorce2 == true && commResorce3 == false)
           || (commResorce1 == false && commResorce2 == false && commResorce3 == true)){
               ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_1_Resource));
           }
        else if((commResorce1 == true && commResorce2 == true && commResorce3 == false)||(commResorce1 == true && commResorce2 == false && commResorce3 == true)
                || (commResorce1 == false && commResorce2 == true && commResorce3 == true)){
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_2_Resources));
                }
        else if(commResorce1 == true && commResorce2 == true && commResorce3 == true)
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_3_Resources));
        else if(commResorce1 == false && commResorce2 == false && commResorce3 == false){
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.Pre_Sales_Commission_No_Resource));
        }
        
        
        PageReference pg = new PageReference('/apex/CommissionPage?id=' + presale.Id);
        pg.setRedirect(false);
        Return pg;
        
        
    }
    
}