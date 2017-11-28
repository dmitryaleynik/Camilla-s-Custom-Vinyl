/**
 * Created by HP on 22.11.2017.
 */
public class SongService
{
    public static Map<Id, Song__c> getAppropriateSongs(List<Track__c> tracks)
    {
        Set <Id> usedSongId = new Set <Id>();
        for (Track__c track : tracks)
        {
            usedSongId.add(track.Song__c);
        }
        Map <Id, Song__c> appropriateSongs = new Map <Id, Song__c> (
                [SELECT id, Track_Count__c, Track_Licenses__c,Genre__c
                 FROM Song__c
                 WHERE Id in :usedSongId ]);
        return appropriateSongs;
    }
    
	public static List<Song__c> getRelatedSongs(List<Track__c> tracks)
		{
			Set <Id> usedSongId = new Set <Id>();
			for (Track__c track : tracks)
            {
					usedSongId.add(track.Song__c);
			}
			return[
				SELECT id, Track_Count__c, Track_Licenses__c, Genre__c, Name, Length_m__c
				FROM Song__c
				WHERE Id in :usedSongId ];
		}
}