//
//  Settings.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 5/5/14.
//  Copyright (c) 2014 Purbo Mohamad. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MMP_VALUE_THEME_MORNING @"morning"
#define MMP_VALUE_THEME_DUSK @"dusk"

enum {
    MMPSAOrientationMmOnTop,
    MMPSAOrientationInchOnTop
};
typedef NSInteger MMPSAOrientationType;

@interface Settings : NSObject

+ (NSString *)getTheme;
+ (void)setTheme:(NSString *)theme;
+ (MMPSAOrientationType)getOrientation;
+ (void)setOrientation:(MMPSAOrientationType)orientation;

@end
