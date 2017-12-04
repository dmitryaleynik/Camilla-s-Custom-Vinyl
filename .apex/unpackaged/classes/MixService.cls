/**
 * Created by HP on 22.11.2017.
 */
public class MixService
{
    public static void setGenre(Map<Id, Mix__c> mapMix )
    {

        for (Mix__c mix : mapMix.values())
        {
            mix.Secondary_Genre__c = null;
            mix.Primary_Genre__c = null;
        }
        system.debug(mapMix);
        AggregateResult [] aggregateResult = [SELECT count(Id) number, Mix__c mixId, Song__r.Genre__c genre
                                              FROM Track__c
                                              WHERE Mix__C in :mapMix.keySet()
                                              GROUP BY Song__r.Genre__c, Mix__c
                                              ORDER BY Mix__c, count(Id) DESC, Song__r.Genre__c];
        System.debug(aggregateResult);

        Id processingMixId;
        for (Integer i=0; i<aggregateResult.size();i++)     // take two first record for every Mix
        {
            if(processingMixId != aggregateResult[i].get('MixId'))
            {
                processingMixId = (Id)aggregateResult[i].get('MixId');
                Mix__c processingMix = mapMix.get(processingMixId);
                if(i+1 < aggregateResult.size() &&  processingMixId == aggregateResult[i+1].get('mixId') )
                {
                    processingMix.Primary_Genre__c = (String)aggregateResult[i].get('genre');
                    i++;
                    processingMix.Secondary_Genre__c = (String)aggregateResult[i].get('genre');
                    system.debug(processingMix);
                    continue;
                }else
                {
                    processingMix.Primary_Genre__c = (String)aggregateResult[i].get('genre');
                    processingMix.Secondary_Genre__c = null;
                    system.debug('norm');
                    continue;
                }
            } else
            {
                continue;
            }
        }
        update mapMix.values();
    }
    public static Map<Id, Mix__c> getRelatedMixes (Set <Id> mixIds ){
		Map <Id, Mix__c> mapMix = new Map<Id, Mix__c>([SELECT  Name, Primary_Genre__c, Secondary_Genre__c
				FROM  Mix__c
				WHERE id in :mixIds]);
		return  mapMix;
	}

}