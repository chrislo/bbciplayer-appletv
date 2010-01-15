#import <Cocoa/Cocoa.h>
#import "BBCiPlayerEntity.h"

@interface BBCiPlayerCategory : BBCiPlayerEntity {

}

+ (BBCiPlayerCategory *)categoryWithId:(NSString *)id andTitle:(NSString *)title;

@end
