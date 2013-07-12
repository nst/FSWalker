//
//  InfoPanelController.h
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright 2008 Sen:te. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSItem.h"

@interface InfoPanelController : UIViewController {
	IBOutlet UILabel *modificationDate;
	IBOutlet UILabel *ownerAndGroup;
	IBOutlet UILabel *posixPermissions;
	IBOutlet UILabel *creationDate;
	IBOutlet UILabel *fileSize;
	FSItem *fsItem;
}

@property(retain) UILabel *modificationDate;
@property(retain) UILabel *ownerAndGroup;
@property(retain) UILabel *posixPermissions;
@property(retain) UILabel *creationDate;
@property(retain) UILabel *fileSize;
@property(retain) FSItem *fsItem;

- (IBAction)dismissInfoPanel:(id)sender;

@end
