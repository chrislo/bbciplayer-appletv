#import "BBCiPlayerMostPopularController.h"
#import "BBCiPlayerCategory.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerService.h"
#import "BBCiPlayerIonRequest.h"

@implementation BBCiPlayerMostPopularController

- (id)initWithService:(BBCiPlayerService *)service {
    if ((self = [super init])) {
		_service = [service retain];
		
		[self setListTitle:@"Most Popular"];
		[self setListIcon:[_service thumbnail]];
		
		NSURL *ionURL = [NSURL URLWithString:[[@"http://www.bbc.co.uk/iplayer/ion/mostpopular/masterbrand/" stringByAppendingString:[_service id]] stringByAppendingString:@"/format/json"]];
		NSDictionary *ion = [BBCiPlayerIonRequest sendRequestWithURL:ionURL];
		_items = [[self episodeItemsFromIon:ion] retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (id)initWithType:(BBCiPlayerServiceType)type {
    if ((self = [super init])) {
		_type = type;
		
		[self setListTitle:@"Most Popular"];
		
		NSString *type;
		if (_type == BBCiPlayerServiceTypeTV) {
			type = @"tv";
		}
		else if (_type == BBCiPlayerServiceTypeRadio) {
			type = @"radio";
		}
		
		NSURL *ionURL = [NSURL URLWithString:[[@"http://www.bbc.co.uk/iplayer/ion/mostpopular/service_type/" stringByAppendingString:type] stringByAppendingString:@"/format/json"]];
		NSDictionary *ion = [BBCiPlayerIonRequest sendRequestWithURL:ionURL];
		_items = [[self episodeItemsFromIon:ion] retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (id)initWithCategory:(BBCiPlayerCategory *)category andServiceType:(BBCiPlayerServiceType)type {
    if ((self = [super init])) {
		_category = [category retain];
		_type = type;
		
		NSString *type;
		if (_type == BBCiPlayerServiceTypeTV) {
			type = @"tv";
			[self setListTitle:@"Most Popular TV"];
		}
		else if (_type == BBCiPlayerServiceTypeRadio) {
			type = @"radio";
			[self setListTitle:@"Most Popular Radio"];
		}
		
		NSString *ionURLString = [NSString stringWithFormat:@"http://www.bbc.co.uk/iplayer/ion/mostpopular/category/%@/service_type/%@/format/json", [_category id], type];
		NSURL *ionURL = [NSURL URLWithString:ionURLString];
		NSDictionary *ion = [BBCiPlayerIonRequest sendRequestWithURL:ionURL];
		_items = [[self episodeItemsFromIon:ion] retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (id)initWithLetter:(NSString *)letter andServiceType:(BBCiPlayerServiceType)type {
    if ((self = [super init])) {
		_letter = [letter retain];
		_type = type;
		
		NSString *type;
		if (_type == BBCiPlayerServiceTypeTV) {
			type = @"tv";
			[self setListTitle:@"Most Popular TV"];
		}
		else if (_type == BBCiPlayerServiceTypeRadio) {
			type = @"radio";
			[self setListTitle:@"Most Popular Radio"];
		}
		
		NSString *ionURLString = [NSString stringWithFormat:@"http://www.bbc.co.uk/iplayer/ion/mostpopular/letter/%@/service_type/%@/format/json", [_letter lowercaseString], type];
		NSURL *ionURL = [NSURL URLWithString:ionURLString];
		NSDictionary *ion = [BBCiPlayerIonRequest sendRequestWithURL:ionURL];
		_items = [[self episodeItemsFromIon:ion] retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (void)dealloc {
	[_service release];
	[_category release];
	[_letter release];
	[super dealloc];
}

- (void)itemSelected:(long)row {
	BBCiPlayerEpisode *episode = [_items objectAtIndex:row];
    [self episodeSelected:episode];
}

- (id)previewControlForItem:(long)row {
	BBCiPlayerEpisode *episode = [_items objectAtIndex:row];
	return [self previewControlForEpisode:episode];
}

@end
