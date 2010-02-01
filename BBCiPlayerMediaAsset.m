#import "BBCiPlayerMediaAsset.h"

@implementation BBCiPlayerMediaAsset

- (id)init {
	if ((self = [super init])) {
		_imageOnly = NO;
    }
    return self;
}

- (void)dealloc {
	[_title release];
	[_artist release];
	[_summary release];
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

- (id)mediaType
{
	if (_imageOnly) {
		return nil;
	}
	else if (_isRadio) {
		return [BRMediaType internetRadioStation];
	}
	else {
		return [BRMediaType TVShow];
	}
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

- (NSString *)title {
	return _title;
}

- (void)setTitle:(NSString *)title {
	[_title release];
	_title = [title retain];
}

- (NSString *)artist {
	return _artist;
}

- (void)setArtist:(NSString *)artist {
	[_artist release];
	_artist = [artist retain];
}

- (id)mediaSummary {
	return _summary;
}

- (void)setMediaSummary:(NSString *)mediaSummary {
	[_summary release];
	_summary = [mediaSummary retain];
}

- (void)setImageOnly:(BOOL)imageOnly {
	_imageOnly = imageOnly;
}

- (void)setIsRadio:(BOOL)isRadio {
	_isRadio = isRadio;
}

@end
