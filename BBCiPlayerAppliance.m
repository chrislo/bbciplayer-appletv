#import "BBCiPlayerAppliance.h"
#import "BBCiPlayerServiceTypeController.h"

#define TV_IDENTIFIER @"tv"
#define RADIO_IDENTIFIER @"radio"

@implementation BBCiPlayerAppliance

+ (NSString *)className {	
    NSString *className = NSStringFromClass(self);
    NSRange range = [[BRBacktracingException backtrace] rangeOfString: @"_loadApplianceAtPath:"];
    if (range.location != NSNotFound)
    {
        className = @"MOVAppliance"; 
    }
    return className;
}

-(id)applianceInfo {
	return [BRApplianceInfo infoForApplianceBundle:[NSBundle bundleForClass:[self class]]];
}

-(id)applianceCategories {
	NSMutableArray *categories = [NSMutableArray array];
	
	NSEnumerator *enumerator = [[[self applianceInfo] applianceCategoryDescriptors] objectEnumerator];
	id obj;
	while ((obj = [enumerator nextObject]) != nil) {
		BRApplianceCategory *category = [BRApplianceCategory categoryWithName:[obj valueForKey:@"name"] identifier:[obj valueForKey:@"identifier"] preferredOrder:[[obj valueForKey:@"preferred-order"] floatValue]];
		[categories addObject:category];
	}
	
	return categories;
}

- (id)previewControlForIdentifier:(id)ident {
	BRMainMenuImageControl *preview = [[BRMainMenuImageControl alloc] init];
	
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"MainMenuPreview" ofType:@"png"];
	BRImage *image = [BRImage imageWithPath:path];
	
	[preview setImage:(id)image];
	return [preview autorelease];
}

-(id)controllerForIdentifier:(id)ident args:(id)args {
	
	NSString *identifier = (NSString *)ident;
	BRController *controller;
	
	if ([identifier isEqualToString:TV_IDENTIFIER]) {
		controller = [[BBCiPlayerServiceTypeController alloc] initWithType:BBCiPlayerServiceTypeTV];
	}
	else if ([identifier isEqualToString:RADIO_IDENTIFIER]) {
		controller = [[BBCiPlayerServiceTypeController alloc] initWithType:BBCiPlayerServiceTypeRadio];
	}
	
	return [controller autorelease];
}

@end
