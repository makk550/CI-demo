public class kbHitsController
{
    public list<VisualforceAccessMetrics> PageMetrics {get;set;}
    
    public kbHitsController()
    {
        PageMetrics = [ 
                            SELECT ApexPageId,DailyPageViewCount,Id,MetricsDate 
                             FROM VisualforceAccessMetrics where ApexPageID='0660c000000bMcF'
                      ];  
    }
    
}