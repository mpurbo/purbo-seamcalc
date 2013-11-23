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
    CGFloat ch = 80.0;
    
    CGFloat x = w/2.0 - cw/2.0;
    CGFloat y = h/2.0 - ch/2.0;
    
    self.slider = [[SeamCalcSlider alloc] initWithFrame:CGRectMake(x, y, cw, ch) handleSize:40.0];
    self.slider.minValue = 0.0;
    self.slider.maxValue = 40.0;
    
    //0.0393700787
    
    [self.view addSubview:self.slider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
