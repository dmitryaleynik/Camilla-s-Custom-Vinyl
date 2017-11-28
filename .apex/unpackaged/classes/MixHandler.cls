/**
 * Created by HP on 22.11.2017.
 */
public class MixHandler implements  TriggerTemplate.Handler
{
    private List<Mix__c> newValues;
    private List<Mix__c> oldValues;
    private Map<Id, Mix__c> oldMap;

    public  void setValues (List<sObject> newValues, List<sObject> oldValues, Map<Id,sObject> oldMap)
    {
        this.newValues = newValues;
        this.oldValues = oldValues;
        this.oldMap = (Map<Id, Mix__c>) oldMap;
    }
    
    public void handle (TriggerTemplate.TriggerAction action) 
    {
        if (action == TriggerTemplate.TriggerAction.afterUpdate)
        {
            //MixService.setPrimaryAndSecondaryGenre(newValues);
        }

        if (action == TriggerTemplate.TriggerAction.afterInsert)
        {
            //MixService.setPrimaryAndSecondaryGenre(newValues);
        }
        if (action == TriggerTemplate.TriggerAction.beforeDelete)
        {
			MixService.updSongBeforeMixDel(oldValues);
        }
        if (action == TriggerTemplate.TriggerAction.afterUndelete)
        {
			MixService.updSongAfterUndel(newValues);
        }
    }
}