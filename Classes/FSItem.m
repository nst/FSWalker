//
//  FSItem.m
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright 2008 Sen:te. All rights reserved.
//

#import "FSItem.h"

@implementation FSItem

@synthesize parent;
@synthesize filename;
@synthesize attributes;
@synthesize path;
@dynamic children;
@dynamic prettyFilename;
@dynamic icon;
@dynamic modificationDate;
@dynamic ownerName;
@dynamic groupName;
@dynamic posixPermissions;
@dynamic creationDate;
@dynamic fileSize;
@dynamic ownerAndGroup;
@dynamic isSymbolicLink;

- (BOOL)canBeFollowed {

	if([[self posixPermissions] intValue] == 0) return NO;
	
	if(self.isDirectory) return YES;
	
	if(self.isSymbolicLink) {
		NSFileManager *fm = [NSFileManager defaultManager];
		NSError *e = nil;
		NSString *destPath = [fm destinationOfSymbolicLinkAtPath:self.path error:&e];
		if(e || !destPath) return NO;
		return [fm contentsOfDirectoryAtPath:destPath error:nil] != nil;
	}
	
	return NO;
}

- (UIImage *)icon {
	if(self.isDirectory) {
		return [UIImage imageNamed:@"GenericFolderIcon.png"];
	} else if (self.isSymbolicLink) {
		return [UIImage imageNamed:@"SymLinkIcon.png"];
	} else {
		return [UIImage imageNamed:@"GenericDocumentIcon.png"];
	}
}
/*
- (UIImage *)image {
	if(self.isDirectory) {
		return [UIImage imageNamed:@"GenericFolder.png"];
	} else if (self.isSymbolicLink) {
		return [UIImage imageNamed:@"SymLink.png"];
	} else {
		return [UIImage imageNamed:@"GenericDocument.png"];
	}
}
*/

- (NSArray *)children {
	if(children == nil) {
		NSArray *childrenFilenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self.parent stringByAppendingPathComponent:self.filename] error:nil];
		NSMutableArray *a = [[NSMutableArray alloc] init];
		for(NSString *fn in childrenFilenames) {
			FSItem *child = [FSItem fsItemWithDir:[parent stringByAppendingPathComponent:filename] fileName:fn];
			[a addObject:child];
		}
		self.children = a;
		[a release];
	}
	return children;
}

- (void)setChildren:(NSArray *)someChildren {
    [children autorelease];
    children = [someChildren retain];
}

- (void)dealloc {
	[parent release];
	[filename release];
	[attributes release];
	[children release];
	[path release];
	[super dealloc];
}

- (BOOL)isDirectory {
	return [[attributes objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory];
}

- (BOOL)isSymbolicLink {
	return [[attributes objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink];
}

- (NSString *)prettyFilename {
	return [filename isEqualToString:@""] ? @"/" : filename;
}

+ (FSItem *)fsItemWithDir:(NSString *)dir fileName:(NSString *)fileName {
	FSItem *i = [[FSItem alloc] init];
	i.parent = dir;
	i.filename = fileName;
	i.path = [dir stringByAppendingPathComponent:fileName];
	i.attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:i.path error:nil];
	return [i autorelease];
}

- (NSDate *)modificationDate {
	return [self.attributes objectForKey:NSFileModificationDate];
}

- (NSString *)ownerName {
	return [self.attributes objectForKey:NSFileOwnerAccountName];
}

- (NSString *)groupName {
	return [self.attributes objectForKey:NSFileGroupOwnerAccountName];
}

- (NSString *)posixPermissions {
	NSNumber *n = [self.attributes objectForKey:NSFilePosixPermissions];
	return [NSString stringWithFormat:@"%O", [n unsignedLongValue]];
}

- (NSDate *)creationDate {
	return [self.attributes objectForKey:NSFileCreationDate];
}

- (NSString *)fileSize {
	return [self.attributes objectForKey:NSFileSize];
}

- (NSString *)ownerAndGroup {
	return [NSString stringWithFormat:@"%@ %@", self.ownerName, self.groupName];
}

@end
