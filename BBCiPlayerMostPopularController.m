#import "BBCiPlayerMostPopularController.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerService.h"
#import "BBCiPlayerIonRequest.h"

@implementation BBCiPlayerMostPopularController

- (id)initWithService:(BBCiPlayerService *)service {
    if ((self = [super init])) {
		_service = [service retain];
		
		[self setListTitle:@"Most Popular"];
		[self setListIcon:[_service thumbnail]];
		
		NSURL *ionURL = [NSURL URLWithString:[[@"http://www.bbc.co.uk/iplayer/ion/mostpopular/service/" stringByAppendingString:[_service id]] stringByAppendingString:@"/format/json"]];
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

- (void)dealloc {
	[_service release];
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
