//
//  FLToDoItem.h
//  ClearStyle
//
//  Created by wufulin on 13-10-21.
//  Copyright (c) 2013年 netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLToDoItem : NSObject

// A text description of this item.
@property (nonatomic, copy) NSString *text;

// A Boolean value that determines the completed state of this item.
@property (nonatomic) BOOL completed;

// Returns an FLToDoItem item initialized with the given text.
- (id)initWithText:(NSString *)text;

// Returns an FLToDoItem item initialized with the given text.
+ (id)toDoItemWithText:(NSString *)text;

@end
