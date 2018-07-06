global class GlobalLeaderboardSchedule implements Schedulable {
   global void execute(SchedulableContext ctx) {
        GlobalLeaderboardController.updatePhotosofJson('leaderboard');
        GlobalLeaderboardController.updatePhotosofJson('ranking');
   }   
}