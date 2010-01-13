#import "BBCiPlayerService.h"

@implementation BBCiPlayerService

+ (BBCiPlayerService *)serviceWithId:(NSString *)id andTitle:(NSString *)title {
	BBCiPlayerService *service = [[BBCiPlayerService alloc] initWithId:id title:title andSynopsis:nil];
	return [service autorelease];
}

@end
