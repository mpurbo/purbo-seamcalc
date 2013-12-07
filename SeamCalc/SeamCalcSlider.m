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

@interface SeamCalcHandle : UIView

@end

@interface SeamCalcScale : UIView

@property (nonatomic, weak) SeamCalcSlider *slider;

- (ScaleMarker *)findMarkerClosestTo:(CGFloat)value;

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
        
        for (ScaleMarker *marker in self.primaryScaleMarkers) {
            marker.primary = YES;
        }
        for (ScaleMarker *marker in self.secondaryScaleMarkers) {
            marker.primary = NO;
        }
        
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
        [self sendActionsForControlEvents:UIControlEventValueChanged];
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

#define SC_GRAY_LEVEL 0.85
#define SC_GRAY SC_GRAY_LEVEL, SC_GRAY_LEVEL, SC_GRAY_LEVEL, 1.0

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // scale line width
    CGFloat lineWidth = 1.0;
    
    CGFloat handleSize = _slider.handle.frame.size.width;
    
    // slider main line is from half of handle diameter to frame width - half of handle diameter
    // so that the handle circle can go all the way to the frame left.
    CGFloat left = handleSize/2.0;
    CGFloat right = self.frame.size.width - handleSize/2.0;
    CGFloat scaleWidth = right - left;
    
    CGContextSetRGBStrokeColor(context, SC_GRAY);
    
    // primary scale lines
    for (ScaleMarker *marker in _slider.primaryScaleMarkers) {
        CGFloat x = left + (([marker.value floatValue] - _slider.minValue)/(_slider.maxValue - _slider.minValue)) * scaleWidth;
        // height is subtracted by label height to make space for the label.
        CGFloat h = self.frame.size.height/2.0 - ((self.frame.size.height/2.0) * marker.lengthProportion);
        if (_slider.highlightCurrentMeasurement) {
            CGFloat gray = [self grayLevelFor:x inReferenceTo:_slider.handle.center.x maxDistance:(right - left)];
            CGContextSetRGBStrokeColor(context, gray, gray, gray, 1.0);
        }
        CGContextMoveToPoint(context, x, (self.frame.size.height/2.0) + lineWidth);
        CGContextAddLineToPoint(context, x, h);
        CGContextStrokePath(context);
    }
    
    // secondary scale lines
    for (ScaleMarker *marker in _slider.secondaryScaleMarkers) {
        CGFloat primValue = _slider.convertToPrimary([marker.value floatValue]);
        CGFloat x = left + ((primValue - _slider.minValue)/(_slider.maxValue - _slider.minValue)) * scaleWidth;
        CGFloat h = self.frame.size.height/2.0 + ((self.frame.size.height/2.0) * marker.lengthProportion);
        if (_slider.highlightCurrentMeasurement) {
            CGFloat gray = [self grayLevelFor:x inReferenceTo:_slider.handle.center.x maxDistance:(right - left)];
            CGContextSetRGBStrokeColor(context, gray, gray, gray, 1.0);
        }
        CGContextMoveToPoint(context, x, (self.frame.size.height/2.0));
        CGContextAddLineToPoint(context, x, h);
        CGContextStrokePath(context);
    }
    
    // main line
    
    if (_slider.highlightCurrentMeasurement) {
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        size_t num_locations = 2;
        CGFloat locations_l[2] = { 0.0, 1.0 };
        CGFloat locations_r[2] = { 1.0, 0.0 };
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
    
    CGFloat distance = fabs(current - center);
    CGFloat x = 1.0;
    if (distance > 0.0) {
        x = distance/10.0;
    }

    CGFloat gray = 1.0 - ((1.0/x) * SC_GRAY_LEVEL);
    if (gray < 0.0) {
        gray = 0.0;
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

@implementation MixedNumberView

- (id)initWithFloat:(CGFloat)floatNumber frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.whole = floor(floatNumber);
        
        // calculating float number to fractional number with int components: whole numerator/denominator
        // e.g. 1.25 -> 1 1/4
        // adapted from: http://rosettacode.org/wiki/Convert_decimal_number_to_rational#C

        CGFloat f = floatNumber - self.whole;
        
        NSInteger num;
        NSInteger denom;
        NSInteger md = 10;
        
        NSInteger a, h[3] = { 0, 1, 0 }, k[3] = { 1, 0, 0 };
        NSInteger x, d, n = 1;
        NSInteger i, neg = 0;
        
        if (md <= 1) {
            denom = 1;
            num = (NSInteger)f;
        } else {
            if (f < 0) { neg = 1; f = -f; }
            
            while (f != floor(f)) { n <<= 1; f *= 2; }
            d = f;
            
            /* continued fraction and check denominator each step */
            for (i = 0; i < 64; i++) {
                a = n ? d / n : 0;
                if (i && !a) break;
                
                x = d; d = n; n = x % n;
                
                x = a;
                if (k[1] * a + k[0] >= md) {
                    x = (md - k[0]) / k[1];
                    if (x * 2 >= a || k[1] >= md)
                        i = 65;
                    else
                        break;
                }
                
                h[2] = x * h[1] + h[0]; h[0] = h[1]; h[1] = h[2];
                k[2] = x * k[1] + k[0]; k[0] = k[1]; k[1] = k[2];
            }
            denom = k[1];
            num = neg ? -h[1] : h[1];
        }
        
        self.denominator = denom;
        self.numerator = num;
        
        NSLog(@"%d %d/%d", self.whole, self.numerator, self.denominator);
        
    }
    return self;
}

- (id)initWithWhole:(NSInteger)whole numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.whole = whole;
        self.numerator = numerator;
        self.denominator = denominator;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    [[UIColor redColor] setFill];
    [[UIColor greenColor] setStroke];
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
}

@end
