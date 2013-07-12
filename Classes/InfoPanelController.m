//
//  InfoPanelController.m
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright 2008 Sen:te. All rights reserved.
//

#import "InfoPanelController.h"
#import "NSNumber+Bytes.h"

@implementation InfoPanelController

@synthesize modificationDate;
@synthesize ownerAndGroup;
@synthesize posixPermissions;
@synthesize creationDate;
@synthesize fileSize;
@synthesize fsItem;

- (IBAction)dismissInfoPanel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

- (void)viewDidLoad {
	//NSLog(@"-- viewDidLoad, %@", self.view);
}


- (void)viewWillAppear:(BOOL)animated {
	self.view; // load the view if it hasn't been loaded yet
	
	self.navigationItem.title = fsItem.filename;
	
	ownerAndGroup.text = fsItem.ownerAndGroup;
	fileSize.text = [[NSNumber numberWithLongLong:[fsItem.fileSize longLongValue]] prettyBytes];
	creationDate.text = [fsItem.creationDate description];
	modificationDate.text = [fsItem.modificationDate description];
	posixPermissions.text = [fsItem.posixPermissions description];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[modificationDate release];
	[ownerAndGroup release];
	[posixPermissions release];
	[creationDate release];
	[fileSize release];
	[fsItem release];
	
	[super dealloc];
}


@end
