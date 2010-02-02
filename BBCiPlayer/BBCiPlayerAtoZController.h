#import <Cocoa/Cocoa.h>
#import "BBCiPlayerMenuController.h"

@interface BBCiPlayerAtoZController : BBCiPlayerMenuController {
@private
	NSString *_letter;
}

- (id)init;
- (id)initWithLetter:(NSString *)letter;

@end
