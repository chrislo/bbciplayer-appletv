#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "BBCiPlayerMenuController.h"
#import "BBCiPlayerServiceTypeController.h"

@class BBCiPlayerService;

@interface BBCiPlayerHighlightsController : BBCiPlayerMenuController {
@private
	BBCiPlayerService *_service;
	BBCiPlayerServiceType _type;
}

- (id)initWithService:(BBCiPlayerService *)service;
- (id)initWithType:(BBCiPlayerServiceType)type;

@end
