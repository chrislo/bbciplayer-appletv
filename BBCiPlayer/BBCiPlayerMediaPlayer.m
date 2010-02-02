#import "BBCiPlayerMediaPlayer.h"
#import <signal.h>
#import <sys/stat.h>

@implementation BBCiPlayerMediaPlayer

- (id)initWithPid:(NSString *)pid ofMediaType:(NSString *)type {
    if ((self = [super init])) {
        _pid = [pid retain];
		_type = [type retain];
		
		NSDictionary *info = [self streamInfo];
		
		if ([info objectForKey:@"playpath"]) {
		
			NSString *flvstreamerPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"flvstreamer" ofType:nil inDirectory:@"bin"];
			NSString *mplayerPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"mplayer" ofType:nil inDirectory:@"bin"];

			CFUUIDRef uuid = CFUUIDCreate(NULL);
			NSString *uniqueString = (NSString *)CFUUIDCreateString(NULL, uuid);
			CFRelease(uuid);
			
			_filePath = [NSString pathWithComponents:[NSArray arrayWithObjects: NSTemporaryDirectory(), [@"bbciplayer-" stringByAppendingString:uniqueString], nil]];
			[_filePath retain];

			mkfifo([_filePath cString], 0666);

			_flvstreamerTask = [[NSTask alloc] init];
			[_flvstreamerTask setLaunchPath:flvstreamerPath];
			
			NSMutableArray *flvstreamerArguments = [NSMutableArray arrayWithObjects:@"--port", @"1935", @"--timeout", @"10", @"--quiet", nil];
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
			[flvstreamerArguments addObject:@"-o"];
			[flvstreamerArguments addObject:_filePath];
			[_flvstreamerTask setArguments:flvstreamerArguments];
			
			_mplayerTask = [[[NSTask alloc] init] autorelease];
			[_mplayerTask setLaunchPath:mplayerPath];

			NSMutableArray *mplayerArguments = [NSMutableArray arrayWithObjects:@"-really-quiet", @"-cache", @"3072", nil];
			
			if ([type isEqualToString:@"audio"]) {
				[mplayerArguments addObject:@"-vo"];
				[mplayerArguments addObject:@"null"];
			}
			else {
				[mplayerArguments addObject:@"-vo"];
				[mplayerArguments addObject:@"corevideo:device_id=1"];
				[mplayerArguments addObject:@"-fs"];
			}
			
			[mplayerArguments addObject:@"-slave"];
			[mplayerArguments addObject:_filePath];
			
			[_mplayerTask setArguments:mplayerArguments];
			[_mplayerTask waitUntilExit];
			[_mplayerTask setStandardInput:[NSPipe pipe]];
						
			[[NSNotificationCenter defaultCenter] addObserver:self
													 selector:@selector(_mplayerTerminated:)
													     name:NSTaskDidTerminateNotification
													   object:_mplayerTask];

			[_flvstreamerTask launch];
			[_mplayerTask launch];
			
			_state = BBCiPlayerMediaPlayerStatePlaying;
		}
    }
    return self;
}

- (void)dealloc {
	[_mediaAsset release];
    [_pid release];
    [_type release];
	[_filePath release];
	[_mplayerTask release];
	[_flvstreamerTask release];
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

- (BOOL)setMediaAtIndex:(long)index inTrackList:(id)tracklist error:(id *)error {
	_mediaAsset = [tracklist objectAtIndex:index];
	return [super setMediaAtIndex:index inTrackList:tracklist error:error];
}

- (id)media {
	return _mediaAsset;
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
		NSFileHandle *mplayerStdin = [[_mplayerTask standardInput] fileHandleForWriting];
		[mplayerStdin writeData:[command dataUsingEncoding:NSASCIIStringEncoding]];
	}
	@catch (NSException *exception) {
		// ignore
	}
}

- (void)_mplayerTerminated:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSTaskDidTerminateNotification object:nil];
	kill([_flvstreamerTask processIdentifier], SIGKILL);
	[[NSFileManager defaultManager] removeFileAtPath:_filePath handler:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BBCiPlayerMediaPlayerDidTerminateNotification" object:self];
}

@end
