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

@end

@interface SeamCalcSlider() {
    BOOL draggingHandle;
    CGFloat distanceFromCenter;
}

@property (nonatomic, strong) SeamCalcHandle *handle;
@property (nonatomic, strong) SeamCalcScale *scale;

@end

@implementation SeamCalcSlider

- (id)initWithFrame:(CGRect)frame handleSize:(CGFloat)handleSize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scale = [[SeamCalcScale alloc] initWithFrame:CGRectMake(handleSize/2.0, 0.0, self.frame.size.width - handleSize/2.0, self.frame.size.height)];
        self.handle = [[SeamCalcHandle alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height/2.0 - handleSize/2.0, handleSize, handleSize)];
        
        [self addSubview:self.scale];
        [self addSubview:self.handle];
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
    self.handle.center = CGPointMake(touchPoint.x - distanceFromCenter,
                                     self.handle.center.y);
    
    [self setNeedsLayout];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
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
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat lineWidth = 2;
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
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.8, 0.8, 0.8, 1.0);
    CGContextSetLineWidth(context, lineWidth);
    CGContextMoveToPoint(context, 0.0, self.frame.size.height/2.0);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height/2.0);
    CGContextStrokePath(context);
}

@end