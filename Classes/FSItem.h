//
//  FSItem.h
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright 2008 Sen:te. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FSItem : NSObject {
	NSString *parent;
	NSString *filename;
	NSDictionary *attributes;
	NSArray *children;
	NSString *path;
}

@property(retain) NSString *parent;
@property(retain) NSString *filename;
@property(retain) NSDictionary *attributes;
@property(retain) NSArray *children;
@property(retain) NSString *path;

@property(readonly) NSString *prettyFilename;
@property(readonly) UIImage *icon;
//@property(readonly) UIImage *image;
@property(readonly) NSDate *modificationDate;
@property(readonly) NSString *ownerName;
@property(readonly) NSString *groupName;
@property(readonly) NSString *posixPermissions;
@property(readonly) NSDate *creationDate;
@property(readonly) NSString *fileSize;
@property(readonly) NSString *ownerAndGroup;

@property(readonly) BOOL isDirectory;
@property(readonly) BOOL isSymbolicLink;
@property(readonly) BOOL canBeFollowed;

+ (FSItem *)fsItemWithDir:(NSString *)dir fileName:(NSString *)fileName;

@end
