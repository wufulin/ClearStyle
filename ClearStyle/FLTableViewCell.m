//
//  FLTableViewCell.m
//  ClearStyle
//
//  Created by wufulin on 13-10-21.
//  Copyright (c) 2013年 netease. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FLTableViewCell.h"
#import "FLStrikethroughLabel.h"

@implementation FLTableViewCell
{
	CAGradientLayer *_gradientLayer;
	CGPoint _originalCenter;
	BOOL _deleteOnDragRelease;
	BOOL _markCompleteOnDragRelease;
	FLStrikethroughLabel *_label;
	CALayer *_itemCompleteLayer;
	UILabel *_tickLabel;
	UILabel *_crossLabel;
}

const float LABEL_LEFT_MARGIN = 15.0f;
const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		// add a tick and cross
		_tickLabel = [self createCueLabel];
		_tickLabel.text = @"\u2713";
		_tickLabel.textAlignment = NSTextAlignmentRight;
		[self addSubview:_tickLabel];
		
		_crossLabel = [self createCueLabel];
		_crossLabel.text = @"\u2717";
		_crossLabel.textAlignment = NSTextAlignmentLeft;
		[self addSubview:_crossLabel];
		
        // add a layer that overlays the cell adding a subtle gradient effect
		_gradientLayer = [CAGradientLayer layer];
		_gradientLayer.frame = self.bounds;
		_gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
							(id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
							(id)[[UIColor clearColor] CGColor],
							(id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
		_gradientLayer.locations = @[@0.00f,@0.01f,@0.95f,@1.00f];
		[self.layer insertSublayer:_gradientLayer atIndex:0];
		
		// create a label that renders the to-do item text
		_label = [[FLStrikethroughLabel alloc] initWithFrame:CGRectNull];
		_label.textColor = [UIColor whiteColor];
		_label.font = [UIFont boldSystemFontOfSize:16];
		_label.backgroundColor = [UIColor clearColor];
		[self addSubview:_label];
		
		// remove the default blue highlight for selected cells
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		// add a layer that renders a green background when an items is complete
		_itemCompleteLayer = [CALayer layer];
		_itemCompleteLayer.backgroundColor = [[[UIColor alloc] initWithRed:0.0 green:0.6 blue:0.0 alpha:1.0] CGColor];
		_itemCompleteLayer.hidden = YES;
		[self.layer insertSublayer:_itemCompleteLayer atIndex:0];
		
		// add a pan recognizer
		UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		recognizer.delegate = self;
		[self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
	[super layoutSubviews];
	// ensure the gradient layers occupies the full bounds
	_gradientLayer.frame = self.bounds;
	_itemCompleteLayer.frame = self.bounds;
	_label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0, self.bounds.size.width - LABEL_LEFT_MARGIN, self.bounds.size.height);
	_tickLabel.frame = CGRectMake(-UI_CUES_WIDTH-UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
	_crossLabel.frame = CGRectMake(self.bounds.size.width+UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
}

- (void)setTodoItem:(FLToDoItem *)todoItem {
	_todoItem = todoItem;
	// we must update all the visual state associated with the model item
	_label.text = todoItem.text;
	_label.strikethrough = todoItem.completed;
	_itemCompleteLayer.hidden = !todoItem.completed;
}

// utility method for creating the contextual cues
- (UILabel *)createCueLabel {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectNull];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:32.0f];
	label.backgroundColor = [UIColor clearColor];
	return label;
}

#pragma mark - horizontal pan gesture methods
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
	CGPoint translation = [gestureRecognizer translationInView:[self superview]];
	// Check for horizontal gesture
	if (fabsf(translation.x) > fabsf(translation.y)) {
		return YES;
	}
	return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
	// 1
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		// if the gesture has just started, record the current centre location
		_originalCenter = self.center;
	}
	
	// 2
	if (recognizer.state == UIGestureRecognizerStateChanged) {
		// translate the center
		CGPoint translation = [recognizer translationInView:self];
		self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
		// determine whether the item has been dragged far enough to initiate a delete / complete
		_deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;
		_markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width / 2;
		
		// fade the contextual cues
		float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width/2);
		_tickLabel.alpha = cueAlpha;
		_crossLabel.alpha = cueAlpha;
		
		// indicate when the item have been pulled far enough to invoke the given action
		_tickLabel.textColor = _markCompleteOnDragRelease ? [UIColor greenColor] : [UIColor whiteColor];
		_crossLabel.textColor = _deleteOnDragRelease ? [UIColor redColor] : [UIColor whiteColor];
	}
	
	// 3
	if (recognizer.state == UIGestureRecognizerStateEnded) {
		// the frame this cell would have had before being dragged
		CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
		if (!_deleteOnDragRelease) {
			// if the item is not being deleted, snap back to the original location
			[UIView animateWithDuration:0.2 animations:^{
				self.frame = originalFrame;
			}];
		}
		
		if (_deleteOnDragRelease) {
			// notify the delegate that this item should bu deleted
			[self.delegate toDoItemDeleted:self.todoItem];
		}
		
		if (_markCompleteOnDragRelease) {
			// mark the item as complete and update the UI state
			self.todoItem.completed = YES;
			_itemCompleteLayer.hidden = NO;
			_label.strikethrough = YES;
		}
	}
}

@end