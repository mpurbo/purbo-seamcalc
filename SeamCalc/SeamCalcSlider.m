//
//  SeamCalcSlider.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/17/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import "SeamCalcSlider.h"

@interface SeamCalcHandle : UIView

@end

@interface SeamCalcScale : UIView

@property (nonatomic, weak) SeamCalcSlider *slider;

@end

@interface SeamCalcSlider() {
    BOOL draggingHandle;
    CGFloat distanceFromCenter;
}

@property (nonatomic, strong) SeamCalcHandle *handle;
@property (nonatomic, strong) SeamCalcScale *scale;

@end

@interface SeamCalcSlider()

@property (nonatomic, readwrite, assign) CGFloat minValue;
@property (nonatomic, readwrite, assign) CGFloat maxValue;

@property (nonatomic, readwrite, strong) NSArray *primaryScaleMarkers;
@property (nonatomic, readwrite, strong) NSArray *secondaryScaleMarkers;

@property (nonatomic, readwrite, copy) ConverterBlock convertToPrimary;
@property (nonatomic, readwrite, copy) ConverterBlock convertToSecondary;

@end

@implementation SeamCalcSlider

- (id)initWithFrame:(CGRect)frame
         handleSize:(CGFloat)handleSize
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue primaryScaleMarkers:(NSArray *)primaryScaleMarkers secondaryScaleMarkers:(NSArray *)secondaryScaleMarkers
   convertToPrimary:(ConverterBlock)convertToPrimary
 convertToSecondary:(ConverterBlock)convertToSecondary
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scale = [[SeamCalcScale alloc] initWithFrame:CGRectMake(0.0,
                                                                     0.0,
                                                                     self.frame.size.width,
                                                                     self.frame.size.height)];
        self.scale.slider = self;
        
        self.handle = [[SeamCalcHandle alloc] initWithFrame:CGRectMake(0.0,
                                                                       self.frame.size.height/2.0 - handleSize/2.0,
                                                                       handleSize,
                                                                       handleSize)];
        
        self.minValue = minValue;
        self.maxValue = maxValue;
        self.primaryScaleMarkers = primaryScaleMarkers;
        self.secondaryScaleMarkers = secondaryScaleMarkers;
        
        [self addSubview:self.scale];
        [self addSubview:self.handle];
        
        self.convertToPrimary = convertToPrimary;
        self.convertToSecondary = convertToSecondary;
    }
    return self;
}

-(void)layoutSubviews
{
    /*
     // Set the initial state
     _minThumb.center = CGPointMake([self xForValue:selectedMinimumValue], self.center.y);
     
     _maxThumb.center = CGPointMake([self xForValue:selectedMaximumValue], self.center.y);
     
     
     NSLog(@"Tapable size %f", _minThumb.bounds.size.width);
     [self updateTrackHighlight];
     */
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.handle.frame, touchPoint)) {
        draggingHandle = YES;
        distanceFromCenter = touchPoint.x - self.handle.center.x;
    }
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!draggingHandle){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat movedX = touchPoint.x - distanceFromCenter;
    if (movedX >= self.handle.frame.size.width/2.0 && movedX <= self.frame.size.width - (self.handle.frame.size.width/2.0)) {
        self.handle.center = CGPointMake(touchPoint.x - distanceFromCenter,
                                         self.handle.center.y);
        
        [self setNeedsLayout];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    draggingHandle = NO;
}

@end

@implementation SeamCalcHandle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        
        self.opaque = NO;
        self.alpha = 0.7;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat lineWidth = 1;
    CGRect borderRect = CGRectInset(rect, lineWidth * 0.5, lineWidth * 0.5);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, lineWidth);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);
}

@end

