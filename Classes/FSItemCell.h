//
//  FSItemCell.h
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright 2008 Sen:te. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSItem.h"

@interface FSItemCell : UITableViewCell {
	FSItem *fsItem;
	IBOutlet UIButton *iconButton;
	IBOutlet UILabel *label;
}

@property(retain) FSItem *fsItem;
@property(retain) UIButton *iconButton;
@property(retain) UILabel *label;

- (IBAction)showInfo:(id)sender;

@end
