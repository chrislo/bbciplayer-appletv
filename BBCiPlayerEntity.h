#import <Cocoa/Cocoa.h>

@interface BBCiPlayerEntity : NSObject {
    NSString *_id;
    NSString *_title;
    NSString *_synopsis;
}

- (id)initWithId:(NSString *)id;
- (NSString *)id;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSString *)synopsis;
- (void)setSynopsis:(NSString *)synopsis;

- (NSArray *)metadataLabels;
- (NSArray *)metadataObjs;

@end
