#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "BBCiPlayerEntity.h"

@interface BBCiPlayerService : BBCiPlayerEntity {

}

+ (BBCiPlayerService *)serviceWithId:(NSString *)id andTitle:(NSString *)title;

- (BRImage *)thumbnail;

@end
