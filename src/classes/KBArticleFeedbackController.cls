public class KBArticleFeedbackController {
    public String aNumber {get; set;} 
    public Id aId {get; set;}
    public KBArticle_Rating__c artFeedback {get; set;}
    public String contactName {get; set;} 
    public String contactEmail {get; set;}
    public String feedbackComment {get; set;} 
    public integer thumbsUpDownRating {get; set;}
    public Boolean renderGreyThumbsUp {get; set;}
    public Boolean renderGreyThumbsDown {get; set;}
    public boolean renderFeedbackInput {get; set;}
    public boolean renderFeedbackList {get; set;}
    public boolean renderAcknowledgement {get; set;}
    public boolean disableSubmitFeedback {get; set;}
    public boolean renderContactPanel {get; set;}
    public String legArticleNumber {get; set;}
    
    public String averageRatingTitle {
      get {
        averageRatingTitle = string.format(Label.AverageRateTitle, new String[]{String.valueOf(averageArticleRating), String.valueOf(articleVoteCount)});  
        System.debug('averageRatingTitle: '+averageRatingTitle);
        return averageRatingTitle;
      } 
      set;
    }

    public Decimal averageArticleRating {
      get{
        if(averageArticleRating == null && avgRating != null && avgRating.size() > 0) {
          averageArticleRating = avgRating[0].Average_Score__c.setScale(2, RoundingMode.HALF_UP);
        }
        else{
          averageArticleRating = 0.00;  
        }
          System.debug('averageArticleRating'+averageArticleRating);
        return averageArticleRating;
      }
      set;
    }
    
    public Decimal articleVoteCount{
      get{
        if(articleVoteCount == null && avgRating != null && avgRating.size() > 0) {
          articleVoteCount = avgRating[0].Vote_Count__c;  
        }
        else{
          articleVoteCount = 0;  
        }
        return articleVoteCount;
      }
      set;
    }
    
    public List<KBArticle_Average_Rating__c> avgRating {
      get{
        if(avgRating == null) {
          avgRating = [SELECT Id, Name, Average_Score__c, Vote_Count__c 
                    FROM KBArticle_Average_Rating__c 
                    WHERE Name = :aNumber];  
        }
      
        return avgRating;  
      }
      set;
    }
    public List<KBArticle_Rating__c> feedbackList {
        get{            
            feedbackList = con.getRecords();
            return feedbackList;
        }
        set;
    }
    
    public KBArticleFeedbackController(){
        renderFeedbackInput = true;
        renderAcknowledgement = false;
        renderFeedbackList = true;
        renderGreyThumbsUp = true;
        renderGreyThumbsDown = true; 
        disableSubmitFeedback = true;
        thumbsUpDownRating = 0;
        renderContactPanel = false;
    }

    public void save(){
        artFeedback = new KBArticle_Rating__c();
        artFeedback.Name = aNumber;       
        artFeedback.Article_Rating__c = thumbsUpDownRating;
        artFeedback.Feedback_By__c = contactName;
        artFeedback.Contact_Email__c = contactEmail;
        artFeedback.Feedback_Comments__c = feedbackComment;
        artFeedback.Legacy_Article_Number__c = legArticleNumber;
        if(avgRating != null && avgRating.size() > 0) {         
            artFeedback.KBArticle_Average_Rating__c = avgRating[0].Id;
        }
        else {
            KBArticle_Average_Rating__c avgArtRating = new KBArticle_Average_Rating__c(Name = aNumber, Average_Score__c = 0.0, Legacy_Article_Number__c=legArticleNumber);
            insert avgArtRating;
            artFeedback.KBArticle_Average_Rating__c = avgArtRating.Id;            
        }
        
        try{
            insert artFeedback;  
            renderAcknowledgement = true;
            renderFeedbackInput = false;
           
        }catch(exception ex){
            renderAcknowledgement = false;
        }     
    } 
    
    public void disableSubmitButton(){     
        disableSubmitFeedback = (feedbackComment != '' ||  thumbsUpDownRating != 0) ? false : true;
    }
    
    public void reset() {
        renderFeedbackInput = true;
        renderGreyThumbsUp = true;
        renderGreyThumbsDown = true; 
        renderContactPanel =false;
        disableSubmitFeedback = true;
        thumbsUpDownRating = 0;
        contactName = '';
        contactEmail = '';
        feedbackComment = '';
    }
    
    public PageReference backToArticle() { 
        PageReference previousPage;
        if(aId==null)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Article '+aNumber+' doesnot exist or might be permanently archived. Please ensure the article number is correct'));
        }
        else
        {
         previousPage = new Pagereference('/'+aId);  
        }
        return previousPage;
    }

    /*public void requestFeedback() { 
        renderFeedbackInput = true;
    }*/
    
     public void incrementVoteCount()
    {
        
        thumbsUpDownRating = 100;
        renderGreyThumbsUp = false;
        renderGreyThumbsDown = true;
        renderContactPanel = true;
        disableSubmitButton();
    }
    
    public void decrementVoteCount()
    {
        thumbsUpDownRating = 20;
        renderGreyThumbsUp = true;
        renderGreyThumbsDown = false;
        renderContactPanel = true;
        disableSubmitButton();
    }
    
    // instantiate the StandardSetController from a query locator
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Article_Rating__c, Feedback_Comments__c, CreatedDate, Feedback_By__c, Contact_Email__c
                                FROM KBArticle_Rating__c 
                                WHERE name =: aNumber
                                ORDER BY CreatedDate DESC]));
                // sets the number of records in each page set
                con.setPageSize(10);
            }
            return con;
        }
        set;
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    // returns the first page of records
    public void first() {
        con.first();
    }

    // returns the last page of records
    public void last() {
        con.last();
    }

    // returns the previous page of records
    public void previous() {
        con.previous();
    }

    // returns the next page of records
    public void next() {
        con.next();
    }
}