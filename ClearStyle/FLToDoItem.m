//
//  FLToDoItem.m
//  ClearStyle
//
//  Created by wufulin on 13-10-21.
//  Copyright (c) 2013年 netease. All rights reserved.
//

#import "FLToDoItem.h"

@implementation FLToDoItem

- (id)initWithText:(NSString *)text {
	if (self = [super init]) {
		self.text = text;
	}
	return self;
}

+ (id)toDoItemWithText:(NSString *)text {
	return [[FLToDoItem alloc] initWithText:text];
}

@end
