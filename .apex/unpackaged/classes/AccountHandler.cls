public class AccountHandler {
    public static void onAfterUpdate(List <Order__c> orders)
    {
       Set <Id> parentId = Utils.getParentIds(orders,'Account__c');
        Map <Id, Account> relatedAccount = new Map<Id, Account>([SELECT Total_Income__c, Last_Payment_Date__c
                                                    FROM Account 
                                                    WHERE id in :parentId]);
        AggregateResult [] aggregateResults = [SELECT Sum(Payment_Amount__c), Account__c
                                               FROM Order__c 
                                               WHERE Account__c in :parentId 
                                               GROUP BY Account__c];
        for(AggregateResult aggRes : aggregateResults)
        {
            
        }
        
    }
       
  
}