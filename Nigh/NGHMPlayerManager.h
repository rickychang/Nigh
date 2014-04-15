//
//  NGHMPlayerManager.h
//  Nigh
//
//  Created by Ricky Chang on 4/14/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NGHMultipeerSessionManager.h"

@interface NGHMPlayerManager : NSObject

@property (strong, nonatomic) NGHMultipeerSessionManager *sessionManager;
@property (strong, nonatomic) MPMusicPlayerController *mPlayerController;

-(void)handleNowPlayingItemChanged:(id)notification;
-(void)handlePlaybackStateChanged:(id)notification;


@end
