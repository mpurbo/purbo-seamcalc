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

@interface SeamCalcSlider : UIControl

@property (nonatomic, assign) CGFloat handleSize;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) BOOL highlightCurrentMeasurement;

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, strong) NSArray *primaryScaleMarkers;
@property (nonatomic, strong) NSArray *secondaryScaleMarkers;

@property (nonatomic, copy) ConverterBlock convertToPrimary;
@property (nonatomic, copy) ConverterBlock convertToSecondary;

/*
- (id)initWithFrame:(CGRect)frame
         handleSize:(CGFloat)handleSize
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue primaryScaleMarkers:(NSArray *)primaryScaleMarkers secondaryScaleMarkers:(NSArray *)secondaryScaleMarkers
   convertToPrimary:(ConverterBlock)convertToPrimary
 convertToSecondary:(ConverterBlock)convertToSecondary;
*/

@end
