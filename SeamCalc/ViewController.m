//
//  ViewController.m
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/16/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import "ViewController.h"
#import "SeamCalcSlider.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _slider.primaryScaleMarkers = @[[ScaleMarker markerWithInt:0 lengthProportion:1.0 labelHeightProportion:0.15],
                                    [ScaleMarker markerWithInt:5 lengthProportion:0.5 labelVisible:NO],
                                    [ScaleMarker markerWithInt:10 lengthProportion:1.0 labelHeightProportion:0.15],
                                    [ScaleMarker markerWithInt:15 lengthProportion:0.5 labelVisible:NO],
                                    [ScaleMarker markerWithInt:20 lengthProportion:1.0 labelHeightProportion:0.15],
                                    [ScaleMarker markerWithInt:25 lengthProportion:0.5 labelVisible:NO],
                                    [ScaleMarker markerWithInt:30 lengthProportion:1.0 labelHeightProportion:0.15],
                                    [ScaleMarker markerWithInt:35 lengthProportion:0.5 labelVisible:NO],
                                    [ScaleMarker markerWithInt:40 lengthProportion:1.0 labelHeightProportion:0.15]
                                    ];
    _slider.secondaryScaleMarkers = @[[ScaleMarker markerWithFloat:0.125 lengthProportion:0.5 labelHeightProportion:0.15], // 1/8
                                      [ScaleMarker markerWithFloat:0.25 lengthProportion:1.0 labelHeightProportion:0.15],  // 1/4
                                      [ScaleMarker markerWithFloat:0.375 lengthProportion:0.5 labelHeightProportion:0.15], // 3/8
                                      [ScaleMarker markerWithFloat:0.5 lengthProportion:1.0 labelHeightProportion:0.15],   // 1/2
                                      [ScaleMarker markerWithFloat:0.625 lengthProportion:0.5 labelHeightProportion:0.15], // 5/8
                                      [ScaleMarker markerWithFloat:0.75 lengthProportion:1.0 labelHeightProportion:0.15],  // 3/4
                                      [ScaleMarker markerWithFloat:0.875 lengthProportion:0.5 labelHeightProportion:0.15], // 7/8
                                      [ScaleMarker markerWithFloat:1.5 lengthProportion:1.0 labelHeightProportion:0.15]    // 1 1/2
                                      ];
    _slider.convertToPrimary = ^CGFloat(CGFloat value) {
        return value / 0.0393700787;
    };
    _slider.convertToSecondary = ^CGFloat(CGFloat value) {
        return value * 0.0393700787;
    };
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
