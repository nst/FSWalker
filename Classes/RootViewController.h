//
//  RootViewController.h
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright Sen:te 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSItem;

@interface RootViewController : UITableViewController {
	FSItem *fsItem;
}

@property(nonatomic, retain) FSItem *fsItem;

@end
