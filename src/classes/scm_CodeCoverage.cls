public class scm_CodeCoverage {

   
    public  List<CoverageData> coverageData {get; set;}
    public  List<CodeCoverageAggregateWrapper> coverageList  {get; set;}
    public List<CodeCoverageWrapper> testClassesList {get;set;}
  
    public ToolingApi toolingApi {get; set;}
    public String codeCov{get;set;}
    public Integer cov{get;set;}
    public Static Map<id,ApexClass> classMap{get;set;}
    public Static Map<id,ApexTrigger> triggerMap {get;set;}
    public Integer componentCount{get;set;}
    public Integer offsetNumber {get;set;}

    static
    {
         classMap = new Map<id,ApexClass>([Select Name from ApexClass]);
         triggerMap = new Map<id,ApexTrigger>([Select Name from ApexTrigger]);
    }
    public scm_CodeCoverage() {
        this.toolingApi = new ToolingApi();
        this.coverageData = new List<CoverageData>();
        this.coverageList = new List<CodeCoverageAggregateWrapper>(); 
        this.coverageData.add(new CoverageData('Percentage',0));
        this.testClassesList = new List<CodeCoverageWrapper>();
        this.cov =0;
        this.offsetNumber=0;
        //this.componentCount = [Select count() from ApexClass];
        //this.componentCount += [Select count() from ApexTrigger];
        this.componentCount = 500;
        String query = 'Select count() From ApexCodeCoverageAggregate where NumLinesUncovered != null';
        ToolingAPIWSDL.QueryResult qr = toolingApi.query(query);
        System.debug('  qr '+ qr.size);
        if(qr != null)
        this.componentCount = qr.size;
        
    }

    /**
     * Action for calculating Code Coverage
     */
    public PageReference calculate(){
        try {
        Integer i = Integer.valueOf(codeCov);
        if(i> 100 ||i<0)
        {
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter the value in the Range(0,100)'));
        return null;
        }
    
        
        this.coverageList.clear();
        Map<Id,CodeCoverageAggregateWrapper> wrapperMap = new Map<Id,CodeCoverageAggregateWrapper>();
        
        String query = 'Select ApexClassOrTriggerId, NumLinesCovered,NumLinesUncovered From ApexCodeCoverageAggregate where NumLinesUncovered != null Order By ApexClassOrTriggerId,NumLinesCovered limit 250 offset '+ String.valueOf(offsetNumber);
        ToolingAPIWSDL.QueryResult qr = toolingApi.query(query,'ToolingAPIWSDL.ApexCodeCoverageAggregate');
        
       
        
        for(ToolingAPIWSDL.ApexCodeCoverageAggregate ag : (List<ToolingAPIWSDL.ApexCodeCoverageAggregate>)qr.records){   
           
            //System.debug('ag __'+' '+ ag.ApexClassOrTriggerId+' '+ag.ApexClassOrTrigger.name+' '+ag.NumLinesCovered+ ' '+ ag.NumLinesUncovered);
            CodeCoverageAggregateWrapper w = new CodeCoverageAggregateWrapper(ag); 
            wrapperMap.put(ag.ApexClassOrTriggerId,w);
            if(w.percentage <=i )
            this.coverageList.add(w);
            
        }
     
        for(ApexClass ac : [Select Name, LastModifiedDate From ApexClass Where Id in :wrapperMap.keySet()]){
            wrapperMap.get(ac.Id).name=ac.Name;
            if(ac.LastModifiedDate != null)
            wrapperMap.get(ac.Id).LastModified=ac.LastModifiedDate.format('dd/MM/yyyy');
        }

        for(ApexTrigger at : [Select Name, LastModifiedDate From ApexTrigger Where Id in :wrapperMap.keySet()]){
            wrapperMap.get(at.Id).name=at.Name;
            if(at.LastModifiedDate != null)
            wrapperMap.get(at.Id).LastModified=at.LastModifiedDate.format('dd/MM/yyyy');
        }
        Integer count=0;
        for(count=0; count < coverageList.size(); count++) if(coverageList[count].name =='' || coverageList[count].name == null || coverageList[count].LastModified == null) 
        { System.debug('Removing '+ count + ' '+coverageList[count]);coverageList.remove(count); }
        }
        catch(Exception e)
        {
            System.debug('Exception in Calculate '+ e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
        }
        return null;
    }
    
    
    public PageReference OrgWideCodeCoverage()
    {
        
        this.coverageData.clear();
        cov = 0;    
        ToolingAPIWSDL.QueryResult qr = toolingApi.query('Select PercentCovered  From ApexOrgWideCoverage','ToolingAPIWSDL.ApexOrgWideCoverage');
        //System.debug('qr__'+qr);
        
        for(ToolingAPIWSDL.ApexOrgWideCoverage ag : (List<ToolingAPIWSDL.ApexOrgWideCoverage>)qr.records){
           // System.debug('ag__'+ag.PercentCovered);
            cov = ag.PercentCovered;
        }
        //cov = cov+37;
        
        return null;
    }
    
    public PageReference collectTestClasses()
    {
        try
        {
        String ClassId = ApexPages.currentPage().getParameters().get('classname');
        String query = 'Select ApexTestClassId, TestMethodName,NumLinesUncovered,NumLinesCovered  From ApexCodeCoverage where ApexClassorTriggerId = \'' + ClassId +'\' Order By NumLinesCovered desc limit 250';
           
        ToolingAPIWSDL.QueryResult qr = toolingApi.query(query,'ToolingAPIWSDL.ApexCodeCoverage');
        //System.debug('qr__'+qr);
        if(qr != null)
        for(ToolingAPIWSDL.ApexCodeCoverage ag : (List<ToolingAPIWSDL.ApexCodeCoverage>)qr.records){
            
           
           CodeCoverageWrapper c = new CodeCoverageWrapper(ag);
           ApexClass a = classMap.get(ag.ApexTestClassId);
           if(a!= null) c.ApexTestClassName = a.Name;
           
           testClassesList.add(c);
           
        }
        }
        catch(Exception e)
        {
            System.debug('Exception in Finding test classes '+ e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
        }
        
        return null;
    }
    
    public PageReference nextSetClasses()
    {
        System.debug('nextSetClasses componentCount '+ componentCount + ' offsetNumber:'+ offsetNumber);
        
        offsetNumber += 250;
            
        calculate();
        
        return null;
    }
    
    public PageReference prevSetClasses()
    {
        System.debug(' prevSetClasses componentCount '+ componentCount + ' offsetNumber:'+ offsetNumber);
        
        offsetNumber -= 250;
            
        calculate();
        
        return null;
    }
    
    public Boolean gethasNext()
    {
        
        if(offsetNumber + 250 <= componentCount)
        return true;
        else 
        return false;
    }
    public Boolean gethasPrev()
    {
        
        if(offsetNumber  >= 250)
        return true;
        else 
        return false;
    }

    public class CoverageData {
        public String  name {get; private set;}
        public Decimal size {get; private set;}
        public String chartColor {get; private set;}
        public CoverageData(String name, Decimal data) {
            this.name = name;
            this.size = data;
        }
    }

    public class CodeCoverageAggregateWrapper{
        public Id      classId    {get; private set;}
        public String  name       {get; set;        }
        public Integer uncovered  {get; private set;}
        public Integer covered    {get; private set;}
        public Decimal percentage {get; private set;}
        public Integer totalLines {get; private set;}
        public String LastModified {get;set;}
        public CodeCoverageAggregateWrapper(ToolingAPIWSDL.ApexCodeCoverageAggregate ag){
        
            //System.debug(' ag ___ '+ ag);
            this.name       = '';
            this.classId    = ag.ApexClassOrTriggerId;
            this.covered    = ag.numLinesCovered;
            this.uncovered  = ag.numLinesUncovered;
            //this.totalLines = this.uncovered + this.covered;
            if(this.uncovered != null) this.totalLines = this.uncovered + this.covered;
            else
            this.totalLines = this.covered;
            this.percentage = this.covered > 0 ? (100*this.covered)/(this.totalLines) : 0;

        }
    }
    
    public class CodeCoverageWrapper{
        
        public String ApexTestClassId{get;set;}
        public String TestMethodName{get;set;}
        public String ApexTestClassName{get;set;}
        public Decimal percentage {get; set;}
        
        public CodeCoverageWrapper()
        {
            ApexTestClassId =TestMethodName =ApexTestClassName ='';
        }
        
        public CodeCoverageWrapper(ToolingAPIWSDL.ApexCodeCoverage a)
        {
            this.ApexTestClassId = a.ApexTestClassId;
            this.TestMethodName = a.TestMethodName;
            this.percentage = (a.NumLinesUncovered != null && a.NumLinesCovered>0)? (100*a.NumLinesCovered)/(a.NumLinesUncovered+a.NumLinesCovered) : 0;
        }
        
    }

}