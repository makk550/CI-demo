Public class SelecticaContractController{
    
    public String S3URL{get;set;}
    public string ArchivedSectionCheck{get;set;}
    public String outputString{get;set;}
    public List<wrapperrelatedlistblock> relatedlists{get;set;}
    public Static List<wrapperrelatedlistblock> getWrapperValues{get;set;}
    public static wrapperrelatedlistblock relatedWrapperClassObject;
    public List<wrapperrelatedlistvariablevalues> Casebasicdetails{get;set;}
    public wrapperrelatedlistvariablevalues CaseBasicSectionValues{get;set;}
    public Set<String> setHeader{get;set;}
    public Set<String> commentSetHeader{get;set;}
    public Integer headerValue{get;set;}
    public Integer commentHeaderValue{get;set;}
    public Integer agreementHeaderValue{get;set;}
    public Set<String> agreementSetHeader{get;set;}
    public List<String> nodeNames{get;set;}
    public String parentNode{get;set;}
    public List<String> masterParentChilds{get;set;}
    public Boolean showChildNode{get;set;}
    public List<String> finalList{get;set;}
    public Set<String> activitySetHeader{get;set;}
    public Integer activityHeaderValue{get;set;}
    public string username{get;set;}
    public string source{get;set;}
    public List<String> onloadShowList{get;set;}
    public String contractNumber{get;set;}
    public String attachmentURL{get;set;}
    
    public SelecticaContractController(){
        showChildNode = false;
        finalList = new List<String>();
        masterParentChilds = new List<String>();
        onloadShowList = new List<String>();
        nodeNames = new List<String>();
        setHeader = new set<String>();
        commentSetHeader = new set<String>();
        agreementSetHeader = new set<String>();
        activitySetHeader = new Set<String>();
        relatedlists=new List<wrapperrelatedlistblock>();
        CaseBasicSectionValues= new wrapperrelatedlistvariablevalues();    
        Casebasicdetails=new List<wrapperrelatedlistvariablevalues>();
        S3URL = apexpages.currentpage().getparameters().get('ContractLink')<>null?apexpages.currentpage().getparameters().get('ContractLink'):'';
        system.debug('---->'+S3URL);
        User currentUser;
        if(!Test.isRunningTest()){
            currentUser = [select username, firstname, lastname from User where id=:UserInfo.getUserId() AND IsActive=:true];
        }else{
            currentUser = [Select username, firstname, lastname from User where id=:UserInfo.getUserId() AND IsActive=:true];
        }
        if(currentUser<>null && currentUser.username<>null){
            username=currentUser.firstname+' '+currentUser.lastname;
        }
        
        if(String.isNotBlank(S3URL)){
            List<String> splitS3URL = S3URL.split('/');
            source = splitS3URL[0].touppercase();
            List<String> listOfContract = splitS3URL[1].split('_');
            contractNumber = listOfContract[0];
            callAWSLink(S3URL);
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please pass the valid parameter!!'));  
        }
    }
    
    public void callAWSLink(String S3URL){
       String XMLFileContent;
       AWSBucketAccess AWSBucketAccessObj = new AWSBucketAccess();
       XMLFileContent = AWSBucketAccessObj.AWSBucketAccessMethod(S3URL,'','');
       system.debug('!@#@!@#'+XMLFileContent);
       Dom.Document doc = new Dom.Document();
       doc.load(XMLFileContent);
       Dom.XMLNode parentNode = doc.getRootElement();
       for(DOM.XMLNode xmlnodeobj:parentNode.getChildElements()){
           findChild(xmlnodeobj);
       }
    }
    
    public void displayContract(DOM.XMLNode xmlnodeobj){
        wrapperrelatedlistvariablevalues sectionvalue= new wrapperrelatedlistvariablevalues();
        sectionvalue.sectionName = xmlnodeobj.getAttributeValue(xmlnodeobj.getAttributeKeyAt(1), xmlnodeobj.getAttributeKeyNsAt(1));
        sectionvalue.columnValue = xmlnodeobj.getAttributeValue(xmlnodeobj.getAttributeKeyAt(0), xmlnodeobj.getAttributeKeyNsAt(0));
        system.debug('***************section value'+xmlnodeobj.getChildElements());
        List<VariableValues> caseValues = new List<VariableValues>();
        List<attachmentWrapper> attachValues = new List<attachmentWrapper>();
        if(sectionvalue.sectionName=='Contract Detail'){
            for(Dom.XMLNode child : xmlnodeobj.getChildElements()){
                if(child.getText()<>null || child.getText()<>''){
                    String childName = child.getAttributeValue(child.getAttributeKeyAt(0), child.getAttributeKeyNsAt(0));
                    String childValue = child.getText();
                    if(string.isNotBlank(childValue)){
                        childValue = childValue.replace('\n','+newLineCharcter+');
                    }
                    VariableValues samplevalue = new VariableValues(childName,childValue);
                    caseValues.add(samplevalue);     
                }
            }
        }else if(sectionvalue.sectionName=='Attachments'){
           Integer counter = 0;
           for(Dom.XMLNode child:xmlnodeobj.getChildElements()){
               for(Dom.XMLNode innerChild:child.getChildElements()){
                   
                   String childName = innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0));
                   String childValue = innerChild.getText()<>'' && innerChild.getText()<>null?innerChild.getText():'';
                   VariableValues samplevalue;
                   if((!childName.contains(' ') && (childName.contains('/') || childName.contains('_')) && childName.contains('.')) || childName=='null'){
                       setHeader.add(innerChild.getAttributeValue(innerChild.getAttributeKeyAt(1), innerChild.getAttributeKeyNsAt(1)));
                       childName = innerChild.getAttributeValue(innerChild.getAttributeKeyAt(1), innerChild.getAttributeKeyNsAt(1));
                       String hyperLinkVal = innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0));
                       ++counter;
                       childValue = childValue.replace('\n','+newLineCharcter+');
                       childValue = childValue.replace(',','+newCommas+');
                       childValue = contractNumber+'_'+counter+'_Attachment'+'**CHILDVAL**'+hyperLinkVal+'**CHILDVAL**'+childValue;
                       samplevalue = new VariableValues(childName,childValue); 
                   }else{
                       setHeader.add(innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0)));
                       childValue = childValue.replace('\n','+newLineCharcter+');
                       childValue = childValue.replace(',','+newCommas+');
                       samplevalue = new VariableValues(childName,childValue); 
                   }
                   system.debug('@#%@%@%@%@%#@$%#@$%#$%'+setHeader);
                   caseValues.add(samplevalue);
               }
           }
           headerValue = setHeader.size()+1;
        }else if(sectionvalue.sectionName=='Comments'){
           for(Dom.XMLNode child:xmlnodeobj.getChildElements()){
               for(Dom.XMLNode innerChild:child.getChildElements()){
                   commentSetHeader.add(innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0)));
                   String childName = innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0));
                   String childValue = innerChild.getText()<>'' && innerChild.getText()<>null?innerChild.getText():'';
                   childValue = childValue.replace('\n','+newLineCharcter+');
                   childValue = childValue.replace(',','+newCommas+');
                   VariableValues samplevalue = new VariableValues(childName,childValue);
                   caseValues.add(samplevalue);
               }
           }
           commentheaderValue = commentSetHeader.size()+1;
        }else if(sectionvalue.sectionName=='Agreements'){
           Integer counter = 0;
           for(Dom.XMLNode child:xmlnodeobj.getChildElements()){
               for(Dom.XMLNode innerChild:child.getChildElements()){
                   String childName = innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0));
                   String childValue = innerChild.getText()<>'' && innerChild.getText()<>null?innerChild.getText():'';
                   VariableValues samplevalue;
                   if((!childName.contains(' ') && (childName.contains('/') || childName.contains('_')) && childName.contains('.')) || childName=='null'){
                       agreementSetHeader.add(innerChild.getAttributeValue(innerChild.getAttributeKeyAt(1), innerChild.getAttributeKeyNsAt(1)));
                       childName = innerChild.getAttributeValue(innerChild.getAttributeKeyAt(1), innerChild.getAttributeKeyNsAt(1));
                       String hyperLinkVal = innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0));
                       ++counter;
                       childValue = contractNumber+'_'+counter+'_Agreement'+'**CHILDVAL**'+hyperLinkVal+'**CHILDVAL**'+childValue;
                       samplevalue = new VariableValues(childName,childValue); 
                   }else{
                       agreementSetHeader.add(innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0)));
                       childValue = childValue.replace('\n','+newLineCharcter+');
                       childValue = childValue.replace(',','+newCommas+');
                       childValue = childValue;
                       samplevalue = new VariableValues(childName,childValue); 
                   }
                   system.debug('Agree: '+childName);
                   system.debug('Agree111: '+childValue);
                   caseValues.add(samplevalue);
               }
           }
           agreementHeaderValue = agreementSetHeader.size()+1;
        }else if(sectionvalue.sectionName=='Activity Log'){
           for(Dom.XMLNode child:xmlnodeobj.getChildElements()){
               for(Dom.XMLNode innerChild:child.getChildElements()){
                   activitySetHeader.add(innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0)));
                   String childName = innerChild.getAttributeValue(innerChild.getAttributeKeyAt(0), innerChild.getAttributeKeyNsAt(0));
                   String childValue = innerChild.getText()<>'' && innerChild.getText()<>null?innerChild.getText():'';
                   childValue = childValue.replace('\n','+newLineCharcter+');
                   childValue = childValue.replace(',','+newCommas+');
                   VariableValues samplevalue = new VariableValues(childName,childValue);
                   caseValues.add(samplevalue);
               }
           }
           activityHeaderValue = activitySetHeader.size()+1;
        }else if(sectionvalue.sectionName=='Childs Hierarchy'){
            String nextXML;
            for(Dom.XMLNode child:xmlnodeobj.getChildElements()){
                nextXML = child.getText()<>null && child.getText()<>''?child.getText():'';
            }
            system.debug(nextXML+'**S3URL******'+S3URL);
            if(String.isNotBlank(nextXML)){
                String XMLChildContent;
                List<String> newString = S3URL.split('/');
                List<String> nextXMLString = nextXML.split('/');
                String concatString = newString[0]+'/'+nextXMLString[0]+'/'+nextXMLString[1];
                system.debug('*************'+concatString);
                AWSBucketAccess AWSBucketAccessObj = new AWSBucketAccess();
                if(!Test.isRunningTest()){
                    XMLChildContent = AWSBucketAccessObj.AWSBucketAccessMethod(concatString,'','');
                }else{
                    XMLChildContent = createDummyResponse();
                }
                if(String.isNotBlank(XMLChildContent)){
                    Dom.Document doc = new Dom.Document();
                   doc.load(XMLChildContent);
                   Dom.XMLNode parentNode = doc.getRootElement();
                   for(DOM.XMLNode xmlNodeRelatedObj:parentNode.getChildElements()){
                       findRelatedChild(xmlNodeRelatedObj);
                   }
                }
            }
        }
        sectionvalue.mylist=caseValues;
        Casebasicdetails.add(sectionvalue);
    }
    
    private void findChild(DOM.XMLNode xmlnodeobj){
       if(xmlnodeobj.getName().contains('section')){
           ArchivedSectionCheck = xmlnodeobj.getAttributeValue(xmlnodeobj.getAttributeKeyAt(2), xmlnodeobj.getAttributeKeyNsAt(2));
           system.debug('ArchivedSectionCheck: '+ArchivedSectionCheck);
           if(ArchivedSectionCheck.equals('true'))
           displayContract(xmlnodeobj);
       }
        
       for(Dom.XMLNode child : xmlnodeobj.getChildElements()){
         if(child.getText()<>null || child.getText()<>''){
            outputString = outputString + '\n'+child.getName()+ ' : ' +child.getText();
         }
         findChild(child);            
       }
    }
    
    private void findRelatedChild(DOM.XMLNode xmlnodeobj){
       system.debug('$$$$$$$$$$$$'+xmlnodeobj.getName().contains('section'));
       if(xmlnodeobj.getName().contains('section')){
           ArchivedSectionCheck = xmlnodeobj.getAttributeValue(xmlnodeobj.getAttributeKeyAt(2), xmlnodeobj.getAttributeKeyNsAt(2));
           system.debug('$$$$$$ArchivedSectionCheck$$$$$$'+ArchivedSectionCheck);
           if(ArchivedSectionCheck.equals('true'))
               displayRelatedContract(xmlnodeobj);
       }
        
       for(Dom.XMLNode child : xmlnodeobj.getChildElements()){
         if(child.getText()<>null || child.getText()<>''){
            outputString = outputString + '\n'+child.getName()+ ' : ' +child.getText();
         }
         findRelatedChild(child);            
       }
    }
    
    public void displayRelatedContract(Dom.XMLNode xmlNodeObj){
        List<String> allNodes = new List<String>();
        if(xmlNodeObj.getName()<>null && xmlNodeObj.getName()<>''){
            for(Dom.xmlNode childElement:xmlNodeObj.getChildElements()){
                allNodes = callMethod(childElement);   
            }
            system.debug('$$$$'+allNodes);
            if(allNodes<>null && allNodes.size()>0){
                parentNode = allNodes[0].replace('|_ _ _ _ _ _','');
                parentNode = parentNode.replace(',','+replaceComma+');
                onloadShowList.add('--CURRENT ELEMENT--'+parentNode);
                system.debug('onloadShowList: '+onloadShowList);
                for(Integer i=1;i<allNodes.size();i++){
                    String splitCommas = allNodes[i].replace(',','+replaceComma+');
                    masterParentChilds.add(allNodes[i]);
                }
            }
        }
        
    }  
    
    public List<String> callMethod(Dom.xmlNode childElement){
        String x ='';
        String hell='';
        String sub = '|_ _ _ _ _ _';
        for(Dom.xmlNode nextElement:childElement.getChildElements()){
            Integer count =0;
            if(nextElement.getName().equalsIgnoreCase('contractnumber')){
                x = nextElement.getText();
                hell = x;
            }else if(nextElement.getName().equalsIgnoreCase('contractname')){
                x = x+'----'+nextElement.getText();
                x = x.replace(',','+replaceComma+');
                nodeNames.add(x);
                system.debug('---child nodes---'+x);
            }
            
            if(nextElement.getName().equalsIgnoreCase('childcontracts')){
               for(dom.xmlNode child:nextElement.getChildElements()){
                   newChildMethod(child,sub, hell);
               }
            }
            
            if(nextElement.getName().equalsIgnoreCase('parentcontracts')){
               for(dom.xmlNode child:nextElement.getChildElements()){
                   newParentNode(child);
               }
            }
            
        }
        return nodeNames;
    }
    
    
    public List<String> newChildMethod(Dom.xmlNode child, String sub, String x){
        if(child.getName().equalsIgnoreCase('Contract')){
           String c='';
           String q='';
           for(Dom.xmlNode childVal:child.getChildElements()){
               if(childVal.getName().equalsIgnoreCase('contractnumber')){
                    c = childVal.getText();
                    q = c;
                }else if(childVal.getName().equalsIgnoreCase('contractname')){
                    sub = sub;
                    c = sub+c+'----'+childVal.getText()+'--NEXT TO PARENT--'+x;
                    c= c.replace(',','+replaceComma+');
                    nodeNames.add(c);
                    system.debug('---new child nodes---'+c);
                }
                
                if(childVal.getName().equalsIgnoreCase('childcontracts')){
                   sub = sub+'|_ _ _ _ _ _';
                   x=q;
                   for(dom.xmlNode childValNode:childVal.getChildElements()){
                       newChildMethod(childValNode, sub,x);
                   }
                }
           }
       }
       return nodeNames;
    }
    
    Public void newParentNode(Dom.xmlNode child){
        if(child.getName().equalsIgnoreCase('Contract')){
            string parentNodeValue ='';
           for(Dom.xmlNode childVal:child.getChildElements()){
               if(childVal.getName().equalsIgnoreCase('contractnumber')){
                   parentNodeValue = parentNodeValue + childVal.getText();    
               }else if(childVal.getName().equalsIgnoreCase('contractname')){
                   parentNodeValue = parentNodeValue +'----' +childVal.getText();
                   system.debug('before parent: '+parentNodeValue);
                   parentNodeValue = parentNodeValue.replace(',','+replaceComma+');
                   system.debug('before parent: '+parentNodeValue);
                   onloadShowList.add(parentNodeValue);
               }
               if(childVal.getName().equalsIgnoreCase('parentcontracts')){
                  for(dom.xmlNode childValNode:childVal.getChildElements()){
                      newParentNode(childValNode);
                  }
               }
           }
       }
       //return nodeNames;
    }
    
    public pageReference callAWSFunc(){
        String defaultComponent = System.currentPagereference().getParameters().get('urlVal');
        
        if(String.isNotBlank(defaultComponent)){
            String bucket;
            AWS_credentials__c credentials;
            //Organization orgObj = [select Id, IsSandbox from Organization limit 1];
            //if(!orgObj.IsSandbox){
                bucket =  EncodingUtil.urlEncode(System.Label.AWS_SelecticaArchival_Bucket_Name, 'UTF-8');  
                credentials = AWS_credentials__c.getValues(System.Label.AWS_Selectica_Credential_Name);
            /*}else{
                bucket =  EncodingUtil.urlEncode(System.Label.AWS_CaseArchival_Bucket_Name, 'UTF-8');
                credentials = AWS_credentials__c.getValues(System.Label.AWS_CaseArchival_Credential_Name);
            }*/
            if(credentials!=null){
                String S3Key = credentials.Key__c;
                String fname = EncodingUtil.urlEncode(defaultComponent, 'UTF-8');
                Datetime now = DateTime.now();
                Datetime expireson = now.AddSeconds(120);
                Long Lexpires = expireson.getTime()/1000;
                String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+bucket+'/DOCS/'+defaultComponent;
                System.debug('redirectToS3Key stringstosign: ' + stringtosign);
                String signed = make_sig(stringtosign,credentials);
                System.debug('signed: ' + signed);
                String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
                System.debug('codedsigned: ' + codedsigned);
                attachmentURL = System.Label.AWS_CaseArchival_Root_URL+bucket+'/DOCS/'+defaultComponent+'?AWSAccessKeyId='+S3Key+'&Expires='+Lexpires+'&Signature='+codedsigned;
                System.debug('attachmentURL: ' + attachmentURL);
            }
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
        public list<wrapperrelatedlistvariablevalues> attachmentList{get;set;}
        wrapperrelatedlistblock(string name, string objectApiName){
            listname=name;
            apiName = objectApiName;
            mylist=new list<wrapperrelatedlistvariablevalues>();
        }
    }
    
    //wrapper class to create list of variable value wrapper class and usage for case basics display    
    public class wrapperrelatedlistvariablevalues{
        public list<VariableValues> mylist{get;set;}
        public List<attachmentWrapper> wrapperList{get;set;}
        public boolean iscalled {get;set;}
        public string sectionName{get;set;}
        public string columnValue{get;set;}
        wrapperrelatedlistvariablevalues(){
            mylist=new list<VariableValues>();
            wrapperList = new List<attachmentWrapper>();
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
    
    public class attachmentWrapper{
        public String attachmentName{get;set;}
        public String attachmentValue{get;set;}
        attachmentWrapper(string name,string value){
            attachmentName=name;
            attachmentValue=value;
        }
    }
    
    private String createDummyResponse(){
        return '<?xml version="1.0" encoding="UTF-8"?><contractdetails><contract><fields><section column="1" name="Contract Detail" visible="true"><contract name="Contract"><contractnumber name="Contract Number">2558852</contractnumber><contractname name="Contract Name">Amend#2 State of AZ MLSA-6/30/2006</contractname><childcontracts name="Child Contracts"><contract name="Contract"><contractnumber name="Contract Number">2689042</contractnumber><contractname name="Contract Name">Amend#8 ADES - Mainframe Replaceme</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5034199</contractnumber><contractname name="Contract Name">Amend#2 AZ-DES Clarity upg--18378</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5034490</contractnumber><contractname name="Contract Name">Amend#2 ADES-Clarity Add-Functiona</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5195015</contractnumber><contractname name="Contract Name">Amend#2 AZ-DES ServCat_18863</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5195092</contractnumber><contractname name="Contract Name">Amend#2 AZ DES - VSA SwCM SISO</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5701353</contractnumber><contractname name="Contract Name">SLED-S-OF-TM_ MF_staffaug_20959</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5708495</contractnumber><contractname name="Contract Name">Amend#R ADES-ITSM_Intgrt_RFR-21021</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5723971</contractnumber><contractname name="Contract Name">Amend#1 AZ DES - eHealth Integrati</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5984708</contractnumber><contractname name="Contract Name">AZ DOT - ITAM Services 2423</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">5989794</contractnumber><contractname name="Contract Name">ADES - Tuning for ITSM Integration</contractname><childcontracts name="Child Contracts"/></contract><contract name="Contract"><contractnumber name="Contract Number">6570189</contractnumber><contractname name="Contract Name">SLED-S-OF-TM-0911-ITCM-AZDES</contractname><childcontracts name="Child Contracts"/></contract></childcontracts><parentcontracts name="Parent Contracts"><contract name="Contract"><contractnumber name="Contract Number">1103343</contractnumber><contractname name="Contract Name">State of AZ MLSA-6/30/2006</contractname><parentcontracts name="Parent Contracts"><contract name="Contract"><contractnumber name="Contract Number">1012318</contractnumber><contractname name="Contract Name">CA GSA Master-9/26/2002</contractname></contract></parentcontracts></contract></parentcontracts></contract></section></fields></contract></contractdetails>';
    }
}