#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@class BBCiPlayerEpisode, BBCiPlayerMediaPlayer;

@interface BBCiPlayerVideoPlayerController : BRController {
	BBCiPlayerEpisode *_episode;
	BBCiPlayerMediaPlayer *_player;
}

- (id)initWithEpisode:(BBCiPlayerEpisode *)episode;
- (void)mediaPlayerTerminated:(NSNotification *)notification;
- (void)enableBackRowRendering;
- (void)disableBackRowRendering;
- (void)enableScreenSaver;
- (void)disableScreenSaver;

@end
