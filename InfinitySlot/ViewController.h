//
//  ViewController.h
//  Try_Laba_For_Cat
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>


@import GoogleMobileAds;
@import iAd;

@interface ViewController : UIViewController<ADBannerViewDelegate, GADInterstitialDelegate>{
    
}

-(void)removeAd;
-(void)addMoney:(int)money;

@end
