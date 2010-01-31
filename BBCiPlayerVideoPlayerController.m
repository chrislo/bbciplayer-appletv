#import "BBCiPlayerVideoPlayerController.h"
#import "BBCiPlayerMediaPlayer.h"
#import "BBCiPlayerEpisode.h"
#import <OpenGL/OpenGL.h>
#import <objc/objc-class.h>

@class BRRenderContext;
@class CARenderer;

@interface BRRenderer (BBCiPlayerAdditions)

- (BRRenderContext *)context;
- (CARenderer*)renderer;
- (void)setRenderer:(CARenderer*)renderer;

@end

@implementation BRRenderer (BBCiPlayerAdditions)

- (BRRenderContext *)context {
	Ivar ret = class_getInstanceVariable([self class], "_context");
	return *(BRRenderContext * *)(((char *)self)+ret->ivar_offset);
}

- (CARenderer *)renderer {
	Ivar ret = class_getInstanceVariable([self class], "_renderer");
	return *(CARenderer * *)(((char *)self)+ret->ivar_offset);
}

- (void)setRenderer:(CARenderer *)renderer {
	Ivar ret = class_getInstanceVariable([self class], "_renderer");
	*(CARenderer * *)(((char *)self)+ret->ivar_offset) = renderer;
}
@end

@interface BRSettingsFacade (compat)
- (int)screenSaverTimeout;
- (void)setScreenSaverTimeout:(int)f_timeout;
@end

static CARenderer *_backRowRenderer;
static int _screenSaverTimeout;

@implementation BBCiPlayerVideoPlayerController

- (id)initWithEpisode:(BBCiPlayerEpisode *)episode {
    if ((self = [super init])) {
        _episode = [episode retain];
		
		_player = [[BBCiPlayerMediaPlayer alloc] initWithPid:[_episode version] ofMediaType:[episode mediaType]];
		[_player retain];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
										 selector:@selector(mediaPlayerTerminated:)
											 name:@"BBCiPlayerMediaPlayerDidTerminateNotification"
										   object:_player];
		
		[self disableScreenSaver];
		[self disableBackRowRendering];
	}
    return self;
}

- (void)dealloc {
    [_episode release];
    [_player release];
    [super dealloc];
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
	[self enableBackRowRendering];
	[self enableScreenSaver];
	[[self stack] popController];
}

// adapted from xbmc
- (void)enableScreenSaver {
	[[BRSettingsFacade sharedInstance] setScreenSaverTimeout:_screenSaverTimeout];
	[[BRSettingsFacade sharedInstance] flushDiskChanges];
}

// adapted from xbmc
- (void)disableScreenSaver {
	_screenSaverTimeout = [[BRSettingsFacade sharedInstance] screenSaverTimeout];
	[[BRSettingsFacade sharedInstance] setScreenSaverTimeout:-1];
	[[BRSettingsFacade sharedInstance] flushDiskChanges];
}

// adapted from xbmc
- (void)enableBackRowRendering {
    BRRenderer *renderer = [BRRenderer sharedInstance];
    [renderer setRenderer:_backRowRenderer];
    [[BRDisplayManager sharedInstance] captureAllDisplays];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BRDisplayManagerConfigurationEnd" object:[BRDisplayManager sharedInstance]];
}

// adapted from xbmc
- (void)disableBackRowRendering {
    [[BRDisplayManager sharedInstance] releaseAllDisplays];
	BRRenderer *renderer = [BRRenderer sharedInstance];

    _backRowRenderer = [renderer renderer];
    [renderer setRenderer:nil];
    
    CGLContextObj ctx = [[renderer context] CGLContext];
    CGLClearDrawable(ctx);
}

@end
