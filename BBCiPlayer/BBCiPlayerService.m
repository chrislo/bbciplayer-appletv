#import "BBCiPlayerService.h"

@implementation BBCiPlayerService

+ (BBCiPlayerService *)serviceWithId:(NSString *)id andTitle:(NSString *)title {
	BBCiPlayerService *service = [[BBCiPlayerService alloc] initWithId:id title:title andSynopsis:nil];
	return [service autorelease];
}

- (BRImage *)thumbnail {
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:[self id] ofType:@"png" inDirectory:@"ServiceThumbnails"];
	return [BRImage imageWithPath:path];
}

@end
