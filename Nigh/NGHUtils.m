//
//  NGHUtils.m
//  Nigh
//
//  Created by natalie on 4/13/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHUtils.h"

@implementation NGHUtils


+(void)opaqueifyStatusBar:(UIView*)view {
    UIView * topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    [topBarView setAlpha:1.0];
    [topBarView setBackgroundColor:view.backgroundColor];

    [view addSubview:topBarView];
}

@end
