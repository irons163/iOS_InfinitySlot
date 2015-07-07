//
//  MyUtils.h
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/21.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtils : NSObject

+(void)playBackgroundMusic:(NSString*)filename;
+(void)backgroundMusicPlayerStop;
+(void)backgroundMusicPlayerPause;
+(void)backgroundMusicPlayerPlay;

@end
