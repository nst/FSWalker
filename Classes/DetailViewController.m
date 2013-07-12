//
//  DetailViewController.m
//  FSWalker
//
//  Created by Nicolas Seriot on 01.02.09.
//  Copyright 2009 Sen:te. All rights reserved.
//

#import "DetailViewController.h"
#import "FSItem.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation DetailViewController

@synthesize fsItem;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {    // Called when the view is about to made visible. Default does nothing
	self.title = fsItem.prettyFilename;
}


- (void)viewDidAppear:(BOOL)animated {     // Called when the view has been fully transitioned onto the screen. Default does nothing
	NSArray *imageExt = [NSArray arrayWithObjects:@"png", @"pdf", @"jpg", @"gif", nil];
	NSArray *soundExt = [NSArray arrayWithObjects:@"m4r", @"caf", @"wav", @"aiff", nil];
	
	NSString *ext = [[fsItem.filename pathExtension] lowercaseString];
	
	if([ext isEqualToString:@"plist"]) {
		id plist = [NSDictionary dictionaryWithContentsOfFile:fsItem.path];
		if(!plist) plist = [NSArray arrayWithContentsOfFile:fsItem.path];
		if(!plist) return;
		
		BOOL txtFormat = ![[NSUserDefaults standardUserDefaults] boolForKey:@"XMLPlist"];
		
		if(txtFormat) {
			textView.text = [plist description];
			return;
		}
		
		NSString *errorString = nil;
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:plist format:kCFPropertyListXMLFormat_v1_0 errorDescription:&errorString];
		if(errorString) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error: can't open file"
															message:errorString
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[alert show]; 
			[alert release];
			
			[errorString release];
		} else {		
			textView.text = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		}
	} else if([imageExt containsObject:ext]) {
		imageView.image = [UIImage imageWithContentsOfFile:fsItem.path];
	} else if ([soundExt containsObject:ext]) {
		// TODO: handle sound
		// file:///Developer/Platforms/iPhoneOS.platform/Developer/Documentation/DocSets/com.apple.adc.documentation.AppleiPhone2_2.iPhoneLibrary.docset/Contents/Resources/Documents/samplecode/SysSound/listing4.html
		NSLog(@"-- TODO: play %@", fsItem.filename);
		
		SystemSoundID soundFileObject;
		CFURLRef urlRef = CFURLCreateWithString(NULL, (CFStringRef) fsItem.path, NULL);
		
		AudioServicesCreateSystemSoundID (urlRef, &soundFileObject);
		AudioServicesPlaySystemSound (soundFileObject);
		AudioServicesDisposeSystemSoundID (soundFileObject);
		CFRelease (urlRef);
	} else {
		NSError *e = nil;
		NSString *s = [NSString stringWithContentsOfFile:fsItem.path encoding:NSUTF8StringEncoding error:&e];
		if(e) { // try again
			e = nil;
			s = [NSString stringWithContentsOfFile:fsItem.path encoding:NSISOLatin1StringEncoding error:&e];			
		}
		
		if(!e && s) {
			imageView.image = nil;
			textView.text = s;
		} else if (e) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error: can't open file"
															message:[e localizedDescription]
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[alert show]; 
			[alert release];    
		}
	}
}

- (void)viewDidDisappear:(BOOL)animated {  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
	imageView.image = nil;
	textView.text = @"";
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[fsItem release];
    [super dealloc];
}


@end
