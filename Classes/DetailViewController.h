//
//  DetailViewController.h
//  FSWalker
//
//  Created by Nicolas Seriot on 01.02.09.
//  Copyright 2009 Sen:te. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSItem;

@interface DetailViewController : UIViewController {
	FSItem *fsItem;
	
	IBOutlet UITextView *textView;
	IBOutlet UIImageView *imageView;
}

@property (nonatomic, retain) FSItem *fsItem;

@end
