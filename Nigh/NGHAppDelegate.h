//
//  NGHAppDelegate.h
//  Nigh
//
//  Created by RIcky Chang on 4/7/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGHMultipeerSessionManager.h"

@interface NGHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NGHMultipeerSessionManager *sessionManager;

@end
