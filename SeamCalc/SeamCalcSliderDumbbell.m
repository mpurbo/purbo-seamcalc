//
//  SeamCalcSlider.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/16/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import "SeamCalcSliderDumbbell.h"

@interface SeamCalcSliderDumbbell() {
    CGPoint touchStart;
}

@property (strong, nonatomic) UIImageView *imageView;
@property (assign) float topValue;
@property (strong, nonatomic) UILabel *topLabel;
@property (assign) float bottomValue;
@property (strong, nonatomic) UILabel *bottomLabel;

@end

@implementation SeamCalcSliderDumbbell

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // background image
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.imageView];
        // top label
        self.topValue = 0.0;
        self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0,
                                                                  frame.size.width, frame.size.width)];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        self.topLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        self.topLabel.text = [NSString stringWithFormat:@"%.1f", self.topValue];
        [self addSubview:self.topLabel];
        // bottom label
        self.bottomValue = 0.0;
        self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, frame.size.height - frame.size.width,
                                                                     frame.size.width, frame.size.width)];
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
        self.bottomLabel.text = [NSString stringWithFormat:@"%.1f", self.bottomValue];
        [self addSubview:self.bottomLabel];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchStart = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    //self.center = CGPointMake(self.center.x + point.x - touchStart.x, self.center.y + point.y - touchStart.y);
    // limit change to x-direction only
    CGFloat x = self.center.x + point.x - touchStart.x;
    self.center = CGPointMake(x, self.center.y);
    self.topValue = x - self.superview.center.x;
    self.topLabel.text = [NSString stringWithFormat:@"%.1f", self.topValue];
    self.bottomValue = (x - self.superview.center.x) * 0.03937;
    self.bottomLabel.text = [NSString stringWithFormat:@"%.1f", self.bottomValue];    
}

@end
