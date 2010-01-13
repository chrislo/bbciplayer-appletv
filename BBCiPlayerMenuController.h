#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface BBCiPlayerMenuController : BRMediaMenuController {
@protected
	NSMutableArray *_items;
}

- (NSString *)titleForRow:(long)row;
- (NSMutableArray *)episodeItemsFromIon:(NSDictionary *)ion;

@end
