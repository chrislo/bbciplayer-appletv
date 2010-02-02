#import "BBCiPlayerHighlightsController.h"
#import "BBCiPlayerCategory.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerService.h"
#import "BBCiPlayerIonRequest.h"

@implementation BBCiPlayerHighlightsController

- (id)initWithService:(BBCiPlayerService *)service {
    if ((self = [super init])) {
		_service = [service retain];
		
		[self setListTitle:@"Highlights"];
		[self setListIcon:[_service thumbnail]];
		
		NSURL *ionURL = [NSURL URLWithString:[[@"http://www.bbc.co.uk/iplayer/ion/featured/masterbrand/" stringByAppendingString:[_service id]] stringByAppendingString:@"/format/json"]];
		NSDictionary *ion = [BBCiPlayerIonRequest sendRequestWithURL:ionURL];
		_items = [[self episodeItemsFromIon:ion] retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (id)initWithType:(BBCiPlayerServiceType)type {
    if ((self = [super init])) {
		_type = type;
		
		[self setListTitle:@"Highlights"];
		
		NSString *type;
		if (_type == BBCiPlayerServiceTypeTV) {
			type = @"tv";
		}
		else if (_type == BBCiPlayerServiceTypeRadio) {
			type = @"radio";
		}
		
		NSURL *ionURL = [NSURL URLWithString:[[@"http://www.bbc.co.uk/iplayer/ion/featured/service_type/" stringByAppendingString:type] stringByAppendingString:@"/format/json"]];
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
			[self setListTitle:@"TV Highlights"];
		}
		else if (_type == BBCiPlayerServiceTypeRadio) {
			type = @"radio";
			[self setListTitle:@"Radio Highlights"];
		}
		
		NSString *ionURLString = [NSString stringWithFormat:@"http://www.bbc.co.uk/iplayer/ion/featured/category/%@/service_type/%@/format/json", [_category id], type];
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
