#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "BBCiPlayerMenuController.h"
#import "BBCiPlayerServiceTypeController.h"

@interface BBCiPlayerMostPopularController : BBCiPlayerMenuController {
@private
	NSString *_service;
	BBCiPlayerServiceType _type;
}

- (id)initWithService:(NSString *)service;
- (id)initWithType:(BBCiPlayerServiceType)type;

@end
