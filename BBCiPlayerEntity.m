#import "BBCiPlayerEntity.h"

@implementation BBCiPlayerEntity

- (id)initWithId:(NSString *)id title:(NSString *)title andSynopsis:(NSString *)synopsis {
    if ((self = [super init])) {
        _id = [id retain];
		_title = [title retain];
		_synopsis = [synopsis retain];
    }
    return self;
}

- (void)dealloc {
    [_id release];
    [_title release];
    [_synopsis release];
    [super dealloc];
}

- (NSString *)id {
    return _id;
}

- (NSString *)title {
    return _title;
}

- (NSString *)synopsis {
    return _synopsis;
}

- (NSArray *)metadataLabels {
	return [NSArray array];
}

- (NSArray *)metadataObjs {
	return [NSArray array];
}

@end
