trigger UpdateTrackCount on Track__c (before insert, after update,  after delete, after undelete) {
    if (   Trigger.isInsert || Trigger.isUndelete) {
        Set <Id> updatedSongId = new Set <Id>();
        List <Song__c> updatedSong = new List<Song__c>();
        Map <Id, Song__c> songs = new Map  <Id, Song__c> ([SELECT id, Track_Count__c, Track_Licenses__c FROM Song__c ]);    
        for (Track__c track : Trigger.New) {
            Song__c currentSong =  songs.get(track.Song__c);
            if (currentSong.Track_Count__c == currentSong.Track_Licenses__c) {
                track.addError('You exeeded the limits of using that song.');
            }
            else {
                currentSong.Track_Count__c++;  
        	    updatedSongId.add(currentSong.Id);
            }           
        }
        for (Id i:  updatedSongId) {
        	updatedSong.add(songs.get(i));		   
        }
        update updatedSong;
        
    }
    if(Trigger.isDelete) {
        Set <Id> updatedSongId = new Set <Id>();
        List <Song__c> updatedSong = new List<Song__c>();
        Map <Id, Song__c> songs = new Map  <Id, Song__c> ([SELECT id, Track_Count__c, Track_Licenses__c FROM Song__c ]);    
        for (Track__c track : Trigger.Old) {
            Song__c currentSong =  songs.get(track.Song__c);
            currentSong.Track_Count__c--;
            updatedSongId.add(currentSong.Id);
        }
        for (Id i:  updatedSongId) {
        	updatedSong.add(songs.get(i));		   
        }
        update updatedSong;
        
    }
   if(Trigger.isUpdate) {
       
       
    }
}