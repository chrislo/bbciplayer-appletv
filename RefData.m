#import "RefData.h"

@implementation RefData

+ (NSArray *)categories {
	return [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:@"Children's",        @"name", @"childrens",           @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Comedy",            @"name", @"comedy",              @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Drama",             @"name", @"drama",               @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Entertainment",     @"name", @"entertainment",       @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Factual",           @"name", @"factual",             @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Films",             @"name", @"films",               @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Music",             @"name", @"music",               @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"News",              @"name", @"news",                @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Religion & Ethics", @"name", @"religion_and_ethics", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Sport",             @"name", @"sport",               @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Sign Zone",         @"name", @"signed",              @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Audio Described",   @"name", @"audiodescribed",      @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Northern Ireland",  @"name", @"northern_ireland",    @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Scotland",          @"name", @"scotland",            @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"Wales",             @"name", @"wales",               @"identifier", nil],
	nil];
}

+ (NSArray *)tvServices {
	return [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC One",          @"name", @"bbc_one",        @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Two",          @"name", @"bbc_two",        @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Three",        @"name", @"bbc_three",      @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Four",         @"name", @"bbc_four",       @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"CBBC",             @"name", @"cbbc",           @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"CBeebies",         @"name", @"cbeebies",       @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC News Channel", @"name", @"bbc_news24",     @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Parliament",   @"name", @"bbc_parliament", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC HD",           @"name", @"bbc_hd",         @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Alba",         @"name", @"bbc_alba",       @"identifier", nil],
	nil];
}

+ (NSArray *)networkRadioServices {
	return [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio 1",       @"name", @"bbc_radio_one",       @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC 1Xtra",         @"name", @"bbc_1xtra",           @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio 2",       @"name", @"bbc_radio_two",       @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio 3",       @"name", @"bbc_radio_three",     @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio 4",       @"name", @"bbc_radio_four",      @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio 5 live",  @"name", @"bbc_radio_five_live", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio 5 live sports extra", @"name", @"bbc_radio_five_live_sports_extra", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC 6 Music",       @"name", @"bbc_6music",          @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio 7",       @"name", @"bbc_7",               @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Asian Network", @"name", @"bbc_asian_network",   @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC World Service", @"name", @"bbc_world_service",   @"identifier", nil],
	nil];
}

+ (NSArray *)nationalRadioServices {
	return [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio Scotland",     @"name", @"bbc_radio_scotland",     @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio Nan Gàidheal", @"name", @"bbc_radio_nan_gaidheal", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio Ulster",       @"name", @"bbc_radio_ulster",       @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio Wales",        @"name", @"bbc_radio_wales",        @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Radio Cymru",        @"name", @"bbc_radio_cymru",        @"identifier", nil],
	nil];
}

+ (NSArray *)localRadioServices {
	return [NSArray arrayWithObjects:
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Berkshire", @"name", @"bbc_radio_berkshire", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Bristol", @"name", @"bbc_radio_bristol", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Cambridgeshire", @"name", @"bbc_radio_cambridge", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Cornwall", @"name", @"bbc_radio_cornwall", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Coventry & Warwickshire", @"name", @"bbc_radio_coventry_warwickshire", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Cumbria", @"name", @"bbc_radio_cumbria", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Derby", @"name", @"bbc_radio_derby", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Devon", @"name", @"bbc_radio_devon", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Essex", @"name", @"bbc_radio_essex", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Gloucestershire", @"name", @"bbc_radio_gloucestershire", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Guernsey", @"name", @"bbc_radio_guernsey", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Hereford & Worcester", @"name", @"bbc_radio_hereford_worcester", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Humberside", @"name", @"bbc_radio_humberside", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Jersey", @"name", @"bbc_radio_jersey", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Kent", @"name", @"bbc_radio_kent", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Lancashire", @"name", @"bbc_radio_lancashire", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Leeds", @"name", @"bbc_radio_leeds", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Leicester", @"name", @"bbc_radio_leicester", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Lincolnshire", @"name", @"bbc_radio_lincolnshire", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC London", @"name", @"bbc_london", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Manchester", @"name", @"bbc_radio_manchester", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Merseyside", @"name", @"bbc_radio_merseyside", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Newcastle", @"name", @"bbc_radio_newcastle", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Norfolk", @"name", @"bbc_radio_norfolk", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Northampton", @"name", @"bbc_radio_northampton", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Nottingham", @"name", @"bbc_radio_nottingham", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Oxford", @"name", @"bbc_radio_oxford", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Sheffield", @"name", @"bbc_radio_sheffield", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Shropshire", @"name", @"bbc_radio_shropshire", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Solent", @"name", @"bbc_radio_solent", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Somerset", @"name", @"bbc_radio_somerset_sound", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Stoke", @"name", @"bbc_radio_stoke", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Suffolk", @"name", @"bbc_radio_suffolk", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Surrey", @"name", @"bbc_radio_surrey", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Sussex", @"name", @"bbc_radio_sussex", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Tees", @"name", @"bbc_tees", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Three Counties", @"name", @"bbc_three_counties_radio", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC WM", @"name", @"bbc_wm", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC Wiltshire", @"name", @"bbc_radio_wiltshire", @"identifier", nil],
		[NSDictionary dictionaryWithObjectsAndKeys:@"BBC York", @"name", @"bbc_radio_york", @"identifier", nil],
	nil];
}

@end
