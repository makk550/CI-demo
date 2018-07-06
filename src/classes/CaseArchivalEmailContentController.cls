public class CaseArchivalEmailContentController{
    public static List<string> headerlist{get;set;}
    public Static String sourceName{get;set;}
    public static String emailContentURL{get;set;}
    public static String source{get;set;}
    public string ArchivedSectionCheck{get;set;}
    public string username{get;set;}
    public String daylightSaving;
    public Boolean showBlock{get;set;}
    public String outputString{get;set;}
    public List<wrapperrelatedlistvariablevalues> Casebasicdetails{get;set;}
    public wrapperrelatedlistvariablevalues CaseBasicSectionValues{get;set;}
    public List<wrapperrelatedlistblock> relatedlists{get;set;}
    public Static List<wrapperrelatedlistblock> getWrapperValues{get;set;}
    public static wrapperrelatedlistblock relatedWrapperClassObject;
    public String attachmentURL{get;set;}
    
    public CaseArchivalEmailContentController(){
        showBlock = false;
        CaseBasicSectionValues= new wrapperrelatedlistvariablevalues();    
        Casebasicdetails=new List<wrapperrelatedlistvariablevalues>();
        headerlist = new List<string>();        
        relatedlists=new List<wrapperrelatedlistblock>();
        
        User currentUser;
        if(!Test.isRunningTest()){
            User logginedInUser = [select FederationIdentifier from User where id=:UserInfo.getUserId()];
            String federationIdValue = logginedInUser.FederationIdentifier<>null?logginedInUser.FederationIdentifier.remove('-cc'):'';
            system.debug(federationIdValue+'@@@@@'+logginedInUser.FederationIdentifier);
            if(String.isNotBlank(federationIdValue)){
                currentUser = [Select profileId,TimeZoneSidKey,firstName,lastName from User where profile.name<>:System.Label.AWS_CommunityProfileName AND Username LIKE:federationIdValue+'%' AND IsActive=:true limit 1];
                String boxNameValue = federationIdValue.substringAfter('.');
                system.debug('####currentUser###'+currentUser);
            }
        }else{
            currentUser = [Select profileId,TimeZoneSidKey,firstName,lastName from User where profile.name<>:System.Label.AWS_CommunityProfileName AND lastName=:'Sharma' limit 1];
        }
        if(currentUser<>null && currentUser.TimeZoneSidKey<>null){
            username=currentUser.firstname+' '+currentUser.lastname;
            Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getdescribe();
            List<Schema.PicklistEntry> picklistObj = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry pickOneFormat:picklistObj){
                if(currentUser.TimeZoneSidKey==pickOneFormat.getValue()){
                    daylightSaving = pickOneFormat.getlabel();
                }
            }
        }
        
        emailContentURL = apexpages.currentpage().getparameters().get('Eid')<>null?apexpages.currentpage().getparameters().get('Eid'):'';
        sourceName = apexpages.currentpage().getparameters().get('source')<>null?apexpages.currentpage().getparameters().get('source'):'';
        system.debug('#!#!@!@!@!'+emailContentURL);
        
        if(String.isNotBlank(emailContentURL) && String.isNotBlank(sourceName)){
            if(sourceName.equalsIgnoreCase('star')){
                source = sourceName.touppercase(); 
            }else{
                source = sourceName.touppercase()+ ' Service Cloud';
            }
            save(emailContentURL);   
        }else{
            ApexPages.Message errorMsg;
            if(String.isNotBlank(emailContentURL) && String.isBlank(sourceName)){
                errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'The URL does not contains <b>Source Name</b>');
            }else if(String.isBlank(emailContentURL) && String.isNotBlank(sourceName)){
                errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'The URL does not contains <b>Email Content Link</b>');
            }else{
                errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'The URL does not contains <b>Source Name</b> and <b>Email Content Link</b>');
            }
            ApexPages.addmessage(errorMsg);
        }
    }
    
    public PageReference save(String emailURL){
       showBlock = true;
       Dom.XMLNode ordDtls = retrieveXMLDetails(emailURL);
       
       for(DOM.XMLNode xmlnodeobj:ordDtls.getChildElements()){
           findChild(xmlnodeobj);
        }
        return null;
    }
    
    private Dom.XMLNode retrieveXMLDetails(String emailURL){
       AWSBucketAccess awsBucketAccessObj = new AWSBucketAccess();
       String xmlContent = awsBucketAccessObj.AWSBucketAccessMethod(emailURL,'','');
       Dom.Document doc = new Dom.Document();
       doc.load(xmlContent);
       Dom.XMLNode parentNode = doc.getRootElement();
       return parentNode;    
    }
    
    private void findChild(DOM.XMLNode xmlnodeobj){
    
       if(xmlnodeobj.getName().contains('section')){
           ArchivedSectionCheck = xmlnodeobj.getAttributeValue(xmlnodeobj.getAttributeKeyAt(0), xmlnodeobj.getAttributeKeyNsAt(0));
           if(ArchivedSectionCheck.equals('true'))
           displayCase(xmlnodeobj);
       }
       
       if(xmlnodeobj.getName().equals('relatedList')){
             
            wrapperrelatedlistblock wrapperRelatedObj; 
            String relatedObjectLabelName = xmlnodeobj.getAttributeValue(xmlnodeobj.getAttributeKeyAt(0), xmlnodeobj.getAttributeKeyNsAt(0));
            system.debug('$@*#*11111111'+relatedObjectLabelName);
            String replaceSpecialCharacter;
            if(relatedObjectLabelName.contains('&')){
                replaceSpecialCharacter = relatedObjectLabelName.replace('&','').replaceAll(' ','');
            }else{
                replaceSpecialCharacter = relatedObjectLabelName.replaceAll(' ','');
            }
            
            if(wrapperRelatedObj==null)
                    wrapperRelatedObj =new wrapperrelatedlistblock(relatedObjectLabelName, replaceSpecialCharacter);
            
            for(Dom.XMLNode relatedParent: xmlnodeobj.getChildElements()){
                wrapperRelatedObj.listurl=relatedParent.getText();
             system.debug('****************8list value***********8'+wrapperRelatedObj.listurl);
            }
            relatedlists.add(wrapperRelatedObj);
            system.debug('*******relatedlists***********relatedlists**********************'+relatedlists);
       }         
   
       for(Dom.XMLNode child : xmlnodeobj.getChildElements()){
         if(child.getText()<>null || child.getText()<>''){
            outputString = outputString + '\n'+child.getName()+ ' : ' +child.getText();
         }
         findChild(child);            
       }
    }
    
    //function used to parse xml and store data into wrapper class for case basic display        
    public void displayCase(DOM.XMLNode xmlnodeobj){
        wrapperrelatedlistvariablevalues sectionvalue= new wrapperrelatedlistvariablevalues();
        sectionvalue.sectionName = xmlnodeobj.getAttributeValue(xmlnodeobj.getAttributeKeyAt(2), xmlnodeobj.getAttributeKeyNsAt(2));
        sectionvalue.columnValue = xmlnodeobj.getAttributeValue(xmlnodeobj.getAttributeKeyAt(1), xmlnodeobj.getAttributeKeyNsAt(1));
        system.debug('***************section value'+sectionvalue.sectionName);
        
        List<VariableValues> caseValues = new List<VariableValues>();
        for(Dom.XMLNode child : xmlnodeobj.getChildElements()){
            if(child.getText()<>null || child.getText()<>''){
                String childName = child.getAttributeValue(child.getAttributeKeyAt(0), child.getAttributeKeyNsAt(0));
                String childValue = child.getText();
                if(string.isNotBlank(childValue)){
                    if(childValue.contains('-') && childValue.contains(':') && childValue.contains('T') && childValue.contains('Z') && childValue.endswith('Z')){
                        childValue = UIdateAndTimeFormat(childValue);
                    }else{
                        childValue = childValue.replace('\n','+newLineCharcter+');
                    }
                }
                VariableValues samplevalue = new VariableValues(childName,childValue);
                caseValues.add(samplevalue);     
            }
        }
        sectionvalue.mylist=caseValues;
        Casebasicdetails.add(sectionvalue);
    }
    
    //remote action to create dynamic table for related items
    @RemoteAction
    public static List<wrapperrelatedlistblock> getRelatedChildDetails(String parameterName,String bucketURL, String baseURL, String sourceVal){
        system.debug(bucketURL+'@@@@@@@@@@@@@Sin remote method '+baseURL);
        String relatedDaylightSaving;
        User logginedUser;
        if(!Test.isRunningTest()){
            User logginedInUser = [select FederationIdentifier from User where id=:UserInfo.getUserId()];
            String federationIdValue = logginedInUser.FederationIdentifier<>null?logginedInUser.FederationIdentifier.remove('-cc'):'';
            system.debug(federationIdValue+'@@@@@'+logginedInUser.FederationIdentifier);
            if(String.isNotBlank(federationIdValue)){
                logginedUser = [Select TimeZoneSidKey from User where profile.name<>:System.Label.AWS_CommunityProfileName AND Username LIKE:federationIdValue+'%' AND IsActive=:true limit 1];
            }
        }else{
            logginedUser = [Select TimeZoneSidKey from User where profile.name<>:System.Label.AWS_CommunityProfileName AND lastName=:'Sharma' limit 1];
        }
        if(logginedUser<>null && logginedUser.TimeZoneSidKey<>null){
            Schema.DescribeFieldResult userResult = User.TimeZoneSidKey.getdescribe();
            List<Schema.PicklistEntry> pickListEntryObj = userResult.getPicklistValues();
            for(Schema.PicklistEntry pickListValue:pickListEntryObj){
                if(logginedUser.TimeZoneSidKey==pickListValue.getValue()){
                    relatedDaylightSaving = pickListValue.getlabel();
                }
            }
        }
        getWrapperValues= new List<wrapperrelatedlistblock>();
        AWSBucketAccess awsBucketAccessObj = new AWSBucketAccess();
        String relatedObjectXmlContent;
        List<String> relatedPath;
        if(String.isNotBlank(bucketURL) && String.isNotBlank(baseURL) && baseURL.contains('/')){
            relatedPath = baseURL.split('/'); 
            system.debug(baseURL+'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+relatedPath);
            relatedObjectXmlContent = awsBucketAccessObj.AWSBucketAccessMethod(bucketURL,relatedPath[0],relatedPath[1]);
            Dom.Document doc = new Dom.Document();  
            doc.load(relatedObjectXmlContent);
            Dom.XMLNode childName = doc.getRootElement();
            String relatedChildName = childName.getName().replace('_Fields','');
            if(relatedWrapperClassObject==null)
                relatedWrapperClassObject =new wrapperrelatedlistblock(relatedChildName, relatedChildName); 
                for(Dom.XMLNode child:childName.getChildElements()){
                    if(child.getName()<>null){
                        relatedWrapperClassObject=displayrelatedlist(child,relatedWrapperClassObject,parameterName,relatedDaylightSaving,sourceVal,baseURL);
                    }
                }
            if(relatedWrapperClassObject<>null){
                getWrapperValues.add(relatedWrapperClassObject);
            }
        }
       return getWrapperValues;
    }
    
    public static wrapperrelatedlistblock displayrelatedlist(DOM.XMLNode relatedChild, wrapperrelatedlistblock relatedWrapperClassObj, String relatedChildName, String relatedDaylightSaving, String awsSource, String relatedFolderLoc){
        Set<String> setOfHeader = new Set<String>();
        wrapperrelatedlistvariablevalues wrapperrelatedlistvariableObj =new wrapperrelatedlistvariablevalues(); 
        headerlist =new List<string>();
        for(Dom.XMLNode child: relatedChild.getChildElements()){
            if(child.getText()<>null || child.getText()<>''){
                if(!child.getAttributeValue(child.getAttributeKeyAt(0), child.getAttributeKeyNsAt(0)).equals('Archived Fields')){
                    String relatedChildNames = child.getName();
                    String relatedChildValue = child.getText();
                    system.debug(relatedChildName+'#####EMAIL CONTENT#######'+relatedFolderLoc+'%%%%%%%%'+relatedChildNames+'^^^^^^^^'+awsSource);                   
                        
                    if(string.isNotBlank(relatedChildValue)){
                        if(relatedChildValue.contains('-') && relatedChildValue.contains(':') && relatedChildValue.contains('T') && relatedChildValue.contains('Z') && relatedChildValue.endswith('Z')){
                            relatedChildValue = relatedUIDateTimeFormat(relatedChildValue,relatedDaylightSaving);
                        }else if(relatedChildNames.containsIgnoreCase('bodyLength') && string.isNotBlank(relatedChildValue)){
                            Decimal convertByteintoKB = Decimal.valueOf(relatedChildValue)/1024;
                            relatedChildValue = string.valueOf(convertByteintoKB>1000?(convertByteintoKB/1024).setScale(2)+'MB':convertByteintoKB.setScale(2)+'KB');
                        }else if(String.isNotBlank(awsSource) && relatedFolderLoc.contains('EmailMessageContent') && relatedChildName.equalsIgnoreCase('Attachments') && relatedChildNames.equalsIgnoreCase('Name') && awsSource.equalsIgnoreCase('layer7')){
                            
                            String attachmentContentURL;
                            if(String.isNotBlank(child.getAttributeValue(child.getAttributeKeyAt(1), child.getAttributeKeyNsAt(1)))){
                                attachmentContentURL = child.getAttributeValue(child.getAttributeKeyAt(1), child.getAttributeKeyNsAt(1));
                            }
                            if(String.isNotBlank(attachmentContentURL) && attachmentContentURL.contains('/')){
                                attachmentContentURL = attachmentContentURL.substringAfter('/');
                                if(String.isNotBlank(attachmentContentURL)){
                                    relatedChildValue = attachmentContentURL+'uniqueAttachmentContent'+relatedChildValue;
                                }        
                            }
                        }else{
                          relatedChildValue = relatedChildValue.replace('\n','+newLineCharcter+');
                      }
                    }
                    VariableValues variableValueObj = new VariableValues(relatedChildNames,relatedChildValue);
                    wrapperrelatedlistvariableObj.mylist.add(variableValueObj);
                    setOfHeader.add(child.getAttributeValue(child.getAttributeKeyAt(0), child.getAttributeKeyNsAt(0)));
                    system.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'+setOfHeader);
                }
            }
        }
        headerList.addAll(setOfHeader);
        relatedWrapperClassObj.headername=headerList;
        relatedWrapperClassObj.mylist.add(wrapperrelatedlistvariableObj);
        return relatedWrapperClassObj;
    }
    
    //format date and time for related items on the basis of loggined user
    private static String relatedUIDateTimeFormat(String relatedChildValue, String relatedDaylightSaving){
      if(String.isNotBlank(relatedDaylightSaving)){
          String relatedDateFormat = relatedDaylightSaving.substring(5,10);
          String relatedSignSymbol = relatedDaylightSaving.substring(4,5);
          List<String> splitRelatedDateFormat= relatedDateFormat.split(':');
          relatedChildValue = relatedChildValue.replace('T',' ').replace('Z','');
          DateTime relatedDateTimeFormat = dateTime.valueofGmt(relatedChildValue);
          
          if(relatedDaylightSaving<>null && relatedDaylightSaving.contains('Daylight')){
             relatedDateTimeFormat = calculateDayLight(relatedDateTimeFormat,splitRelatedDateFormat,relatedSignSymbol);
          }else{
            relatedDateTimeFormat = relatedDateTimeFormat.addHours(Integer.valueOf(relatedSignSymbol+splitRelatedDateFormat[0])).addMinutes(Integer.valueOf(relatedSignSymbol+splitRelatedDateFormat[1]));
          }
          
          List<String> splitRelatedDateTime = string.valueOfGmt(relatedDateTimeFormat).split(' ');
          List<String> relatedDisplayDateFormat = splitRelatedDateTime[0].split('-');
          List<String> relatedDisplayTimeFormat = splitRelatedDateTime[1].split(':');
          String relatedUIdateFormat = (Integer.valueOf(relatedDisplayDateFormat[1])>=10?relatedDisplayDateFormat[1]:relatedDisplayDateFormat[1].substring(1,2))+'/'+(Integer.valueOf(relatedDisplayDateFormat[2])>=10?relatedDisplayDateFormat[2]:relatedDisplayDateFormat[2].substring(1,2))+'/'+relatedDisplayDateFormat[0];
          Integer convertRelatedStringIntoInt = Integer.valueOf(relatedDisplayTimeFormat[0]);
          Integer relatedTimeValue = (convertRelatedStringIntoInt>=12?((convertRelatedStringIntoInt-12)>0?(convertRelatedStringIntoInt-12):12):(convertRelatedStringIntoInt>0?(convertRelatedStringIntoInt>=10?convertRelatedStringIntoInt:Integer.valueOf(relatedDisplayTimeFormat[0].substring(1,2))):12));
          String relatedUItimeFormat = String.valueOf(relatedTimeValue)+':'+relatedDisplayTimeFormat[1]+' '+(convertRelatedStringIntoInt>=12?'PM':'AM');
          system.debug(relatedUIdateFormat+'####relatedUItimeFormat#####'+relatedUItimeFormat);
          return relatedUIdateFormat+' '+relatedUItimeFormat;
      }
      return null;
    }
    
    // format date and time on the basis of loggined user
    private String UIdateAndTimeFormat(String childValue){
      if(String.isNotBlank(daylightSaving)){
          String dateFormat = daylightSaving.substring(5,10);
          String signSymbol = daylightSaving.substring(4,5);
          List<String> splitDateFormat= dateFormat.split(':');
          childValue = childValue.replace('T',' ').replace('Z','');
          DateTime dateTimeFormat = dateTime.valueofGmt(childValue);
          
          if(daylightSaving<>null && daylightSaving.contains('Daylight')){
             dateTimeFormat = calculateDayLight(dateTimeFormat,splitDateFormat,signSymbol);
          }else{
            dateTimeFormat = dateTimeFormat.addHours(Integer.valueOf(signSymbol+splitDateFormat[0])).addMinutes(Integer.valueOf(signSymbol+splitDateFormat[1]));  
          }
           
          List<String> splitDateTimeFormat = string.valueOfGmt(dateTimeFormat).split(' ');
          List<String> displayDateFormat = splitDateTimeFormat[0].split('-');
          List<String> displayTimeFormat = splitDateTimeFormat[1].split(':');
          system.debug(splitDateTimeFormat+'%%%%%%%%%%'+displayTimeFormat);
         
          String UIdateFormat = (Integer.valueOf(displayDateFormat[1])>=10?displayDateFormat[1]:displayDateFormat[1].substring(1,2))+'/'+(Integer.valueOf(displayDateFormat[2])>=10?displayDateFormat[2]:displayDateFormat[2].substring(1,2))+'/'+displayDateFormat[0];
          Integer convertStringIntoInt = Integer.valueOf(displayTimeFormat[0]);
          Integer timeValue = (convertStringIntoInt>=12?((convertStringIntoInt-12)>0?(convertStringIntoInt-12):12):(convertStringIntoInt>0?(convertStringIntoInt>=10?convertStringIntoInt:Integer.valueOf(displayTimeFormat[0].substring(1,2))):12));
          String UItimeFormat = String.valueOf(timeValue)+':'+displayTimeFormat[1]+' '+(convertStringIntoInt>=12?'PM':'AM');
          system.debug(UIdateFormat+'^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^'+UItimeFormat);
          return UIdateFormat+' '+UItimeFormat;
      }
      return null;
    }
    
    //method to calculate day light saving based on logged in user time zone
    private static DateTime calculateDayLight(DateTime dateTimeFormat, List<String> splitDateFormat, String signSymbol){
      system.debug(splitDateFormat+'#############'+dateTimeFormat+'#################'+signSymbol);
      Date currentDate = date.newInstance(dateTimeFormat.yearGmt(),dateTimeFormat.monthGmt(),dateTimeFormat.dayGmt());
      Time currentTime = time.newInstance(dateTimeFormat.hourGmt(),dateTimeFormat.minuteGmt(),dateTimeFormat.secondGmt(),dateTimeFormat.millisecondGmt());
      DateTime inputDateTime = dateTime.newInstance(currentDate,currentTime);
      DateTime dateTimeGmtFormat = dateTime.valueOfGmt(string.valueOf(inputDateTime));
      Date currentWeekDate = currentDate.toStartofWeek();
      DateTime currentDateTime = dateTime.newInstance(currentWeekDate.year(),currentWeekDate.month(),currentWeekDate.day());
      Integer dayLessThan7 = Integer.valueOf(currentWeekDate.day());
      String monthDay;
      if(Integer.valueOf(dateTimeGmtFormat.yearGmt())>=2007){
         if(dateTimeGmtFormat.formatGmt('EEEE')=='Sunday' && Integer.valueOf(dateTimeGmtFormat.monthGmt())==3 && Integer.valueOf(dateTimeGmtFormat.dayGmt())<8){
            monthDay = currentDateTime.formatGmt('EEEE');
         }else if(dayLessThan7<8 && Integer.valueOf(currentDateTime.month())==3){
            monthDay = currentDateTime.formatGmt('EEEE'); 
         }else if(Integer.valueOf(currentDateTime.month())==11 && (dateTimeGmtFormat.monthGmt()==currentDateTime.month()) && (dateTimeGmtFormat.dayGmt()<=currentDateTime.day()) && dayLessThan7<8){
            monthDay = currentDateTime.formatGmt('EEEE');
         }
         
         if(dateTimeGmtFormat.formatGmt('EEEE')=='Sunday' && 
             ((Integer.valueOf(dateTimeGmtFormat.monthGmt())==3 && Integer.valueOf(dateTimeGmtFormat.dayGmt())<8 && Integer.valueOf(dateTimeGmtFormat.hourGmt())>=2) || 
                 (Integer.valueOf(dateTimeGmtFormat.monthGmt())==11 && Integer.valueOf(dateTimeGmtFormat.dayGmt())<8 && Integer.valueOf(dateTimeGmtFormat.hourGmt())<2) || 
                 (Integer.valueOf(dateTimeGmtFormat.monthGmt())==11 && Integer.valueOf(dateTimeGmtFormat.dayGmt())<8 && Integer.valueOf(dateTimeGmtFormat.hourGmt())==2 && Integer.valueOf(dateTimeGmtFormat.secondGmt())==0))
           ){
            dateTimeFormat = dateTimeFormat.addHours(Integer.valueOf(signSymbol+splitDateFormat[0])+1).addMinutes(Integer.valueOf(signSymbol+splitDateFormat[1]));
         }else if((Integer.valueOf(currentDateTime.month())>3 && Integer.valueOf(currentDateTime.month())<11) ||
              (Integer.valueOf(currentDateTime.month())==3 && dayLessThan7<08 && monthDay=='Sunday' && Integer.valueOf(dateTimeGmtFormat.hourGmt())>=2) || (Integer.valueOf(currentDateTime.month())==3 && dayLessThan7>=8) ||
              (Integer.valueOf(currentDateTime.month())==11  && dayLessThan7<08  && (dateTimeGmtFormat.monthGmt()==currentDateTime.month()) && (dateTimeGmtFormat.dayGmt()<=currentDateTime.day()) && Integer.valueOf(dateTimeGmtFormat.hourGmt())==2 && Integer.valueOf(dateTimeGmtFormat.secondGmt())==0) ||
              (Integer.valueOf(currentDateTime.month())==11  && dayLessThan7<08  && (dateTimeGmtFormat.monthGmt()==currentDateTime.month()) && (dateTimeGmtFormat.dayGmt()<=currentDateTime.day()) && Integer.valueOf(dateTimeGmtFormat.hourGmt())<2)
           ){
              dateTimeFormat = dateTimeFormat.addHours(Integer.valueOf(signSymbol+splitDateFormat[0])+1).addMinutes(Integer.valueOf(signSymbol+splitDateFormat[1]));
         }else{
             dateTimeFormat = dateTimeFormat.addHours(Integer.valueOf(signSymbol+splitDateFormat[0])-1).addMinutes(Integer.valueOf(signSymbol+splitDateFormat[1]));
         }
      }else if(Integer.valueOf(dateTimeGmtFormat.yearGmt())<2007){
         if(dayLessThan7<8 && Integer.valueOf(currentDateTime.month())==4){
             monthDay = currentDateTime.formatGmt('EEEE');
         }else if(dayLessThan7>=25 && Integer.valueOf(currentDateTime.month())==10 && (dateTimeGmtFormat.monthGmt()==currentDateTime.month()) && (dateTimeGmtFormat.dayGmt()<=currentDateTime.day())){
             monthDay = currentDateTime.formatGmt('EEEE');
         }
         
         if(dateTimeGmtFormat.formatGmt('EEEE')=='Sunday' && 
             ((Integer.valueOf(dateTimeGmtFormat.monthGmt())==4 && Integer.valueOf(dateTimeGmtFormat.dayGmt())<8 && Integer.valueOf(dateTimeGmtFormat.hourGmt())>=2) || 
                 (Integer.valueOf(dateTimeGmtFormat.monthGmt())==10 && Integer.valueOf(dateTimeGmtFormat.dayGmt())==31 && Integer.valueOf(dateTimeGmtFormat.hourGmt())==2 && Integer.valueOf(dateTimeGmtFormat.secondGmt())==0) ||
                 (Integer.valueOf(dateTimeGmtFormat.monthGmt())==10 && Integer.valueOf(dateTimeGmtFormat.dayGmt())==31 && Integer.valueOf(dateTimeGmtFormat.hourGmt())<2) ||
                 (Integer.valueOf(dateTimeGmtFormat.monthGmt())==10 && Integer.valueOf(dateTimeGmtFormat.dayGmt())>=25 && Integer.valueOf(dateTimeGmtFormat.hourGmt())<2) ||
                 (Integer.valueOf(dateTimeGmtFormat.monthGmt())==10 && Integer.valueOf(dateTimeGmtFormat.dayGmt())>=25 && Integer.valueOf(dateTimeGmtFormat.hourGmt())==2 && Integer.valueOf(dateTimeGmtFormat.secondGmt())==0)
             )  
           ){
             system.debug('#############1st');
             dateTimeFormat = dateTimeFormat.addHours(Integer.valueOf(signSymbol+splitDateFormat[0])+1).addMinutes(Integer.valueOf(signSymbol+splitDateFormat[1]));
         }else if((Integer.valueOf(currentDateTime.month())>4 && Integer.valueOf(currentDateTime.month())<10) ||
            (Integer.valueOf(currentDateTime.month())==4 && dayLessThan7<8 && monthDay=='Sunday' && Integer.valueOf(dateTimeGmtFormat.hourGmt())>=2) ||
            (Integer.valueOf(currentDateTime.month())==4 && dayLessThan7>=8) || (Integer.valueOf(currentDateTime.month())==10 && dayLessThan7<25) ||
            (Integer.valueOf(currentDateTime.month())==10 && dayLessThan7>=25 && (dateTimeGmtFormat.monthGmt()==currentDateTime.month()) && (dateTimeGmtFormat.dayGmt()<=currentDateTime.day()) && Integer.valueOf(dateTimeGmtFormat.hourGmt())<=2)
           ){
             system.debug('#############2nd');
             dateTimeFormat = dateTimeFormat.addHours(Integer.valueOf(signSymbol+splitDateFormat[0])+1).addMinutes(Integer.valueOf(signSymbol+splitDateFormat[1]));
         }else{
             system.debug('#############3rd');
             dateTimeFormat = dateTimeFormat.addHours(Integer.valueOf(signSymbol+splitDateFormat[0])-1).addMinutes(Integer.valueOf(signSymbol+splitDateFormat[1]));
         }              
      }
      system.debug('###########'+dateTimeFormat);
      return dateTimeFormat;
    }
    
    public pageReference returnAttachmentURL(){
        String AWSLinkValue = system.currentpagereference().getparameters().get('attachmentId');
        system.debug('---first: '+AWSLinkValue);
        AWSLinkValue = '/'+AWSLinkValue;
        String stringAfterLast = AWSLinkValue.substringAfterLast('/');
        if(String.isNotBlank(stringAfterLast)){
            String encodedString = EncodingUtil.urlEncode(stringAfterLast, 'UTF-8');
            encodedString = encodedString.replace('%28','(');
            encodedString = encodedString.replace('%29',')');
            AWSLinkValue = AWSLinkValue.replace(stringAfterLast,encodedString);
            system.debug('---@@@@@: '+encodedString);
        }
        system.debug('---@@@@@: '+AWSLinkValue);
        String bucket =  EncodingUtil.urlEncode(System.Label.AWS_CaseArchival_Bucket_Name, 'UTF-8');
        AWS_credentials__c credentials = AWS_credentials__c.getValues(System.Label.AWS_CaseArchival_Credential_Name);
        if(credentials!=null){
            String S3Key = credentials.Key__c;
            String fname = EncodingUtil.urlEncode(AWSLinkValue, 'UTF-8');
            Datetime now = DateTime.now();
            Datetime expireson = now.AddSeconds(120);
            Long Lexpires = expireson.getTime()/1000;
            String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucket+AWSLinkValue;
            System.debug('redirectToS3Key stringstosign: ' + stringtosign);
            String signed = make_sig(stringtosign,credentials);
            System.debug('signed: ' + signed);
            String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
            System.debug('codedsigned: ' + codedsigned);
            attachmentURL = System.Label.AWS_CaseArchival_Root_URL+bucket+AWSLinkValue+'?AWSAccessKeyId='+S3Key+'&Expires='+Lexpires+'&Signature='+codedsigned;
            System.debug('attachmentURL: ' + attachmentURL);
            PageReference pageReferenceObj = new PageReference(attachmentURL);
            return pageReferenceObj;
        }
        return null;
    }
    
    public static String make_sig(string canonicalBuffer, AWS_credentials__c credentials) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(credentials.Secret__c));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(credentials.Secret__c)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
    
    public class wrapperrelatedlistblock{
        public string listname {get;set;}
        public string apiName{get;set;}
        public List<string> headername{get;set;}
        public string listurl{get;set;}
        public list<wrapperrelatedlistvariablevalues> mylist{get;set;}
        wrapperrelatedlistblock(string name, string objectApiName){
            listname=name;
            apiName = objectApiName;
            mylist=new list<wrapperrelatedlistvariablevalues>();
        }
    }
 
    //wrapper class to create list of variable value wrapper class and usage for case basics display    
    public class wrapperrelatedlistvariablevalues{
        public list<VariableValues> mylist{get;set;}
        public boolean iscalled {get;set;}
        public string sectionName{get;set;}
        public string columnValue{get;set;}
        wrapperrelatedlistvariablevalues(){
            mylist=new list<VariableValues>();
            iscalled=false;
        }
    }
    
    //Wrapper class to store name value for all the fields
    public class VariableValues{
        public String variablename{get;set;}
        public String variablevalue{get;set;}
        VariableValues(string name,string value){
            variablename=name;
            variablevalue=value;
        }
    }
}