public class MixBuilderController 
{
    private Id mixID;
    public Mix__c mix {get;set;}
    public List<WrapperResult> wrapper {get; set;}
    public  Set <Id> usedSongId {get; set;}
    public Integer mixTrackCount {get; set;}
    public Id clickedSongId {get;set;}
    public Double  mixLength {get; set;}
    public Integer remMixTracks {get; set;}
    public Double remMixLength {get; set;}
    public String filter {get; set;}

    public SelectOption paginationSizeOptions{get;set;}
    public static final Integer PAGE_SIZE = 5;

    public MixBuilderController ()
    {
        mixID = ApexPages.currentPage().getParameters().get('Id');
        wrapper = new List<WrapperResult>();
        usedSongId = new Set<Id>();
        filter = 'Any';

        if (mixID == null)
        {
            mix = new Mix__c();
            updateTable();
        }else
        {
            usedSongId = SongService.getUsedSongId(mixId);
            updateTable();
            mix = MixService.getMixById(mixID);
            updateMixCount();
            updateMixLength();
            updateRemMixLength();
            updateRemMixCount();
            //standardSetController = new ApexPages.StandardSetController(Database.query('Select'));
        }
    }

    public void updateTable ()
    {
        List<Song__c> filteredSongs;
        wrapper.clear();
        if (filter.equals('Any'))
        {
             filteredSongs = [SELECT Name, Genre__c, Length_m__c
                             FROM Song__c
                                ORDER BY  Name];

        }
        else
        {
            filteredSongs = [SELECT Name, Genre__c, Length_m__c
                            FROM Song__c
                            WHERE Genre__c = :filter
                                ORDER BY  Name];
        }
        for ( Song__c song : filteredSongs )
        {
            if(usedSongId.contains(song.Id))
            {
                wrapper.add(new WrapperResult(this, song, true));
            }
            else
            {
                wrapper.add(new WrapperResult(song));
            }
        }
    }

    public PageReference save()
    {
        return null;

    }
    public void updateMixLength ()
    {
        this.mixLength = SongService.getLengthOfSongs(usedSongId);
    }
    public void updateRemMixLength ()
    {
        this.remMixLength = 100 - SongService.getLengthOfSongs(usedSongId);
    }
    public void updateMixCount ()
    {
        this.mixTrackCount = usedSongId.size();
    }
    public void updateRemMixCount ()
    {
        this.remMixTracks = 20 - usedSongId.size();
    }

    public List<SelectOption> getItems ()
    {
        List <SelectOption> options = new List<SelectOption>();
        List<PicklistEntry> availableGenres = Song__c.Genre__c.getDescribe().getPicklistValues();
        options.add(new SelectOption('Any','Any'));
        for (PicklistEntry genre :availableGenres)
        {
            options.add(new SelectOption(genre.getValue() ,genre.getValue()));
        }
        System.debug(options);
        return options;
    }

    public void changeUsedSongs ()
    {
        System.debug(usedSongId);
        if (!usedSongId.remove(this.clickedSongId))
        {
            usedSongId.add(this.clickedSongId);
        }
        updateRemMixLength();
        updateMixLength();
        updateMixCount();
        updateRemMixCount();
        System.debug(usedSongId);
    }

     public class WrapperResult
    {
        public Boolean isSelected {get;set;}
        public Song__c song {get;set;}
        public MixBuilderController outerClass;
        public WrapperResult (Song__c song)
        {
            this.song = song;
            this.isSelected = false;
        }

        public WrapperResult (MixBuilderController outerClass, Song__c song,Boolean isSelected)
        {
            this.outerClass = outerClass;
            this.song = song;
            this.isSelected = isSelected;
        }

    }
}