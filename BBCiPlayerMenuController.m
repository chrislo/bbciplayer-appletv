#import "BBCiPlayerMenuController.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerMediaAsset.h"
#import "BBCiPlayerMetadataPreviewControl.h"

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

- (id)previewControlForItem:(long)row {
	return nil;
}

- (NSMutableArray *)episodeItemsFromIon:(NSDictionary *)ion {
	NSMutableArray *episodes = [NSMutableArray array];
	if (ion) {
		NSArray *blocklist = [ion objectForKey:@"blocklist"];
		
		for (int i = 0; i < [blocklist count]; i++) {
				
			NSDictionary *episodeData;
			if ([[blocklist objectAtIndex:i] objectForKey:@"episode"]) {
				episodeData = [[blocklist objectAtIndex:i] objectForKey:@"episode"];
			}
			else {
				episodeData = [blocklist objectAtIndex:i];
			}
			
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

- (void)episodeSelected:(BBCiPlayerEpisode *)episode {
    BRAlertController *controller = [BRAlertController alertOfType:0 titled:[episode title] primaryText:[episode id] secondaryText:nil];
    [[self stack] pushController:controller];
}

- (id)previewControlForEpisode:(BBCiPlayerEpisode *)episode {
	NSString *path = [[@"http://www.bbc.co.uk/iplayer/images/episode/" stringByAppendingString:[episode id]] stringByAppendingString:@"_512_288.jpg"];
	NSURL *url = [NSURL URLWithString:path];
	
	BBCiPlayerMediaAsset *asset = [[BBCiPlayerMediaAsset alloc] init];
	[asset setImage:[BRImage imageWithURL:url]];
	[asset setTitle:[episode title]];
	[asset setMediaSummary:[episode synopsis]];
	
	BBCiPlayerMetadataPreviewControl *preview = [[BBCiPlayerMetadataPreviewControl alloc] initWithEntity:episode];
	[preview setAsset:asset];
	[asset release];

	return [preview autorelease];
}

@end
