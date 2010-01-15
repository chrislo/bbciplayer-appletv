#import "BBCiPlayerCategoriesController.h"
#import	"BBCiPlayerCategoryController.h"
#import "BBCiPlayerCategory.h"
#import "BBCiPlayerService.h"
#import "RefData.h"

@implementation BBCiPlayerCategoriesController

- (id)init {
	return [self initWithService:nil];
}

- (id)initWithService:(BBCiPlayerService *)service {
    if ((self = [super init])) {
		[self setListTitle:@"Categories"];
		
		if (service) {
			_service = [service retain];
			[self setListIcon:[_service thumbnail]];
		}
		
		_items = [[NSMutableArray alloc] initWithArray:[RefData categories]];
		[_items retain];
		
		[[self list] setDatasource:self];
	}
	
    return self;
}

- (void)dealloc {
	[_service release];
	[super dealloc];
}

- (void)itemSelected:(long)row {
	BBCiPlayerCategory *category = [_items objectAtIndex:row];
    BBCiPlayerCategoryController *controller;
	
	if (_service) {
		controller = [[BBCiPlayerCategoryController alloc] initWithCategory:category andService:_service];
	}
	else {
		controller = [[BBCiPlayerCategoryController alloc] initWithCategory:category];
	}
	
    [controller autorelease];
    [[self stack] pushController:controller];
}

@end
