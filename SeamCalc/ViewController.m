//
//  ViewController.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/16/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import "ViewController.h"
#import "SeamCalcSlider.h"

@interface CircleFinishedDelegate : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UILabel *label;

- (id)initWithView:(UIView *)view label:(UILabel *)label;
- (void)animationDidStop:(CABasicAnimation *)animation finished:(BOOL)flag;

@end

@interface ViewController ()

@property (nonatomic, strong) CAShapeLayer *layerPopupLine;
@property (nonatomic, strong) CAShapeLayer *layerPopupCircle;
@property (nonatomic, strong) UILabel *labelPopupText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _slider.primaryScaleMarkers = @[[ScaleMarker markerWithInt:0 lengthProportion:1.0 labelHeightProportion:0.15],
                                    [ScaleMarker markerWithInt:5 lengthProportion:0.5 labelVisible:NO],
                                    [ScaleMarker markerWithInt:10 lengthProportion:1.0 labelHeightProportion:0.15],
                                    [ScaleMarker markerWithInt:15 lengthProportion:0.5 labelVisible:NO],
                                    [ScaleMarker markerWithInt:20 lengthProportion:1.0 labelHeightProportion:0.15],
                                    [ScaleMarker markerWithInt:25 lengthProportion:0.5 labelVisible:NO],
                                    [ScaleMarker markerWithInt:30 lengthProportion:1.0 labelHeightProportion:0.15],
                                    [ScaleMarker markerWithInt:35 lengthProportion:0.5 labelVisible:NO],
                                    [ScaleMarker markerWithInt:40 lengthProportion:1.0 labelHeightProportion:0.15]
                                    ];
    _slider.secondaryScaleMarkers = @[[ScaleMarker markerWithFloat:0.125 lengthProportion:0.5 labelHeightProportion:0.15], // 1/8
                                      [ScaleMarker markerWithFloat:0.25 lengthProportion:1.0 labelHeightProportion:0.15],  // 1/4
                                      [ScaleMarker markerWithFloat:0.375 lengthProportion:0.5 labelHeightProportion:0.15], // 3/8
                                      [ScaleMarker markerWithFloat:0.5 lengthProportion:1.0 labelHeightProportion:0.15],   // 1/2
                                      [ScaleMarker markerWithFloat:0.625 lengthProportion:0.5 labelHeightProportion:0.15], // 5/8
                                      [ScaleMarker markerWithFloat:0.75 lengthProportion:1.0 labelHeightProportion:0.15],  // 3/4
                                      [ScaleMarker markerWithFloat:0.875 lengthProportion:0.5 labelHeightProportion:0.15], // 7/8
                                      [ScaleMarker markerWithFloat:1.5 lengthProportion:1.0 labelHeightProportion:0.15]    // 1 1/2
                                      ];
    _slider.convertToPrimary = ^CGFloat(CGFloat value) {
        return value / 0.0393700787;
    };
    _slider.convertToSecondary = ^CGFloat(CGFloat value) {
        return value * 0.0393700787;
    };
    _slider.primaryFormatter = ^NSString *(CGFloat value) {
        return [NSString stringWithFormat:@"%d", (int)roundf(value)];
    };
    
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sliderValueChanged:(id)sender
{
    if (self.layerPopupLine) {
        [self.layerPopupLine removeFromSuperlayer];
        self.layerPopupLine = nil;
    }
    if (self.layerPopupCircle) {
        [self.layerPopupCircle removeFromSuperlayer];
        self.layerPopupCircle = nil;
    }
    if (self.labelPopupText) {
        [self.labelPopupText removeFromSuperview];
        self.labelPopupText = nil;
    }
    
    //NSLog(@"value => x : %f => %f", _slider.value, [_slider valueToX:_slider.value]);
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(checkValueStays:)
                                   userInfo:[NSNumber numberWithFloat:_slider.value]
                                    repeats:NO];
}

