#import <Cocoa/Cocoa.h>
#import "BBCiPlayerEntity.h"

@interface BBCiPlayerEpisode : BBCiPlayerEntity {
	int _duration;
	NSString *_mediaType;
	NSString *_version;
	NSDate *_broadcast;
	NSMutableArray *_categories;
}

- (id)initWithIon:(NSDictionary *)ion;
- (NSString *)mediaType;
- (NSString *)version;

@end
