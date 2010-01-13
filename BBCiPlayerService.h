#import <Cocoa/Cocoa.h>
#import "BBCiPlayerEntity.h"

@interface BBCiPlayerService : BBCiPlayerEntity {

}

+ (BBCiPlayerService *)serviceWithId:(NSString *)id andTitle:(NSString *)title;

@end
