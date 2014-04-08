//
//  NGHFirstViewController.h
//  Nigh
//
//  Created by RIcky Chang on 4/7/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSMessagesViewController/JSMessagesViewController.h>
#import "NGHMultipeerSessionManager.h"

@interface NGHChatViewController : JSMessagesViewController<JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NGHMultipeerSessionManager *sessionManager;
// TODO: add avatar support

@end
