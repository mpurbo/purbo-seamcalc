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

@interface SeamCalcScale : UIView {
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

- (id)initWithSlider:(SeamCalcSlider *)slider frame:(CGRect)frame;
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
        
        self.scale = [[SeamCalcScale alloc] initWithSlider:self
                                                     frame:CGRectMake(0.0,
                                                                      0.0,
                                                                      self.frame.size.width,
                                                                      self.frame.size.height)];
        
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
    for (ScaleMarker *marker in _slider.primaryScaleMarkers) {
        CGFloat labelSize = markerMaxHeight * marker.labelHeightProportion;
        CGFloat x = left + (([marker.value floatValue] - _slider.minValue)/(_slider.maxValue - _slider.minValue)) * scaleWidth;
        // min y is added by label height to make space for the label (if the label is visible)
        CGFloat y = markerMaxHeight - (markerMaxHeight * marker.lengthProportion) + (marker.labelVisible ? labelSize : 0.0);
        [primaryScaleOffsets addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        
        // add label if visible
        if (marker.labelVisible) {
            //NSLog(@"   frame (%f, %f, %f, %f)", x - labelSize/2.0, y - labelSize, labelSize, labelSize);
            [self addSubview:[[MixedNumberView alloc] initWithFloat:[marker.value floatValue]
                                                              frame:CGRectMake(x - labelSize/2.0, y - labelSize, labelSize, labelSize)]];
        }
    }
    self.primaryScaleOffsets = primaryScaleOffsets;
    
    // offsets for secondary scale lines (downward)
    //NSLog(@"== Drawing secondary labels");
    NSMutableArray *secondaryScaleOffsets = [NSMutableArray array];
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
            [self addSubview:[[MixedNumberView alloc] initWithFloat:[marker.value floatValue]
                                                              frame:CGRectMake(x - labelSize/2.0, y, labelSize, labelSize)]];
        }
    }
    self.secondaryScaleOffsets = secondaryScaleOffsets;
}

- (void)drawScales:(NSArray *)scaleOffsets withContext:(CGContextRef)context lineWidth:(CGFloat)lineWidth
{
    for (NSValue *ptvalue in scaleOffsets) {
        CGPoint pt = [ptvalue CGPointValue];
        if (_slider.highlightCurrentMeasurement) {
            CGFloat gray = [self grayLevelFor:pt.x inReferenceTo:_slider.handle.center.x maxDistance:(right - left)];
            CGContextSetRGBStrokeColor(context, gray, gray, gray, 1.0);
        }
        CGFloat mainLineY = (self.frame.size.height/2.0) + lineWidth;
        CGContextMoveToPoint(context, pt.x, mainLineY);
        CGContextAddLineToPoint(context, pt.x, pt.y);
        //NSLog(@"   Line drawn (%f, %f) - (%f, %f)", pt.x, mainLineY, pt.x, pt.y);
        CGContextStrokePath(context);
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
    [self drawScales:self.primaryScaleOffsets withContext:context lineWidth:lineWidth];
    // secondary scale lines (downward)
    //NSLog(@"== Drawing secondary scale lines");
    [self drawScales:self.secondaryScaleOffsets withContext:context lineWidth:lineWidth];
    
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
        self.backgroundColor = [UIColor clearColor];
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
        
        //NSLog(@"%d %d/%d", self.whole, self.numerator, self.denominator);
        [self initLabelsWithFrame:frame];
    }
    return self;
}

- (id)initWithWhole:(NSInteger)whole numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.whole = whole;
        self.numerator = numerator;
        self.denominator = denominator;
        [self initLabelsWithFrame:frame];
    }
    return self;
}

