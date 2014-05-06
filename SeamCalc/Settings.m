//
//  Settings.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 5/5/14.
//  Copyright (c) 2014 Purbo Mohamad. All rights reserved.
//

#import "Settings.h"

@implementation Settings

#define MMP_SETKEY_THEME @"MMPSeamAllowanceTheme"
#define MMP_SETKEY_ORIENTATION @"MMPSeamAllowanceOrientation"

+ (NSString *)getTheme
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *theme = [defaults objectForKey:MMP_SETKEY_THEME];
    if (theme == nil) {
        [defaults setObject:MMP_VALUE_THEME_MORNING forKey:MMP_SETKEY_THEME];
        theme = MMP_VALUE_THEME_MORNING;
    }
    return theme;
}

+ (void)setTheme:(NSString *)theme
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theme forKey:MMP_SETKEY_THEME];
}

+ (MMPSAOrientationType)getOrientation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *norientation = [defaults objectForKey:MMP_SETKEY_ORIENTATION];
    if (norientation == nil) {
        norientation = [NSNumber numberWithInteger:MMPSAOrientationMmOnTop];
        [defaults setObject:norientation forKey:MMP_SETKEY_ORIENTATION];
        
    }
    return [norientation integerValue];
}

+ (void)setOrientation:(MMPSAOrientationType)orientation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:orientation] forKey:MMP_SETKEY_ORIENTATION];
}

@end
