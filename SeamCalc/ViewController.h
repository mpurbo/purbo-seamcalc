//
//  ViewController.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 11/16/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeamCalcSlider.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet SeamCalcSlider *slider;

@property (strong, nonatomic) IBOutlet UILabel *labelTop;
@property (strong, nonatomic) IBOutlet UILabel *labelBottom;

@end
