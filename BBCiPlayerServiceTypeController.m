#import "BBCiPlayerServiceTypeController.h"
#import "RefData.h"

@implementation BBCiPlayerServiceTypeController

- (id)initWithType:(BBCiPlayerServiceType)type {
    if ((self = [super init])) {
		_type = type;
    }
	
	_names = [[NSMutableArray alloc] initWithObjects:@"Highlights", @"Most Popular", nil];
	[_names retain];
	
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
		[_names addObject:[[services objectAtIndex:i] objectForKey:@"name"]];
	}
	
	[[self list] setDatasource:self];
	
    return self;
}

- (void)dealloc {
	[_names release];
	[super dealloc];
}

- (long)itemCount {
    return [_names count];
}

- (id)itemForRow:(long)row {
	BRTextMenuItemLayer *item = [BRTextMenuItemLayer folderMenuItem];
	[item setTitle:[_names objectAtIndex:row]];
	return item;
}

- (NSString *)titleForRow:(long)row {
    return [_names objectAtIndex:row];
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
    BRAlertController *controller = [BRAlertController alertOfType:0 titled:@"Click" primaryText:@"You clicked" secondaryText:nil];
    [[self stack] pushController:controller];
}

- (float)heightForRow:(long)row {
	return 0.0f;
}

@end
