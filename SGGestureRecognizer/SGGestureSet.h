//
//  SGGestureSet.h
//  SGGestureRecognizer
//
//  Created by soulghost on 9/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGGesturePoint;
@class SGGestureVector;

@interface SGGestureSet : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL isStandardized;

+ (instancetype)gestureSetWithName:(NSString *)name;
+ (instancetype)gestureSetWithPoints:(NSArray<NSValue *> *)points;
+ (instancetype)gestureSetWithName:(NSString *)name points:(NSArray<NSValue *> *)points;


- (void)addGesturePoint:(SGGesturePoint *)gesPt;
- (void)removeAllGesturePoints;
- (NSInteger)countPoints;
- (SGGesturePoint *)pointAtIndex:(NSInteger)index;
- (void)setPoint:(SGGesturePoint *)pt atIndex:(NSInteger)index;
- (NSArray<SGGesturePoint *>*)getPoints;

- (SGGestureVector *)getVector;
- (void)setVector:(SGGestureVector *)vector;

@end
