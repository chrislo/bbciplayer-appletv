#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "BBCiPlayerMenuController.h"
#import "BBCiPlayerServiceTypeController.h"

@class BBCiPlayerCategory;
@class BBCiPlayerService;

@interface BBCiPlayerMostPopularController : BBCiPlayerMenuController {
@private
	BBCiPlayerService *_service;
	BBCiPlayerServiceType _type;
	BBCiPlayerCategory *_category;
	NSString *_letter;
}

- (id)initWithService:(BBCiPlayerService *)service;
- (id)initWithType:(BBCiPlayerServiceType)type;
- (id)initWithCategory:(BBCiPlayerCategory *)category andServiceType:(BBCiPlayerServiceType)type;
- (id)initWithLetter:(NSString *)letter andServiceType:(BBCiPlayerServiceType)type;

@end
