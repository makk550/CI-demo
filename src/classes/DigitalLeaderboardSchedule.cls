global class DigitalLeaderboardSchedule implements Schedulable {
   global void execute(SchedulableContext ctx) {
        DigitalLeaderboardController.SaveTeamPhotos('NA');
        DigitalLeaderboardController.SaveTeamPhotos('EMEA');
        DigitalLeaderboardController.SaveTeamPhotos('APJ');
        DigitalLeaderboardController.SaveTeamPhotos('LA');
        DigitalLeaderboardController.SaveTeamPhotos('GLOBAL');
   }   
}