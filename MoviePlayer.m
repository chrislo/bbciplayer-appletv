#import "MoviePlayer.h"
#import <OpenGL/OpenGL.h>
#import <objc/objc-class.h>

@class BRRenderContext;
@class CARenderer;

@interface BRRenderer (NitoAdditions)

- (BRRenderContext *) context;

- (CARenderer*) renderer;
- (void) setRenderer:(CARenderer*) theRenderer;

@end

@implementation BRRenderer (NitoAdditions)

- (BRRenderContext *) context
{
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_context");

	return *(BRRenderContext * *)(((char *)self)+ret->ivar_offset);
}

- (CARenderer*) renderer {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_renderer");

	return *(CARenderer * *)(((char *)self)+ret->ivar_offset);
}

- (void) setRenderer:(CARenderer*) theRenderer{
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_renderer");

	*(CARenderer * *)(((char *)self)+ret->ivar_offset) = theRenderer;
}
@end

static CARenderer *_brRenderer;
static BOOL _screensaverEnabled;

@implementation MoviePlayer

+ (void)playMovie:(NSString *)pid ofMediaType:(NSString *)type {
	
    NSDictionary *data = [self getStreamDataForVersion:pid ofMediaType:type];
	
	if ([data objectForKey:@"playpath"]) {
	
		NSString *flvstreamerPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"flvstreamer" ofType:nil inDirectory:@"bin"];
		NSString *mplayerPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"mplayer" ofType:nil inDirectory:@"bin"];
		
		NSTask *flvstreamerTask = [[[NSTask alloc] init] autorelease];
		[flvstreamerTask setLaunchPath:flvstreamerPath];
		
		NSMutableArray *flvstreamerArguments = [NSMutableArray arrayWithObjects:@"--port", @"1935", @"--timeout", @"10", @"--quiet", @"-o", @"-", nil];
		[flvstreamerArguments addObject:@"--protocol"];
		[flvstreamerArguments addObject:[data objectForKey:@"protocol"]];
		[flvstreamerArguments addObject:@"--playpath"];
		[flvstreamerArguments addObject:[data objectForKey:@"playpath"]];
		[flvstreamerArguments addObject:@"--host"];
		[flvstreamerArguments addObject:[data objectForKey:@"server"]];
		[flvstreamerArguments addObject:@"--swfUrl"];
		[flvstreamerArguments addObject:@"http://www.bbc.co.uk/emp/10player.swf?revision=14200_14320"];
		[flvstreamerArguments addObject:@"--tcUrl"];
		[flvstreamerArguments addObject:[data objectForKey:@"tcUrl"]];
		[flvstreamerArguments addObject:@"--app"];
		[flvstreamerArguments addObject:[data objectForKey:@"application"]];
		[flvstreamerTask setArguments:flvstreamerArguments];
		
		NSTask *mplayerTask = [[[NSTask alloc] init] autorelease];
		[mplayerTask setLaunchPath:mplayerPath];
		
		NSMutableArray *mplayerArguments = [NSMutableArray arrayWithObjects:@"-really-quiet", @"-cache", @"3072", @"-", nil];
		
		if ([type isEqualToString:@"audio"]) {
			[mplayerArguments addObject:@"-vo"];
			[mplayerArguments addObject:@"null"];
		}
		else {
			[mplayerArguments addObject:@"-vo"];
			[mplayerArguments addObject:@"corevideo:device_id=1"];
			[mplayerArguments addObject:@"-fs"];
		}
		
		[mplayerTask setArguments:mplayerArguments];
		[mplayerTask waitUntilExit];
		
		NSPipe *videoPipe = [NSPipe pipe];
		[flvstreamerTask setStandardOutput:videoPipe];
		[mplayerTask setStandardInput:videoPipe];
		
		
			[[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(mplayerTerminated:)
                                               name:NSTaskDidTerminateNotification
                                             object:mplayerTask];
											 
											 
		
		//if ([type isEqualToString:@"video"]) {
			_screensaverEnabled = [[BRSettingsFacade sharedInstance] screenSaverEnabled];
			[[BRSettingsFacade sharedInstance] setScreenSaverEnabled:NO];
			[self disableBRRendering];
			
			
			[flvstreamerTask launch];
		[mplayerTask launch];
			
	/*		
			  ProcessSerialNumber psn;
  OSErr err = 0;
  
  // loop until we find the process

  while([mplayerTask isRunning] && procNotFound == (err = GetProcessForPID([mplayerTask processIdentifier], &psn))) {
    // wait...
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
  }
  
  if(err) {
    NSLog(@"Error getting PSN: %d", err);
  } else {
    NSLog(@"Waiting for process to be visible");
    // wait for it to be visible
    while([mplayerTask isRunning] && !IsProcessVisible(&psn)) {
      // do nothing!
      [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
    if( [mplayerTask isRunning] ){
      NSLog(@"Process is visible, making it front");
      SetFrontProcess(&psn);
    }
  }  
  
  */
  
		//}
		
		// YOU BIG IDIOT
		// YOU ARE RENABLING THE RENDERING IMMEDIATELY YOURSELF
		// DUHHHH
		
		// THIS NEEDS TO BE DONE WHEN MPLAYER QUITS
		// so probably can take out the front process stuff (maybe) but not the disable/enable. try both ways.
		
//		if ([type isEqualToString:@"video"]) {
//			[self enableBRRendering];
//			[[BRSettingsFacade singleton] setScreenSaverEnabled:_screensaverEnabled];
//		}
	}
}


