//
//  SeamCalcSlider.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/17/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleMarker.h"

typedef CGFloat (^ConverterBlock)(CGFloat value);

@interface MixedNumberView : UIView

@property (nonatomic, assign) NSInteger whole;
@property (nonatomic, assign) NSUInteger numerator;
@property (nonatomic, assign) NSUInteger denominator;

- (id)initWithFloat:(CGFloat)floatNumber frame:(CGRect)frame;
- (id)initWithWhole:(NSInteger)whole numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator frame:(CGRect)frame;

@end

@interface SeamCalcSlider : UIControl

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) BOOL highlightCurrentMeasurement;

@property (nonatomic, readonly, assign) CGFloat minValue;
@property (nonatomic, readonly, assign) CGFloat maxValue;

@property (nonatomic, readonly, strong) NSArray *primaryScaleMarkers;
@property (nonatomic, readonly, strong) NSArray *secondaryScaleMarkers;

@property (nonatomic, readonly, copy) ConverterBlock convertToPrimary;
@property (nonatomic, readonly, copy) ConverterBlock convertToSecondary;

- (id)initWithFrame:(CGRect)frame
         handleSize:(CGFloat)handleSize
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue primaryScaleMarkers:(NSArray *)primaryScaleMarkers secondaryScaleMarkers:(NSArray *)secondaryScaleMarkers
   convertToPrimary:(ConverterBlock)convertToPrimary
 convertToSecondary:(ConverterBlock)convertToSecondary;

@end
