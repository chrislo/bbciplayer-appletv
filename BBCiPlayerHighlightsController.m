#import "BBCiPlayerHighlightsController.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerMediaAsset.h"
#import "BBCiPlayerMetadataPreviewControl.h"
#import "NSDictionary+BSJSONAdditions.h"

@implementation BBCiPlayerHighlightsController

- (id)initWithService:(NSString *)service {
    if ((self = [super init])) {
		_service = [service retain];
    }
    return self;
}

- (id)initWithType:(BBCiPlayerServiceType)type {
    if ((self = [super init])) {
		_type = type;
		
		_items = [[NSMutableArray alloc] init];
		[_items retain];
		
		[self setListTitle:@"Highlights"];
		
		NSURL *ionURL;
		NSString *type;
		if (_type == BBCiPlayerServiceTypeTV) {
			type = @"tv";
		}
		else if (_type == BBCiPlayerServiceTypeRadio) {
			type = @"radio";
		}
		ionURL = [NSURL URLWithString:[[@"http://www.bbc.co.uk/iplayer/ion/featured/service_type/" stringByAppendingString:type] stringByAppendingString:@"/format/json"]];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:ionURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
		NSURLResponse *response;
		NSError *error;
		NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		if (error == nil) {
			NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
			
			if (json) {
				NSDictionary *data = [NSDictionary dictionaryWithJSONString:json];
				[json release];
				
				if (data) {
					NSArray *blocklist = [data objectForKey:@"blocklist"];
					
					for (int i = 0; i < [blocklist count]; i++) {
						NSDictionary *episodeData = [blocklist objectAtIndex:i];
						NSString *availability = [episodeData objectForKey:@"availability"];
						if ([availability isEqualToString:@"CURRENT"]) {
							BBCiPlayerEpisode *episode = [[BBCiPlayerEpisode alloc] initWithIon:episodeData];
							[_items addObject:episode];
							[episode release];
						}
					}
				}
			}
			else {
				NSLog(@"Error in Dynamite response: %@", [responseData description]);
			}
		}
		else {
			NSLog(@"Error downloading %@: %@", ionURL, [error localizedDescription]);
		}
		
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