+ (NSDictionary *)getStreamDataForVersion:(NSString *)pid ofMediaType:(NSString *)type {
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    NSURL *url = [NSURL URLWithString:[@"http://www.bbc.co.uk/mediaselector/4/mtis/stream/" stringByAppendingString:pid]];
    NSXMLDocument *xml = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:nil];
	NSXMLElement *rootElement = [xml rootElement];
		
	NSString *xpath;
	NSArray *objectElements;
	
	if ([type isEqualToString:@"audio"]) {
		xpath = @"//media[@kind='audio' and @service='iplayer_uk_stream_aac_rtmp_concrete']/connection[@kind='akamai' or @kind='limelight']";
		objectElements = [rootElement nodesForXPath:xpath error:nil];
		
		// is it nations radio?
		if ([objectElements count] == 0) {
			xpath = @"//media[@kind='audio' and @service='iplayer_intl_stream_mp3']/connection[@kind='akamai' or @kind='limelight']";
			objectElements = [rootElement nodesForXPath:xpath error:nil];
			
			// is it local radio?
			if ([objectElements count] == 0) {
				xpath = @"//media[@kind='audio' and @service='iplayer_intl_stream_mp3_lo']/connection[@kind='akamai' or @kind='limelight']";
				objectElements = [rootElement nodesForXPath:xpath error:nil];
			}
		}
	}
	else {
		xpath = @"//media[@kind='video' and @service='iplayer_streaming_h264_flv_high']/connection[@kind='akamai' or @kind='limelight']";
		objectElements = [rootElement nodesForXPath:xpath error:nil];
	}
	
	NSXMLElement *connectionElement;
	if ([objectElements count] > 0) {
		connectionElement = [objectElements objectAtIndex:0];
		
		[data setObject:[[connectionElement attributeForName:@"server"] stringValue] forKey:@"server"];
		[data setObject:[[connectionElement attributeForName:@"identifier"] stringValue] forKey:@"identifier"];
		[data setObject:[[connectionElement attributeForName:@"authString"] stringValue] forKey:@"authString"];
		
		if ([connectionElement attributeForName:@"application"] == nil) {
			[data setObject:@"ondemand" forKey:@"application"];
		}
		else {
			[data setObject:[[connectionElement attributeForName:@"application"] stringValue] forKey:@"application"];
		}
		
		NSXMLNode *protocolNode = [connectionElement attributeForName:@"protocol"]; 
		if (protocolNode != nil && [[protocolNode stringValue] isEqualToString:@"rtmpe"]) {
			[data setObject:@"3" forKey:@"protocol"];
		}
		else {
			[data setObject:@"0" forKey:@"protocol"];
		}
		
		if ([[[connectionElement attributeForName:@"kind"] stringValue] isEqualToString:@"akamai"]) {
			[data setObject:[NSString stringWithFormat:@"%@?auth=%@&aifp=v001",
			                                           [data objectForKey:@"identifier"],
													   [data objectForKey:@"authString"]]
				  forKey:@"playpath"];
			
			// remove the mp3:/mp4: at the start
			NSString *identifier = [[data objectForKey:@"identifier"] substringFromIndex:4];
			[data setObject:identifier forKey:@"identifier"];
			
			[data setObject:[NSString stringWithFormat:@"%@?_fcs_vhost=%@&auth=%@&aifp=v001&slist=%@",
			                                           [data objectForKey:@"application"],
													   [data objectForKey:@"server"],
													   [data objectForKey:@"authString"],
													   [data objectForKey:@"identifier"]]
				  forKey:@"application"];
		}
		else if ([[[connectionElement attributeForName:@"kind"] stringValue] isEqualToString:@"limelight"]) {
			[data setObject:[NSString stringWithFormat:@"%@?%@",
			                                           [data objectForKey:@"identifier"],
													   [data objectForKey:@"authString"]]
				  forKey:@"playpath"];
		}
		
		[data setObject:[NSString stringWithFormat:@"rtmp://%@:1935/%@",
												   [data objectForKey:@"server"],
												   [data objectForKey:@"application"]]
			  forKey:@"tcUrl"];
	}
    
    [xml release];
    return data;
}

// adapted from xbmc
+ (void)enableBRRendering {
    BRDisplayManager *displayManager = [BRDisplayManager sharedInstance];
    
    //restore the renderer
    BRRenderer *theRender = [BRRenderer sharedInstance];
    [theRender setRenderer:_brRenderer];
    [displayManager captureAllDisplays];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BRDisplayManagerConfigurationEnd" object: [BRDisplayManager sharedInstance]];
}
 
// adapted from xbmc
+ (void)disableBRRendering {
    BRDisplayManager *displayManager = [BRDisplayManager sharedInstance];
    [displayManager releaseAllDisplays];
    
    //grab the context and release it
    BRRenderer *theRender = [BRRenderer sharedInstance];
    
    //we need to replace the CARenderer in BRRenderer or Finder crashes in its RenderThread
    //save it so it can be restored later
    _brRenderer = [theRender renderer];
    [theRender setRenderer:nil];
    
    //this enables XBMC to run as a proper fullscreen app (otherwise we get an invalid drawable)
    CGLContextObj ctx = [[theRender context] CGLContext];
    CGLClearDrawable( ctx );
}

+ (void)mplayerTerminated:(NSNotification *)note
{
	[self enableBRRendering];
				[[BRSettingsFacade singleton] setScreenSaverEnabled:_screensaverEnabled];
	
	//remove our listener
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
