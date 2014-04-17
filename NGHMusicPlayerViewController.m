//
//  NGHMusicPlayerViewController.m
//  Nigh
//
//  Created by Ricky Chang on 4/16/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHMusicPlayerViewController.h"

@interface NGHMusicPlayerViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    MPMusicPlayerController* appMusicPlayer =
    [MPMusicPlayerController applicationMusicPlayer];
    
    [appMusicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [appMusicPlayer setRepeatMode: MPMusicRepeatModeNone];
    
    [volumeSlider setValue:[musicPlayer volume]];
    
    if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        
        [playPauseButton setImage:[UIImage imageNamed:@"pause-solid"] forState:UIControlStateNormal];
        
    } else {
        
        [playPauseButton setImage:[UIImage imageNamed:@"play-solid"] forState:UIControlStateNormal];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)volumeChanged:(id)sender {

}
- (IBAction)showMediaPicker:(id)sender {
    
}
- (IBAction)previousSong:(id)sender {
    
}

- (IBAction)playPause:(id)sender {
    
}
- (IBAction)nextSong:(id)sender {
    
}

- (void) registerMediaPlayerNotifications {
    
}

@end
