#import	"BBCiPlayerCategoryController.h"
#import "BBCiPlayerServiceTypeController.h"
#import "BBCiPlayerHighlightsController.h"
#import "BBCiPlayerMostPopularController.h"
#import "BBCiPlayerIonRequest.h"
#import "BBCiPlayerCategory.h"
#import "BBCiPlayerService.h"

@implementation BBCiPlayerCategoryController

- (id)initWithCategory:(BBCiPlayerCategory *)category {
    if ((self = [super init])) {
		_category = [category retain];
		[self setListTitle:[category title]];

		BBCiPlayerEntity *tvHighlights = [[BBCiPlayerEntity alloc] initWithId:@"highlights-tv" title:@"TV Highlights" andSynopsis:nil];		
		BBCiPlayerEntity *radioHighlights = [[BBCiPlayerEntity alloc] initWithId:@"highlights-radio" title:@"Radio Highlights" andSynopsis:nil];
		BBCiPlayerEntity *tvMostPopular = [[BBCiPlayerEntity alloc] initWithId:@"mostpopular-tv" title:@"Most Popular TV" andSynopsis:nil];
		BBCiPlayerEntity *radioMostPopular = [[BBCiPlayerEntity alloc] initWithId:@"mostpopular-radio" title:@"Most Popular Radio" andSynopsis:nil];
		
		_items = [[NSMutableArray alloc] initWithObjects:tvHighlights, radioHighlights, tvMostPopular, radioMostPopular, nil];
		[_items retain];
		
		[tvHighlights release];
		[radioHighlights release];
		[tvMostPopular release];
		[radioMostPopular release];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (id)initWithCategory:(BBCiPlayerCategory *)category andService:(BBCiPlayerService *)service {
    if ((self = [super init])) {
		_category = [category retain];
		_service = [service retain];
		
		[self setListTitle:[category title]];
		[self setListIcon:[_service thumbnail]];
		
		NSString *ionURLString = [NSString stringWithFormat:@"http://www.bbc.co.uk/iplayer/ion/listview/category/%@/masterbrand/%@/block_type/episode/sort/dateavailable/perpage/30/format/json", [_category id], [_service id]];
		NSURL *ionURL = [NSURL URLWithString:ionURLString];
		NSDictionary *ion = [BBCiPlayerIonRequest sendRequestWithURL:ionURL];
		_items = [[self episodeItemsFromIon:ion] retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (void)dealloc {
	[_category release];
	[_service release];
	[super dealloc];
}

- (void)itemSelected:(long)row {
	if (_service) {
		BBCiPlayerEpisode *episode = [_items objectAtIndex:row];
		[self episodeSelected:episode];
	}
	else {
		BBCiPlayerMenuController *controller;
		
		if (row == 0) {
			controller = [[BBCiPlayerHighlightsController alloc] initWithCategory:_category andServiceType:BBCiPlayerServiceTypeTV];
		}
		else if (row == 1) {
			controller = [[BBCiPlayerHighlightsController alloc] initWithCategory:_category andServiceType:BBCiPlayerServiceTypeRadio];
		}
		else if (row == 2) {
			controller = [[BBCiPlayerMostPopularController alloc] initWithCategory:_category andServiceType:BBCiPlayerServiceTypeTV];
		}
		else if (row == 3) {
			controller = [[BBCiPlayerMostPopularController alloc] initWithCategory:_category andServiceType:BBCiPlayerServiceTypeRadio];
		}
		
		[controller autorelease];
		[[self stack] pushController:controller];
	}
}

- (id)previewControlForItem:(long)row {
	if (_service) {
		BBCiPlayerEpisode *episode = [_items objectAtIndex:row];
		return [self previewControlForEpisode:episode];
	}
	else {
		return nil;
	}
}

@end
