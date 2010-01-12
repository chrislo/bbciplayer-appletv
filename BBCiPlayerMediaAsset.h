#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface BBCiPlayerMediaAsset : BRXMLMediaAsset {
	NSString *_title;
	NSString *_summary;
	NSString *_imagePath;
	BRImage *_coverart;
}

- (void)setImagePath:(NSString *)path;
- (void)setTitle:(NSString *)title;
- (void)setMediaSummary:(NSString *)mediaSummary;
- (void)setImage:(BRImage *)image;

@end
