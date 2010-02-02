#import "BBCiPlayerAtoZController.h"
#import "BBCiPlayerMostPopularController.h"
#import "BBCiPlayerServiceTypeController.h"
#import "BBCiPlayerEntity.h"

@implementation BBCiPlayerAtoZController

- (id)init {
    if ((self = [super init])) {
		[self setListTitle:@"A to Z"];
		
		_items = [[NSMutableArray alloc] init];
		[_items retain];
		
		NSArray *letters = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"0-9", nil];

		for (int i = 0; i < [letters count]; i++) {
			NSString *letter = [letters objectAtIndex:i];
			BBCiPlayerEntity *entity = [[BBCiPlayerEntity alloc] initWithId:letter title:letter andSynopsis:nil];
			[_items addObject:entity];
		}
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (id)initWithLetter:(NSString *)letter {
    if ((self = [super init])) {
		_letter = [letter retain];
		[self setListTitle:[@"A to Z: " stringByAppendingString:_letter]];
		
		BBCiPlayerEntity *tvMostPopular = [[BBCiPlayerEntity alloc] initWithId:@"mostpopular-tv" title:@"Most Popular TV" andSynopsis:nil];
		BBCiPlayerEntity *radioMostPopular = [[BBCiPlayerEntity alloc] initWithId:@"mostpopular-radio" title:@"Most Popular Radio" andSynopsis:nil];
		
		_items = [[NSMutableArray alloc] initWithObjects:tvMostPopular, radioMostPopular, nil];
		[_items retain];
		
		[tvMostPopular release];
		[radioMostPopular release];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (void)dealloc {
	[_letter release];
	[super dealloc];
}

- (void)itemSelected:(long)row {
	BBCiPlayerEntity *entity = [_items objectAtIndex:row];
    BBCiPlayerMenuController *controller;
	
	if (_letter) {
		if (row == 0) {
			controller = [[BBCiPlayerMostPopularController alloc] initWithLetter:_letter andServiceType:BBCiPlayerServiceTypeTV];
		}
		else if (row == 1) {
			controller = [[BBCiPlayerMostPopularController alloc] initWithLetter:_letter andServiceType:BBCiPlayerServiceTypeRadio];
		}
	}
	else {
		controller = [[BBCiPlayerAtoZController alloc] initWithLetter:[entity id]];
	}
	
    [controller autorelease];
    [[self stack] pushController:controller];
}

@end
