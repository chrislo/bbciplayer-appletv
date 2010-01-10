#import "BBCiPlayerMediaAsset.h"

@implementation BBCiPlayerMediaAsset

- (void)dealloc {
	[_imagePath release];
	[_coverart release];
	[super dealloc];
}

- (void)setImagePath:(NSString *)path {
	[_imagePath release];
	_imagePath = [path retain];
}

- (void)setImage:(BRImage *)image {
	[_coverart release];
	_coverart = [image retain];
}

- (BOOL)hasCoverArt {
	return YES;
}

- (id)coverArt {
	if (_imagePath) {
		return [BRImage imageWithPath:_imagePath];
	}
	
	if (_coverart) {
		return _coverart;
	}

	return nil;
}

@end
