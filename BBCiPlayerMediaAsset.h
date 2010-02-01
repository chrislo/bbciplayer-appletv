#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface BBCiPlayerMediaAsset : BRXMLMediaAsset {
	NSString *_title;
	NSString *_artist;
	NSString *_summary;
	NSString *_imagePath;
	BRImage *_coverart;
	BOOL _imageOnly;
	BOOL _isRadio;
}

- (void)setImagePath:(NSString *)path;
- (void)setTitle:(NSString *)title;
- (void)setArtist:(NSString *)artist;
- (void)setMediaSummary:(NSString *)mediaSummary;
- (void)setImage:(BRImage *)image;
- (void)setImageOnly:(BOOL)imageOnly;
- (void)setIsRadio:(BOOL)isRadio;

@end
