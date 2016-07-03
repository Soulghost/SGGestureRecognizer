//
//  SGGesturePoint.m
//  SGGestureRecognizer
//
//  Created by soulghost on 9/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGGesturePoint.h"

static NSString * const kSGGesturePointX = @"kSGGesturePointX";
static NSString * const kSGGesturePointY = @"kSGGesturePointY";

@implementation SGGesturePoint

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeDouble:self.x forKey:kSGGesturePointX];
    [encoder encodeDouble:self.y forKey:kSGGesturePointY];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.x = [decoder decodeDoubleForKey:kSGGesturePointX];
        self.y = [decoder decodeDoubleForKey:kSGGesturePointY];
    }
    return self;
}

+ (instancetype)gesturePointWithCGPoint:(CGPoint)pt {
    SGGesturePoint *gesPt = [[SGGesturePoint alloc] init];
    gesPt.x = pt.x;
    gesPt.y = pt.y;
    return gesPt;
}

- (double)distanceTo:(SGGesturePoint *)pt {
    double dx = self.x - pt.x;
    double dy = self.y - pt.y;
    return sqrt(dx * dx + dy * dy);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{%lf,%lf}",self.x,self.y];
}

@end
