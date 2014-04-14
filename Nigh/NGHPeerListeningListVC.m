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


#define SAMPLE_SONG @"Partition"
#define SAMPLE_ARTIST @"Beyoncé"

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
    
    
    _userPic.layer.cornerRadius = 20; // this value vary as per your desire
    _userPic.clipsToBounds = YES;
    [_userPic setBackgroundColor:[UIColor purpleColor]];
    NSString * peerName = [[[NGHAppDelegate globalSessionManager] peerNames] objectAtIndex:0];
    
    [_headerLabel setText:[NSString stringWithFormat:@"%@ is listening to", peerName]];
    [_footerLabel setText:[NSString stringWithFormat:@"\"%@\" by %@",
                           SAMPLE_SONG, SAMPLE_ARTIST]];
    
    [_messageButton setTitle:[NSString stringWithFormat:@"Message %@", peerName]
                    forState:UIControlStateNormal];
    
}
-(void)showNoPeerList {
    [_outerHasPeersView setAlpha:0.0];
    [_outerHasNoPeersView setAlpha:1.0];
}

-(IBAction)messagePeer:(id)sender {
    NSLog(@"message peer");
    
}

@end
