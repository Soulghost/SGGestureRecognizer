//
//  SGGestureVector.m
//  SGGestureRecognizer
//
//  Created by soulghost on 9/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGGestureVector.h"

static NSString * const kSGGestureVectorNums = @"kSGGestureVectorNums";

@interface SGGestureVector ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *nums;

@end

@implementation SGGestureVector

- (instancetype)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        self.nums = [decoder decodeObjectForKey:kSGGestureVectorNums];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.nums forKey:kSGGestureVectorNums];
}

- (NSMutableArray *)nums{
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

+ (instancetype)vector{
    return [[SGGestureVector alloc] init];
}

- (void)clear{
    [self.nums removeAllObjects];
}

- (void)addDouble:(double)value{
    NSNumber *number = [NSNumber numberWithDouble:value];
    [self.nums addObject:number];
}

- (double)doubleAtIndex:(NSInteger)index{
    NSNumber *number = self.nums[index];
    return number.doubleValue;
}

- (void)setDouble:(double)value atIndex:(NSInteger)index{
    NSNumber *number = [NSNumber numberWithDouble:value];
    self.nums[index] = number;
}

- (NSInteger)length{
    return self.nums.count;
}

- (NSString *)description{
    return [self.nums description];
}

@end
