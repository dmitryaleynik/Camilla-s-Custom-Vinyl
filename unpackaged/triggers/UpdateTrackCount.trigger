trigger UpdateTrackCount on Track__c (before insert, after update,  after delete, after undelete) {
    if (Trigger.isInsert) {
        List <Song__c> songs = new List <Song__c> ();
        List <Id> songId = new List <Id>();
        for (Track__c track : Trigger.New) {
            songId.add(track.Song__c);
        }
        for (Song__c song : [Select id,Track_Count__c,Track_Licenses__c FROM Song__c WHERE Id in :songId]) {
            if (song.Track_Count__c == song.Track_Licenses__c) {
            }
            song.Track_Count__c++;
            songs.add(song);
        }
        update songs;
    }
    if(Trigger.isDelete){
        List <Song__c> songs = new List <Song__c> ();
        List <Id> songId = new List <Id>();
        for (Track__c track : Trigger.New) {
            songId.add(track.Song__c);
        }
        for (Song__c song : [Select id,Track_Count__c,Track_Licenses__c FROM Song__c WHERE Id in :songId]) {
            song.Track_Count__c--;
            songs.add(song);
        }
        update songs;
    }

}
