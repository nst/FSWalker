#import "NSNumber+Bytes.h"


@implementation NSNumber (Bytes)

- (NSString *)prettyBytes {
	float bytes = [self longValue];
	NSUInteger unit = 0;

	if(bytes < 1) return @"-";

	while(bytes > 1024) {
		bytes = bytes / 1024.0;
		unit++;
	}
	
	if(unit > 5) return @"HUGE";
	
	NSString *unitString = [[NSArray arrayWithObjects:@"Bytes", @"KB", @"MB", @"GB", @"TB", @"PB", nil] objectAtIndex:unit];
	
	if(unit == 0) {
		return [NSString stringWithFormat:@"%d %@", (int)bytes, unitString];
	} else {
		return [NSString stringWithFormat:@"%.2f %@", (float)bytes, unitString];
	}
}

@end
