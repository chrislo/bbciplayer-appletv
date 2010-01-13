#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "BBCiPlayerMenuController.h"

enum {
    BBCiPlayerServiceTypeTV = 1,
	BBCiPlayerServiceTypeRadio = 2,
};
typedef unsigned int BBCiPlayerServiceType;

@interface BBCiPlayerServiceTypeController : BBCiPlayerMenuController {
@private
	BBCiPlayerServiceType _type;
}

- (id)initWithType:(BBCiPlayerServiceType)type;

@end
