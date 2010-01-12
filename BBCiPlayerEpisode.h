#import <Cocoa/Cocoa.h>
#import "BBCiPlayerEntity.h"

@interface BBCiPlayerEpisode : BBCiPlayerEntity {
	int _duration;
	NSDate *_broadcast;
	NSMutableArray *_categories;
}

- (id)initWithIon:(NSDictionary *)ion;

@end
