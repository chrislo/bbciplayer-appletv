#import "BBCiPlayerServiceTypeController.h"
#import "BBCiPlayerHighlightsController.h"
#import "BBCiPlayerMostPopularController.h"
#import "BBCiPlayerMediaAsset.h"
#import "RefData.h"

@implementation BBCiPlayerServiceTypeController

- (id)initWithType:(BBCiPlayerServiceType)type {
    if ((self = [super init])) {
		_type = type;
    }
	
	_items = [[NSMutableArray alloc] initWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Highlights", @"name", @"highlights", @"identifier", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Most Popular", @"name", @"mostpopular", @"identifier", nil], nil];
	[_items retain];
	
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

- (void)dealloc {
	[_items release];
	[super dealloc];
}

- (long)itemCount {
    return [_items count];
}

- (id)itemForRow:(long)row {
	BRTextMenuItemLayer *item = [BRTextMenuItemLayer folderMenuItem];
	[item setTitle:[[_items objectAtIndex:row] objectForKey:@"name"]];
	return item;
}

- (NSString *)titleForRow:(long)row {
    return [[_items objectAtIndex:row] objectForKey:@"name"];
}

- (long)rowForTitle:(NSString *)title {
    long result = -1;

    long i, count = [self itemCount];
    for (i = 0; i < count; i++) {
		if ([[self titleForRow:i] isEqualToString:title]) {
            result = i;
            break;
        }
    }

    return result;
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
		controller = [BRAlertController alertOfType:0 titled:@"Click" primaryText:@"You clicked" secondaryText:nil];
	}
	
	[[self stack] pushController:controller]; 
}

- (float)heightForRow:(long)row {
	return 0.0f;
}

- (id)previewControlForItem:(long)row {

	if (row < 2)
		return nil;

	NSString *identifier = [[_items objectAtIndex:row] objectForKey:@"identifier"];
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:identifier ofType:@"jpg" inDirectory:@"ServicePreviews"];
	
	BRMetadataPreviewControl *preview = [[BRMetadataPreviewControl alloc] init];
	BBCiPlayerMediaAsset *asset = [[BBCiPlayerMediaAsset alloc] init];
	[asset setImagePath:path];	
	[preview setAsset:asset];
	[asset release];
	
	return [preview autorelease];
}

@end
