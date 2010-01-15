//
//  MoviePlayer.m
//  SimpleBrowser
//
//  Created by Jonathan Tweed on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MoviePlayer.h"


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
	
		[flvstreamerTask launch];
		[mplayerTask launch];
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

@end
