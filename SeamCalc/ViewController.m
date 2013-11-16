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
    
    UIImage *image = [UIImage imageNamed:@"slider"];
    
    CGFloat x = w/2.0 - image.size.width/2.0;
    CGFloat y = h/2.0 - image.size.height/2.0;
    
    self.slider = [[SeamCalcSlider alloc] initWithFrame:CGRectMake(x, y, image.size.width, image.size.height)
                                                  image:[UIImage imageNamed:@"slider"]];
    
    [self.view addSubview:self.slider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
