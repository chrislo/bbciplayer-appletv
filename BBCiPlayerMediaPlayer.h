#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

enum {
    BBCiPlayerMediaPlayerStateStopped = 0,
	BBCiPlayerMediaPlayerStatePaused = 1,
	BBCiPlayerMediaPlayerStatePlaying = 2,
};
typedef unsigned int BBCiPlayerMediaPlayerState;

@class BBCiPlayerMediaAsset;

@interface BBCiPlayerMediaPlayer : BRMediaPlayer {
	BBCiPlayerMediaAsset *_mediaAsset;
	BBCiPlayerMediaPlayerState _state;
	NSString *_pid;
	NSString *_type;
	NSString *_commandPipePath;
	NSFileHandle *_commandPipe;
}

- (id)initWithPid:(NSString *)pid ofMediaType:(NSString *)type;
- (NSDictionary *)streamInfo;
- (BBCiPlayerMediaPlayerState)state;
- (void)play;
- (void)pause;
- (void)stop;
- (void)_sendCommand:(NSString *)command;
- (void)_mplayerTerminated:(NSNotification *)notification;

extern NSString *kBRMediaPlayerCurrentAssetChanged;

@end