- (void)initLabelsWithFrame:(CGRect)frame
{
    if (self.whole > 0 && self.numerator == 0) {
        // whole number only
        CGRect rectWhole = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        NSString *sWhole = [NSString stringWithFormat:@"%d", self.whole];
        UILabel *labelWhole = [[UILabel alloc] initWithFrame:rectWhole];
        labelWhole.font = [self adjustFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0]
                               toFitString:sWhole inRect:rectWhole];
        labelWhole.backgroundColor = [UIColor clearColor];
        labelWhole.textColor = [UIColor blackColor];
        labelWhole.textAlignment = NSTextAlignmentCenter;
        labelWhole.text = sWhole;
        [self addSubview:labelWhole];
    } else if (self.whole == 0 && self.numerator > 0) {
        // fractional part only
        CGRect rectNum = CGRectMake(0.0, 0.0, frame.size.width/2.0, frame.size.height/2.0);
        NSString *sNum = [NSString stringWithFormat:@"%d", self.numerator];
        UILabel *labelNum = [[UILabel alloc] initWithFrame:rectNum];
        labelNum.font = [self adjustFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0]
                             toFitString:sNum inRect:rectNum];
        labelNum.backgroundColor = [UIColor clearColor];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.text = sNum;
        [self addSubview:labelNum];
        
        CGRect rectDenom = CGRectMake(frame.size.width/2.0, frame.size.height/2.0, frame.size.width/2.0, frame.size.height/2.0);
        NSString *sDenom = [NSString stringWithFormat:@"%d", self.denominator];
        UILabel *labelDenom = [[UILabel alloc] initWithFrame:rectDenom];
        labelDenom.font = [self adjustFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17.0]
                               toFitString:sDenom inRect:rectDenom];
        labelDenom.backgroundColor = [UIColor clearColor];
        labelDenom.textColor = [UIColor blackColor];
        labelDenom.textAlignment = NSTextAlignmentCenter;
        labelDenom.text = sDenom;
        [self addSubview:labelDenom];
    } else if (self.whole > 0 && self.numerator > 0) {
        // half of the frame is for whole number, another half for num/denom
        CGRect rectWhole = CGRectMake(0.0, 0.0, frame.size.width/2.0, frame.size.height);
        NSString *sWhole = [NSString stringWithFormat:@"%d", self.whole];
        UILabel *labelWhole = [[UILabel alloc] initWithFrame:rectWhole];
        labelWhole.font = [self adjustFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0]
                               toFitString:sWhole inRect:rectWhole];
        labelWhole.backgroundColor = [UIColor clearColor];
        labelWhole.textColor = [UIColor blackColor];
        labelWhole.textAlignment = NSTextAlignmentCenter;
        labelWhole.text = sWhole;
        [self addSubview:labelWhole];
        
        CGRect rectNum = CGRectMake(frame.size.width/2.0, 0.0, frame.size.width/4.0, frame.size.height/4.0);
        NSString *sNum = [NSString stringWithFormat:@"%d", self.numerator];
        UILabel *labelNum = [[UILabel alloc] initWithFrame:rectNum];
        labelNum.font = [self adjustFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0]
                             toFitString:sNum inRect:rectNum];
        labelNum.backgroundColor = [UIColor clearColor];
        labelNum.textColor = [UIColor blackColor];
        labelNum.textAlignment = NSTextAlignmentCenter;
        labelNum.text = sNum;
        [self addSubview:labelNum];
        
        CGRect rectDenom = CGRectMake(frame.size.width*0.75, frame.size.height/2.0, frame.size.width/4.0, frame.size.height/4.0);
        NSString *sDenom = [NSString stringWithFormat:@"%d", self.denominator];
        UILabel *labelDenom = [[UILabel alloc] initWithFrame:rectDenom];
        labelDenom.font = [self adjustFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0]
                               toFitString:sDenom inRect:rectDenom];
        labelDenom.backgroundColor = [UIColor clearColor];
        labelDenom.textColor = [UIColor blackColor];
        labelDenom.textAlignment = NSTextAlignmentCenter;
        labelDenom.text = sDenom;
        [self addSubview:labelDenom];
    }
    
}

- (UIFont *)adjustFont:(UIFont *)font toFitString:(NSString *)string inRect:(CGRect)rect
{
    UIFont *ret = font;
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:ret}];
    while(size.width > rect.size.width){
        ret = [UIFont fontWithDescriptor:ret.fontDescriptor size:ret.pointSize - 1];
        size = [string sizeWithAttributes:@{NSFontAttributeName:ret}];
    }
    return ret;
}

/*
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}
*/

@end
