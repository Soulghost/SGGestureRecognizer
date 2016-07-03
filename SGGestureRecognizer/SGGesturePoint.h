//
//  SGGesturePoint.h
//  SGGestureRecognizer
//
//  Created by soulghost on 9/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SGGesturePoint : NSObject <NSCoding>

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

+ (instancetype)gesturePointWithCGPoint:(CGPoint)pt;
- (double)distanceTo:(SGGesturePoint *)pt;

@end
