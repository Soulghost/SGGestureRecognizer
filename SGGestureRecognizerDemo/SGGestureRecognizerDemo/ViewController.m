//
//  ViewController.m
//  SGGestureRecognizerDemo
//
//  Created by soulghost on 3/7/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "ViewController.h"
#import "SGDollarOneManager.h"
#import "SGGestureSet.h"
#import "SGGesturePreviewController.h"

typedef NS_ENUM(NSInteger,SampleMode){
    SampleModeRecord = 0,
    SampleModeRecognize
};

@interface ViewController () <UITextFieldDelegate>

@property (nonatomic, assign) SampleMode sampleMode;
@property (nonatomic, strong) NSMutableArray<NSValue *> *samplePoints;
@property (nonatomic, weak) CAShapeLayer *sLayer;
@property (nonatomic, strong) UIBezierPath *bPath;
@property (nonatomic, weak) UITextField *nameField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self comminInit];
}

- (void)comminInit {
    // set gesture load path
    [SGDollarOneManager sharedManager].libLoadPath = [[NSBundle mainBundle] pathForResource:@"gestureLib.gs" ofType:nil];
    // add gesture
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    // init UI
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Record",@"Recognize"]];
    segment.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5f, 36);
    segment.selectedSegmentIndex = 1;
    [self segmentDidSelected:segment];
    [segment addTarget:self action:@selector(segmentDidSelected:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    UITextField *tf = [[UITextField alloc] init];
    self.nameField = tf;
    tf.center = CGPointMake(segment.center.x, 70);
    tf.bounds = CGRectMake(0, 0, 240, 30);
    tf.backgroundColor = [UIColor grayColor];
    tf.textColor = [UIColor whiteColor];
    tf.delegate = self;
    tf.textAlignment = NSTextAlignmentCenter;
    tf.keyboardType = UIKeyboardTypeASCIICapable;
    tf.spellCheckingType = UITextSpellCheckingTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:tf];
    UIButton *magicBtn = [[UIButton alloc] init];
    magicBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5f, 103);
    magicBtn.bounds = CGRectMake(0, 0, 120, 30);
    magicBtn.backgroundColor = [UIColor lightGrayColor];
    [magicBtn setTitle:@"GestureLib" forState:UIControlStateNormal];
    [magicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [magicBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [magicBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:magicBtn];
}

#pragma mark -
#pragma mark 懒加载
- (NSMutableArray<NSValue *> *)samplePoints {
    if (_samplePoints == nil) {
        _samplePoints = @[].mutableCopy;
    }
    return _samplePoints;
}

- (CAShapeLayer *)sLayer {
    if (_sLayer == nil) {
        CAShapeLayer *sLayer = [CAShapeLayer layer];
        sLayer.lineJoin = @"round";
        sLayer.strokeColor = [UIColor yellowColor].CGColor;
        sLayer.fillColor = [UIColor clearColor].CGColor;
        sLayer.path = self.bPath.CGPath;
        sLayer.lineWidth = 4.0f;
        [self.view.layer addSublayer:sLayer];
        _sLayer = sLayer;
    }
    return _sLayer;
}

- (UIBezierPath *)bPath {
    if (_bPath == nil) {
        _bPath = [UIBezierPath bezierPath];
    }
    return _bPath;
}

#pragma mark -
#pragma mark ButtonClick Handler
- (void)preview {
    SGGesturePreviewController *vc = [[SGGesturePreviewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
#pragma mark Touch Handler
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameField resignFirstResponder];
}

- (void)pan:(UIGestureRecognizer *)ges {
    switch (ges.state) {
        case UIGestureRecognizerStateBegan: {
            [self.bPath removeAllPoints];
            [self.samplePoints removeAllObjects];
            self.sLayer.path = self.bPath.CGPath;
            CGPoint pt = [ges locationInView:self.view];
            [self.samplePoints addObject:[NSValue valueWithCGPoint:pt]];
            [self.bPath moveToPoint:pt];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint pt = [ges locationInView:self.view];
            [self.samplePoints addObject:[NSValue valueWithCGPoint:pt]];
            [self.bPath addLineToPoint:pt];
            self.sLayer.path = self.bPath.CGPath;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            self.sLayer.path = [UIBezierPath bezierPath].CGPath;
            switch (self.sampleMode) {
                case SampleModeRecord: {
                    [self sample];
                    break;
                }
                case SampleModeRecognize: {
                    [self recognize];
                    break;
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark UISegmentedControl Delegate
- (void)segmentDidSelected:(UISegmentedControl *)segment{
    self.sampleMode = segment.selectedSegmentIndex;
}

#pragma mark -
#pragma mark Sample & Recognize
- (void)sample {
    SGDollarOneManager *mgr = [SGDollarOneManager sharedManager];
    SGGestureSet *set = [SGGestureSet gestureSetWithName:self.nameField.text points:self.samplePoints];
    if (set.countPoints) {
        [mgr addGestureSet:set];
    }
}

- (void)recognize {
    SGDollarOneManager *mgr = [SGDollarOneManager sharedManager];
    SGGestureSet *set = [SGGestureSet gestureSetWithPoints:self.samplePoints];
    NSString *gesName = [mgr recognizeGestureSet:set];
    if (gesName.length) {
        NSLog(@"Recognize Succeeded. The gesture is <%@>",gesName);
        [[[UIAlertView alloc] initWithTitle:gesName message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Confirm", nil] show];
    } else {
        NSLog(@"Recognize Failed.");
    }
}

@end
