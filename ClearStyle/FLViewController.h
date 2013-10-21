//
//  FLViewController.h
//  ClearStyle
//
//  Created by wufulin on 13-10-21.
//  Copyright (c) 2013年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLTableViewCellDelegate.h"

@interface FLViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, FLTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
