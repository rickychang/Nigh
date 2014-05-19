//
//  NGHMusicPlayerViewController.m
//  Nigh
//
//  Created by Ricky Chang on 4/16/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHMusicPlayerViewController.h"
#import "NGHSongInfoMessage.h"
#import <MediaPlayer/MPMediaItem.h>
#import <GVMusicPlayerController/GVMusicPlayerController.h>
#import "NGHAppDelegate.h"

@interface NGHMusicPlayerViewController () <MPMediaPickerControllerDelegate, GVMusicPlayerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistAlbumLabel;

@end

@implementation NGHMusicPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sessionManager = ((NGHAppDelegate*)[[UIApplication sharedApplication] delegate]).sessionManager;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GVMusicPlayerController sharedInstance] addDelegate:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[GVMusicPlayerController sharedInstance] removeDelegate:self];
    [super viewDidDisappear:animated];
}

#pragma mark - Catch remote control events, forward to the music player

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    [[GVMusicPlayerController sharedInstance] remoteControlReceivedWithEvent:receivedEvent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVMusicPlayerControllerDelegate

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer playbackStateChanged:(MPMusicPlaybackState)playbackState previousPlaybackState:(MPMusicPlaybackState)previousPlaybackState {
    self.playPauseButton.selected = (playbackState == MPMusicPlaybackStatePlaying);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer trackDidChange:(MPMediaItem *)nowPlayingItem previousTrack:(MPMediaItem *)previousTrack {
    
    // Labels
    self.titleLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    self.artistAlbumLabel.text = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    
    // Artwork
    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        self.artworkImageView.image = [artwork imageWithSize:self.artworkImageView.frame.size];
    }
    
    NSNumber *duration = [nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration];
    
    
    NGHSongInfoMessage *newMessage = [[NGHSongInfoMessage alloc] initWithTitle:self.titleLabel.text
                                                                        artist:self.artistAlbumLabel.text duration:duration
                                                                        sender:self.sessionManager.myPeerID.displayName
                                                                          date:[NSDate date]];
    
    // Very simple message serialization, reuse model class for chat view. Will need to change to support other message types.
    NSData* dataToSend = [NSKeyedArchiver archivedDataWithRootObject:newMessage];
   [self.sessionManager.session sendData:dataToSend toPeers:self.sessionManager.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
    
    NSLog(@"Proof that this code is being called, even in the background!");
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer endOfQueueReached:(MPMediaItem *)lastTrack {
    NSLog(@"End of queue, but last track was %@", [lastTrack valueForProperty:MPMediaItemPropertyTitle]);
}

- (void)musicPlayer:(GVMusicPlayerController *)musicPlayer volumeChanged:(float)volume {
    self.volumeSlider.value = volume;
}


#pragma mark - IBActions

- (IBAction)playButtonPressed {
    if ([GVMusicPlayerController sharedInstance].playbackState == MPMusicPlaybackStatePlaying) {
        [[GVMusicPlayerController sharedInstance] pause];
    } else {
        [[GVMusicPlayerController sharedInstance] play];
    }
}

- (IBAction)prevButtonPressed {
    [[GVMusicPlayerController sharedInstance] skipToPreviousItem];
}

- (IBAction)nextButtonPressed {
    [[GVMusicPlayerController sharedInstance] skipToNextItem];
}


- (IBAction)volumeChanged:(UISlider *)sender {
    [GVMusicPlayerController sharedInstance].volume = sender.value;
}

- (IBAction)showMediaPicker:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    [[GVMusicPlayerController sharedInstance] setQueueWithItemCollection:mediaItemCollection];
    [[GVMusicPlayerController sharedInstance] play];
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

@end

