#import "BBCiPlayerMediaPlayer.h"
#import <sys/stat.h>
#include <unistd.h>

@implementation BBCiPlayerMediaPlayer

- (id)initWithPid:(NSString *)pid ofMediaType:(NSString *)type {
    if ((self = [super init])) {
        _pid = [pid retain];
		_type = [type retain];
		
		NSDictionary *info = [self streamInfo];
		
		if ([info objectForKey:@"playpath"]) {
		
			NSString *flvstreamerPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"flvstreamer" ofType:nil inDirectory:@"bin"];
			NSString *mplayerPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"mplayer" ofType:nil inDirectory:@"bin"];

			NSTask *flvstreamerTask = [[[NSTask alloc] init] autorelease];
			[flvstreamerTask setLaunchPath:flvstreamerPath];
			
			NSMutableArray *flvstreamerArguments = [NSMutableArray arrayWithObjects:@"--port", @"1935", @"--timeout", @"15", @"--quiet", @"-o", @"-", nil];
			[flvstreamerArguments addObject:@"--protocol"];
			[flvstreamerArguments addObject:[info objectForKey:@"protocol"]];
			[flvstreamerArguments addObject:@"--playpath"];
			[flvstreamerArguments addObject:[info objectForKey:@"playpath"]];
			[flvstreamerArguments addObject:@"--host"];
			[flvstreamerArguments addObject:[info objectForKey:@"server"]];
			[flvstreamerArguments addObject:@"--swfUrl"];
			[flvstreamerArguments addObject:@"http://www.bbc.co.uk/emp/10player.swf?revision=14200_14320"];
			[flvstreamerArguments addObject:@"--tcUrl"];
			[flvstreamerArguments addObject:[info objectForKey:@"tcUrl"]];
			[flvstreamerArguments addObject:@"--app"];
			[flvstreamerArguments addObject:[info objectForKey:@"application"]];
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
			
			// create named pipe for controlling mplayer
			CFUUIDRef uuid = CFUUIDCreate(NULL);
			NSString *uniqueString = (NSString *)CFUUIDCreateString(NULL, uuid);
			CFRelease(uuid);
			
			_commandPipePath = [NSString pathWithComponents:[NSArray arrayWithObjects: NSTemporaryDirectory(), [@"bbciplayer-" stringByAppendingString:uniqueString], nil]];
			[_commandPipePath retain];
			
			mkfifo([_commandPipePath cString], 0666);
			
			[mplayerArguments addObject:@"-slave"];
			[mplayerArguments addObject:@"-input"];
			[mplayerArguments addObject:[@"file=" stringByAppendingString:_commandPipePath]];
			
			// mplayer arguments all set up, configure the task
			[mplayerTask setArguments:mplayerArguments];
			[mplayerTask waitUntilExit];
			
			NSPipe *videoPipe = [NSPipe pipe];
			[flvstreamerTask setStandardOutput:videoPipe];
			[mplayerTask setStandardInput:videoPipe];
						
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(_mplayerTerminated:)
													     name:NSTaskDidTerminateNotification
													   object:mplayerTask];

			[flvstreamerTask launch];
			[mplayerTask launch];
			
			// set state and open command pipe for writing
			_state = BBCiPlayerMediaPlayerStatePlaying;
			
			_commandPipe = [NSFileHandle fileHandleForWritingAtPath:_commandPipePath];
			[_commandPipe retain];
		}
    }
    return self;
}

- (void)dealloc {
    [_pid release];
    [_type release];
	[_commandPipe release];
	[_commandPipePath release];
    [super dealloc];
}


- (NSDictionary *)streamInfo {
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    NSURL *url = [NSURL URLWithString:[@"http://www.bbc.co.uk/mediaselector/4/mtis/stream/" stringByAppendingString:_pid]];
    NSXMLDocument *xml = [[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLDocumentTidyXML error:nil];
	NSXMLElement *rootElement = [xml rootElement];
		
	NSString *xpath;
	NSArray *objectElements;
	
	if ([_type isEqualToString:@"audio"]) {
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
		
		[info setObject:[[connectionElement attributeForName:@"server"] stringValue] forKey:@"server"];
		[info setObject:[[connectionElement attributeForName:@"identifier"] stringValue] forKey:@"identifier"];
		[info setObject:[[connectionElement attributeForName:@"authString"] stringValue] forKey:@"authString"];
		
		if ([connectionElement attributeForName:@"application"] == nil) {
			[info setObject:@"ondemand" forKey:@"application"];
		}
		else {
			[info setObject:[[connectionElement attributeForName:@"application"] stringValue] forKey:@"application"];
		}
		
		NSXMLNode *protocolNode = [connectionElement attributeForName:@"protocol"]; 
		if (protocolNode != nil && [[protocolNode stringValue] isEqualToString:@"rtmpe"]) {
			[info setObject:@"3" forKey:@"protocol"];
		}
		else {
			[info setObject:@"0" forKey:@"protocol"];
		}
		
		if ([[[connectionElement attributeForName:@"kind"] stringValue] isEqualToString:@"akamai"]) {
			[info setObject:[NSString stringWithFormat:@"%@?auth=%@&aifp=v001",
			                                           [info objectForKey:@"identifier"],
													   [info objectForKey:@"authString"]]
				  forKey:@"playpath"];
			
			// remove the mp3:/mp4: at the start
			NSString *identifier = [[info objectForKey:@"identifier"] substringFromIndex:4];
			[info setObject:identifier forKey:@"identifier"];
			
			[info setObject:[NSString stringWithFormat:@"%@?_fcs_vhost=%@&auth=%@&aifp=v001&slist=%@",
			                                           [info objectForKey:@"application"],
													   [info objectForKey:@"server"],
													   [info objectForKey:@"authString"],
													   [info objectForKey:@"identifier"]]
				  forKey:@"application"];
		}
		else if ([[[connectionElement attributeForName:@"kind"] stringValue] isEqualToString:@"limelight"]) {
			[info setObject:[NSString stringWithFormat:@"%@?%@",
			                                           [info objectForKey:@"identifier"],
													   [info objectForKey:@"authString"]]
				  forKey:@"playpath"];
		}
		
		[info setObject:[NSString stringWithFormat:@"rtmp://%@:1935/%@",
												   [info objectForKey:@"server"],
												   [info objectForKey:@"application"]]
			  forKey:@"tcUrl"];
	}
    
    [xml release];
    return info;
}

- (BBCiPlayerMediaPlayerState)state {
	return _state;
}

- (void)play {
	_state = BBCiPlayerMediaPlayerStatePlaying;
	[self _sendCommand:@"pause\n"];
}

- (void)pause {
	_state = BBCiPlayerMediaPlayerStatePaused;
	[self _sendCommand:@"pause\n"];
}

- (void)stop {
	_state = BBCiPlayerMediaPlayerStateStopped;
	[self _sendCommand:@"quit\n"];
}

- (void)_sendCommand:(NSString *)command {
	@try {
		[_commandPipe writeData:[command dataUsingEncoding:NSASCIIStringEncoding]];
	}
	@catch (NSException *exception) {
		// ignore
	}
}

- (void)_mplayerTerminated:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSTaskDidTerminateNotification object:nil];
	[_commandPipe closeFile];
	[[NSFileManager defaultManager] removeFileAtPath:_commandPipePath handler:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BBCiPlayerMediaPlayerDidTerminateNotification" object:self];
}

@end
