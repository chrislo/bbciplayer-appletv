#import "BBCiPlayerScheduleDayController.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerService.h"
#import "BBCiPlayerIonRequest.h"

@implementation BBCiPlayerScheduleDayController

- (id)initWithService:(BBCiPlayerService *)service andDate:(NSDate *)date {
    if ((self = [super init])) {
		_service = [service retain];
        _date = [date retain];
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self setListTitle:[dateFormatter stringFromDate:_date]];
		[self setListIcon:[_service thumbnail]];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSURL *ionURL = [NSURL URLWithString:[[[@"http://www.bbc.co.uk/iplayer/ion/schedule/date/" stringByAppendingString:[dateFormatter stringFromDate:_date]] stringByAppendingString:@"/format/json/service/"] stringByAppendingString:[_service id]]];
		
		NSDictionary *ion = [BBCiPlayerIonRequest sendRequestWithURL:ionURL];		
		_items = [[self episodeItemsFromIon:ion] retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (void)dealloc {
	[_service release];
    [_date release];
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
