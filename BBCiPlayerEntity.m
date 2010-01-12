#import "BBCiPlayerEntity.h"

@implementation BBCiPlayerEntity

- (id)initWithId:(NSString *)id {
    if ((self = [super init])) {
        _id = [id retain];
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

- (void)setTitle:(NSString *)title {
    [_title release];
    _title = [title retain];
}

- (NSString *)synopsis {
    return _synopsis;
}

- (void)setSynopsis:(NSString *)synopsis {
    [_synopsis release];
    _synopsis = [synopsis retain];
}

- (NSArray *)metadataLabels {
	return [NSArray array];
}

- (NSArray *)metadataObjs {
	return [NSArray array];
}

@end
