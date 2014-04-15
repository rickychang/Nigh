//
//  NGHMPlayerManager.m
//  Nigh
//
//  Created by Ricky Chang on 4/14/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHMPlayerManager.h"
#import "NGHSongInfoMessage.h"

@implementation NGHMPlayerManager

-(id)initWithSessionManager:(NGHMultipeerSessionManager*)sessionManager {
    self = [super init];
    
    if (self) {
        _mPlayerController = [MPMusicPlayerController iPodMusicPlayer];
        _sessionManager = sessionManager;
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter
         addObserver: self
         selector:    @selector (handleNowPlayingItemChanged:)
         name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
         object:      _mPlayerController];
        
        [notificationCenter
         addObserver: self
         selector:    @selector (handlePlaybackStateChanged:)
         name:        MPMusicPlayerControllerPlaybackStateDidChangeNotification
         object:      _mPlayerController];
        
        [_mPlayerController beginGeneratingPlaybackNotifications];
        
    }
    
    return self;
}

- (void)dealloc {
    [self.mPlayerController endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mPlayerController = nil;
    self.sessionManager = nil;
}

-(void)sendCurrentSongInfo {
    MPMediaItem *currentItem = self.mPlayerController.nowPlayingItem;
    if (currentItem) {
        NGHSongInfoMessage *songInfo = [[NGHSongInfoMessage alloc] initWithTitle:[currentItem valueForProperty:MPMediaItemPropertyTitle]
                                                                          artist:[currentItem valueForProperty:MPMediaItemPropertyArtist]
                                                                        duration:[currentItem valueForProperty:MPMediaItemPropertyPlaybackDuration]
                                                                          sender:self.sessionManager.myPeerID.displayName
                                                                            date:[NSDate date]];
        NSData* dataToSend = [NSKeyedArchiver archivedDataWithRootObject:songInfo];
        [self.sessionManager.session sendData:dataToSend toPeers:self.sessionManager.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
        
    }
}

-(void)handleNowPlayingItemChanged:(id)notification {
    [self sendCurrentSongInfo];
    
}

-(void)handlePlaybackStateChanged:(id)notification {
    
}




@end
