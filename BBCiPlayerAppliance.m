#import "BBCiPlayerAppliance.h"

@implementation BBCiPlayerAppliance

+ (NSString *)className {	
    NSString *className = NSStringFromClass(self);
    NSRange range = [[BRBacktracingException backtrace] rangeOfString: @"_loadApplianceAtPath:"];
    if (range.location != NSNotFound)
    {
        BRLog(@"[%@ className] called for whitelist check; returning MOVAppliance instead", className);
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
	while((obj = [enumerator nextObject]) != nil) {
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

-(id)controllerForIdentifier:(id)indent args:(id)args {

}

@end
