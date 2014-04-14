//
//  NGHSettingsViewController.m
//  Nigh
//
//  Created by Ricky Chang on 4/13/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHSettingsViewController.h"

@implementation NGHSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    NSLog(@"settingsViewControllerDidEnd");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)synchronizeSettings {
    [super synchronizeSettings];
    NSLog(@"synchornizeSettings called.");
}

@end
