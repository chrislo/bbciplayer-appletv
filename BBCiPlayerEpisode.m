#import "BBCiPlayerEpisode.h"

@implementation BBCiPlayerEpisode

- (id)initWithIon:(NSDictionary *)ion {
    if ((self = [super init])) {
        _id = [[ion objectForKey:@"id"] retain];
        _title = [[ion objectForKey:@"complete_title"] retain];
        _synopsis = [[ion objectForKey:@"synopsis"] retain];
		_duration = [[ion objectForKey:@"duration"] intValue];
		
		NSMutableString *dateString = [[ion objectForKey:@"original_broadcast_datetime"] mutableCopy];
		[dateString replaceOccurrencesOfString:@"T" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [dateString length])];
		[dateString replaceOccurrencesOfString:@"+" withString:@" +" options:NSLiteralSearch range:NSMakeRange(0, [dateString length])];
		_broadcast = [[[NSDate alloc] initWithString:dateString] retain];
		
		_categories = [[[NSMutableArray alloc] init] retain];
		NSArray *ionCategories = [ion objectForKey:@"categories"];
		for (int i = 0; i < [ionCategories count]; i++) {
			NSDictionary *ionCategory = [ionCategories objectAtIndex:i];
			if ([[ionCategory objectForKey:@"level"] isEqualToString:@"1"]) {
				[_categories addObject:[ionCategory objectForKey:@"title"]];
			}
		}
    }
    return self;
}

- (void)dealloc {
	[_broadcast release];
	[_categories release];
	[super dealloc];
}

- (NSArray *)metadataLabels {
	NSMutableArray *labels = [NSMutableArray array];
	
	if (_duration) {
		[labels addObject:@"Length"];
	}
	
	if (_broadcast) {
		[labels addObject:@"Aired"];
	}
	
	if ([_categories count] > 0) {
		[labels addObject:@"Genre"];
	}
	
	return labels;
}

- (NSArray *)metadataObjs {
	NSMutableArray *objs = [NSMutableArray array];
	
	if (_duration) {
		int minutes = _duration / 60;
		NSString *length = [NSString stringWithFormat:@"%d minutes", minutes];
		[objs addObject:length];
	}
	
	if (_broadcast) {
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[objs addObject:[dateFormatter stringFromDate:_broadcast]];
	}
	
	if ([_categories count] > 0) {
		[objs addObject:[_categories componentsJoinedByString:@", "]];
	
	}
	
	return objs;
}

@end
