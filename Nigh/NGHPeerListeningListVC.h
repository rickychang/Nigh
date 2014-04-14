//
//  NGHPeerListeningListVC.h
//  Nigh
//
//  Created by natalie on 4/13/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGHPeerListeningListVC : UIViewController

@property (nonatomic, weak) IBOutlet UIView * outerHasPeersView;
@property (nonatomic, weak) IBOutlet UIView * outerHasNoPeersView;


@property (nonatomic, weak) IBOutlet UILabel * headerLabel;
@property (nonatomic, weak) IBOutlet UILabel * footerLabel;
@property (nonatomic, weak) IBOutlet UIButton * messageButton;

@property (nonatomic, weak) IBOutlet UIImageView * userPic;

-(IBAction)messagePeer:(id)sender;

@end
