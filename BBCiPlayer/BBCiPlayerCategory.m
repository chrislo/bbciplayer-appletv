#import "BBCiPlayerCategory.h"

@implementation BBCiPlayerCategory

+ (BBCiPlayerCategory *)categoryWithId:(NSString *)id andTitle:(NSString *)title {
	BBCiPlayerCategory *category = [[BBCiPlayerCategory alloc] initWithId:id title:title andSynopsis:nil];
	return [category autorelease];
}

@end
