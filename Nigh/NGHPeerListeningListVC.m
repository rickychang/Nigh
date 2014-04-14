//
//  NGHPeerListeningListVC.m
//  Nigh
//
//  Created by natalie on 4/13/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHPeerListeningListVC.h"
#import "NGHAppDelegate.h"
#import "NGHMultipeerSessionManager.h"


@implementation NGHPeerListeningListVC


-(void)viewDidLoad {
    
    [super viewDidLoad];
    
  
}

-(void)viewDidAppear:(BOOL)animated {
    if ([[NGHAppDelegate globalSessionManager] hasPeerConnection]) {
        
        [self showPeerList];
        
    }
    else {
        
        [self showNoPeerList];
    }
}

-(void)showPeerList {
    [_outerHasNoPeersView setAlpha:0.0];
    [_outerHasPeersView setAlpha:1.0];
}
-(void)showNoPeerList {
    [_outerHasPeersView setAlpha:0.0];
    [_outerHasNoPeersView setAlpha:1.0];
}
@end
