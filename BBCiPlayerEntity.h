#import <Cocoa/Cocoa.h>

@interface BBCiPlayerEntity : NSObject {
    NSString *_id;
    NSString *_title;
    NSString *_synopsis;
}

- (id)initWithId:(NSString *)id title:(NSString *)title andSynopsis:(NSString *)synopsis;
- (NSString *)id;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSString *)synopsis;
- (void)setSynopsis:(NSString *)synopsis;

- (NSArray *)metadataLabels;
- (NSArray *)metadataObjs;

@end
