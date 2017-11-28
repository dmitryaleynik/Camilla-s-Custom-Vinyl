public class MixBuilderController {
	private Id id;
	private Mix__c mix {get;set;}

	 public MixBuilderController ()
	{
		System.debug('ds');
		id = ApexPages.currentPage().getParameters().get('Id');
		mix = (id==null)? new Mix__c(): [
			SELECT Name, (
					SELECT name,Song__c
					FROM Tracks__r), Primary_Genre__c, Secondary_Genre__c
			FROM Mix__c
			Where Id = :id
			  Limit 1];

		System.debug(mix);
	}

	public List<Song__c> getSongs ()
	{
		System.debug( SongService.getRelatedSongs(mix.Tracks__r));
		return  SongService.getRelatedSongs(mix.Tracks__r);

	}
}