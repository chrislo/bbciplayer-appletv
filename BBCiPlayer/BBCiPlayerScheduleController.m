#import "BBCiPlayerScheduleController.h"
#import "BBCiPlayerScheduleDayController.h"
#import "BBCiPlayerEntity.h"
#import "BBCiPlayerService.h"

@implementation BBCiPlayerScheduleController

- (id)initWithService:(BBCiPlayerService *)service {
    if ((self = [super init])) {
		_service = [service retain];
		
		[self setListTitle:@"Schedule"];
		[self setListIcon:[_service thumbnail]];
		
		_items = [[NSMutableArray alloc] init];
		[_items retain];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		
		for (int i = 0; i < 8; i++) {
			NSTimeInterval interval = 24 * 60 * 60 * -1 * i;
			NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
			NSString *id = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];			
			BBCiPlayerEntity *scheduleDay = [[BBCiPlayerEntity alloc] initWithId:id title:[dateFormatter stringFromDate:date] andSynopsis:nil];
		    [_items addObject:scheduleDay];
		    [scheduleDay release];
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
    NSTimeInterval interval = [[[_items objectAtIndex:row] id] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];	
    BBCiPlayerScheduleDayController *controller = [[BBCiPlayerScheduleDayController alloc] initWithService:_service andDate:date];
    [controller autorelease];
    [[self stack] pushController:controller];
}

@end
