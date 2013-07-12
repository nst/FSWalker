//
//  RootViewController.m
//  FSWalker
//
//  Created by Nicolas Seriot on 17.08.08.
//  Copyright Sen:te 2008. All rights reserved.
//

#import "RootViewController.h"
#import "FSItemCell.h"
#import "DetailViewController.h"
#import "InfoPanelController.h"
#import "FSItem.h"

@implementation RootViewController

@dynamic fsItem;

- (void)setFsItem:(FSItem *)item {
	if(item != fsItem) {
		[item retain];
		[fsItem release];
		fsItem = item;

		self.title = fsItem.prettyFilename;
	}
}

- (FSItem *)fsItem {
	return fsItem;
}

- (void)viewDidLoad {
	// Add the following line if you want the list to be editable
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfo:) name:@"ShowInfo" object:nil];
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowInfo" object:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [fsItem.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"FSItemCell";
	
	FSItemCell *cell = (FSItemCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = (FSItemCell *)[[[NSBundle mainBundle] loadNibNamed:@"FSItemCell" owner:self options:nil] lastObject];
	}
	
	// Set up the cell
	FSItem *child = [fsItem.children objectAtIndex:indexPath.row];
	cell.fsItem = child;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	FSItem *child = [fsItem.children objectAtIndex:indexPath.row];
	
	if([child.posixPermissions intValue] == 0) return;

	NSString *path = [child.parent stringByAppendingPathComponent:child.filename];
	NSLog(@"did select %@", path);

	if(child.canBeFollowed) {
		RootViewController *rvc = [[RootViewController alloc] init];
		rvc.title = fsItem.filename;
		rvc.fsItem = child;
		[self.navigationController pushViewController:rvc animated:YES];
		[rvc release];
	} else {
		DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
		detailVC.fsItem = child;
		[self.navigationController pushViewController:detailVC animated:YES];	
		[detailVC release];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.title = fsItem.prettyFilename;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[fsItem release];	
	[super dealloc];
}

- (void)showInfo:(NSNotification *)notification {
	FSItem *anFSItem = [notification object];
	InfoPanelController *infoPanelVC = [[InfoPanelController alloc] initWithNibName:@"InfoPanelController" bundle:nil];
	infoPanelVC.fsItem = anFSItem;
	[self.navigationController presentModalViewController:infoPanelVC animated:YES];
	[infoPanelVC release];
}

@end

