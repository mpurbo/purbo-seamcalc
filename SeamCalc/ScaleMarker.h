//
//  ScaleMarker.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 12/8/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaleMarker : NSObject

@property (nonatomic, readonly, strong) NSNumber *value;
@property (nonatomic, readonly, assign) CGFloat lengthProportion;
@property (nonatomic, readonly, assign) CGFloat labelHeightProportion;
@property (nonatomic, readonly, assign) BOOL labelVisible;
@property (nonatomic, readonly, assign) BOOL primary;

- (id)initWithInt:(int)value;
- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion;
- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible;

/**
 *  Initialize with customized marker length and label height and integer value.
 *
 *  @param value                 Value of the marker.
 *  @param lengthProportion      Length as a factor of maximum marker length.
 *  @param labelHeightProportion Label height as a factor of maximum marker length.
 *  @param labelVisible          Whether the label should be visible or not.
 *
 *  @return Newly created marker instance.
 */
- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelHeightProportion:(CGFloat)labelHeightProportion;

- (id)initWithFloat:(float)value;
- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion;
- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible;

/**
 *  Initialize with customized marker length and label height and float value.
 *
 *  @param value                 Value of the marker.
 *  @param lengthProportion      Length as a factor of maximum marker length.
 *  @param labelHeightProportion Label height as a factor of maximum marker length.
 *  @param labelVisible          Whether the label should be visible or not.
 *
 *  @return Newly created marker instance.
 */
- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelHeightProportion:(CGFloat)labelHeightProportion;

+ (ScaleMarker *)markerWithInt:(int)value;
+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion;
+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible;
+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelHeightProportion:(CGFloat)labelHeightProportion;

+ (ScaleMarker *)markerWithFloat:(float)value;
+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion;
+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible;
+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelHeightProportion:(CGFloat)labelHeightProportion;

@end