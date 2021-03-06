//
//  SeamCalcSlider.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/17/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import "SeamCalcSlider.h"
#import <CoreText/CoreText.h>
#import "ScaleMarkerPrivate.h"
#import "MixedNumberView.h"

@interface SeamCalcHandle : UIView

@property (nonatomic, strong) ScaleTheme *theme;

@end

@interface SeamCalcScale() {
    // marker maximum height
    CGFloat markerMaxHeight;
    CGFloat handleSize;
    
    // slider main line is from half of handle diameter to frame width - half of handle diameter
    // so that the handle circle can go all the way to the frame left.
    CGFloat left;
    CGFloat right;
    CGFloat scaleWidth;
}

@property (nonatomic, weak) SeamCalcSlider *slider;

@property (nonatomic, strong) NSArray *primaryScaleOffsets;
@property (nonatomic, strong) NSArray *secondaryScaleOffsets;

@property (nonatomic, strong) NSArray *primaryScaleLabels;
@property (nonatomic, strong) NSArray *secondaryScaleLabels;

- (id)initWithSlider:(SeamCalcSlider *)slider frame:(CGRect)frame;
- (void)cleanupLineAndLabels;

@end

@interface SeamCalcAnimatedMarker : UIView

@end

@interface SeamCalcSlider() {
    BOOL draggingHandle;
    CGFloat distanceFromCenter;
}

@property (nonatomic, strong) SeamCalcHandle *handle;

@end

@interface SeamCalcSlider()

@end

@implementation SeamCalcSlider

- (void)initComponents
{
    if (self.scale) {
        [self.scale removeFromSuperview];
    }
    if (self.handle) {
        [self.handle removeFromSuperview];
    }
    
    self.handle = [[SeamCalcHandle alloc] initWithFrame:CGRectMake(0.0,
                                                                   self.frame.size.height/2.0 - self.handleSize/2.0,
                                                                   self.handleSize,
                                                                   self.handleSize)];
    self.scale = [[SeamCalcScale alloc] initWithSlider:self
                                                 frame:CGRectMake(0.0,
                                                                  0.0,
                                                                  self.frame.size.width,
                                                                  self.frame.size.height)];
    
    [self addSubview:self.scale];
    [self addSubview:self.handle];
}

