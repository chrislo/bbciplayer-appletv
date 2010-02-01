#import "BBCiPlayerSearchController.h"
#import "BBCiPlayerVideoPlayerController.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerIonRequest.h"
#import "BBCiPlayerAudioPlayerController.h"
#import "BBCiPlayerVideoPlayerController.h"

@implementation BBCiPlayerSearchController

- (id)init {
    if ((self = [super initWithTextEntryStyle:2])) {
		[self setTitle:@"Search"];
		[self setTextFieldDelegate:self];
		_items = [[NSMutableArray alloc] init];
		[_items retain];
		[_list setAcceptsFocus:YES];
		[_list setProvider:self];
	}
	
    return self;
}

- (void)dealloc {
	[_items release];
	[super dealloc];
}

- (long)dataCount {
	return [_items count];
}

- (id)dataAtIndex:(long)row {
	return [_items objectAtIndex:row];
}

- (id)hashForDataAtIndex:(long)row {
	return [[self dataAtIndex:row] id];
}

- (id)controlFactory {
	return self;
}

- (id)controlForData:(id)data currentControl:(id)current requestedBy:(id)sender {
	BRTextImageMenuItemLayer *control = [BRTextImageMenuItemLayer twoLineMenuItem];
	[control setTitle:[data title]];
		
	if ([data broadcast]) {
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[control setSubtitle:[@"Aired " stringByAppendingString:[dateFormatter stringFromDate:[data broadcast]]]];
		[dateFormatter release];
	}
	
	NSString *imagePath = [[@"http://www.bbc.co.uk/iplayer/images/episode/" stringByAppendingString:[data id]] stringByAppendingString:@"_178_100.jpg"];
	NSURL *imageURL = [NSURL URLWithString:imagePath];
	[control setThumbnailImage:[BRImage imageWithURL:imageURL]];
	
	return control;
}

- (float)heightForRow:(long)row {
	return 0.0f;
}

- (BOOL)rowSelectable:(long)row {
	return YES;
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

- (void)layoutSubcontrols {
	[super layoutSubcontrols];

	CGRect listFrame = [_list frame];
	listFrame.origin.x *= 1.75f;
	[_list setFrame:listFrame];
		
	CGRect editorFrame = [_editor frame];
	editorFrame.origin.x *= 0.25f;
	editorFrame.origin.y = editorFrame.origin.x;
	[_editor setFrame:editorFrame];
}

- (void)textDidChange:(id)sender {
	[self performSearchWithQuery:[sender stringValue]];
}

- (void)textDidEndEditing:(id)sender {
	[self performSearchWithQuery:[sender stringValue]];
}

- (void)performSearchWithQuery:(NSString *)query {
	NSURL *ionURL = [NSURL URLWithString:[@"http://www.bbc.co.uk/iplayer/ion/search/local_radio/included/format/json?q=" stringByAppendingString:[query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
	NSDictionary *ion = [BBCiPlayerIonRequest sendRequestWithURL:ionURL];
	[_items release];
	_items = [[self episodeItemsFromIon:ion] retain];
	[_list reload];
	[self refreshControllerForModelUpdate];
}

- (void)itemSelected:(long)row {
	BBCiPlayerEpisode *episode = [self dataAtIndex:row];
	BRController *controller;
	if ([[episode mediaType] isEqualToString:@"audio"]) {
		controller = [[BBCiPlayerAudioPlayerController alloc] initWithEpisode:episode];
	}
	else {
		controller = [[BBCiPlayerVideoPlayerController alloc] initWithEpisode:episode];
	}
	[controller autorelease];
    [[self stack] pushController:controller];
}

- (BOOL)brEventAction:(BREvent *)event {

	if ([event remoteAction] == 6) { // left
		if ([self focusedControl] == _list) {
			[self setFocusedControl:_editor];
			return YES;
		}
		else {
			_editorAlreadyAtRightEdge = NO;
			return [super brEventAction:event];
		}
	}
	else if ([event remoteAction] == 7) { // right
		if (_editorAlreadyAtRightEdge && [_editor _keyboardFocusIsAtEdge:2] && [self dataCount] > 0) {
			[self setFocusedControl:_list];
			return YES;
		}
		else if ([_editor _keyboardFocusIsAtEdge:2]) {
			_editorAlreadyAtRightEdge = YES;
			return YES;
		}
	}
	else if ([event remoteAction] == 1 && [self focusedControl] == _list) { // menu
		_editorAlreadyAtRightEdge = NO;
		[_editor setFocusToGlyphNamed:@"Clear"];
		[self setFocusedControl:_editor];
		return YES;
	}
	
	return [super brEventAction:event];
}

@end
