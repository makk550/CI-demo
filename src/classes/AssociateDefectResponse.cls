/*
Created By: Tarun Sharma
Created On: 10/05/2015
Purpose: Response class for defectAssociateController
Modified By:
*/
public class AssociateDefectResponse{
    public String operation;
    public Boolean successful;
    public List<Errors> errors;
    public List<Warnings> warnings;   
    public Defect defect;
    
    public Class Defect{
        public String defectNumber;
        public String defectId;
        public String subject;
        public String description;
        public String status;
        public String defectSeverity;
        public String defectPripority;
        public String defectOwner;
        public String targetedReleaseNumber;
        public String targetReleaseDate;
        public String resolution;
        public String uiURL;
        public Boolean blocked;
        public String blockedReason;
        public String workspaceName;
        public String defectType;
    }
    
    public Class Errors{
        public String cause;
        public String detail;        
    } 
    
    public Class Warnings{
        public String cause;
        public String detail;        
    }
}

/*[
    {
        "operation": "GET",
        "successful": true,
        "errors": null,
        "warnings": null,
        "defect": {
            "defectNumber": "DE33664",
            "defectId": "https://rally1.rallydev.com/slm/webservice/v2.0/defect/43980265138",
            "subject": "Incide Subject",
            "description": "Create an incident",
            "status": "Submitted",
            "defectSeverity": "4 - Minor",
            "defectPripority": "4 - Low",
            "defectOwner": null,
            "targetedReleaseNumber": null,
            "targetReleaseDate": "2015-10-09T02:25:00.857-04:00",
            "resolution": "None",
            "comments": [
                {
                    "comment": "Commenter: vojja01 <br>On: 2015-04-16T16:04:40+05:30 <br><br>Comment 1",
                    "date": "2015-10-01T01:06:03.687Z",
                    "author": "toolsadmin@ca.com",
                    "authorName": null
                },
                {
                    "comment": "Commenter: vojja01 <br>On: 2015-04-16T16:04:40+05:30 <br><br>Comment 2",
                    "date": "2015-10-01T01:06:04.224Z",
                    "author": "toolsadmin@ca.com",
                    "authorName": null
                }
            ]
        }
    }
]*/