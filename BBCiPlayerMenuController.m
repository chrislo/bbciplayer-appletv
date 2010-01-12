#import "BBCiPlayerMenuController.h"
#import "BBCiPlayerMediaAsset.h"
#import "BBCiPlayerMetadataPreviewControl.h"
#import "NSDictionary+BSJSONAdditions.h"

@implementation BBCiPlayerMenuController

- (void)dealloc {
	[_items release];
	[super dealloc];
}

- (long)itemCount {
    return [_items count];
}

- (id)itemForRow:(long)row {
	BRTextMenuItemLayer *item = [BRTextMenuItemLayer menuItem];
	[item setTitle:[self titleForRow:row]];
	return item;
}

- (NSString *)titleForRow:(long)row {
    return [[_items objectAtIndex:row] title];
}

- (long)rowForTitle:(NSString *)title {
    long result = -1;

    long i, count = [self itemCount];
    for (i = 0; i < count; i++) {
		if ([[self titleForRow:i] isEqualToString:title]) {
            result = i;
            break;
        }
    }

    return result;
}

- (float)heightForRow:(long)row {
	return 0.0f;
}

@end
