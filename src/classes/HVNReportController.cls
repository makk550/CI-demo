global class HVNReportController {

    public List<HVN__c> hvnRecord { get; set; }
    public List<HVN_Educational_Background__c> Educations { get; set; }
    public Integer EducationsListSize { get; set; }

    public List<HVN_Professional_Experience__c> ProExp { get; set; }
    public Integer ProfessionalListSize { get; set; }

    public List<HVN_Affiliation__c> Affiliations { get; set; }
    public Integer AffiliationsListSize { get; set; }

    public List<HVN_Memberships__c> Memberships { get; set; }
    public Integer MembershipsListSize { get; set; }

    public List<HVN_Survey__c> Surveys { get; set; }
    public Integer SurveysListSize { get; set; }

    public List<HVN_Activities__c> Activities { get; set; }
    public Integer ActivitiesListSize { get; set; }

    public List<Executive_Contact__c> ExecContact { get; set; }
    public Integer ExecContactListSize { get; set; }
    
    public HVNReportController(){
        string hvnId=   ApexPages.currentPage().getParameters().get('id');
        hvnRecord       =       [select Contact__r.Account.Sales_Area__c,Contact__r.MobilePhone,Id,Name,Next_Touchpoint_2__c,
        Last_Touchpoint__c,Last_Touchpoint_Contact_by__c,Last_Touchpoint_Date__c,HVN_Contact_Photo__c,Role__c,Relationship_Status__c,
        Relationship_Status_Graphic__c,Secondary_HVN_Contact_Owner_1__r.Name,Secondary_HVN_Contact_Owner_2__r.Name,
        Secondary_HVN_Contact_Owner_3__r.Name,Primary_HVN_Owner__r.Name,Primary_HVN_Owner__r.User_Photo__c,Contact__r.Account.Id,
        Contact__r.Account.Name,Contact__r.Account.Company_Logo__c,Contact__r.Account.Owner.User_Photo__c,Contact__r.Account.Owner.Name,
        Contact__r.Name,Contact__r.Title,Contact__r.Email,Contact__r.Account.OwnerId,Contact__r.Account.Company_Overview__c, 
        Birthday_Month__c, Birthday_Year__c, Subscription__c, Subscription_Other__c, Military_Service__c, College_Fraternity_Sorority__c,Awards_Recognition__c,  
        Public_Speaker__c, Additional_Language__c, Family_Information__c, Additional_Information__c, Community_Involvement__c, Hobbies__c,
        Hobbies_Other__c, Music_Style__c, Holiday_Celebrations__c, Holiday_Celebrated_Other__c, Culinary_Preference__c, Favorite_Charity__c,
        Movie_Genre__c, Favorite_Movie__c, TV_Genre__c, Favorite_TV_Show__c, Book_Preference__c, Sports__c, Sport_Other__c,
        Preferred_Events__c, Preferred_Events_Other__c, External_Picture__c, Dietary_Requirements__c, Dietary_Requirements_Other__c, Gift_Limit_Amount__c, Gift_Currency__c              
        from HVN__c where Id=:hvnID limit 1];

        Educations      =       [Select Year__c, Name, Id, HVN_Contact__c, Field_of_Studies__c, Alma_Mater__c From HVN_Educational_Background__c where HVN_Contact__c=:hvnId order by Year__c desc];
        EducationsListSize = Educations.size();
                 
        ProExp          =       [Select Title__c, Tenure__c, Status__c, Id, HVN_Contact__c, Company_Name__c, Role_Description__c From HVN_Professional_Experience__c where HVN_Contact__c=:hvnId order by Status__c asc];
        ProfessionalListSize = ProExp.size();

        Affiliations=   [Select Name, HVN_Contact__c, Notes__c From HVN_Affiliation__c where HVN_Contact__c=:hvnId order by Name asc];
        AffiliationsListSize = Affiliations.size();

        Memberships =   [Select Name, HVN_Contact__c, Notes__c From HVN_Memberships__c  where HVN_Contact__c=:hvnId order by Name asc];
        MembershipsListSize = Memberships.size();

        Surveys         =       [Select Survey_Period__c, Survey_Period_Quarter__c, Recommend_CA__c, Name, HVN_Contact__c, Desired_Relationship__c, Current_Relationship__c, Completion_Status__c From HVN_Survey__c where HVN_Contact__c=:hvnId order by Survey_Period__c asc];
        SurveysListSize = Surveys.size();

        Activities      =       [Select Topic_Covered__c, Speaker__c, Participation_Status__c, Participation_Invitation__c, Name, HVN_Contact__c, Event_Other__c, Event_Name__c, Date__c From HVN_Activities__c  where HVN_Contact__c=:hvnId order by Date__c desc];
        ActivitiesListSize = Activities.size();
                
        ExecContact             =               [Select Name, Id, HVN_Contact__c, Notes__c From Executive_Contact__c where HVN_Contact__c=:hvnId order by Name];
        ExecContactListSize = ExecContact.size();
    }

    static testMethod void runTest() {
        HVNReportController hctl = new HVNReportController();
    }
}