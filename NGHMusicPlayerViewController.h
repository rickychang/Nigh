//
//  NGHMusicPlayerViewController.h
//  Nigh
//
//  Created by Ricky Chang on 4/16/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NGHMusicPlayerViewController : UIViewController <MPMediaPickerControllerDelegate> {
    
    IBOutlet UIImageView *artworkImageView;
    IBOutlet UISlider *volumeSlider;
    IBOutlet UIButton *playPauseButton;
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *artistAlbumLabel;
    
    MPMusicPlayerController *musicPlayer;
    
}
@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

- (IBAction)volumeChanged:(id)sender;
- (IBAction)showMediaPicker:(id)sender;
- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;

- (void) registerMediaPlayerNotifications;

@end