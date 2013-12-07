//
//  ScaleMarker.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 12/8/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import "ScaleMarker.h"
#import "ScaleMarkerPrivate.h"

#define MP_DEFAULT_MARKER_LENGTHPROP 1.0
#define MP_DEFAULT_MARKER_LABELHEIGHTPROP 0.2

@implementation ScaleMarker

- (id)initWithInt:(int)value
{
    return [self initWithInt:value lengthProportion:MP_DEFAULT_MARKER_LENGTHPROP labelVisible:YES];
}

- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion
{
    return [self initWithInt:value lengthProportion:lengthProportion labelVisible:YES];
}

- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible
{
    self = [super init];
    if (self) {
        self.value = [NSNumber numberWithInt:value];
        self.lengthProportion = lengthProportion;
        self.labelVisible = labelVisible;
        self.labelHeightProportion = MP_DEFAULT_MARKER_LABELHEIGHTPROP;
    }
    return self;
}

- (id)initWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelHeightProportion:(CGFloat)labelHeightProportion
{
    self = [super init];
    if (self) {
        self.value = [NSNumber numberWithInt:value];
        self.lengthProportion = lengthProportion;
        self.labelVisible = YES;
        self.labelHeightProportion = labelHeightProportion;
    }
    return self;
}

- (id)initWithFloat:(float)value
{
    return [self initWithFloat:value lengthProportion:MP_DEFAULT_MARKER_LENGTHPROP labelVisible:YES];
}

- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion
{
    return [self initWithFloat:value lengthProportion:lengthProportion labelVisible:YES];
}

- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible
{
    self = [super init];
    if (self) {
        self.value = [NSNumber numberWithFloat:value];
        self.lengthProportion = lengthProportion;
        self.labelVisible = labelVisible;
        self.labelHeightProportion = MP_DEFAULT_MARKER_LABELHEIGHTPROP;
    }
    return self;
}

- (id)initWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelHeightProportion:(CGFloat)labelHeightProportion
{
    self = [super init];
    if (self) {
        self.value = [NSNumber numberWithFloat:value];
        self.lengthProportion = lengthProportion;
        self.labelVisible = YES;
        self.labelHeightProportion = labelHeightProportion;
    }
    return self;
}


+ (ScaleMarker *)markerWithInt:(int)value
{
    return [[ScaleMarker alloc] initWithInt:value];
}

+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion
{
    return [[ScaleMarker alloc] initWithInt:value lengthProportion:lengthProportion];
}

+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible
{
    return [[ScaleMarker alloc] initWithInt:value lengthProportion:lengthProportion labelVisible:labelVisible];
}

+ (ScaleMarker *)markerWithInt:(int)value lengthProportion:(CGFloat)lengthProportion labelHeightProportion:(CGFloat)labelHeightProportion
{
    return [[ScaleMarker alloc] initWithInt:value lengthProportion:lengthProportion labelHeightProportion:labelHeightProportion];
}

+ (ScaleMarker *)markerWithFloat:(float)value
{
    return [[ScaleMarker alloc] initWithFloat:value];
}

+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion
{
    return [[ScaleMarker alloc] initWithFloat:value lengthProportion:lengthProportion];
}

+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelVisible:(BOOL)labelVisible
{
    return [[ScaleMarker alloc] initWithFloat:value lengthProportion:lengthProportion labelVisible:labelVisible];
}

+ (ScaleMarker *)markerWithFloat:(float)value lengthProportion:(CGFloat)lengthProportion labelHeightProportion:(CGFloat)labelHeightProportion
{
    return [[ScaleMarker alloc] initWithFloat:value lengthProportion:lengthProportion labelHeightProportion:labelHeightProportion];
}

@end