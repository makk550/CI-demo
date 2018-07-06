public with sharing class PDDHistoryController {  
    //Protected Members
    private static final DescribeSObjectResult oPDDSchema = Schema.SObjectType.PDD__c;
    private static final Map<string, Schema.SObjectField> mapFields = oPDDSchema.fields.getMap();

    //Properties
    public List<String> PDDIds {get;set;}
    public integer PageSize {get;set;}
    public boolean AllowShowMore {get;set;}
    public String sdunsID {get;set;}
    public String materialID {get;set;}

    public List<PDDHistory> PDDHistories {
        get { return getPDDHistory(PDDIds); }
    }

    //Constructors

    /**
     * Default Constructor
     */
    public PDDHistoryController() {
    
        PDDIds =new List<String>();
        sdunsID = ApexPages.currentPage().getParameters().get('myDID');
        materialID = ApexPages.currentPage().getParameters().get('materialId');
        for(PDD__c inst :[select id from PDD__c where Instance__r.Account_ID__c=:sdunsID And Instance__r.Product_Material__c =:materialID ]){
            PDDIds.add(inst.Id);
        }
        
        PageSize = 10;   
        AllowShowMore = true;
    }

    //Public Methods
    public void showMore() {
        PageSize += 10;
    }

    //Private Methods

    /**
     * Returns PDD History records associated to the current PDD
     *
     * @param   PDDId     the PDD__c record id to retrieve
     * @return  a list of PDDHistory objects
     */
    public List<PDDHistory> getPDDHistory(List<String> PDDIds) {
        List<PDDHistory> listPDDHistory = new List<PDDHistory>();

        if (PDDIds != null) {
            DateTime dLastCreatedDate = null;

            integer limitPlusOne = PageSize + 1;

            List<PDD__History> listEntityHistory = [SELECT Id, Field, NewValue, OldValue, CreatedDate, CreatedById, CreatedBy.Name,Parent.Instance__r.Name FROM PDD__History WHERE ParentId IN :PDDIds ORDER BY CreatedDate DESC, Id DESC LIMIT :limitPlusOne];
            AllowShowMore = (listEntityHistory.size() == limitPlusOne);

            for (PDD__History oHistory : listEntityHistory) {
                PDDHistory oPDDHistory = new PDDHistory(oHistory);

                if (mapFields.containsKey(oHistory.Field)) {
                    oPDDHistory.FieldLabel = mapFields.get(oHistory.Field).getDescribe().Label;
                }

                if (dLastCreatedDate == oHistory.CreatedDate) {
                    oPDDHistory.ShowDateAndUser = false;
                }
                else {
                    oPDDHistory.ShowDateAndUser = true;
                }

                listPDDHistory.add(oPDDHistory);
                dLastCreatedDate = oHistory.CreatedDate;

                if (listPDDHistory.size() == PageSize) break;
            }
        }

        return listPDDHistory;
    }

    //Internal Classes

    /**
     * Data structure representing a PDD History record for display
     */
    public class PDDHistory {
        //Properties
        public boolean ShowDateAndUser {get;set;}
        public string FieldLabel {get;set;}
        public PDD__History History {get; private set;}

        public string ActionFormat {
            get { return getActionFormat(); }
        }

        public PDDHistory(PDD__History oHistory) {
            History = oHistory;
        }

        //Constructors
        public PDDHistory() {
            showDateAndUser = true;
        }

        //Private Methods
        public string getActionFormat() {
            string sActionFormat = '';

            if (History != null) {
                sActionFormat = 'Record {0}.';

                if (History.newValue != null && History.oldValue == null) {
                    sActionFormat = 'Changed <strong>{1}</strong> to <strong>{3}</strong>.';    
                }
                else if (History.newValue != null && History.oldValue != null) {
                    sActionFormat = 'Changed <strong>{1}</strong> from {2} to <strong>{3}</strong>.';   
                }
                else if (History.Field != null && History.Field.equalsIgnoreCase('created')) {
                    sActionFormat = 'Created.';
                }
            }

            return sActionFormat;
        }
    }
}