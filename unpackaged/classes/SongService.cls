/**
 * Created by HP on 22.11.2017.
 */
public class SongService
{
	public static void recalculateTrCount (Map<Id,Song__c> mapSong, Map<Id, Track__c> newMap)
		{
			for (Song__c song : mapSong.values())
				{
					Integer trackCount = song.Tracks__r.size();
					Integer trackLicence = (Integer)song.Track_Licenses__c;
					if(trackCount > trackLicence)
					{
						for (Track__c track : song.Tracks__r )
							{
								Track__c  triggerContextTrack = newMap.get(track.Id);
								if ( triggerContextTrack != null)
								{
									triggerContextTrack.addError('You exeeded the limits of using that song.');
								}
							}
					} else
					{
						song.Track_Count__c = trackCount;
					}
				}
			update mapSong.values();
		}

	public static Map<Id, Song__c> getRelatedSongs(Set<Id> relatedSongsID)
	{
		Map<Id,Song__c> relatedSongs = new Map <Id,Song__c> ([SELECT name,Genre__c, Track_Count__c, Track_Licenses__c,
				(SELECT  Name,Song__c
						FROM  Tracks__r)
				FROM  Song__c
				WHERE Id in : relatedSongsID]);
		return relatedSongs;


	}


}