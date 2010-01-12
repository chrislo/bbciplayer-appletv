#import "BBCiPlayerMetadataPreviewControl.h"
#import "BBCiPlayerEntity.h"

@implementation BBCiPlayerMetadataPreviewControl

- (id)initWithEntity:(BBCiPlayerEntity *)entity {
	if ((self = [super init])) {
		_entity = [entity retain];
    }
    return self;
}

- (void)dealloc {
	[_entity release];
	[super dealloc];
}

- (void)_updateMetadataLayer {
	[super _updateMetadataLayer];
	[_metadataLayer setMetadata:[_entity metadataObjs] withLabels:[_entity metadataLabels]];
}

@end
