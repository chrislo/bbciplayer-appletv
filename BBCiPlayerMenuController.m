#import "BBCiPlayerMenuController.h"
#import "BBCiPlayerEpisode.h"
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

- (NSMutableArray *)episodeItemsFromIon:(NSDictionary *)ion {
	NSMutableArray *episodes = [NSMutableArray array];
	if (ion) {
		NSArray *blocklist = [ion objectForKey:@"blocklist"];
		
		for (int i = 0; i < [blocklist count]; i++) {
			NSDictionary *episodeData = [blocklist objectAtIndex:i];
			NSString *availability = [episodeData objectForKey:@"availability"];
			if ([availability isEqualToString:@"CURRENT"]) {
				BBCiPlayerEpisode *episode = [[BBCiPlayerEpisode alloc] initWithIon:episodeData];
				[episodes addObject:episode];
				[episode release];
			}
		}
	}
	return episodes;
}

@end
