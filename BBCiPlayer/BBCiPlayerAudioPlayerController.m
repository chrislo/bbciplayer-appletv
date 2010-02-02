#import "BBCiPlayerAudioPlayerController.h"
#import "BBCiPlayerMediaPlayer.h"
#import "BBCiPlayerEpisode.h"
#import "BBCiPlayerMediaAsset.h"
#import "RefData.h"

@implementation BBCiPlayerAudioPlayerController

- (id)initWithEpisode:(BBCiPlayerEpisode *)episode {
    if ((self = [super init])) {
        _episode = [episode retain];
		
		NSString *path = [[@"http://www.bbc.co.uk/iplayer/images/episode/" stringByAppendingString:[episode id]] stringByAppendingString:@"_512_288.jpg"];
		NSURL *url = [NSURL URLWithString:path];
		BBCiPlayerMediaAsset *asset = [[BBCiPlayerMediaAsset alloc] init];
		[asset setImage:[BRImage imageWithURL:url]];
		[asset setTitle:[episode title]];
		
		// ick
		NSMutableArray *services = [NSMutableArray array];
		[(NSMutableArray *)services addObjectsFromArray:[RefData networkRadioServices]];
		[(NSMutableArray *)services addObjectsFromArray:[RefData nationalRadioServices]];
		[(NSMutableArray *)services addObjectsFromArray:[RefData localRadioServices]];
		
		for (int i = 0; i < [services count]; i++) {
			if ([[[services objectAtIndex:i] id] isEqualToString:[episode masterbrand]]) {
				[asset setArtist:[[services objectAtIndex:i] title]];
				break;
			}
		}
		
		[asset setMediaSummary:[episode synopsis]];
		[asset setIsRadio:YES];

		_player = [[BBCiPlayerMediaPlayer alloc] initWithPid:[_episode version] ofMediaType:[episode mediaType]];
		[_player retain];
		[_player setMediaAtIndex:0 inTrackList:[NSArray arrayWithObject:asset] error:nil];
		[_player setState:3 error:nil];
		
		_nowPlaying = [NSClassFromString(@"BRMusicNowPlayingControl") control];
		[_nowPlaying retain];
		[_nowPlaying setPlayer:_player];
		[self addControl:_nowPlaying];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
										 selector:@selector(mediaPlayerTerminated:)
											 name:@"BBCiPlayerMediaPlayerDidTerminateNotification"
										   object:_player];
	}
    return self;
}

- (void)dealloc {
	[_nowPlaying release];
    [_episode release];
	[_player release];
    [super dealloc];
}

- (void)layoutSubcontrols {
	[super layoutSubcontrols];
	[_nowPlaying setFrame:[self frame]];
}

- (BOOL)brEventAction:(BREvent *)event {

	// 5 == play/pause
	// 1 == menu

	if ([event remoteAction] == 5) {
		if ([_player state] == BBCiPlayerMediaPlayerStatePlaying) {
			[_player pause];
		}
		else if ([_player state] == BBCiPlayerMediaPlayerStatePaused) {
			[_player play];
		}
		return YES;
	}
	else if ([event remoteAction] == 1) {
		[_player stop];
		return YES;
	}
	
	return [super brEventAction:event];
}

- (void)mediaPlayerTerminated:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"BBCiPlayerMediaPlayerDidTerminateNotification" object:_player];
	[[self stack] popController];
}

@end
