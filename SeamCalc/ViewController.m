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

@property (strong, nonatomic) SeamCalcSlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    
    CGFloat cw = 240.0;
    CGFloat ch = 200.0;
    
    CGFloat x = w/2.0 - cw/2.0;
    CGFloat y = h/2.0 - ch/2.0;

    self.slider = [[SeamCalcSlider alloc] initWithFrame:CGRectMake(x, y, cw, ch)
                                             handleSize:40.0
                                               minValue:0.0 maxValue:40.0
                                    primaryScaleMarkers:@[[ScaleMarker markerWithInt:0],
                                                          [ScaleMarker markerWithInt:5 lengthProportion:0.5 labelVisible:NO],
                                                          [ScaleMarker markerWithInt:10],
                                                          [ScaleMarker markerWithInt:15 lengthProportion:0.5 labelVisible:NO],
                                                          [ScaleMarker markerWithInt:20],
                                                          [ScaleMarker markerWithInt:25 lengthProportion:0.5 labelVisible:NO],
                                                          [ScaleMarker markerWithInt:30],
                                                          [ScaleMarker markerWithInt:35 lengthProportion:0.5 labelVisible:NO],
                                                          [ScaleMarker markerWithInt:40]
                                                          ]
                                  secondaryScaleMarkers:@[[ScaleMarker markerWithFloat:0.125 lengthProportion:0.5], // 1/8
                                                          [ScaleMarker markerWithFloat:0.25],  // 1/4
                                                          [ScaleMarker markerWithFloat:0.375 lengthProportion:0.5], // 3/8
                                                          [ScaleMarker markerWithFloat:0.5],   // 1/2
                                                          [ScaleMarker markerWithFloat:0.625 lengthProportion:0.5], // 5/8
                                                          [ScaleMarker markerWithFloat:0.75],  // 3/4
                                                          [ScaleMarker markerWithFloat:0.875 lengthProportion:0.5], // 7/8
                                                          [ScaleMarker markerWithFloat:1.5]    // 1 1/2
                                                          ]
                                       convertToPrimary:^CGFloat(CGFloat value) {
                                           return value / 0.0393700787;
                                       }
                                     convertToSecondary:^CGFloat(CGFloat value) {
                                         return value * 0.0393700787;
                                     }];
    
    [self.view addSubview:self.slider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
