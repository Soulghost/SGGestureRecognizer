//
//  SGDollarOneManager.m
//  SGGestureRecognizer
//
//  Created by soulghost on 9/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGDollarOneManager.h"
#import "SGGestureSet.h"
#import "SGGesturePoint.h"
#import "SGGestureVector.h"

@interface SGDollarOneManager ()

@end

@implementation SGDollarOneManager

+ (instancetype)sharedManager {
    static SGDollarOneManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SGDollarOneManager new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.samplePointCount = 200;
        self.threshold = 0.25;
        self.gestureSize = CGSizeMake(150, 150);
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.libLoadPath = [rootPath stringByAppendingPathComponent:@"gestureLib.gs"];
        self.libSavePath = self.libLoadPath;
        [self loadGestures];
    }
    return self;
}

- (void)setLibLoadPath:(NSString *)libLoadPath {
    _libLoadPath = [libLoadPath copy];
    [self loadGestures];
}

- (NSMutableArray<SGGestureSet *> *)gestureSets {
    if (_gestureSets == nil) {
        _gestureSets = [NSMutableArray array];
    }
    return _gestureSets;
}

- (void)addGestureSet:(SGGestureSet *)set {
    [self standardizeSet:&set];
    [self.gestureSets addObject:set];
    [self saveGestures];
}

- (void)saveGestures {
    [NSKeyedArchiver archiveRootObject:self.gestureSets toFile:self.libSavePath];
}

- (void)loadGestures {
    NSMutableArray<SGGestureSet *> *gestures = [NSKeyedUnarchiver unarchiveObjectWithFile:self.libLoadPath];
    if (gestures != nil) {
        self.gestureSets = gestures;
    }
}

- (NSString *)recognizeGestureSet:(SGGestureSet *)set {
    [self standardizeSet:&set];
    SGGestureVector *vec1 = [set getVector];
    SGGestureSet *bestSet = nil;
    double minD = CGFLOAT_MAX;
    for (int i = 0; i < self.gestureSets.count; i++) {
        SGGestureSet *libSet = self.gestureSets[i];
        SGGestureVector *vec2 = [libSet getVector];
        double D = [self cosDistanceWithVector1:vec1 vector2:vec2];
        if(D <= self.threshold && D < minD){
            minD = D;
            bestSet = libSet;
        }
    }
    return bestSet.name;
}

