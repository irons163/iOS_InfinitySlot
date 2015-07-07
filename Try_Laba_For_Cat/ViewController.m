//
//  ViewController.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/4/18.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "GameOverViewController.h"
#import "BuyViewController.h"
#import "CommonUtil.h"

@implementation ViewController{
    ADBannerView * adBannerView;
    GADInterstitial *interstitial;
    MyScene * scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 200, 30)];
    adBannerView.delegate = self;
    adBannerView.alpha = 1.0f;
    [self.view addSubview:adBannerView];
    
    
    NSLog(@"Google Mobile Ads SDK version: %@", [GADRequest sdkVersion]);
    
    interstitial = [self createAndLoadInterstitial];

    bool areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //this will load wether or not they bought the in-app purchase
    
    ((CommonUtil*)[CommonUtil sharedInstance]).isPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPurchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(areAdsRemoved){
        [self.view setBackgroundColor:[UIColor blueColor]];
        //if they did buy it, set the background to blue, if your using the code above to set the background to blue, if your removing ads, your going to have to make your own code here
    }
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    scene.onGameOver = ^(int gameLevel, int gameTime){
        [self gameOverWithLose:gameLevel withGameTime:gameTime];
    };
    
    scene.showAdmob = ^(){
        [self showAdmob];
    };
    
    scene.showBuyViewController = ^(){
        [self showBuyViewController];
    };
    
    // Present the scene.
    [skView presentScene:scene];
}

-(void) gameOverWithLose:(int)gameLevel withGameTime:(int)gameTime{
    GameOverViewController* gameOverDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverDialogViewController.delegate = self;
    
    //    gameOverDialogViewController.gameLevelTensDigitalLabel = time;
    
    gameOverDialogViewController.gameLevel = gameLevel;
    
    gameOverDialogViewController.gameTime = gameTime;
    
    //    [self.navigationController popToViewController:gameOverDialogViewController animated:YES];
    
    //    [self.delegate BviewcontrollerDidTapButton:self];
    
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [gameOverDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    /* //before ios8
     self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
     */
    
    //    [self.navigationController presentModalViewController:gameOverDialogViewController animated:YES];
    
    [self.navigationController presentViewController:gameOverDialogViewController animated:YES completion:^{
        //        [reset];
    }];
}

-(void) showBuyViewController{
    BuyViewController* buyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyViewController"];
    buyViewController.viewController = self;
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.navigationController presentViewController:buyViewController animated:YES completion:^{
    }];
}

-(void)showAdmob{
    if ([interstitial isReady]) {
        [interstitial presentFromRootViewController:self];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];
//    interstitial.adUnitID = @"ca-app-pub-2566742856382887/8779587052";
    interstitial.adUnitID = @"ca-app-pub-3940256099942544/4411468910";
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self->interstitial = [self createAndLoadInterstitial];
}

-(void)removeAd{
    [adBannerView setAlpha:0];
}

-(void)addMoney:(int)money{
    [scene addMoney:money];
}

@end
