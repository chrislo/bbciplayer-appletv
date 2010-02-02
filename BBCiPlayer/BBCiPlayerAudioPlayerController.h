#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@class BBCiPlayerEpisode, BBCiPlayerMediaPlayer;

@interface BBCiPlayerAudioPlayerController : BRController {
	BBCiPlayerEpisode *_episode;
	BBCiPlayerMediaPlayer *_player;
	BRMusicNowPlayingControl *_nowPlaying;
}

- (id)initWithEpisode:(BBCiPlayerEpisode *)episode;
- (void)mediaPlayerTerminated:(NSNotification *)notification;

@end
