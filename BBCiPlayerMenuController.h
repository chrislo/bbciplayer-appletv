#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@class BBCiPlayerEpisode;

@interface BBCiPlayerMenuController : BRMediaMenuController {
@protected
	NSMutableArray *_items;
}

- (NSString *)titleForRow:(long)row;
- (NSMutableArray *)episodeItemsFromIon:(NSDictionary *)ion;
- (void)episodeSelected:(BBCiPlayerEpisode *)episode;
- (id)previewControlForEpisode:(BBCiPlayerEpisode *)episode;

@end
