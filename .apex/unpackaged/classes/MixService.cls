/**
 * Created by HP on 22.11.2017.
 */
public class MixService
{
    public static void setPrimaryAndSecondaryGenre (List<Mix__c> newValues)
    {
        List<Mix__c> mixesToUpdate = new List<Mix__c>();
        for (Mix__c mix : newValues)
        {
            if (mix.Tracks__r.size() > 0)
            {
                List<String> currMaxGenres =getPrimeAndSecGenre(mix);
                mix.Primary_Genre__c = currMaxGenres.get(0);
                mix.Secondary_Genre__c = currMaxGenres.get(1);
                mixesToUpdate.add(mix);
            }
        }
        update mixesToUpdate;
    }

    private static Map<String, Integer> getNumberOfEachGenre (Mix__c mix)
	{
			List<String> primaryAndSecondaryGenre = new List<String>();
			Map<String, Integer> numOfEachGenre = new Map<String, Integer>();
			String maxUsedGenre;
			String secondMaxUsedGenre;
			Integer numOfMaxGenre = 0;
			Integer numOfSecondMaxUsedGenre = 0;
			Map<Id, Song__c> usedSongs = SongService.getAppropriateSongs(mix.Tracks__r);

			for (Track__c track : mix.Tracks__r)
            {
					Song__c currentSong = usedSongs.get(track.Song__c);
					String currentGenre = currentSong.Genre__c;
					Integer numOfCurrGenre = numOfEachGenre.get(currentGenre);
					if (numOfCurrGenre == null)
					{
						numOfCurrGenre = 1;
						numOfEachGenre.put(currentGenre, numOfCurrGenre);

					} else
					{
						numOfCurrGenre++;
						numOfEachGenre.put(currentGenre, numOfCurrGenre);
					}
					System.debug(numOfCurrGenre + '' + currentGenre);
			}
			return numOfEachGenre;
    }

	private static List <String> getPrimeAndSecGenre(Mix__c mix)
    {
		String primeGenre;
		Integer primeNumber = 0;
		String secGenre;
		Integer secNumber = 0;
		Map <String,Integer> numOfEachGenre = getNumberOfEachGenre(mix);
		for (String currGenre : numOfEachGenre.keySet())
        {
			Integer currNumber = numOfEachGenre.get(currGenre);
			if(primeNumber < currNumber)
            {
				secNumber = primeNumber;
				secGenre = primeGenre;
				primeNumber = currNumber;
				primeGenre = currGenre;
			} else if (secNumber < currNumber)
            {
				secNumber = currNumber;
				secGenre = currGenre;
			}
		}
		List<String> primAndSecGenre = new List<String>();
		primAndSecGenre.add(primeGenre);
		primAndSecGenre.add(secGenre);
		return primAndSecGenre;
	}

    public static  List<Mix__c> getAppropriateMix(List<Track__c> tracks)
    {
        Set<Id> mixID = new Set<Id>();
        for (Track__c track : tracks)
        {
            mixID.add(track.Mix__c);
        }
        return [SELECT  Name, Primary_Genre__c, Secondary_Genre__c,
         (SELECT Name, Song__c FROM  Tracks__r) FROM  Mix__c WHERE id in :mixID];

    }

	public static void updSongBeforeMixDel(List<Mix__c> oldValues)
    {
		List<Track__c> relatedTracks = TrackService.getRelatedTrack(oldValues);
		TrackService.updTrCountAfterDel(relatedTracks);
	}

	public static void  updSongAfterUndel(List<Mix__c> newValues)
    {
		List<Track__c> relatedTracks = TrackService.getRelatedTrack(newValues);
		TrackService.updTrCountAfterIns(relatedTracks);
	}

}