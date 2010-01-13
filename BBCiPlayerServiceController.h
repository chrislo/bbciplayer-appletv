#import <Cocoa/Cocoa.h>
#import "BBCiPlayerMenuController.h"

@class BBCiPlayerService;

@interface BBCiPlayerServiceController : BBCiPlayerMenuController {
@private
	BBCiPlayerService *_service;
}

- (id)initWithService:(BBCiPlayerService *)service;

@end
