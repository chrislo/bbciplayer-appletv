#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "BBCiPlayerMenuController.h"

@class BBCiPlayerService;

@interface BBCiPlayerScheduleDayController : BBCiPlayerMenuController {
@private
	BBCiPlayerService *_service;
	NSDate *_date;
}

- (id)initWithService:(BBCiPlayerService *)service andDate:(NSDate *)date;

@end
