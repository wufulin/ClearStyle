//
//  FLTableViewCellDelegate.h
//  ClearStyle
//
//  Created by wufulin on 13-10-21.
//  Copyright (c) 2013年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLToDoItem.h"

@protocol FLTableViewCellDelegate <NSObject>

// indicates that the given item has been deleted
- (void)toDoItemDeleted:(FLToDoItem *)todoItem;

@end
