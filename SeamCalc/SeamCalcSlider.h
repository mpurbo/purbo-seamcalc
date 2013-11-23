//
//  SeamCalcSlider.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/17/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat (^ConverterBlock)(CGFloat value);

@interface SeamCalcSlider : UIControl

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, copy) ConverterBlock converter;

- (id)initWithFrame:(CGRect)frame handleSize:(CGFloat)handleSize;

@end
