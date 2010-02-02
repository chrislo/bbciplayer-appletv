#import <Cocoa/Cocoa.h>
#import "BBCiPlayerMenuController.h"

@class BBCiPlayerService;

@interface BBCiPlayerCategoriesController : BBCiPlayerMenuController {
@private
	BBCiPlayerService *_service;
}

- (id)init;
- (id)initWithService:(BBCiPlayerService *)service;

@end
