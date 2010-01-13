#import "BBCiPlayerServiceTypeController.h"
#import "BBCiPlayerHighlightsController.h"
#import "BBCiPlayerMostPopularController.h"
#import "BBCiPlayerServiceController.h"
#import "BBCiPlayerMetadataPreviewControl.h"
#import "BBCiPlayerEntity.h"
#import "BBCiPlayerService.h"
#import "BBCiPlayerMediaAsset.h"
#import "RefData.h"

@implementation BBCiPlayerServiceTypeController

- (id)initWithType:(BBCiPlayerServiceType)type {
    if ((self = [super init])) {
		_type = type;
    }
	
	BBCiPlayerEntity *highlights = [[BBCiPlayerEntity alloc] initWithId:@"highlights" title:@"Highlights" andSynopsis:nil];
	BBCiPlayerEntity *mostPopular = [[BBCiPlayerEntity alloc] initWithId:@"mostpopular" title:@"Most Popular" andSynopsis:nil];
	
	_items = [[NSMutableArray alloc] initWithObjects:highlights, mostPopular, nil];
	[_items retain];
	
	[highlights release];
	[mostPopular release];
	
	NSArray *services;
	
	if (_type == BBCiPlayerServiceTypeTV) {
        [self setListTitle:@"TV"];
		services = [RefData tvServices];
	}
	else if (_type == BBCiPlayerServiceTypeRadio) {
        [self setListTitle:@"Radio"];
		services = [NSMutableArray array];
		[(NSMutableArray *)services addObjectsFromArray:[RefData networkRadioServices]];
		[(NSMutableArray *)services addObjectsFromArray:[RefData nationalRadioServices]];
		[(NSMutableArray *)services addObjectsFromArray:[RefData localRadioServices]];
	}
	
	for (int i = 0; i < [services count]; i++) {
		[_items addObject:[services objectAtIndex:i]];
	}
	
	[[self list] setDatasource:self];
	
    return self;
}

- (void)itemSelected:(long)row {
	BRController *controller;

	if (row == 0) {
		controller = [[BBCiPlayerHighlightsController alloc] initWithType:_type];
		[controller autorelease];
	}
	else if (row == 1) {
		controller = [[BBCiPlayerMostPopularController alloc] initWithType:_type];
		[controller autorelease];
	}
	else {
		BBCiPlayerService *service = [_items objectAtIndex:row];
		controller = [[BBCiPlayerServiceController alloc] initWithService:service];
	}
	
	[[self stack] pushController:controller];
}

- (id)previewControlForItem:(long)row {

	if (row < 2) {
		return nil;
	}
	
	NSString *identifier = [[_items objectAtIndex:row] id];
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:identifier ofType:@"jpg" inDirectory:@"ServicePreviews"];
	
	BBCiPlayerMetadataPreviewControl *preview = [[BBCiPlayerMetadataPreviewControl alloc] init];
	BBCiPlayerMediaAsset *asset = [[BBCiPlayerMediaAsset alloc] init];
	[asset setImagePath:path];
	[asset setImageOnly:YES];
	[preview setAsset:asset];
	[asset release];
	
	return [preview autorelease];
}

@end
