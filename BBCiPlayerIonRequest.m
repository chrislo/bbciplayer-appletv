#import "BBCiPlayerIonRequest.h"
#import <JSON/JSON.h>

@implementation BBCiPlayerIonRequest

+ (NSDictionary *)sendRequestWithURL:(NSURL *)url {
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	NSURLResponse *response;
	NSError *error;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSDictionary *data;
	
	if (error == nil) {
		NSString *json = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		
		if (json) {
			data = [json JSONValue];
			[json release];
		}
		else {
			NSLog(@"Error in Dynamite response: %@", [responseData description]);
		}
	}
	else {
		NSLog(@"Error downloading %@: %@", url, [error localizedDescription]);
	}

	return data;
}

@end
