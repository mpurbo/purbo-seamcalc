//
//  MixedNumberView.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 12/11/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixedNumberView : UIView

@property (nonatomic, assign) NSInteger whole;
@property (nonatomic, assign) NSUInteger numerator;
@property (nonatomic, assign) NSUInteger denominator;

@property (nonatomic, strong, readonly) UILabel *labelWhole;
@property (nonatomic, strong, readonly) UILabel *labelNumerator;
@property (nonatomic, strong, readonly) UILabel *labelDenominator;

- (id)initWithFloat:(CGFloat)floatNumber frame:(CGRect)frame;
- (id)initWithWhole:(NSInteger)whole numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator frame:(CGRect)frame;

@end
