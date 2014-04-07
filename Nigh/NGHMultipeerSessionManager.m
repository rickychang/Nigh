//
//  NGHMultipeerSessionManager.m
//  Nigh
//
//  Created by Ricky Chang on 4/7/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHMultipeerSessionManager.h"

@implementation NGHMultipeerSessionManager

// TODO: Stop using device name as default display name. Change this to force use to specify a name.
// TODO: Right now we stop services when application enters background, we don't want to do this if
// the user is streaming music and we probably want the app to stay connected for a short time (a few minutes)
// in case the user want to momentarily switch apps.
-(id)init {
    self = [super init];
    
    if (self) {
        [self initPeerWithDisplayName:[[UIDevice currentDevice] name]];
        _session = nil;
        _advertiser = nil;
        _browser = nil;
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        
        // Register for notifications
        [defaultCenter addObserver:self
                          selector:@selector(startServices)
                              name:UIApplicationWillEnterForegroundNotification
                            object:nil];
        
        [defaultCenter addObserver:self
                          selector:@selector(stopServices)
                              name:UIApplicationDidEnterBackgroundNotification
                            object:nil];
        
        [self startServices];
        
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Nil out delegates
    self.session.delegate = nil;
    self.advertiser.delegate = nil;
    self.browser.delegate = nil;
}

-(void)initPeerWithDisplayName:(NSString *)displayName
{
    _myPeerID = [[MCPeerID alloc] initWithDisplayName:displayName];
}

- (void)setupSession {
    
    self.session = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.session.delegate = self;
    
    // Create the service advertiser
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerID
                                                        discoveryInfo:nil
                                                          serviceType:kMCSessionServiceType];
    self.advertiser.delegate = self;
    
    // Create the service browser
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.myPeerID
                                                    serviceType:kMCSessionServiceType];
    self.browser.delegate = self;
}

-(void)teardownSession {
    [self.session disconnect];
}

-(void)startServices {
    [self setupSession];
    [self.advertiser startAdvertisingPeer];
    [self.browser startBrowsingForPeers];
}


-(void)stopServices {
    [self.browser stopBrowsingForPeers];
    [self.advertiser stopAdvertisingPeer];
    [self teardownSession];
}

-(NSString *)stringForPeerConnectionState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            
        case MCSessionStateConnecting:
            return @"Connecting";
            
        case MCSessionStateNotConnected:
            return @"Not Connected";
    }
}

#pragma mark - MCSessionDelegate


-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
    
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary *dict = @{@"data": data,
                           @"peerID": peerID
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
// Hacky stream opening code:
//    if (!_inputStream) {
//        _inputStream = [[TDAudioInputStreamer alloc] initWithInputStream:stream];
//        [_inputStream start];
//    }
//    
}

#pragma mark - MCNearbyServiceBrowserDelegate

// TODO: Handle case when peers have the same name.
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSString *remotePeerName = peerID.displayName;
    
    NSLog(@"Browser found %@", remotePeerName);
    
    MCPeerID *myPeerID = self.session.myPeerID;
    
    BOOL shouldInvite = ([myPeerID.displayName compare:remotePeerName] == NSOrderedDescending);
    
    if (shouldInvite)
    {
        NSLog(@"Inviting %@", remotePeerName);
        [browser invitePeer:peerID toSession:self.session withContext:nil timeout:30.0];
    }
    else
    {
        NSLog(@"Not inviting %@", remotePeerName);
    }
    
}


- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"lostPeer %@", peerID.displayName);
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"didNotStartBrowsingForPeers: %@", error);
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    NSLog(@"didReceiveInvitationFromPeer %@", peerID.displayName);
    
    invitationHandler(YES, self.session);
    
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"didNotStartAdvertisingForPeers: %@", error);
}

// Required to handle bug in MPC framework, without this session will disconnect randomly.
- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    certificateHandler(YES);
}




@end