- (void)checkValueStays:(NSTimer*)timer
{
    NSNumber *prevValue = timer.userInfo;
    //NSLog(@"Check value stays: %f == %f?", _slider.value, [prevValue floatValue]);
    if ([prevValue floatValue] == _slider.value) {
        //NSLog(@"Yay value stays! Do the animation thing!");
        if (_slider.value > 0.0) {
            // only when value > 0.0
            ScaleMarker *marker1 = [_slider.scale findMarkerClosestTo:_slider.value inMarkers:_slider.primaryScaleMarkers];
            ScaleMarker *marker2 = [_slider.scale findMarkerClosestTo:_slider.value inMarkers:_slider.secondaryScaleMarkers];
            // calc distance
            //NSLog(@"prim = %f, sec = %f", [marker1.value floatValue], [marker2.value floatValue]);
            float val1_prim = [marker1.value floatValue];
            float val2_prim = _slider.convertToPrimary([marker2.value floatValue]);
            float valdist_prim = fabsf(val1_prim - val2_prim);
            //NSLog(@"prim = %f, sec = %f, dist = %f", val1_prim, val2_prim, valdist_prim);
            if (valdist_prim > 1.0) {
                float distval1 = fabsf(val1_prim - _slider.value);
                float distval2 = fabsf(val2_prim - _slider.value);
                CGFloat x = [_slider valueToX:_slider.value];
                CGFloat y = _slider.frame.origin.y + _slider.frame.size.height/2.0;
                CGFloat h = _slider.frame.size.height * 0.3;
                if (distval1 < distval2) {
                    // closer to marker1
                    [self animateLineFrom:CGPointMake(_slider.frame.origin.x + x, y)
                                       to:CGPointMake(_slider.frame.origin.x + x, y + h)
                                forMarker:marker1];
                } else {
                    // closer to marker2
                    [self animateLineFrom:CGPointMake(_slider.frame.origin.x + x, y)
                                       to:CGPointMake(_slider.frame.origin.x + x, y - h)
                                forMarker:marker2];
                }
            }
        }
    }
}

- (void)animateLineFrom:(CGPoint)start to:(CGPoint)end forMarker:(ScaleMarker *)marker
{
    // callout line
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    [path addLineToPoint:end];
    
    CGColorRef color = [UIColor colorWithRed:0.16 green:0.5 blue:0.725 alpha:0.9].CGColor;
    
    self.layerPopupLine = [CAShapeLayer layer];
    self.layerPopupLine.frame = self.view.bounds;
    self.layerPopupLine.path = path.CGPath;
    self.layerPopupLine.strokeColor = color;//[[UIColor blackColor] CGColor];
    self.layerPopupLine.fillColor = nil;
    self.layerPopupLine.lineWidth = 1.0f;
    self.layerPopupLine.lineDashPattern = @[@4, @1];
    self.layerPopupLine.lineJoin = kCALineJoinBevel;
    
    [self.view.layer addSublayer:self.layerPopupLine];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    [self.layerPopupLine addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    // circle
    
    CGFloat radius = _slider.frame.size.height * 0.05;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.lineWidth = 1;
    //rgb(41, 128, 185)
    circle.strokeColor = color;//[UIColor blackColor].CGColor;
    circle.fillColor = color;
    circle.bounds = CGRectMake(0, 0, radius * 2.0, radius * 2.0);
    circle.position = CGPointMake(end.x,
                                  marker.primary ? end.y + radius : end.y - radius);
    circle.path = [UIBezierPath bezierPathWithOvalInRect:circle.bounds].CGPath;
    [self.view.layer addSublayer:circle];
    
    /*
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration = 1.0;
    drawAnimation.repeatCount = 1.0;
    drawAnimation.removedOnCompletion = NO;
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    */
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(end.x - radius,
                                                               marker.primary ? end.y : end.y - radius * 2.0,
                                                               radius * 2.0, radius * 2.0)];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    CGFloat value = marker.primary ? _slider.convertToSecondary([marker.value floatValue]) : _slider.convertToPrimary([marker.value floatValue]);
    if (!marker.primary && _slider.primaryFormatter) {
        label.text = _slider.primaryFormatter(value);
    } else if (marker.primary && _slider.secondaryFormatter) {
        label.text = _slider.secondaryFormatter(value);
    } else {
        label.text = [NSString stringWithFormat:@"%0.1f", value];
    }
    
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    colorAnimation.fromValue = (__bridge id)[UIColor colorWithRed:0.16 green:0.5 blue:0.725 alpha:0.0].CGColor;;
    colorAnimation.toValue = (__bridge id)color;//(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
    colorAnimation.duration = 1.0;
    colorAnimation.repeatCount = 1.0;
    colorAnimation.removedOnCompletion = NO;
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    colorAnimation.delegate = [[CircleFinishedDelegate alloc] initWithView:self.view label:label];
    [circle addAnimation:colorAnimation forKey:@"drawCircleAnimation"];
    
    self.labelPopupText = label;
    self.layerPopupCircle = circle;
}

@end

@implementation CircleFinishedDelegate

- (id)initWithView:(UIView *)view label:(UILabel *)label
{
    self = [super init];
    if (self) {
        self.view = view;
        self.label = label;
    }
    return self;
}

- (void)animationDidStop:(CABasicAnimation *)animation finished:(BOOL)flag
{
    [self.view addSubview:self.label];
}

@end