@implementation SeamCalcScale

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat lineWidth = 1;
    
    CGFloat handleSize = _slider.handle.frame.size.width;
    CGFloat left = handleSize/2.0;
    CGFloat right = self.frame.size.width - handleSize/2.0;
    CGFloat scaleWidth = right - left;
    
    // main line
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.8, 0.8, 0.8, 1.0);
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextMoveToPoint(context, left, self.frame.size.height/2.0);
    CGContextAddLineToPoint(context, right, self.frame.size.height/2.0);
    CGContextStrokePath(context);
    
    // primary scale lines
    for (ScaleMarker *marker in _slider.primaryScaleMarkers) {
        CGFloat x = left + (([marker.value floatValue] - _slider.minValue)/(_slider.maxValue - _slider.minValue)) * scaleWidth;
        CGFloat h = self.frame.size.height/2.0 - ((self.frame.size.height/2.0) * marker.lengthProportion);
        CGContextMoveToPoint(context, x, self.frame.size.height/2.0);
        CGContextAddLineToPoint(context, x, h);
        CGContextStrokePath(context);
    }
    
    // secondary scale lines
    for (ScaleMarker *marker in _slider.secondaryScaleMarkers) {
        CGFloat primValue = _slider.convertToPrimary([marker.value floatValue]);
        CGFloat x = left + ((primValue - _slider.minValue)/(_slider.maxValue - _slider.minValue)) * scaleWidth;
        CGFloat h = self.frame.size.height/2.0 + ((self.frame.size.height/2.0) * marker.lengthProportion);
        CGContextMoveToPoint(context, x, self.frame.size.height/2.0);
        CGContextAddLineToPoint(context, x, h);
        CGContextStrokePath(context);
    }
}

@end

@implementation ScaleMixedNumber

- (id)initWithFloat:(CGFloat)floatNumber
{
    self = [super  init];
    if (self) {
        // adapted from: http://www.ics.uci.edu/~eppstein/numth/frap.c
        // TODO ...
    }
    return self;
}

- (id)initWithWhole:(NSInteger)whole numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator
{
    self = [super  init];
    if (self) {
        self.whole = whole;
        self.numerator = numerator;
        self.denominator = denominator;
    }
    return self;
}

@end

@interface ScaleMarker()

@property (nonatomic, readwrite, strong) NSNumber *value;
@property (nonatomic, readwrite, assign) CGFloat lengthProportion;
@property (nonatomic, readwrite, assign) BOOL labelVisible;

@end

@implementation ScaleMarker

- (id)initWithInt:(int)value
{
    return [self initWithInt:value lengthProportion:1.0 labelVisible:YES];
}

- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion
{
    return [self initWithInt:value lengthProportion:lengthProportion labelVisible:YES];
}

- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible
{
    self = [super init];
    if (self) {
        self.value = [NSNumber numberWithInt:value];
        self.lengthProportion = lengthProportion;
        self.labelVisible = labelVisible;
    }
    return self;
}

- (id)initWithFloat:(float)value
{
    return [self initWithFloat:value lengthProportion:1.0 labelVisible:YES];
}

- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion
{
    return [self initWithFloat:value lengthProportion:lengthProportion labelVisible:YES];
}

- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible
{
    self = [super init];
    if (self) {
        self.value = [NSNumber numberWithFloat:value];
        self.lengthProportion = lengthProportion;
        self.labelVisible = labelVisible;
    }
    return self;
}

+ (ScaleMarker *)markerWithInt:(int)value
{
    return [[ScaleMarker alloc] initWithInt:value];
}

+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion
{
    return [[ScaleMarker alloc] initWithInt:value lengthProportion:lengthProportion];
}

+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible
{
    return [[ScaleMarker alloc] initWithInt:value lengthProportion:lengthProportion labelVisible:labelVisible];
}

+ (ScaleMarker *)markerWithFloat:(float)value
{
    return [[ScaleMarker alloc] initWithFloat:value];
}

+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion
{
    return [[ScaleMarker alloc] initWithFloat:value lengthProportion:lengthProportion];
}

+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible
{
    return [[ScaleMarker alloc] initWithFloat:value lengthProportion:lengthProportion labelVisible:labelVisible];
}

@end