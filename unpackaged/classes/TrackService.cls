/**
 * Created by HP on 22.11.2017.
 */
public class TrackService
{
    public static void updTrCountAfterIns(List<Track__c> newValues)
    {
        Map<Id, Song__c> appropriateSongs = SongService.getAppropriateSongs(newValues);
        for (Track__c track : newValues)
        {
            Song__c currentSong = appropriateSongs.get(track.Song__c);
            if (currentSong.Track_Count__c == currentSong.Track_Licenses__c)
            {
                track.addError('You exeeded the limits of using that song.');
            } else
            {
                currentSong.Track_Count__c++;
            }
        }
        update appropriateSongs.values();
    }

    public static void updTrCountAfterUndel (List<Track__c> newValues)
    {
        Map<Id, Song__c> appropriateSongs = SongService.getAppropriateSongs(newValues);
        for (Track__c track : newValues)
        {
            Song__c currentSong = appropriateSongs.get(track.Song__c);
            if (currentSong.Track_Count__c == currentSong.Track_Licenses__c)
            {
                track.addError('You exeeded the limits of using that song.');
            } else
            {
                currentSong.Track_Count__c++;
            }
        }
        update appropriateSongs.values();
    }

    public static void updTrCountAfterDel(List<Track__c> oldValues)
    {
        Map<Id, Song__c> appropriateSongs = SongService.getAppropriateSongs(oldValues);
		System.debug(appropriateSongs);
        for (Track__c track : oldValues)
        {
            Song__c currentSong = appropriateSongs.get(track.Song__c);
			System.debug(currentSong);
            currentSong.Track_Count__c--;
        }
        update appropriateSongs.values();
    }

    public static void updTrCountAfterUpd(List<Track__c> newValues, Map<Id, Track__c> oldMap)
    {
        Map<Id, Song__c> appropriateSongs = SongService.getAppropriateSongs(newValues);
        for (Track__c track : newValues)
        {
            Song__c currentSong = appropriateSongs.get(track.Song__c);
            Song__c laterSong = appropriateSongs.get(oldMap.get(track.Id).Song__c);
            if (laterSong != currentSong)
            {
                if (currentSong.Track_Count__c == currentSong.Track_Licenses__c)
                {
                    track.addError('You exeeded the limits of using that song.');
                } else
                {
                    laterSong.Track_Count__c--;
                    currentSong.Track_Count__c++;
                }
            }
        }
        update appropriateSongs.values();
    }
    
    public static List<Track__c> getRelatedTrack (List<Mix__c> mixes)
    {
		Set<Id> mixesID = new Set<Id>();
		for (Mix__c mix : mixes)
        {
			mixesID.add(mix.Id);
		}
		return [SELECT name,Song__c FROM Track__c WHERE Mix__c IN :mixesId];
	}
    
}