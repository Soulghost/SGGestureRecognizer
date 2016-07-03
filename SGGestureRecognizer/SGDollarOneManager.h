//
//  SGDollarOneManager.h
//  SGGestureRecognizer
//
//  Created by soulghost on 9/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SGGestureSet;

@interface SGDollarOneManager : NSObject

@property (nonatomic, copy) NSString *libLoadPath;
@property (nonatomic, copy) NSString *libSavePath;

@property (nonatomic, assign) NSInteger samplePointCount;
@property (nonatomic, assign) double threshold;
@property (nonatomic, assign) CGPoint sampleMiddle;
@property (nonatomic, assign) CGSize gestureSize;
@property (nonatomic, strong) NSMutableArray<SGGestureSet *> *gestureSets;

+ (instancetype)sharedManager;

- (void)addGestureSet:(SGGestureSet *)set;
- (void)saveGestures;
- (void)loadGestures;
- (NSString *)recognizeGestureSet:(SGGestureSet *)set;
- (void)standardizeSet:(SGGestureSet **)set;

@end
