#import "BBCiPlayerHighlightsController.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerIonRequest.h"
#import "BBCiPlayerMediaAsset.h"
#import "BBCiPlayerMetadataPreviewControl.h"

@implementation BBCiPlayerHighlightsController

- (id)initWithService:(NSString *)service {
    if ((self = [super init])) {
		_service = service;
		
		[self setListTitle:@"Highlights"];
		
		NSURL *ionURL = [NSURL URLWithString:[[@"http://www.bbc.co.uk/iplayer/ion/featured/service/" stringByAppendingString:service] stringByAppendingString:@"/format/json"]];
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

- (void)dealloc {
	[_service release];
	[super dealloc];
}

- (void)itemSelected:(long)row {
    BRAlertController *controller = [BRAlertController alertOfType:0 titled:[self titleForRow:row] primaryText:[[_items objectAtIndex:row] id] secondaryText:nil];
    [[self stack] pushController:controller];
}

- (id)previewControlForItem:(long)row {
	BBCiPlayerEpisode *episode = [_items objectAtIndex:row];

	NSString *path = [[@"http://www.bbc.co.uk/iplayer/images/episode/" stringByAppendingString:[episode id]] stringByAppendingString:@"_512_288.jpg"];
	NSURL *url = [NSURL URLWithString:path];
	
	BBCiPlayerMediaAsset *asset = [[BBCiPlayerMediaAsset alloc] init];
	[asset setImage:[BRImage imageWithURL:url]];
	[asset setTitle:[episode title]];
	[asset setMediaSummary:[episode synopsis]];
	
	BBCiPlayerMetadataPreviewControl *preview = [[BBCiPlayerMetadataPreviewControl alloc] initWithEntity:episode];
	[preview setAsset:asset];
	[asset release];

	return [preview autorelease];
}

@end
