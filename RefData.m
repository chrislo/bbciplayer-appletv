#import "RefData.h"
#import "BBCiPlayerCategory.h"
#import "BBCiPlayerService.h"

@implementation RefData

+ (NSArray *)categories {
	return [NSArray arrayWithObjects:
		[BBCiPlayerCategory categoryWithId:@"9100001" andTitle:@"Children's"],
		[BBCiPlayerCategory categoryWithId:@"9100098" andTitle:@"Comedy"],
		[BBCiPlayerCategory categoryWithId:@"9100003" andTitle:@"Drama"],
		[BBCiPlayerCategory categoryWithId:@"9100099" andTitle:@"Entertainment"],
		[BBCiPlayerCategory categoryWithId:@"9100005" andTitle:@"Factual"],
		[BBCiPlayerCategory categoryWithId:@"9100093" andTitle:@"Films"],
		[BBCiPlayerCategory categoryWithId:@"9100006" andTitle:@"Music"],
		[BBCiPlayerCategory categoryWithId:@"9100007" andTitle:@"News"],
		[BBCiPlayerCategory categoryWithId:@"9100008" andTitle:@"Religion & Ethics"],
		[BBCiPlayerCategory categoryWithId:@"9100010" andTitle:@"Sport"],
		[BBCiPlayerCategory categoryWithId:@"signed" andTitle:@"Sign Zone"],
		[BBCiPlayerCategory categoryWithId:@"dubbedaudiodescribed" andTitle:@"Audio Described"],
		[BBCiPlayerCategory categoryWithId:@"9100094" andTitle:@"Northern Ireland"],
		[BBCiPlayerCategory categoryWithId:@"9100095" andTitle:@"Scotland"],
		[BBCiPlayerCategory categoryWithId:@"9100097" andTitle:@"Wales"],
	nil];
}

+ (NSArray *)tvServices {
	return [NSArray arrayWithObjects:
		[BBCiPlayerService serviceWithId:@"bbc_one"        andTitle:@"BBC One"],
		[BBCiPlayerService serviceWithId:@"bbc_two"        andTitle:@"BBC Two"],
		[BBCiPlayerService serviceWithId:@"bbc_three"      andTitle:@"BBC Three"],
		[BBCiPlayerService serviceWithId:@"bbc_four"       andTitle:@"BBC Four"],
		[BBCiPlayerService serviceWithId:@"cbbc"           andTitle:@"CBBC"],
		[BBCiPlayerService serviceWithId:@"cbeebies"       andTitle:@"CBeebies"],
		[BBCiPlayerService serviceWithId:@"bbc_news24"     andTitle:@"BBC News Channel"],
		[BBCiPlayerService serviceWithId:@"bbc_parliament" andTitle:@"BBC Parliament"], 
		[BBCiPlayerService serviceWithId:@"bbc_hd"         andTitle:@"BBC HD"],
		[BBCiPlayerService serviceWithId:@"bbc_alba"       andTitle:@"BBC Alba"],
	nil];
}

+ (NSArray *)networkRadioServices {
	return [NSArray arrayWithObjects:
		[BBCiPlayerService serviceWithId:@"bbc_radio_one"                    andTitle:@"BBC Radio 1"],    
		[BBCiPlayerService serviceWithId:@"bbc_1xtra"                        andTitle:@"BBC 1Xtra"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_two"                    andTitle:@"BBC Radio 2"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_three"                  andTitle:@"BBC Radio 3"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_four"                   andTitle:@"BBC Radio 4"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_five_live"              andTitle:@"BBC Radio 5 live"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_five_live_sports_extra" andTitle:@"BBC Radio 5 live sports extra"],
		[BBCiPlayerService serviceWithId:@"bbc_6music"                       andTitle:@"BBC 6 Music"],
		[BBCiPlayerService serviceWithId:@"bbc_7"                            andTitle:@"BBC Radio 7"],
		[BBCiPlayerService serviceWithId:@"bbc_asian_network"                andTitle:@"BBC Asian Network"],
		[BBCiPlayerService serviceWithId:@"bbc_world_service"                andTitle:@"BBC World Service"],
	nil];
}

+ (NSArray *)nationalRadioServices {
	return [NSArray arrayWithObjects:
		[BBCiPlayerService serviceWithId:@"bbc_radio_scotland"     andTitle:@"BBC Radio Scotland"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_nan_gaidheal" andTitle:@"BBC Radio Nan Gàidheal"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_ulster"       andTitle:@"BBC Radio Ulster"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_wales"        andTitle:@"BBC Radio Wales"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_cymru"        andTitle:@"BBC Radio Cymru"],
	nil];
}

+ (NSArray *)localRadioServices {
	return [NSArray arrayWithObjects:
		[BBCiPlayerService serviceWithId:@"bbc_radio_berkshire"             andTitle:@"BBC Berkshire"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_bristol"               andTitle:@"BBC Bristol"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_cambridge"             andTitle:@"BBC Cambridgeshire"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_cornwall"              andTitle:@"BBC Cornwall"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_coventry_warwickshire" andTitle:@"BBC Coventry & Warwickshire"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_cumbria"               andTitle:@"BBC Cumbria"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_derby"                 andTitle:@"BBC Derby"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_devon"                 andTitle:@"BBC Devon"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_essex"                 andTitle:@"BBC Essex"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_gloucestershire"       andTitle:@"BBC Gloucestershire"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_guernsey"              andTitle:@"BBC Guernsey"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_hereford_worcester"    andTitle:@"BBC Hereford & Worcester"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_humberside"            andTitle:@"BBC Humberside"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_jersey"                andTitle:@"BBC Jersey"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_kent"                  andTitle:@"BBC Kent"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_lancashire"            andTitle:@"BBC Lancashire"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_leeds"                 andTitle:@"BBC Leeds"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_leicester"             andTitle:@"BBC Leicester"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_lincolnshire"          andTitle:@"BBC Lincolnshire"],
		[BBCiPlayerService serviceWithId:@"bbc_london"                      andTitle:@"BBC London"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_manchester"            andTitle:@"BBC Manchester"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_merseyside"            andTitle:@"BBC Merseyside"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_newcastle"             andTitle:@"BBC Newcastle"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_norfolk"               andTitle:@"BBC Norfolk"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_northampton"           andTitle:@"BBC Northampton"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_nottingham"            andTitle:@"BBC Nottingham"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_oxford"                andTitle:@"BBC Oxford"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_sheffield"             andTitle:@"BBC Sheffield"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_shropshire"            andTitle:@"BBC Shropshire"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_solent"                andTitle:@"BBC Solent"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_somerset_sound"        andTitle:@"BBC Somerset"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_stoke"                 andTitle:@"BBC Stoke"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_suffolk"               andTitle:@"BBC Suffolk"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_surrey"                andTitle:@"BBC Surrey"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_sussex"                andTitle:@"BBC Sussex"],
		[BBCiPlayerService serviceWithId:@"bbc_tees"                        andTitle:@"BBC Tees"],
		[BBCiPlayerService serviceWithId:@"bbc_three_counties_radio"        andTitle:@"BBC Three Counties"],
		[BBCiPlayerService serviceWithId:@"bbc_wm"                          andTitle:@"BBC WM"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_wiltshire"             andTitle:@"BBC Wiltshire"],
		[BBCiPlayerService serviceWithId:@"bbc_radio_york"                  andTitle:@"BBC York"],
	nil];
}

@end
