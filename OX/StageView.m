//
//  StageView.m
//  OX
//
//  Created by huimin liu on 4/24/13.
//  Copyright (c) 2013 huimin liu. All rights reserved.
//

#import "StageView.h"

@implementation StageView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
	self = [super initWithFrame:frame collectionViewLayout:layout];
	if (self) {
		
	}
	return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
	
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

//画“井”字
- (void)drawInContext:(CGContextRef)context
{
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0); //设置颜色
	CGContextSetLineWidth(context, 3.0); //设置笔触宽度
	
	float width = self.bounds.size.width;
	float height = self.bounds.size.height;
	
	CGContextMoveToPoint(context, .0, height / 3.);
	CGContextAddLineToPoint(context, width, height / 3.);
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, .0, height * 2 / 3.);
	CGContextAddLineToPoint(context, width, height * 2 / 3.);
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, width / 3., .0);
	CGContextAddLineToPoint(context, width / 3., height);
	CGContextStrokePath(context);
	
	CGContextMoveToPoint(context, width * 2 / 3., .0);
	CGContextAddLineToPoint(context, width * 2 / 3., height);
	CGContextStrokePath(context);
}

@end
