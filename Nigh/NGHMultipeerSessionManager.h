//
//  NGHMultipeerSessionManager.h
//  Nigh
//
//  Created by Ricky Chang on 4/7/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface NGHMultipeerSessionManager : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) MCPeerID *myPeerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;

@property (nonatomic, strong) NSMutableDictionary * connectedPeers;

-(void) initPeerWithDisplayName:(NSString *)displayName;
-(void)startServices;
-(void)stopServices;
-(BOOL)hasPeerConnection;


@end
