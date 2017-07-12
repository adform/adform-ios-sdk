//
//  InstreamViewController.m
//  sample
//
//  Created by Vladas Drejeris on 18/05/16.
//  Copyright © 2016 adform. All rights reserved.
//

#import "InstreamViewController.h"
#import <AdformAdvertising/AdformAdvertising.h>
#import <AVKit/AVKit.h>

static NSInteger const kPreRollMid = 142494;
static NSInteger const kMidRollMid = 142494;
static NSInteger const kPostRollMid = 142494;

@interface InstreamViewController ()

@property (nonatomic, strong) IBOutlet AFVideoPlayerController *af_videoPlayer;
@property (nonatomic, strong) IBOutlet AVPlayerViewController *av_videoPlayer;

@end

@implementation InstreamViewController

#pragma mark - Actions

- (IBAction)showSDKPlayer:(id)sender {
    
    // Remove old player.
    [self.af_videoPlayer stop];
    [self.af_videoPlayer.view removeFromSuperview];
    
    // Create the player controller with content URL.
    self.af_videoPlayer = [[AFVideoPlayerController alloc] initWithURL:self.contentURL];
    
    // Set master tags for ads.
    self.af_videoPlayer.preRollMId = kPreRollMid;
    self.af_videoPlayer.midRollMId = kMidRollMid;
    self.af_videoPlayer.postRollMId = kPostRollMid;
    
    // Add player view to view hierarchy.
    self.af_videoPlayer.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:self.af_videoPlayer.view];
    
    // Play the player.
    [self.af_videoPlayer play];
}

- (IBAction)showAVPlayer:(id)sender {
    
    // Remove old player.
    [self.af_videoPlayer stop];
    [self.af_videoPlayer.view removeFromSuperview];
    
    // Create AVPlayerViewController.
    self.av_videoPlayer = [AVPlayerViewController new];
    self.av_videoPlayer.player = [AVPlayer playerWithURL:self.contentURL];
    
    // Create content playback for player.
    AFAVPlayerViewControllerPlayback *playback = [[AFAVPlayerViewControllerPlayback alloc] initWithPlayer:self.av_videoPlayer];
    
    // Create the player controller with content playback.
    self.af_videoPlayer = [[AFVideoPlayerController alloc] initWithContainer:self.av_videoPlayer.view andContentPlayback:playback];
    
    // Set master tags for ads.
    self.af_videoPlayer.preRollMId = kPreRollMid;
    self.af_videoPlayer.midRollMId = kPreRollMid;
    self.af_videoPlayer.postRollMId = kPostRollMid;
    
    // Show the player.
    [self presentViewController:self.av_videoPlayer
                       animated:true
                     completion:nil];
}

- (NSURL *)contentURL {
    
    return [NSURL URLWithString:@"http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_640x360.m4v"];
}

@end
