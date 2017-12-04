public class MixBuilderController {
	private Id id;
	public Mix__c mix {get;set;}
    public String name {get;set;}
    public Contact customer {get;set;}
   
	 public MixBuilderController ()
	{
		System.debug('ds');
		id = ApexPages.currentPage().getParameters().get('Id');
		mix = (id==null)? new Mix__c(): [SELECT Name,Primary_Genre__c,Secondary_Genre__c,
					                                                 ( SELECT name,Song__c
                                                                       FROM Tracks__r)
                   
			FROM Mix__c
			Where Id = :id
			Limit 1];
        if (mix != null)
        {
            name = mix.Name;
            customer = [SELECT name 
                        FROM Contact
                        WHERE Id = :mix.Customer__c 
                        LIMIT 1];
        }
        else
        {
            name = 'New Mix';
        }

		System.debug(mix);
	}
   

	public List<Song__c> getSongs ()
	{
        return [SELECT name,Genre__c,Length_m__c  FROM Song__c];

	}

}