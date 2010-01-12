#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@class BBCiPlayerEntity;

@interface BBCiPlayerMetadataPreviewControl : BRMetadataPreviewControl {
	BBCiPlayerEntity *_entity;
}

- (id)initWithEntity:(BBCiPlayerEntity *)entity;

@end
