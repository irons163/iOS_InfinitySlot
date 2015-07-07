//
//  MyUtils.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/21.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MyUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation MyUtils

AVAudioPlayer * backgroundMusicPlayer;

+(void)playBackgroundMusic:(NSString*)filename {
    NSURL * url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    
    if (url == nil) {
        NSLog(@"Could not find file:%@",filename);
        return;
    }
    
    NSError * error;
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (backgroundMusicPlayer == nil) {
        NSLog(@"Could not create audio player:%@",error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
    
//    var error: NSError? = nil backgroundMusicPlayer =
//    AVAudioPlayer(contentsOfURL: url, error: &error) if backgroundMusicPlayer == nil {
//        println("Could not create audio player: \(error!)")
//        return
    }

+(void)backgroundMusicPlayerStop{
    [backgroundMusicPlayer stop];
}

+(void)backgroundMusicPlayerPause{
    [backgroundMusicPlayer pause];
}

+(void)backgroundMusicPlayerPlay{
    [backgroundMusicPlayer play];
}

@end
