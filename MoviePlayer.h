//
//  MoviePlayer.h
//  SimpleBrowser
//
//  Created by Jonathan Tweed on 06/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface MoviePlayer : NSObject {

}

+ (void)playMovie:(NSString *)pid ofMediaType:(NSString *)type;
+ (NSDictionary *)getStreamDataForVersion:(NSString *)pid ofMediaType:(NSString *)type;

+ (void)enableBRRendering;
+ (void)disableBRRendering;
+ (void)mplayerTerminated:(NSNotification *)note;

@end
