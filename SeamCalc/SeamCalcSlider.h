//
//  SeamCalcSlider.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/17/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat (^ConverterBlock)(CGFloat value);

@interface ScaleMixedNumber : NSObject

@property (nonatomic, assign) NSInteger whole;
@property (nonatomic, assign) NSUInteger numerator;
@property (nonatomic, assign) NSUInteger denominator;

- (id)initWithFloat:(CGFloat)floatNumber;
- (id)initWithWhole:(NSInteger)whole numerator:(NSUInteger)numerator denominator:(NSUInteger)denominator;

@end

@interface ScaleMarker : NSObject

@property (nonatomic, readonly, strong) NSNumber *value;
@property (nonatomic, readonly, assign) CGFloat lengthProportion;
@property (nonatomic, readonly, assign) BOOL labelVisible;

- (id)initWithInt:(int)value;
- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion;
- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible;

- (id)initWithFloat:(float)value;
- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion;
- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible;

+ (ScaleMarker *)markerWithInt:(int)value;
+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion;
+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible;

+ (ScaleMarker *)markerWithFloat:(float)value;
+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion;
+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible;

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
