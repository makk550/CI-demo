global class GlobalLeaderboardDealsScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
	
	GlobalLeaderboardController.saveDealsdatatoDOC('bookeddeals');
	GlobalLeaderboardController.saveDealsdatatoDOC('likelydeals');        
        
        
    }

}