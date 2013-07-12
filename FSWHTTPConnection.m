//
//  FSWHTTPConnection.m
//  FSWalker
//
//  Created by Nicolas Seriot on 01.02.09.
//  Copyright 2009 Sen:te. All rights reserved.
//

#import "FSWHTTPConnection.h"
#import "HTTPResponse.h"
#import "NSNumber+Bytes.h"
#import "MyIP.h"

@implementation NSString (FSWalker)

- (BOOL)isDirectory {	
	BOOL isDir = NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:&isDir] && isDir;
}

- (NSString *)lastChange {
	NSDictionary *d = [[NSFileManager defaultManager] attributesOfItemAtPath:self error:nil];
	NSString *s = [[d objectForKey:NSFileModificationDate] description];
	return s ? s : @"-";
}

- (NSString *)prettySize {
	if([self isDirectory]) return @"-";
	
	NSDictionary *d = [[NSFileManager defaultManager] attributesOfItemAtPath:self error:nil];
	NSNumber *n = [NSNumber numberWithLongLong:[[d objectForKey:NSFileSize] longLongValue]];
	NSString *s = [n prettyBytes];
	return s ? s : @"-";
}

@end

@implementation FSWHTTPConnection

- (NSString *)myIP {
	NSString *myIP = [[[MyIP sharedInstance] ipsForInterfaces] objectForKey:@"en0"];
	
#if TARGET_IPHONE_SIMULATOR
	if(!myIP) {
		myIP = [[[MyIP sharedInstance] ipsForInterfaces] objectForKey:@"en1"];
	}
#endif
	
	return myIP;
}

/**
 * Converts relative URI path into full file-system path.
 **/
- (NSString *)filePathForURI:(NSString *)path
{

	// Convert path to a relative path.
	// This essentially means trimming beginning '/' characters.
	// Beware of a bug in the Cocoa framework:
	// 
	// [NSURL URLWithString:@"/foo" relativeToURL:baseURL]       == @"/baseURL/foo"
	// [NSURL URLWithString:@"/foo%20bar" relativeToURL:baseURL] == @"/foo bar"
	// [NSURL URLWithString:@"/foo" relativeToURL:baseURL]       == @"/foo"
	
	NSString *relativePath = path;
	
	while([relativePath hasPrefix:@"/"] && [relativePath length] > 1) {
		relativePath = [relativePath substringFromIndex:1];
	}
	
	NSURL *url = [NSURL URLWithString:relativePath relativeToURL:[NSURL URLWithString:@"/"]];
	
	// Watch out for sneaky requests with ".." in the path
	// For example, the following request: "../Documents/TopSecret.doc"
	if(![[url path] hasPrefix:@"/"]) return nil;
	
	return [[url path] stringByStandardizingPath];
}

/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResponse is a wrapper for an NSData object, and may be used to send a custom response.
 **/
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	// Override me to provide custom responses.
	
	NSString *filePath = [self filePathForURI:path];
	
	BOOL isDir = NO;
	
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir]) {
		if(isDir) {
			NSMutableString *html = [[NSMutableString alloc] init];
			[html appendString:@"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2 Final//EN\">\n"];
			[html appendFormat:@"<HTML>\n<HEAD>\n<TITLE>Index of %@</TITLE>\n</HEAD>\n<BODY>\n", filePath];
			[html appendFormat:@"<H1>Index of %@</H1>\n<pre>\n", filePath];

			NSString *iconFolder = [[NSBundle mainBundle] pathForResource:@"folder" ofType:@"gif"];
			NSString *iconGeneric = [[NSBundle mainBundle] pathForResource:@"generic" ofType:@"gif"];
			NSString *iconBack = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"gif"];
			NSString *iconImage = [[NSBundle mainBundle] pathForResource:@"image2" ofType:@"gif"];
			NSString *iconPdf = [[NSBundle mainBundle] pathForResource:@"image2" ofType:@"gif"];
			NSString *iconBlank = [[NSBundle mainBundle] pathForResource:@"blank" ofType:@"gif"];
			
			NSString *parentDirPad = [@"Name" stringByPaddingToLength:48 withString:@" " startingAtIndex:0];
			NSString *lastChangePad = [@"Last modified" stringByPaddingToLength:28 withString:@" " startingAtIndex:0];
			NSString *sizePad = [@"Size" stringByPaddingToLength:28 withString:@" " startingAtIndex:0];
			
			[html appendFormat:@"<img src=\"%@\" /> %@    %@  %@<hr/>", iconBlank, parentDirPad, lastChangePad, sizePad];
			
			[html appendFormat:@"<img src=\"%@\" /> <A HREF=\"%@\">Parent Directory</A>\n", iconBack, [filePath stringByDeletingLastPathComponent]];
			
			NSError *error = nil;
			NSArray *a = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
			if(!error && a) {
				for(NSString *s in a) {
					NSString *dest = [filePath stringByAppendingPathComponent:s];
					NSString *ext = [[s pathExtension] lowercaseString];
					NSString *iconPath = iconGeneric;
					if([dest isDirectory]) {
						iconPath = iconFolder;
					} else if ([[NSArray arrayWithObjects:@"png", @"gif", @"jpg", nil] containsObject:ext]) {
						iconPath = iconImage;
					} else if ([ext isEqualToString:@"pdf"]) {
						iconPath = iconPdf;
					}
					
					NSString *lastChange = [[dest lastChange] stringByPaddingToLength:28 withString:@" " startingAtIndex:0];
					NSString *prettySize = [[dest prettySize] stringByPaddingToLength:28 withString:@" " startingAtIndex:0];
		 			
					NSString *pad = @" ";
					int padLength = 48-[[s lastPathComponent] length];
					if (padLength > 0)
						pad = [@"" stringByPaddingToLength:padLength withString:@" " startingAtIndex:0];
				
					[html appendFormat:@"<img src=\"%@\" /> <A HREF=\"%@\">%@</A>  %@  %@  %@\n", iconPath, dest, [s lastPathComponent], pad, lastChange, prettySize];
				}
			}
			
			[html appendFormat:@"<hr /></pre>\n<address>%@/CocoaHTTPServer on %@ %@, at %@ (%@) Port %u</address>\n</BODY>\n</HTML>\n",
				[[NSProcessInfo processInfo] processName], [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion], [self myIP], [[NSProcessInfo processInfo] hostName], [server port]];
			
			NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
			[html release];

			HTTPDataResponse *r = [[HTTPDataResponse alloc] initWithData:data];
			return [r autorelease];
			
		} else {
			if([[filePath pathExtension] isEqualToString:@"plist"]) {
				id plist = [NSDictionary dictionaryWithContentsOfFile:filePath];
				if(!plist) plist = [NSArray arrayWithContentsOfFile:filePath];
				if(!plist) return [[[HTTPDataResponse alloc] initWithData:nil] autorelease];
				
				NSString *errorString = nil;
				NSData *data = [NSPropertyListSerialization dataFromPropertyList:plist format:kCFPropertyListXMLFormat_v1_0 errorDescription:&errorString];
				if(errorString) {
					data = [errorString dataUsingEncoding:NSUTF8StringEncoding];
					return [[[HTTPDataResponse alloc] initWithData:data] autorelease];
				} else {		
					return [[[HTTPDataResponse alloc] initWithData:data] autorelease]; // FIXME: return HTTP header Content-Type: text/plain
				}
			}
			
			return [[[HTTPFileResponse alloc] initWithFilePath:filePath] autorelease];	
		}
	}
	
	return nil;
}


@end
