//
//  MyScene.h
//  Try_Laba_For_Cat
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene

typedef void(^gameOverDialog)(int, int);
@property (atomic, copy) gameOverDialog onGameOver;
typedef void(^admob)();
@property (atomic, copy) admob showAdmob;
typedef void(^buyView)();
@property (atomic, copy) buyView showBuyViewController;
typedef void(^rankView)();
@property (atomic, copy) rankView showRankView;
typedef void(^hintView)();
@property (atomic, copy) hintView showHintView;


@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

-(void)stop;

-(void)addMoney:(int)money;

+(NSString*)moneyField;

+(int)MONEY_INIT;

@end
