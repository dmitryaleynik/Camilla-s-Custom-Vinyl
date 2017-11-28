public without sharing class TrackHandler implements TriggerTemplate.Handler
{
	private List<Track__c> newValues;
	private List<Track__c> oldValues;
	private Map<Id, Track__c> oldMap;

	public void setValues(List<sObject> newValues, List<sObject> oldValues, Map<Id, sObject> oldMap)
	{
			this.newValues = newValues;
			this.oldValues = oldValues;
			this.oldMap = (Map<Id, Track__c>) oldMap;
	}

	public void handle(TriggerTemplate.TriggerAction action)
    {
			if (action == TriggerTemplate.TriggerAction.afterUpdate)
			{
				TrackService.updTrCountAfterUpd(newValues, oldMap);
				MixService.setPrimaryAndSecondaryGenre(MixService.getAppropriateMix(newValues));
			}

			if (action == TriggerTemplate.TriggerAction.afterInsert)
			{
				TrackService.updTrCountAfterIns(newValues);
				MixService.setPrimaryAndSecondaryGenre(MixService.getAppropriateMix(newValues));
			}

			if (action == TriggerTemplate.TriggerAction.afterUndelete)
			{
				TrackService.updTrCountAfterUndel(newValues);
				MixService.setPrimaryAndSecondaryGenre(MixService.getAppropriateMix(newValues));

			}
			if (action == TriggerTemplate.TriggerAction.afterDelete)
            {
				TrackService.updTrCountAfterDel(oldValues);
				MixService.setPrimaryAndSecondaryGenre(MixService.getAppropriateMix(oldValues));
			}
		}
}