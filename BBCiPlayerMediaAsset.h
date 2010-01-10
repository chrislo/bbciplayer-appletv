#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface BBCiPlayerMediaAsset : BRXMLMediaAsset {
	NSString *_imagePath;
	BRImage *_coverart;
}

- (void)setImagePath:(NSString *)path;
- (void)setImage:(BRImage *)image;

@end
