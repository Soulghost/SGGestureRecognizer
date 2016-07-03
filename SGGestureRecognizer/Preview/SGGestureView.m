//
//  SGGestureView.m
//  SGGestureRecognizer
//
//  Created by soulghost on 10/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGGestureView.h"
#import "SGDollarOneManager.h"
#import "SGGestureSet.h"
#import "SGGesturePoint.h"

@implementation SGGestureView

+ (instancetype)gestureView {
    CGSize gesSize= CGSizeMake(220, 220);
    SGGestureView *view = [[SGGestureView alloc] initWithFrame:CGRectMake(0, 0, gesSize.width, gesSize.height)];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.set == nil) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextAddRect(ctx, self.bounds);
    CGContextFillPath(ctx);
    NSArray<SGGesturePoint *> *points = self.set.getPoints;
    CGPoint offset = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
    SGGesturePoint *start = [points firstObject];
    [[UIColor redColor] set];
    CGContextAddRect(ctx, CGRectMake(start.x + offset.x - 4, start.y + offset.y - 4, 8, 8));
    CGContextFillPath(ctx);
    [[UIColor whiteColor] set];
    CGContextMoveToPoint(ctx, start.x + offset.x, start.y + offset.y);
    for (int i = 1; i < points.count; i++) {
        SGGesturePoint *pt = points[i];
        CGContextAddLineToPoint(ctx, pt.x + offset.x, pt.y + offset.y);
    }
    CGContextStrokePath(ctx);
    SGGesturePoint *end = [points lastObject];
    [[UIColor blueColor] set];
    CGContextAddRect(ctx, CGRectMake(end.x + offset.x - 4, end.y + offset.y - 4, 8, 8));
    CGContextFillPath(ctx);

}

- (void)setSet:(SGGestureSet *)set {
    _set = set;
    [self setNeedsDisplay];
}

@end
