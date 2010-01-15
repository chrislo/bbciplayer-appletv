#import <Cocoa/Cocoa.h>
#import "BBCiPlayerMenuController.h"

@class BBCiPlayerCategory;
@class BBCiPlayerService;

@interface BBCiPlayerCategoryController : BBCiPlayerMenuController {
@private
	BBCiPlayerCategory *_category;
	BBCiPlayerService *_service;
}

- (id)initWithCategory:(BBCiPlayerCategory *)category;
- (id)initWithCategory:(BBCiPlayerCategory *)category andService:(BBCiPlayerService *)service;

@end
