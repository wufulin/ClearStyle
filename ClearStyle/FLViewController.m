//
//  FLViewController.m
//  ClearStyle
//
//  Created by wufulin on 13-10-21.
//  Copyright (c) 2013年 netease. All rights reserved.
//

#import "FLViewController.h"
#import "FLToDoItem.h"
#import "FLTableViewCell.h"

@interface FLViewController () {
	// an Array of to-do items
	NSMutableArray *_toDoItems;
}
@end

@implementation FLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.tableView.dataSource = self;
	[self.tableView registerClass:[FLTableViewCell class] forCellReuseIdentifier:@"cell"];
	self.tableView.delegate = self;
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// create a dummy to-do list
		_toDoItems = [[NSMutableArray alloc] init];
		[_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Feed the cat"]];
		[_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Buy eggs"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Pack bags for WWDC"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Rule the web"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Buy a new iPhone"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Find missing socks"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Write a new tutorial"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Master Objective-C"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Remember your wedding anniversary!"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Drink less beer"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Learn to draw"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Take the car to the garage"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Sell things on eBay"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Learn to juggle"]];
        [_toDoItems addObject:[FLToDoItem toDoItemWithText:@"Give up"]];
	}
	return self;
}

- (UIColor *)colorForIndex:(NSInteger)index {
	NSUInteger itemCount = _toDoItems.count - 1;
	float val = ((float)index / (float)itemCount) * 0.6;
	return [UIColor colorWithRed:1.0 green:val blue:0.0 alpha:1.0];
}

#pragma mark - UITableViewDataSourece protocol methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _toDoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *ident = @"cell";
	// re-use or create a cell
	FLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	// find the to-do item for this index
	int index = [indexPath row];
	FLToDoItem *item = _toDoItems[index];
	// set the text
//	cell.textLabel.text = item.text;
	cell.delegate = self;
	cell.todoItem = item;
	
	return cell;
}
#pragma mark - UITableViewDelegate protocol methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [self colorForIndex:indexPath.row];
}

#pragma mark - FLTableViewCellDelegate protocol methods
- (void)toDoItemDeleted:(id)todoItem {
	// use the UITableView to animate the removal of this row
	NSUInteger index = [_toDoItems indexOfObject:todoItem];
	[self.tableView beginUpdates];
	[_toDoItems removeObject:todoItem];
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
}

@end
