//
//  SGGestureVector.h
//  SGGestureRecognizer
//
//  Created by soulghost on 9/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGGestureVector : NSObject <NSCoding>

+ (instancetype)vector;
- (void)clear;
- (NSInteger)length;
- (void)addDouble:(double)value;
- (double)doubleAtIndex:(NSInteger)index;
- (void)setDouble:(double)value atIndex:(NSInteger)index;

@end
