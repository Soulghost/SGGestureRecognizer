//
//  SGGestureSet.m
//  SGGestureRecognizer
//
//  Created by soulghost on 9/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGGestureSet.h"
#import "SGGesturePoint.h"
#import "SGGestureVector.h"

static NSString * const kSGGestureSetName = @"kSGGestureSetName";
static NSString * const kSGGestureSetVector = @"kSGGestureSetVector";
static NSString * const kSGGestureArray = @"kSGGestureArray";

@interface SGGestureSet (){
    SGGestureVector *_vector;
}

@property (nonatomic, strong) NSMutableArray<SGGesturePoint *> *gestureArray;

@end

@implementation SGGestureSet

- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:kSGGestureSetName];
    [encoder encodeObject:_vector forKey:kSGGestureSetVector];
    [encoder encodeObject:self.gestureArray forKey:kSGGestureArray];
}

- (instancetype)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:kSGGestureSetName];
        _vector = [decoder decodeObjectForKey:kSGGestureSetVector];
        _gestureArray = [decoder decodeObjectForKey:kSGGestureArray];
        self.isStandardized = YES;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        self.isStandardized = NO;
    }
    return self;
}

+ (instancetype)gestureSetWithName:(NSString *)name{
    SGGestureSet *set = [[SGGestureSet alloc] init];
    set.name = name;
    return set;
}

+ (instancetype)gestureSetWithPoints:(NSArray<NSValue *> *)points {
    SGGestureSet *set = [SGGestureSet new];
    for (int i = 0; i < points.count; i++) {
        CGPoint pt = points[i].CGPointValue;
        SGGesturePoint *gesPt = [SGGesturePoint gesturePointWithCGPoint:pt];
        [set addGesturePoint:gesPt];
    }
    return set;
}

+ (instancetype)gestureSetWithName:(NSString *)name points:(NSArray<NSValue *> *)points{
    SGGestureSet *set = [SGGestureSet gestureSetWithName:name];
    for (int i = 0; i < points.count; i++) {
        CGPoint pt = points[i].CGPointValue;
        SGGesturePoint *gesPt = [SGGesturePoint gesturePointWithCGPoint:pt];
        [set addGesturePoint:gesPt];
    }
    return set;
}

- (NSMutableArray<SGGesturePoint *> *)gestureArray{
    if (_gestureArray == nil) {
        _gestureArray = [NSMutableArray array];
    }
    return _gestureArray;
}

- (void)addGesturePoint:(SGGesturePoint *)gesPt{
    [self.gestureArray addObject:gesPt];
}

- (void)removeAllGesturePoints{
    [self.gestureArray removeAllObjects];
}

- (NSInteger)countPoints{
    return self.gestureArray.count;
}

- (SGGesturePoint *)pointAtIndex:(NSInteger)index{
    if (index >= 0 && index < self.gestureArray.count) {
        return self.gestureArray[index];
    }
    return nil;
}

- (void)setPoint:(SGGesturePoint *)pt atIndex:(NSInteger)index{
    self.gestureArray[index] = pt;
}

- (NSArray<SGGesturePoint *> *)getPoints{
    return self.gestureArray;
}

- (SGGestureVector *)getVector{
    return _vector;
}

- (void)setVector:(SGGestureVector *)vector{
    self.isStandardized = YES;
    _vector = vector;
}

- (NSString *)description{
    return [self.gestureArray description];
}

@end
