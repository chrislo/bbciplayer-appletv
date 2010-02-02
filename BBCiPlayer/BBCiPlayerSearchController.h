#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface BBCiPlayerSearchController : BRTextEntryController <BRTextEntryDelegate, BRProvider, BRControlFactory> {
@protected
	NSMutableArray *_items;
	BOOL _editorAlreadyAtRightEdge;
}

- (void)textDidChange:(id)sender;
- (void)textDidEndEditing:(id)sender;
- (void)performSearchWithQuery:(NSString *)query;

@end
