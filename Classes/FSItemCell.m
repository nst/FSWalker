//
//  FSItemCell.m
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright 2008 Sen:te. All rights reserved.
//

#import "FSItemCell.h"

@implementation FSItemCell

@synthesize iconButton;
@synthesize label;
@dynamic fsItem;

- (void)setFsItem:(FSItem *)item {
	[item retain];
	[fsItem release];
	fsItem = item;
	
	label.text = item.filename;
	[iconButton setImage:item.icon forState:UIControlStateNormal];
	
	self.accessoryType = item.canBeFollowed ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	
	label.textColor = [item.posixPermissions intValue] ? [UIColor blackColor] : [UIColor lightGrayColor];
}

- (FSItem *)fsItem {
	return fsItem;
}

- (void)dealloc {
	[fsItem release];
	[iconButton release];
	[label release];
	[super dealloc];
}

- (IBAction)showInfo:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowInfo" object:fsItem];
}

@end