- (void)standardizeSet:(SGGestureSet *__autoreleasing *)set {
    // 计算曲线的总长度，用于均匀分布采样点
    SGGestureSet *tempSet = *set;
    double sumLength = 0;
    for (int i = 1; i < tempSet.countPoints; i++) {
        SGGesturePoint *pt1 = [tempSet pointAtIndex:i];
        SGGesturePoint *pt2 = [tempSet pointAtIndex:i - 1];
        sumLength += [pt1 distanceTo:pt2];
    }
    // 重新采样
    SGGestureSet *resampleSet = [SGGestureSet gestureSetWithName:tempSet.name];
    double Interval = sumLength / self.samplePointCount;
    double D = 0;
    SGGesturePoint *p1 = [tempSet pointAtIndex:0];
    [resampleSet addGesturePoint:p1];
    for (int i = 1; i < tempSet.countPoints;) {
        SGGesturePoint *p2 = [tempSet pointAtIndex:i];
        double d = [p1 distanceTo:p2];
        if ((D + d) >= Interval) {
            double k = (Interval - D ) / d;
            double x = p1.x + k * (p2.x - p1.x);
            double y = p1.y + k * (p2.y - p1.y);
            SGGesturePoint *p = [SGGesturePoint gesturePointWithCGPoint:CGPointMake(x, y)];
            [resampleSet addGesturePoint:p];
            D = 0;
            p1 = p;
        }else{
            D += d;
            p1 = p2;
            i++;
        }
    }
    // 求坐标平均值作为中点
    double sumx = 0;
    double sumy = 0;
    for (int i = 0; i < resampleSet.countPoints; i++) {
        SGGesturePoint *pt = [resampleSet pointAtIndex:i];
        sumx += pt.x;
        sumy += pt.y;
    }
    CGFloat centerX = sumx / resampleSet.countPoints;
    CGFloat centerY = sumy / resampleSet.countPoints;
    self.sampleMiddle = CGPointMake(centerX, centerY);
    SGGesturePoint *center = [SGGesturePoint gesturePointWithCGPoint:CGPointMake(centerX,centerY)];
    // 根据中点把整个图形移动到坐标原点
    for (int i = 0; i < resampleSet.countPoints; i++) {
        SGGesturePoint *pt = [resampleSet pointAtIndex:i];
        pt.x -= center.x;
        pt.y -= center.y;
        [resampleSet setPoint:pt atIndex:i];
    }
    // 缩放到标准尺寸
    CGFloat minX = CGFLOAT_MAX;
    CGFloat maxX = -CGFLOAT_MAX;
    CGFloat minY = CGFLOAT_MAX;
    CGFloat maxY = -CGFLOAT_MAX;
    for (int i = 0; i < resampleSet.countPoints; i++) {
        SGGesturePoint *pt = [resampleSet pointAtIndex:i];
        minX = MIN(minX, pt.x);
        maxX = MAX(maxX, pt.x);
        minY = MIN(minY, pt.y);
        maxY = MAX(maxY, pt.y);
    }
    CGSize desSize = self.gestureSize;
    CGFloat sideX = maxX - minX;
    CGFloat sideY = maxY - minY;
#pragma mark 有可能产生除以0的错误
    CGFloat longSide = MAX(sideX, sideY);
    CGFloat shortSide = MIN(sideX, sideY);
    bool uniformly = shortSide / longSide < 0.2;
    CGFloat scaleX = desSize.width / sideX;
    CGFloat scaleY = desSize.height / sideY;
    if (uniformly) {
        scaleX = desSize.width / longSide;
        scaleY = desSize.height / longSide;
    }
    for (int i = 0; i < resampleSet.countPoints; i++) {
        SGGesturePoint *pt = [resampleSet pointAtIndex:i];
        pt.x *= scaleX;
        pt.y *= scaleY;
        [resampleSet setPoint:pt atIndex:i];
    }
    // 旋转到标准位置
    SGGesturePoint *firstPoint = [resampleSet pointAtIndex:0];
    CGFloat iAngle = atan2(firstPoint.y, firstPoint.x);
    CGFloat rotationInvariance = M_PI_4;
    CGFloat r= rotationInvariance;
    CGFloat baseOrientation = r * floor((iAngle + r/2) / r);
    CGFloat rotateBy = baseOrientation - iAngle;
    CGFloat cosValue = cos(rotateBy);
    CGFloat sinValue = sin(rotateBy);
    for (int i = 0; i < resampleSet.countPoints; i++) {
        SGGesturePoint *pt = [resampleSet pointAtIndex:i];
        pt.x = pt.x * cosValue - pt.y * sinValue;
        pt.y = pt.x * sinValue + pt.y * cosValue;
        [resampleSet setPoint:pt atIndex:i];
    }
    // 生成向量
    SGGestureVector *vec = [SGGestureVector vector];
    double sum = 0;
    for (int i = 0; i < resampleSet.countPoints; i++) {
        SGGesturePoint *pt = [resampleSet pointAtIndex:i];
        [vec addDouble:pt.x];
        [vec addDouble:pt.y];
        sum += pt.x * pt.x + pt.y * pt.y;
    }
    double magnitude = sqrt(sum);
    for (int i = 0; i < vec.length; i++) {
        double value = [vec doubleAtIndex:i];
        value /= magnitude;
        [vec setDouble:value atIndex:i];
    }
    [resampleSet setVector:vec];
    *set = resampleSet;
}

- (double)cosDistanceWithVector1:(SGGestureVector *)vec1 vector2:(SGGestureVector *)vec2 {
    double a = 0;
    double b = 0;
    for (int i = 0; i <= vec1.length - 1 && i <= vec2.length - 1; i+=2) {
        a += [vec1 doubleAtIndex:i] * [vec2 doubleAtIndex:i] + [vec1 doubleAtIndex:i + 1] * [vec2 doubleAtIndex:i + 1];
        b += [vec1 doubleAtIndex:i] * [vec2 doubleAtIndex:i + 1] - [vec1 doubleAtIndex:i + 1] * [vec2 doubleAtIndex:i];
    }
    double angle = atan(b / a);
    return acos(a * cos(angle) + b * sin(angle));
}

@end