- (void)updateTheme:(ScaleTheme *)theme
{
    self.theme = theme;
    self.scale.theme = theme;
    self.handle.theme = theme;
    [self.scale cleanupLineAndLabels];
    [self.scale setNeedsDisplay];
    [self.handle setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)awakeFromNib
{
    [self initComponents];
}

- (void)setPrimaryScaleMarkers:(NSArray *)primaryScaleMarkers
{
    _primaryScaleMarkers = primaryScaleMarkers;
    
    for (ScaleMarker *marker in _primaryScaleMarkers) {
        marker.primary = YES;
    }
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

- (CGFloat)xToValue:(CGFloat)x
{
    CGFloat wscr = self.frame.size.width - self.handle.frame.size.width;
    CGFloat xscr = x - self.handle.frame.size.width/2.0;
    return self.minValue + ((xscr/wscr) * (self.maxValue - self.minValue));
}

- (CGFloat)valueToX:(CGFloat)value
{
    CGFloat wscr = self.frame.size.width - self.handle.frame.size.width;
    return ((wscr * (value - self.minValue))/(self.maxValue - self.minValue)) + self.handle.frame.size.width/2.0;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!draggingHandle){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    CGFloat movedX = touchPoint.x - distanceFromCenter;
    if (movedX >= self.handle.frame.size.width/2.0 && movedX <= self.frame.size.width - (self.handle.frame.size.width/2.0)) {
        
        CGFloat cx = touchPoint.x - distanceFromCenter;
        self.handle.center = CGPointMake(cx, self.handle.center.y);
        
        _value = [self xToValue:cx];
        
        [self setNeedsLayout];
        [self.scale setNeedsDisplay];
    }
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    draggingHandle = NO;
    
    // find & snap to closest marker
    
    ScaleMarker *marker = [self.scale findMarkerClosestTo:self.value];
    //NSLog(@"Found closest marker: %@ (from value = %f)", marker.value, self.value);
    
    if (marker) {
        CGFloat targetValue = marker.primary ? [marker.value floatValue] : self.convertToPrimary([marker.value floatValue]);
        //NSLog(@"Target value: %f", targetValue);
        [self setValue:targetValue];
    }
}

- (void)setValue:(CGFloat)value
{
    // move handle
    CGFloat cx = [self valueToX:value];
    self.handle.center = CGPointMake(cx, self.handle.center.y);
    
    _value = value;
    [self setNeedsLayout];
    [self.scale setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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
    
    /*
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    */
    /*
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    */
    CGFloat strokeR, strokeG, strokeB, strokeA;
    CGFloat fillR, fillG, fillB, fillA;
    
    [_theme.handleStrokeColor getRed:&strokeR green:&strokeG blue:&strokeB alpha:&strokeA];
    [_theme.handleFillColor getRed:&fillR green:&fillG blue:&fillB alpha:&fillA];
    
    CGContextSetRGBStrokeColor(context, strokeR, strokeG, strokeB, strokeA);
    CGContextSetRGBFillColor(context, fillR, fillG, fillB, fillA);
    
    CGContextSetLineWidth(context, lineWidth);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextStrokeEllipseInRect(context, borderRect);
    CGContextFillPath(context);
}

@end

@implementation SeamCalcScale

#define SC_GRAY_LEVEL 0.85
#define SC_GRAY SC_GRAY_LEVEL, SC_GRAY_LEVEL, SC_GRAY_LEVEL, 1.0

- (id)initWithSlider:(SeamCalcSlider *)slider frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.slider = slider;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.primaryScaleOffsets = nil;
        self.secondaryScaleOffsets = nil;
    }
    return self;
}

- (void)cleanupLineAndLabels
{
    if (_primaryScaleLabels) {
        for (id label in _primaryScaleLabels) {
            if ([label class] == [MixedNumberView class]) {
                [label removeFromSuperview];
            }
        }
    }
    
    if (_secondaryScaleLabels) {
        for (id label in _secondaryScaleLabels) {
            if ([label class] == [MixedNumberView class]) {
                [label removeFromSuperview];
            }
        }
    }
    
    self.primaryScaleOffsets = nil;
    self.secondaryScaleOffsets = nil;
    self.primaryScaleLabels = nil;
    self.secondaryScaleLabels = nil;
}

- (void)initValues
{
    NSLog(@"Initializing scale offset values & labels");
    
    // marker maximum height
    markerMaxHeight = self.frame.size.height/2.0;
    
    handleSize = _slider.handle.frame.size.width;
    
    // slider main line is from half of handle diameter to frame width - half of handle diameter
    // so that the handle circle can go all the way to the frame left.
    left = handleSize/2.0;
    right = self.frame.size.width - handleSize/2.0;
    scaleWidth = right - left;
    
    // offsets for primary scale lines (upward)
    //NSLog(@"== Drawing primary labels");
    NSMutableArray *primaryScaleOffsets = [NSMutableArray array];
    NSMutableArray *primaryScaleLabels = [NSMutableArray array];
    for (ScaleMarker *marker in _slider.primaryScaleMarkers) {
        CGFloat labelSize = markerMaxHeight * marker.labelHeightProportion;
        CGFloat x = left + (([marker.value floatValue] - _slider.minValue)/(_slider.maxValue - _slider.minValue)) * scaleWidth;
        // min y is added by label height to make space for the label (if the label is visible)
        CGFloat y = markerMaxHeight - (markerMaxHeight * marker.lengthProportion) + (marker.labelVisible ? labelSize : 0.0);
        [primaryScaleOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        
        // add label if visible
        if (marker.labelVisible) {
            //NSLog(@"   frame (%f, %f, %f, %f)", x - labelSize/2.0, y - labelSize, labelSize, labelSize);
            MixedNumberView *label = [[MixedNumberView alloc] initWithFloat:[marker.value floatValue]
                                                                      frame:CGRectMake(x - labelSize/2.0, y - labelSize, labelSize, labelSize)];
            [self addSubview:label];
            [primaryScaleLabels addObject:label];
        } else {
            [primaryScaleLabels addObject:[NSNull null]];
        }
    }
    self.primaryScaleOffsets = primaryScaleOffsets;
    self.primaryScaleLabels = primaryScaleLabels;
    
    // offsets for secondary scale lines (downward)
    //NSLog(@"== Drawing secondary labels");
    NSMutableArray *secondaryScaleOffsets = [NSMutableArray array];
    NSMutableArray *secondaryScaleLabels = [NSMutableArray array];
    for (ScaleMarker *marker in _slider.secondaryScaleMarkers) {
        CGFloat labelSize = markerMaxHeight * marker.labelHeightProportion;
        CGFloat primValue = _slider.convertToPrimary([marker.value floatValue]);
        CGFloat x = left + ((primValue - _slider.minValue)/(_slider.maxValue - _slider.minValue)) * scaleWidth;
        // max y is subtracted by label height to make space for the label (if the label is visible)
        CGFloat y = markerMaxHeight + (markerMaxHeight * marker.lengthProportion) - (marker.labelVisible ? markerMaxHeight * marker.labelHeightProportion : 0.0);
        [secondaryScaleOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        // add label if visible
        if (marker.labelVisible) {
            //NSLog(@"   frame (%f, %f, %f, %f)", x - labelSize/2.0, y + labelSize, labelSize, labelSize);
            MixedNumberView *label = [[MixedNumberView alloc] initWithFloat:[marker.value floatValue]
                                                                      frame:CGRectMake(x - labelSize/2.0, y, labelSize, labelSize)];
            [self addSubview:label];
            [secondaryScaleLabels addObject:label];
        } else {
            [secondaryScaleLabels addObject:[NSNull null]];
        }
    }
    self.secondaryScaleOffsets = secondaryScaleOffsets;
    self.secondaryScaleLabels = secondaryScaleLabels;
}

- (void)drawScales:(NSArray *)scaleOffsets
            labels:(NSArray *)labels
       withContext:(CGContextRef)context
         lineWidth:(CGFloat)lineWidth
{
    int i = 0;
    for (NSValue *ptvalue in scaleOffsets) {
        CGPoint pt = [ptvalue CGPointValue];
        if (_slider.highlightCurrentMeasurement) {
            CGFloat gray = [self grayLevelFor:pt.x inReferenceTo:_slider.handle.center.x maxDistance:(right - left)];
            CGContextSetRGBStrokeColor(context, gray, gray, gray, 1.0);
            id label = [labels objectAtIndex:i];
            if ([label class] == [MixedNumberView class]) {
                MixedNumberView *mnv = (MixedNumberView *)label;
                [mnv setColor:[UIColor colorWithRed:gray green:gray blue:gray alpha:1.0]];
                [mnv setNeedsLayout];
                [mnv setNeedsDisplay];
            }
        }
        CGFloat mainLineY = (self.frame.size.height/2.0) + lineWidth;
        CGContextMoveToPoint(context, pt.x, mainLineY);
        CGContextAddLineToPoint(context, pt.x, pt.y);
        //NSLog(@"   Line drawn (%f, %f) - (%f, %f)", pt.x, mainLineY, pt.x, pt.y);
        CGContextStrokePath(context);
        i++;
    }
}

- (void)drawRect:(CGRect)rect
{
    if (!self.primaryScaleOffsets) {
        [self initValues];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // scale line width
    CGFloat lineWidth = 1.0;
    
    CGContextSetRGBStrokeColor(context, SC_GRAY);
    
    // primary scale lines (upward)
    //NSLog(@"== Drawing primary scale lines");
    [self drawScales:self.primaryScaleOffsets labels:self.primaryScaleLabels withContext:context lineWidth:lineWidth];
    // secondary scale lines (downward)
    //NSLog(@"== Drawing secondary scale lines");
    [self drawScales:self.secondaryScaleOffsets labels:self.secondaryScaleLabels withContext:context lineWidth:lineWidth];
    
    // main line
    
    if (_slider.highlightCurrentMeasurement) {
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        size_t num_locations = 2;
        /*
        CGFloat locations_l[2] = { 0.0, 1.0 };
        CGFloat locations_r[2] = { 1.0, 0.0 };
        */
        /*
        CGFloat locations_l[2] = { 1.0, 0.2 };
        CGFloat locations_r[2] = { 0.2, 1.0 };
        */
        CGFloat locations_l[2] = { _theme.leftGrayLevelStart, _theme.leftGrayLevelEnd };
        CGFloat locations_r[2] = { _theme.rightGrayLevelStart, _theme.rightGrayLevelEnd };
        
        CGFloat components[8] =	{ SC_GRAY, 0.0, 0.0, 0.0, 1.0 };
        
        CGGradientRef gradient_l = CGGradientCreateWithColorComponents(colorSpace, components, locations_l, num_locations);
        CGGradientRef gradient_r = CGGradientCreateWithColorComponents(colorSpace, components, locations_r, num_locations);
        
        CGContextSaveGState(context);
        {
            // left to center gradient
            CGContextAddRect(context, CGRectMake(left, self.frame.size.height/2.0,
                                                 _slider.handle.center.x, lineWidth));
            CGContextClip(context);
            CGContextDrawLinearGradient(context, gradient_l,
                                        CGPointMake(left, self.frame.size.height/2.0),
                                        CGPointMake(_slider.handle.center.x, self.frame.size.height/2.0),
                                        0);
        }
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        {
            // center to right gradient
            CGContextAddRect(context, CGRectMake(_slider.handle.center.x, self.frame.size.height/2.0,
                                                 right, lineWidth));
            CGContextClip(context);
            CGContextDrawLinearGradient(context, gradient_r,
                                        CGPointMake(_slider.handle.center.x, self.frame.size.height/2.0),
                                        CGPointMake(right, self.frame.size.height/2.0),
                                        0);
        }
        CGContextRestoreGState(context);
        
        CGGradientRelease(gradient_l);
        CGGradientRelease(gradient_r);
        CGColorSpaceRelease(colorSpace);
        
    } else {
        // use simple line
        CGContextSetLineWidth(context, lineWidth);
        CGContextMoveToPoint(context, left, self.frame.size.height/2.0);
        CGContextAddLineToPoint(context, right, self.frame.size.height/2.0);
        CGContextStrokePath(context);
    }

}

- (CGFloat)grayLevelFor:(CGFloat)current inReferenceTo:(CGFloat)center maxDistance:(CGFloat)maxDistance
{
    // gray level is an asymptotic function of how far the current x is from the current center of the handle:
    // the closer the current x to the center of the handle, the closer it is to the reference gray level (SC_GRAY_LEVEL)
    // simple asymptotic function:
    // f(x) = 1/x, for x >= 0, but we're only interested in x >= 1 (so that f(x) will always be 1 or <= 1
    
    //@property (nonatomic, assign) CGFloat distanceDenominator;
    //@property (nonatomic, assign) BOOL lightTheme;

    CGFloat distance = fabs(current - center);
    CGFloat x = 1.0;
    if (distance > 0.0) {
        //x = distance/10.0;
        //x = distance/20.0;
        x = distance/_theme.distanceDenominator;
    }

    CGFloat gray;
    
    if (_theme.lightTheme) {
        gray = 1.0 - ((1.0/x) * SC_GRAY_LEVEL);
        if (gray < 0.0) {
            gray = 0.0;
        }
    } else {
        gray = ((1.0/x) * SC_GRAY_LEVEL);
        if (gray > 1.0) {
            gray = 1.0;
        }
    }
    
    return gray;
}

- (ScaleMarker *)findMarkerClosestTo:(CGFloat)value
{
    ScaleMarker *minMarker = [self findMarkerClosestTo:value inMarkers:_slider.primaryScaleMarkers];
    if (minMarker) {
        ScaleMarker *minMarker2 = [self findMarkerClosestTo:value inMarkers:_slider.secondaryScaleMarkers];
        if (minMarker2) {
            //NSLog(@"  value = %f, minMarker.value = %@", value, minMarker.value);
            CGFloat dist1 = fabs(value - [minMarker.value floatValue]);
            //NSLog(@"  dist1 = %f", dist1);
            //NSLog(@"  value = %f, minMarker2.value = %@, conv = %f", value, minMarker2.value, self.slider.convertToPrimary([minMarker2.value floatValue]));
            CGFloat dist2 = fabs(value - self.slider.convertToPrimary([minMarker2.value floatValue]));
            //NSLog(@"  dist2 = %f", dist2);
            if (dist2 < dist1) {
                minMarker = minMarker2;
            }
        }
    } else {
        minMarker = [self findMarkerClosestTo:value inMarkers:_slider.secondaryScaleMarkers];
    }
    return minMarker;
}

- (ScaleMarker *)findMarkerClosestTo:(CGFloat)value inMarkers:(NSArray *)markers
{
    ScaleMarker *minMarker = nil;
    CGFloat minDistance = _slider.maxValue;
    
    for (ScaleMarker *marker in markers) {
        if (!minMarker) {
            minDistance = marker.primary ?
                fabs(value - [marker.value floatValue]) :
                fabs(value - self.slider.convertToPrimary([marker.value floatValue]));
            minMarker = marker;
        } else {
            CGFloat distance = marker.primary ?
                fabs(value - [marker.value floatValue]) :
                fabs(value - self.slider.convertToPrimary([marker.value floatValue]));
            if (distance < minDistance) {
                minDistance = distance;
                minMarker = marker;
            }
        }
    }
    
    return minMarker;
}

@end

@implementation SeamCalcAnimatedMarker

- (void)drawRect:(CGRect)rect
{
    
}

@end
