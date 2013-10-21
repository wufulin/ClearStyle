//
//  FLTableViewCell.h
//  ClearStyle
//
//  Created by wufulin on 13-10-21.
//  Copyright (c) 2013年 netease. All rights reserved.
//

#import "FLToDoItem.h"
#import "FLTableViewCellDelegate.h"

@interface FLTableViewCell : UITableViewCell

// The item that this cell renders
@property (nonatomic) FLToDoItem *todoItem;

// The object that acts as delegate for this cell
@property (nonatomic, assign) id<FLTableViewCellDelegate> delegate;

@end
