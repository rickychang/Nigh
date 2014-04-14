//
//  NGHSecondViewController.m
//  Nigh
//
//  Created by RIcky Chang on 4/7/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHPeersViewController.h"
#import "NGHUtils.h"

@interface NGHPeersViewController ()

@end

@implementation NGHPeersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [NGHUtils opaqueifyStatusBar:self.view];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
