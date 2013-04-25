//
//  StageViewCell.m
//  OX
//
//  Created by huimin liu on 4/24/13.
//  Copyright (c) 2013 huimin liu. All rights reserved.
//

#import "StageViewCell.h"

@implementation StageViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.mark = @"";
		self.shining = NO;
    }
    return self;
}

- (void)setMark:(NSString *)mark
{
	if (_mark != mark) {
		_mark = mark;
		[self setNeedsDisplay];
	}
}

- (void)setShining:(BOOL)shining
{
	if (_shining != shining) {
		_shining = shining;
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect); //先清除
	[self drawInContext:context];
}

- (void)drawInContext:(CGContextRef)context
{
	if (self.shining) {
		CGContextSetRGBFillColor(context, .0, 0.8, .0, 1.0); //设置颜色(高亮)
	} else {
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0); //设置颜色(普通)
	}
	[self.mark drawInRect:CGRectMake(20, 8, 70, 70) withFont:[UIFont systemFontOfSize:70.]];
}

@end
