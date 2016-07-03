//
//  SGGestureView.h
//  SGGestureRecognizer
//
//  Created by soulghost on 10/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGGestureSet;

@interface SGGestureView : UIView

@property (nonatomic, strong) SGGestureSet *set;

+ (instancetype)gestureView;

@end
