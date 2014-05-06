//
//  SeamCalcSlider.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/17/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleMarker.h"
#import "ScaleTheme.h"

typedef CGFloat (^ConverterBlock)(CGFloat value);
typedef NSString *(^FormatterBlock)(CGFloat value);

@interface SeamCalcScale : UIView

@property (nonatomic, strong) ScaleTheme *theme;

- (ScaleMarker *)findMarkerClosestTo:(CGFloat)value;
- (ScaleMarker *)findMarkerClosestTo:(CGFloat)value inMarkers:(NSArray *)markers;

@end

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

@property (nonatomic, copy) FormatterBlock primaryFormatter;
@property (nonatomic, copy) FormatterBlock secondaryFormatter;

@property (nonatomic, strong) SeamCalcScale *scale;

@property (nonatomic, strong) ScaleTheme *theme;

/*
- (id)initWithFrame:(CGRect)frame
         handleSize:(CGFloat)handleSize
           minValue:(CGFloat)minValue
           maxValue:(CGFloat)maxValue primaryScaleMarkers:(NSArray *)primaryScaleMarkers secondaryScaleMarkers:(NSArray *)secondaryScaleMarkers
   convertToPrimary:(ConverterBlock)convertToPrimary
 convertToSecondary:(ConverterBlock)convertToSecondary;
*/

- (CGFloat)xToValue:(CGFloat)x;
- (CGFloat)valueToX:(CGFloat)value;

- (void)updateTheme:(ScaleTheme *)theme;
- (void)initComponents;

@end
