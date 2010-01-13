#import "BBCiPlayerServiceController.h"
#import "BBCiPlayerHighlightsController.h"
#import "BBCiPlayerMostPopularController.h"
#import "BBCiPlayerScheduleController.h"
#import "BBCiPlayerEntity.h"
#import "BBCiPlayerService.h"

@implementation BBCiPlayerServiceController

- (id)initWithService:(BBCiPlayerService *)service {
    if ((self = [super init])) {
		_service = [service retain];
		
		[self setListTitle:[_service title]];
		[self setListIcon:[_service thumbnail]];
		
		BBCiPlayerEntity *highlights = [[BBCiPlayerEntity alloc] initWithId:@"highlights" title:@"Highlights" andSynopsis:nil];
		BBCiPlayerEntity *mostPopular = [[BBCiPlayerEntity alloc] initWithId:@"mostpopular" title:@"Most Popular" andSynopsis:nil];
		BBCiPlayerEntity *schedule = [[BBCiPlayerEntity alloc] initWithId:@"schedule" title:@"Schedule" andSynopsis:nil];
		BBCiPlayerEntity *categories = [[BBCiPlayerEntity alloc] initWithId:@"categories" title:@"Categories" andSynopsis:nil];
		
		_items = [[NSMutableArray alloc] initWithObjects:highlights, mostPopular, schedule, categories, nil];
		[_items retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (void)dealloc {
	[_service release];
	[super dealloc];
}

- (void)itemSelected:(long)row {
	BRController *controller;

	if (row == 0) {
		controller = [[BBCiPlayerHighlightsController alloc] initWithService:_service];
		[controller autorelease];
	}
	else if (row == 1) {
		controller = [[BBCiPlayerMostPopularController alloc] initWithService:_service];
		[controller autorelease];
	}
	else if (row == 2) {
		controller = [[BBCiPlayerScheduleController alloc] initWithService:_service];
		[controller autorelease];
	}
	
	[[self stack] pushController:controller];
}

@end
