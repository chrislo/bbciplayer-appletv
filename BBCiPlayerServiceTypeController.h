#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

enum {
    BBCiPlayerServiceTypeTV = 1,
	BBCiPlayerServiceTypeRadio = 2,
};
typedef unsigned int BBCiPlayerServiceType;

@interface BBCiPlayerServiceTypeController : BRMediaMenuController {
@private
	BBCiPlayerServiceType _type;
	NSMutableArray *_items;
}

- (id)initWithType:(BBCiPlayerServiceType)type;

@end
