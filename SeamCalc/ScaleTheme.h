//
//  ScaleTheme.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 5/4/14.
//  Copyright (c) 2014 Purbo Mohamad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaleTheme : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *labelColor;

@property (nonatomic, strong) UIColor *handleStrokeColor;
@property (nonatomic, strong) UIColor *handleFillColor;

@property (nonatomic, assign) CGFloat leftGrayLevelStart;
@property (nonatomic, assign) CGFloat leftGrayLevelEnd;
@property (nonatomic, assign) CGFloat rightGrayLevelStart;
@property (nonatomic, assign) CGFloat rightGrayLevelEnd;

@property (nonatomic, assign) CGFloat distanceDenominator;
@property (nonatomic, assign) BOOL lightTheme;

@property (nonatomic, strong) UIColor *valueHelperColor;

@end
