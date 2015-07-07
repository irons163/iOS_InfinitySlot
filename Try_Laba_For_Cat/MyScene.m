//
//  MyScene.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/4/18.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "MyADView.h"
#import "CommonUtil.h"
#import "RuleUtil.h"
#import "MyDefine.h"
#import "MyUtils.h"

#define DEFAULT_HP  2

const bool TEST_LABA_PRIZE =true;

bool isCanPressStartBtn = true;
bool isCanPressStopBtn = false;
float eachFrameheight=1;
int scrollCount, scrollCount2, scrollCount3;
int position, position2, position3;
bool isLabaSitckRun = false;
bool isLabaSitck2Run = false;
bool isLabaSitck3Run = false;

const int MONEY_COIN_10 = 10;
const int MONEY_COIN_30 = 30;
const int MONEY_COIN_50 = 50;
const static int MONEY_INIT = 2000;
const static int MONEY_INIT_EVERYDAY = 1000;

int currentMoneyLevel = MONEY_COIN_10;
static int currentMoney = MONEY_INIT;

const int displayADPerTimes = 3;
int displayADCount = 1;
bool isFocusStopFallWithCoinsRun = false;

bool isAutoStop = false;

const int AUTO_STOP_TIME_MS = 5000;
int firstStopTimeMs = AUTO_STOP_TIME_MS;
int secondStopTimeMs = AUTO_STOP_TIME_MS;
int thirdStopTimeMs = AUTO_STOP_TIME_MS;

const int DELAY_TIME_PER_LABA_STICK_MIN_MS = 500;
const int DELAY_TIME_PER_LABA_STICK_MAX_MS = 1000;

const int WIN_LT_FRAME = 0;
const int WIN_TOP_FRAME = 1;
const int WIN_RT_FRAME = 2;
const int WIN_LEFT_FRAME = 3;
const int WIN_CENTER_FRAME = 4;
const int WIN_RIGHT_FRAME = 5;
const int WIN_LB_FRAME = 6;
const int WIN_BOTTOM_FRAME = 7;
const int WIN_RB_FRAME = 8;

const int WIN_MID_LINE = 0;
const int WIN_LT_RB_LINE = 1;
const int WIN_LB_RT_LINE = 2;

const int NORMAL_TEXTURE_INDEX = 0;
const int PRESSED_TEXTURE_INDEX = 1;

const static NSString * moneyField = @"money";

const int fallWithCoinsNumber = 30;

@interface MyTimer : NSObject
-(void)stop;
+(instancetype)initWithMyScene:(MyScene*)scene;
@end

@implementation MyTimer{
    bool isStopTheAutoStop;
    MyScene * scene;
}

-(instancetype)init{
    if(self = [super init]){
        isStopTheAutoStop = false;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AUTO_STOP_TIME_MS * NSEC_PER_MSEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if(isStopTheAutoStop)
                return;
            
            for(int i = 0; i<3; i++){
                
                
                
                if(i==0){
                    
                    
                    isAutoStop = true;
                    [scene stop];
                    
                    
                    
                }else if(i==1){
                    
                    usleep(secondStopTimeMs*1000);
                    
                    
                    
                    isAutoStop = true;
                    [scene stop];
                    
                    
                    
                }else if(i==2){
                    
                    usleep(thirdStopTimeMs*1000);
                    
                    
                    
                    isAutoStop = true;
                    [scene stop];
                    
                    
                    //                timer.purge();
                    //                timer.cancel();
                }
            }
            
        });

    }
    return self;
}

+(instancetype)initWithMyScene:(MyScene*)scene{
    MyTimer * timer = [MyTimer new];
    [timer setScene:scene];
    return timer;
}

-(void)setScene:(MyScene*)scene{
    self->scene = scene;
}

-(void)stop{
    isStopTheAutoStop = true;
}


@end

@implementation MyScene{
    int screenWidth, screenHeight;
    int ccount;
    float labaStickApearPartHeight;
    float labaStickCropNodeMaskY;
//    int currentMoney;
//    int holeZposition;
    SKSpriteNode * backgroundNode;
    SKSpriteNode * labaFrameNode;
    SKSpriteNode * labaStickNode, * labaStickNode2, * labaStickNode3;
    SKCropNode * labaStickCropNode, * labaStickCropNode2, * labaStickCropNode3;
    SKSpriteNode * startBtn;
    SKSpriteNode * stopBtn;
    SKSpriteNode * labaHole;
    SKSpriteNode * coin10Btn, * coin30Btn, * coin50Btn;
    MyADView * myAdView;
    SKSpriteNode * storeBtn;
    CommonUtil * commonUtil;
    
    NSMutableArray * winFrameArray;
    NSMutableArray * winLineArray;
    
    NSArray * storeBtnClickTextureArray;
    NSArray * coin10BtnClickTextureArray;
    NSArray * coin30BtnClickTextureArray;
    NSArray * coin50BtnClickTextureArray;
    NSArray * stopBtnClickTextureArray;
    NSArray * startBtnClickTextureArray;
    
    SKLabelNode * textViewMoneyLevel, * textViewCurrentMonryLevel, * textViewMoney, * textViewCurrentMoney;
    
    CGPoint coin10BtnOraginPosition, coin30BtnOraginPosition,coin50BtnOraginPosition;
    
    NSMutableArray * fallWithCoins;
    NSMutableArray * fallWithCoinsY;
    
    float alldistanceXForPerMove;
}



-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
//        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
//        holeZposition = 0;
        
        commonUtil = [CommonUtil sharedInstance];
        
        [MyUtils playBackgroundMusic:@"laba.mp3"];
        
//        [MyUtils backgroundMusicPlayerStop];
        
        [self loadMoney];
        
        backgroundNode = [SKSpriteNode spriteNodeWithImageNamed:@"laba_bg.jpg"];
        backgroundNode.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        backgroundNode.position = CGPointMake(0, 0);
        backgroundNode.anchorPoint = CGPointMake(0, 0);
        [self addChild:backgroundNode];
        
        myAdView = [MyADView spriteNodeWithTexture:nil];
        myAdView.size = CGSizeMake(200, 55);
        myAdView.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 35);
        [myAdView startAd];
        [self addChild:myAdView];
        
        storeBtn = [SKSpriteNode spriteNodeWithImageNamed:@"store1"];
        storeBtn.size = CGSizeMake((self.size.width - myAdView.size.width)/2.0f, myAdView.size.height);
        storeBtn.position = CGPointMake(myAdView.position.x + myAdView.size.width/2.0f + storeBtn.size.width/2.0f, myAdView.position.y);
        [self addChild:storeBtn];
        
        labaFrameNode = [SKSpriteNode spriteNodeWithImageNamed:@"laba_fg"];
        labaFrameNode.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        labaFrameNode.position = CGPointMake(0, 0);
        labaFrameNode.anchorPoint = CGPointMake(0, 0);
        [self addChild:labaFrameNode];
        
        labaStickNode = [SKSpriteNode spriteNodeWithImageNamed:@"lol_laba2.jpg"];
        labaStickNode.anchorPoint = CGPointMake(0, 1);
        labaStickNode.position = CGPointMake((self.frame.size.width - self.frame.size.width/3.6f*3)/2.0f, myAdView.position.y - myAdView.size.height/2.0f -5);
        labaStickNode.size = CGSizeMake(self.frame.size.width/3.6f, self.frame.size.height*2);
//        [self addChild:labaStickNode];
        
        
        labaStickNode2 = [SKSpriteNode spriteNodeWithImageNamed:@"lol_laba2.jpg"];
        labaStickNode2.anchorPoint = CGPointMake(0, 1);
        labaStickNode2.position = CGPointMake(labaStickNode.position.x+labaStickNode.size.width, myAdView.position.y - myAdView.size.height/2.0f-5);
        labaStickNode2.size = CGSizeMake(self.frame.size.width/3.6f, self.frame.size.height*2);
        
        
        labaStickNode3 = [SKSpriteNode spriteNodeWithImageNamed:@"lol_laba2.jpg"];
        labaStickNode3.anchorPoint = CGPointMake(0, 1);
        labaStickNode3.position = CGPointMake(labaStickNode.position.x+labaStickNode.size.width*2, myAdView.position.y - myAdView.size.height/2.0f-5);
        labaStickNode3.size = CGSizeMake(self.frame.size.width/3.6f, self.frame.size.height*2);
        
        startBtn = [SKSpriteNode spriteNodeWithImageNamed:@"start_btn1"];
        startBtn.size = CGSizeMake(100, 100);
        startBtn.position = CGPointMake(self.size.width/2.0, startBtn.size.height/2.0f);
        
        [self addChild:startBtn];
        
        stopBtn = [SKSpriteNode spriteNodeWithImageNamed:@"stop_btn1"];
        stopBtn.size = CGSizeMake(100, 100);
        stopBtn.position = CGPointMake(self.size.width/2.0-startBtn.size.width, stopBtn.size.height/2.0f);
        
        [self addChild:stopBtn];
        
        
        labaHole = [SKSpriteNode spriteNodeWithImageNamed:@"money_in_bar.jpg"];
        labaHole.size = CGSizeMake(30, 100);
//        labaHole.position = CGPointMake(self.size.width/2.0-startBtn.size.width, stopBtn.position.y + stopBtn.size.height/2.0 + labaHole.size.height/2.0);
        labaHole.position = CGPointMake(15, stopBtn.position.y + stopBtn.size.height/2.0 + labaHole.size.height/2.0 +20);
//        labaHole.zPosition = holeZposition;
        int disapearX = labaHole.position.x;
        [self addChild:labaHole];
        
        coin10Btn = [SKSpriteNode spriteNodeWithImageNamed:@"coin_10_btn01"];
        coin10Btn.size = CGSizeMake(80, 80);
        coin10Btn.position = CGPointMake(labaHole.position.x + labaHole.size.width/2.0f + coin10Btn.size.width/2.0f, labaHole.position.y);
        
        coin10BtnOraginPosition = coin10Btn.position;
        
//        [self addChild:coin10Btn];
        
//        coin10Btn
        
        CGSize coinMaskDisplaySise = CGSizeMake((coin10Btn.position.x - disapearX)*2, coin10Btn.size.height);
        
        SKSpriteNode *coinMask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:coinMaskDisplaySise];
        
        coinMask.anchorPoint = coin10Btn.anchorPoint;
        
        coinMask.position = coin10Btn.position;
//        coinMask.position = CGPointMake(disapearX, coin10Btn.position.y);
        
        SKCropNode * coinCropNode = [SKCropNode node];
        //        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size: CGSizeMake(1, 1)];
        
        [coinCropNode addChild:coin10Btn];
        
        coinCropNode.maskNode = coinMask;
        
        //        [node addChild:mask];
        
        [self addChild:coinCropNode];

        
        
        
        coin30Btn = [SKSpriteNode spriteNodeWithImageNamed:@"coin_30_btn01"];
        coin30Btn.size = CGSizeMake(80, 80);
        coin30Btn.position = CGPointMake(coin10Btn.position.x + coin30Btn.size.width, labaHole.position.y);
        coin30BtnOraginPosition = coin30Btn.position;
//        [self addChild:coin30Btn];
//        [coinCropNode addChild:coin30Btn];
        
        coinMaskDisplaySise = CGSizeMake((coin30Btn.position.x - disapearX)*2, coin30Btn.size.height);
        
        coinMask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:coinMaskDisplaySise];
        
        coinMask.anchorPoint = coin30Btn.anchorPoint;
        
        coinMask.position = coin30Btn.position;
        //        coinMask.position = CGPointMake(disapearX, coin10Btn.position.y);
        
        coinCropNode = [SKCropNode node];
        //        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size: CGSizeMake(1, 1)];
        
        [coinCropNode addChild:coin30Btn];
        
        coinCropNode.maskNode = coinMask;
        
        [self addChild:coinCropNode];
        
        coin50Btn = [SKSpriteNode spriteNodeWithImageNamed:@"coin_50_btn01"];
        coin50Btn.size = CGSizeMake(80, 80);
        coin50Btn.position = CGPointMake(coin30Btn.position.x + coin50Btn.size.width, labaHole.position.y);
        coin50BtnOraginPosition = coin50Btn.position;
//        [self addChild:coin50Btn];
//        [coinCropNode addChild:coin50Btn];
        
        coinMaskDisplaySise = CGSizeMake((coin50Btn.position.x - disapearX)*2, coin50Btn.size.height);
        
        coinMask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:coinMaskDisplaySise];
        
        coinMask.anchorPoint = coin50Btn.anchorPoint;
        
        coinMask.position = coin50Btn.position;
        //        coinMask.position = CGPointMake(disapearX, coin10Btn.position.y);
        
        coinCropNode = [SKCropNode node];
        //        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size: CGSizeMake(1, 1)];
        
        [coinCropNode addChild:coin50Btn];
        
        coinCropNode.maskNode = coinMask;
        
        [self addChild:coinCropNode];
        
        float h = labaStickNode.size.height/15.0f;
        float catW = labaStickNode.size.width;
        float catH = labaStickNode.size.height;
        
        labaStickApearPartHeight = labaStickNode.size.height/15.0*3;
        eachFrameheight= labaStickNode.size.height/15.0f;
        
        CGSize displaySise = CGSizeMake(catW, labaStickApearPartHeight);
        
        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:displaySise];
        
        mask.anchorPoint = labaStickNode.anchorPoint;
        
        mask.position = labaStickNode.position;
        
        labaStickCropNodeMaskY = labaStickNode.position.y;
        
        labaStickCropNode = [SKCropNode node];
        //        SKSpriteNode *mask = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size: CGSizeMake(1, 1)];
        
        [labaStickCropNode addChild:labaStickNode];
        
        labaStickCropNode.maskNode = mask;
        
        //        [node addChild:mask];
        
        [self addChild:labaStickCropNode];
        
        SKSpriteNode *mask2 = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:displaySise];
        mask2.anchorPoint = labaStickNode2.anchorPoint;
        mask2.position = labaStickNode2.position;
        
        labaStickCropNode2 = [SKCropNode node];[labaStickCropNode2 addChild:labaStickNode2];
        labaStickCropNode2.maskNode = mask2;
        [self addChild:labaStickCropNode2];
        
        SKSpriteNode *mask3 = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:displaySise];
        mask3.anchorPoint = labaStickNode3.anchorPoint;
        mask3.position = labaStickNode3.position;
        
        labaStickCropNode3 = [SKCropNode node];[labaStickCropNode3 addChild:labaStickNode3];
        labaStickCropNode3.maskNode = mask3;
        [self addChild:labaStickCropNode3];
        
        textViewMoneyLevel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        textViewMoneyLevel.fontSize = 15;
        textViewMoneyLevel.fontColor = UIColorFromRGB(0x77FFEE);
        textViewMoneyLevel.position = CGPointMake(stopBtn.position.x - stopBtn.size.width/3.0f, stopBtn.position.y+stopBtn.frame.size.height/2.0f);
        textViewMoneyLevel.text = @"等級：";
        [self addChild:textViewMoneyLevel];

        textViewCurrentMonryLevel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        textViewCurrentMonryLevel.fontSize = 15;
        textViewCurrentMonryLevel.fontColor = UIColorFromRGB(0xBBFF66);
        textViewCurrentMonryLevel.text = [NSString stringWithFormat:@"%d", currentMoneyLevel];
        textViewCurrentMonryLevel.position = CGPointMake(textViewMoneyLevel.position.x + textViewMoneyLevel.frame.size.width/2 + textViewCurrentMonryLevel.frame.size.width/2, textViewMoneyLevel.position.y);
        
        [self addChild:textViewCurrentMonryLevel];
        
        SKSpriteNode * money = [SKSpriteNode node];
        money.anchorPoint = CGPointMake(0, 0);
        [self addChild:money];
        
        textViewMoney = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        textViewMoney.fontSize = 15;
        textViewMoney.fontColor = UIColorFromRGB(0x77FFEE);
//        textViewMoney.position = CGPointMake(startBtn.position.x - startBtn.size.width/2.0f, startBtn.position.y+startBtn.frame.size.height/2.0f);
        textViewMoney.text = @"金幣：";
//        [self addChild:textViewMoney];
        money.position = CGPointMake(textViewCurrentMonryLevel.position.x + textViewCurrentMonryLevel.frame.size.width + textViewMoney.frame.size.width/2, startBtn.position.y+startBtn.frame.size.height/2.0f);
        [money addChild:textViewMoney];
        
        SKSpriteNode * currentMoneyNode = [SKSpriteNode node];
        currentMoneyNode.anchorPoint = CGPointMake(0, 0);
        [self addChild:currentMoneyNode];
        
        textViewCurrentMoney = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        textViewCurrentMoney.fontSize = 15;
        textViewCurrentMoney.fontColor = UIColorFromRGB(0xBBFF66);
        textViewCurrentMoney.text = [NSString stringWithFormat:@"%d", currentMoney];
//        textViewCurrentMoney.position = CGPointMake(money.position.x + money.frame.size.width + textViewMoney.frame.size.width/2.0f, textViewMoney.position.y);
        currentMoneyNode.position = CGPointMake(money.position.x + textViewMoney.frame.size.width/2 + textViewCurrentMoney.frame.size.width/2, money.position.y);
//        [self addChild:textViewCurrentMoney];
        [currentMoneyNode addChild:textViewCurrentMoney];
        
        [self initWinFrameAndLine];
        
        [self initClickTextureArrays];
        
        [self initFallWithCoins];
    }
    return self;
}

-(void)initClickTextureArrays{
    SKTexture * normalTexture, * pressedTexture;
    normalTexture = [SKTexture textureWithImageNamed:@"store1"];
    pressedTexture = [SKTexture textureWithImageNamed:@"store2"];
    storeBtnClickTextureArray = @[normalTexture, pressedTexture];
    normalTexture = [SKTexture textureWithImageNamed:@"coin_10_btn01"];
    pressedTexture = [SKTexture textureWithImageNamed:@"coin_10_btn02"];
    coin10BtnClickTextureArray = @[normalTexture, pressedTexture];
    normalTexture = [SKTexture textureWithImageNamed:@"coin_30_btn01"];
    pressedTexture = [SKTexture textureWithImageNamed:@"coin_30_btn02"];
    coin30BtnClickTextureArray = @[normalTexture, pressedTexture];
    normalTexture = [SKTexture textureWithImageNamed:@"coin_50_btn01"];
    pressedTexture = [SKTexture textureWithImageNamed:@"coin_50_btn02"];
    coin50BtnClickTextureArray = @[normalTexture, pressedTexture];
    normalTexture = [SKTexture textureWithImageNamed:@"stop_btn1"];
    pressedTexture = [SKTexture textureWithImageNamed:@"stop_btn2"];
    stopBtnClickTextureArray = @[normalTexture, pressedTexture];
    normalTexture = [SKTexture textureWithImageNamed:@"start_btn1"];
    pressedTexture = [SKTexture textureWithImageNamed:@"start_btn2"];
    startBtnClickTextureArray = @[normalTexture, pressedTexture];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (CGRectContainsPoint(coin10Btn.calculateAccumulatedFrame, location))
    {
//        SKAction * rotation = [SKAction repeatAction:[SKAction rotateByAngle:10 duration:2] count:1];
//        SKAction * move = [SKAction moveToX:labaHole.position.x - coin10Btn.size.width duration:2];
//        SKAction * end = [SKAction runBlock:^{
//            [self scoll];
//        }];
//        [coin10Btn runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], end]]];
//        
//        for(int i = 0; i<3; i++){
//            lineCount++;
//            //            if (lineCount == 1) {
//            //                mHandler.post(ScrollRunnable);
//            //            } else if (lineCount == 2) {
//            //                mHandler.post(ScrollRunnable2);
//            //            } else if (lineCount == 3) {
//            //                mHandler.post(ScrollRunnable3);
//            //            }
//        }
//        
//        position=-1;
//        position2=-1;
//        position3=-1;
//        isLabaSitckRun = true;
//        isCanPressStartBtn = false;
        
        if(!isAutoStop && isCanPressStartBtn){
            currentMoneyLevel = MONEY_COIN_10;
            textViewCurrentMonryLevel.text = [NSString stringWithFormat:@"%d", currentMoneyLevel];
        }
        
        coin10Btn.texture = coin10BtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        
    }else if(CGRectContainsPoint(coin30Btn.calculateAccumulatedFrame, location)){
//        SKAction * rotation = [SKAction repeatAction:[SKAction rotateByAngle:10 duration:2] count:2];
//        SKAction * move = [SKAction moveToX:0 duration:3];
//        [coin30Btn runAction:[SKAction group:@[rotation, move]]];
//        
//        [self scoll2];
//        for(int i = 0; i<3; i++){
//            lineCount++;
////            if (lineCount == 1) {
////                mHandler.post(ScrollRunnable);
////            } else if (lineCount == 2) {
////                mHandler.post(ScrollRunnable2);
////            } else if (lineCount == 3) {
////                mHandler.post(ScrollRunnable3);
////            }
//        }
//        
//        position=-1;
//        position2=-1;
//        position3=-1;
//        isCanPressStartBtn = false;
        
        if(!isAutoStop && isCanPressStartBtn){
            currentMoneyLevel = MONEY_COIN_30;
            textViewCurrentMonryLevel.text = [NSString stringWithFormat:@"%d", currentMoneyLevel];
        }
        
        coin30Btn.texture = coin30BtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        
    }else if(CGRectContainsPoint(coin50Btn.calculateAccumulatedFrame, location)){
//        SKAction * rotation = [SKAction repeatAction:[SKAction rotateByAngle:10 duration:2] count:2];
//        SKAction * move = [SKAction moveToX:0 duration:4];
//        [coin50Btn runAction:[SKAction group:@[rotation, move]]];
//        [self scoll3];
//        for(int i = 0; i<3; i++){
//            lineCount++;
//            //            if (lineCount == 1) {
//            //                mHandler.post(ScrollRunnable);
//            //            } else if (lineCount == 2) {
//            //                mHandler.post(ScrollRunnable2);
//            //            } else if (lineCount == 3) {
//            //                mHandler.post(ScrollRunnable3);
//            //            }
//        }
//        
//        position=-1;
//        position2=-1;
//        position3=-1;
//        isCanPressStartBtn = false;
        
        if(!isAutoStop && isCanPressStartBtn){
            currentMoneyLevel = MONEY_COIN_50;
            textViewCurrentMonryLevel.text = [NSString stringWithFormat:@"%d", currentMoneyLevel];
        }
        
        coin50Btn.texture = coin50BtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        
    }else if(CGRectContainsPoint(stopBtn.calculateAccumulatedFrame, location)){
        stopBtn.texture = stopBtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        isAutoStop = false;
        [self stop];
    }else if(CGRectContainsPoint(startBtn.calculateAccumulatedFrame, location)){
        startBtn.texture = startBtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        [self start];
    }else if(CGRectContainsPoint(myAdView.calculateAccumulatedFrame, location)){
        
        [myAdView doClick];
    }else if(CGRectContainsPoint(storeBtn.calculateAccumulatedFrame, location)){
        storeBtn.texture = storeBtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        [self displayBuyView];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    storeBtn.texture = storeBtnClickTextureArray[NORMAL_TEXTURE_INDEX];
    coin10Btn.texture = coin10BtnClickTextureArray[NORMAL_TEXTURE_INDEX];
    coin30Btn.texture = coin30BtnClickTextureArray[NORMAL_TEXTURE_INDEX];
    coin50Btn.texture = coin50BtnClickTextureArray[NORMAL_TEXTURE_INDEX];
    stopBtn.texture = stopBtnClickTextureArray[NORMAL_TEXTURE_INDEX];
    startBtn.texture = startBtnClickTextureArray[NORMAL_TEXTURE_INDEX];
}

-(void)initWinFrameAndLine{
    winFrameArray = [NSMutableArray array];
    for (int i = 0 ; i < 3; i++) {
        for (int j = 0 ; j < 3; j++) {
            SKSpriteNode * winFrameNode = [SKSpriteNode spriteNodeWithImageNamed:@"win_frame"];
            winFrameNode.size = CGSizeMake(labaStickNode.size.width, eachFrameheight);
            winFrameNode.anchorPoint = CGPointMake(0.5, 0.5);
            winFrameNode.position = CGPointMake(labaStickNode.position.x+labaStickNode.size.width/2.0f*(j*2+1), labaStickCropNodeMaskY - eachFrameheight/2.0f*(i*2+1));
            winFrameNode.hidden = true;
            [winFrameArray addObject:winFrameNode];
            [self addChild:winFrameNode];
        }
    }
    
    winLineArray = [NSMutableArray array];
    for(int i = 0 ; i < 3; i++){
        SKSpriteNode * winLineNode = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(labaStickNode.size.width*3, eachFrameheight/20.0f)];
        winLineNode.position = CGPointMake(labaStickNode2.position.x + labaStickNode2.size.width/2.0f, labaStickCropNodeMaskY - eachFrameheight*1.5f);
        
        if(i==WIN_MID_LINE){
            
        }else if(i==WIN_LT_RB_LINE){
            winLineNode.zRotation = -M_PI/4.0f;
        }else{
            winLineNode.zRotation = M_PI/4.0f;
        }
        winLineNode.hidden = true;
        [winLineArray addObject:winLineNode];
        [self addChild:winLineNode];
    }
}

-(void)hideWinFrameAndLine{
    for (int i = 0 ; i < 9; i++) {
        SKSpriteNode * winFrameNode = winFrameArray[i];
        winFrameNode.hidden = true;
    }
    
    for (int i = 0 ; i < 3; i++) {
        SKSpriteNode * winLineNode = winLineArray[i];
        winLineNode.hidden = true;
    }
}

int scrollCount2 = 0;

NSString * scollActionTag1 = @"01";
NSString * scollActionTag2 = @"02";
NSString * scollActionTag3 = @"03";

-(void)start{
    isLabaSitckRun = true;
    isLabaSitck2Run = true;
    isLabaSitck3Run = true;
    
    if(!isCanPressStartBtn)
        return;
    else
        isCanPressStartBtn = false;
    
    if((currentMoney - currentMoneyLevel) < 0){
        [self displayBuyView];
        isCanPressStartBtn = true;
        return;
    }
    
    if(!commonUtil.isPurchased && displayADCount>=displayADPerTimes){
        [self displayAD];
        isCanPressStartBtn = true;
        displayADCount=1;
        return;
    }
    
    displayADCount++;
    isFocusStopFallWithCoinsRun = true;
    [self focusStopFallWithCoinsRun];
    
    [self hideWinFrameAndLine];
    
    [self costMoneyWithCurrentMoneyLevel];
    
    SKAction * rotation = [SKAction repeatAction:[SKAction rotateByAngle:10 duration:1.5] count:1];
    SKAction * move = [SKAction moveToX:labaHole.position.x - coin10Btn.size.width duration:1.5];
    SKAction * end = [SKAction runBlock:^{
        
        [coin10Btn removeAllActions];
        [coin30Btn removeAllActions];
        [coin50Btn removeAllActions];
        coin10Btn.zRotation = 0;
        coin30Btn.zRotation = 0;
        coin50Btn.zRotation = 0;
        coin10Btn.position = coin10BtnOraginPosition;
        coin30Btn.position = coin30BtnOraginPosition;
        coin50Btn.position = coin50BtnOraginPosition;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for(int i = 0; i<3; i++){
                lineCount++;
                
                if (lineCount == 1) {
                    [self scoll];
                } else if (lineCount == 2) {
                    secondStopTimeMs = [self getDelayTimePerLabaStick];
                    usleep(secondStopTimeMs*1000);
                    [self scoll2];
                } else if (lineCount == 3) {
                    thirdStopTimeMs = [self getDelayTimePerLabaStick];
                    usleep(thirdStopTimeMs*1000);
                    [self scoll3];
                }
            }
            
            position=-1;
            position2=-1;
            position3=-1;
            isCanPressStartBtn = false;
            isCanPressStopBtn = true;
            
            position=-1;
            position2=-1;
            position3=-1;
            
            isCanPressStopBtn = true;
            
            //    if(timer!=null){
            //        timer.purge();
            //        timer.cancel();
            //    }
            [self doAutoStopLabaStick];
            
        });
        
    }];
    SKAction * coin30end = [SKAction runBlock:^{
        [self scoll2];
    }];
    SKAction * coin50end = [SKAction runBlock:^{
        [self scoll3];
    }];
    //    [coin50Btn runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], coin50end]]];
    
    if (currentMoneyLevel==10) {
        [coin10Btn runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], end]]];
    }else if(currentMoneyLevel == 30){
        [coin30Btn runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], end]]];
    }else{
        [coin50Btn runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], end]]];
    }
}

-(void)scoll{
//    int c = mlayout.getHeight();
    int a = labaStickApearPartHeight;
    int b = labaStickNode.size.height;
    int c = labaStickCropNodeMaskY;

    SKAction * wait;
    wait = [SKAction waitForDuration:0.06];
    
    SKAction * end2;
    end2 = [SKAction runBlock:^{
    if (a > 0 && isLabaSitckRun) { // 元件未載入之前為0，因此加此判斷式等元件先載入
//        labaStickNode.scrollBy(0, 30); // 往上移30
        labaStickNode.position = CGPointMake(labaStickNode.position.x
                                              , labaStickNode.position.y + 30);
        scrollCount++;
        
        int y = labaStickNode.position.y;
        
        if (labaStickNode.position.y >= (c + b - a)) { // 如果捲到底了
            //            labaStickNode.scrollBy(0, (0 - (a - b))); // 從頭開始
            
            labaStickNode.position = CGPointMake(labaStickNode.position.x
                                                  , c + (labaStickNode.position.y - (c+b-a)));
            
            // Thread.currentThread().interrupt();
            scrollCount=0;
            
        } else {
            
        }
    } else {

    }
    }];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[end2, wait]]] withKey:scollActionTag1];
}

-(void)scoll2{
    //    int c = mlayout.getHeight();
    int a = labaStickApearPartHeight;
    int b = labaStickNode.size.height;
    
    int c = labaStickCropNodeMaskY;
    
    SKAction * scoll;
    scoll = [SKAction moveByX:0 y:(0 - (a - b)) duration:0.1];
    SKAction * wait;
    wait = [SKAction waitForDuration:0.06];
    SKAction * end;
    end = [SKAction runBlock:^{
        [self scoll2];
    }];
    
    SKAction * move;
    move = [SKAction moveToY:(c + b - a)  duration:1];
    SKAction * end2;
    end2 = [SKAction runBlock:^{
//        [self scoll2];
        if (a > 0 && isLabaSitck2Run) { // 元件未載入之前為0，因此加此判斷式等元件先載入
            //        labaStickNode.scrollBy(0, 30); // 往上移30
            labaStickNode2.position = CGPointMake(labaStickNode2.position.x
                                                  , labaStickNode2.position.y + 30);
            scrollCount2++;
            
            int y = labaStickNode2.position.y;
            
            if (labaStickNode2.position.y >= (c + b - a)) { // 如果捲到底了
                //            labaStickNode.scrollBy(0, (0 - (a - b))); // 從頭開始
                
                labaStickNode2.position = CGPointMake(labaStickNode2.position.x
                                                      , c + (labaStickNode2.position.y - (c+b-a)));
                
                // Thread.currentThread().interrupt();
                scrollCount2=0;
                
            } else {

            }
        } else {

        }
    }];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[end2, wait]]] withKey:scollActionTag2];
    
//    if (a > 0) { // 元件未載入之前為0，因此加此判斷式等元件先載入
//        //        labaStickNode.scrollBy(0, 30); // 往上移30
//        labaStickNode2.position = CGPointMake(labaStickNode2.position.x
//                                             , labaStickNode2.position.y + 30);
//        scrollCount2++;
//        
//        int y = labaStickNode2.position.y;
//        
//        if (labaStickNode2.position.y >= (c + b - a)) { // 如果捲到底了
//            //            labaStickNode.scrollBy(0, (0 - (a - b))); // 從頭開始
//            
//            labaStickNode2.position = CGPointMake(labaStickNode2.position.x
//                                                 , c + (labaStickNode2.position.y - (c+b-a)));
//            
//            // Thread.currentThread().interrupt();
//            scrollCount2=0;
//            
//            //            mHandler.postDelayed(this, 100);
//            //            [labaStickNode runAction:scoll];
////            [self runAction:[SKAction sequence:@[wait, end]] withKey:scollActionTag2];
//            
//            [labaStickNode2 runAction:[SKAction sequence:@[move,end2]]];
//        } else {
//            //            mHandler.postDelayed(this, 100);
//            //            [labaStickNode runAction:scoll];
////            [self runAction:[SKAction sequence:@[wait, end]] withKey:scollActionTag2];
//            [labaStickNode2 runAction:[SKAction sequence:@[move,end2]]];
//        }
//    } else {
//        //        mHandler.postDelayed(this, 100);
//        //        [labaStickNode runAction:scoll];
////        [self runAction:[SKAction sequence:@[wait, end]] withKey:scollActionTag2];
//        [labaStickNode2 runAction:[SKAction sequence:@[move,end2]]];
//    }
}


-(void)scoll3{
    //    int c = mlayout.getHeight();
    int a = labaStickApearPartHeight;
    int b = labaStickNode.size.height;
    int c = labaStickCropNodeMaskY;
    
    SKAction * wait;
    wait = [SKAction waitForDuration:0.06];
    
    SKAction * end2;
    end2 = [SKAction runBlock:^{
        if (a > 0 && isLabaSitck3Run) { // 元件未載入之前為0，因此加此判斷式等元件先載入
            //        labaStickNode.scrollBy(0, 30); // 往上移30
            labaStickNode3.position = CGPointMake(labaStickNode3.position.x
                                                 , labaStickNode3.position.y + 30);
            scrollCount3++;
            
            int y = labaStickNode3.position.y;
            
            if (labaStickNode3.position.y >= (c + b - a)) { // 如果捲到底了
                //            labaStickNode.scrollBy(0, (0 - (a - b))); // 從頭開始
                
                labaStickNode3.position = CGPointMake(labaStickNode3.position.x
                                                     , c + (labaStickNode3.position.y - (c+b-a)));
                
                // Thread.currentThread().interrupt();
                scrollCount3=0;
                
            } else {
                
            }
        } else {
            
        }
    }];
    
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[end2, wait]]] withKey:scollActionTag3];
}


MyTimer * timer;

-(void)doAutoStopLabaStick{
    if(timer!=nil){
        [timer stop];
    }
    timer = [MyTimer initWithMyScene:self];
}

int lineCount = 0;
//bool isStopTheAutoStop = false;

-(void)stop{
    if(isCanPressStartBtn || !isCanPressStopBtn)
        return;
    
//    isStopTheAutoStop = true;
    [self doAutoStopLabaStick];
    
    if(lineCount==3){
        isLabaSitckRun = false;
        [self removeActionForKey:scollActionTag1];
//        position = round((float)scrollCount*30 / eachFrameheight);
        position = round((float)((labaStickNode.position.y - labaStickCropNodeMaskY)/eachFrameheight));
        labaStickNode.position = CGPointMake(labaStickNode.position.x, position*eachFrameheight+labaStickCropNodeMaskY);
    }else if(lineCount==2){
        isLabaSitck2Run = false;
        [self removeActionForKey:scollActionTag2];
//        position2 = round((float)scrollCount2*30 / eachFrameheight);
        position2 = round((float)((labaStickNode2.position.y - labaStickCropNodeMaskY)/eachFrameheight));
        labaStickNode2.position = CGPointMake(labaStickNode2.position.x, position2*eachFrameheight+labaStickCropNodeMaskY);
    }else if(lineCount==1){
        isLabaSitck3Run = false;
        [self removeActionForKey:scollActionTag3];
//        position = round((float)scrollCount2*30 / eachFrameheight);
        position3 = round((float)((labaStickNode3.position.y - labaStickCropNodeMaskY)/eachFrameheight));
        labaStickNode3.position = CGPointMake(labaStickNode3.position.x, position3*eachFrameheight+labaStickCropNodeMaskY);
    }
    lineCount--;
    
    if(position==-1 || position2==-1 || position3==-1){
        return;
    }
    
    if(TEST_LABA_PRIZE)
        [self test];
    
    bool big_win = false;
    bool iswin = false;
    int win_money = 0;
	
    if( !(position==position2&&position2==position3) && !(position-1==position2&&position2-1==position3)
       && !(position+1==position2&&position2+1==position3)
       && !(position==2&&position2==1)
       && !(position2==1&&position3==2)
       && !(position==1&&position2==2)
       && !(position2==2&&position3==1)){
        
        if(position==0 || position==1)
            position += 12;
        if(position2==0 || position2==1)
            position2 += 12;
        if(position3==0 || position3==1)
            position3 += 12;
    }
    
    if(position==position2&&position2==position3){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_LEFT_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_RIGHT_FRAME];
        winFrameNode.hidden = false;
        
        SKSpriteNode * winLineNode = winLineArray[WIN_MID_LINE];
        winLineNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy3Connect:position2 money:currentMoneyLevel];
        big_win = [RuleUtil isBigWin:position2];
        if(big_win){
//            AES aes = new AES("infinitegame");
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd!HH:mm:ss");
//            Date dt = new Date();
//            String dts=sdf.format(dt);
//            Log.e("date", dts);
//            encryptStr = aes.encrypt(dts);
//            Log.e("date encryptStr", encryptStr);
//            winDialog.show();
            self.onGameOver(10, 10);
            isAutoStop = false;
        }
        iswin = true;
    }else if(position-1==position2&&position2-1==position3){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_LT_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_RB_FRAME];
        winFrameNode.hidden = false;
        
        SKSpriteNode * winLineNode = winLineArray[WIN_LT_RB_LINE];
        winLineNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy3Connect:position2 money:currentMoneyLevel];
        big_win = [RuleUtil isBigWin:position2];
        if(big_win){
//            winDialog.show();
            self.onGameOver(10, 10);
            isAutoStop = false;
        }

        iswin = true;
    }else if(position+1==position2&&position2+1==position3){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_LB_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_RT_FRAME];
        winFrameNode.hidden = false;
        
        SKSpriteNode * winLineNode = winLineArray[WIN_LB_RT_LINE];
        winLineNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy3Connect:position2 money:currentMoneyLevel];
        big_win = [RuleUtil isBigWin:position2];
        if(big_win){
//            winDialog.show();
            self.onGameOver(10, 10);
            isAutoStop = false;
        }
        iswin = true;
    }else if((position==position2 && position2!=position3)){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_LEFT_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy2Connect:currentMoneyLevel];
        iswin = true;
    }else if((position2==position3 && position!=position2)){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_RIGHT_FRAME];
        winFrameNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy2Connect:currentMoneyLevel];
        iswin = true;
    }else if((position-1==position2 && position2-1!=position3)){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_LT_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy2Connect:currentMoneyLevel];
        iswin = true;
    }else if((position2-1==position3 && position-1!=position2)){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_RB_FRAME];
        winFrameNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy2Connect:currentMoneyLevel];
        iswin = true;
    }else if((position+1==position2 && position2+1!=position3)){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_LB_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy2Connect:currentMoneyLevel];
        iswin = true;
    }else if((position2+1==position3 && position+1!=position2)){
        SKSpriteNode * winFrameNode = winFrameArray[WIN_CENTER_FRAME];
        winFrameNode.hidden = false;
        winFrameNode = winFrameArray[WIN_RT_FRAME];
        winFrameNode.hidden = false;
        
        win_money = [RuleUtil getPrizeFactorBy2Connect:currentMoneyLevel];
        iswin = true;
    }
    
    currentMoney += win_money;
    textViewCurrentMoney.text = [NSString stringWithFormat:@"%d", currentMoney];
    
    [MyScene saveMoney];
    
    int delayTime = 0;
    if(iswin){
        delayTime = 3500;
        [self winWithFallCoins];
    }else{
        delayTime = 500;
    }
    
    if(isAutoStop && !big_win){
//        handler.postDelayed(new Runnable() {
//            
//            @Override
//            public void run() {
//                // TODO Auto-generated method stub
//                button.performClick();
//            }
//        } , delayTime);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [self start];
        });
    }
    
//    timer.purge();
//    timer.cancel();
    
    if(timer!=nil){
        [timer stop];
    }
    
    isCanPressStartBtn = true;
    isCanPressStopBtn = false;
}

-(void)loadMoney{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    currentMoney = [userDefaults integerForKey:moneyField];
    currentMoney = 2000;
}

+(void)saveMoney{
//    settings = context.getSharedPreferences(data,0);
//    settings.edit()
//    .putInt(moneyField, currentMoney)
//    .commit();
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:currentMoney forKey:moneyField];
    [userDefaults synchronize];
}

/*
private void doAutoStopLabaStick(){
    timer = new Timer();
    timer.schedule(new TimerTask() {
        
        @Override
        public void run() {
            // TODO Auto-generated method stub
            for(int i = 0; i<3; i++){
                
                if(i==0){
                    runOnUiThread(new Runnable() {
                        
                        @Override
                        public void run() {
                            
                            isAutoStop = true;
                            stopLabaStick();
                            
                        }
                    });
                }else if(i==1){
                    
                    try {
                        Thread.sleep(secondStopTimeMs);
                    } catch (InterruptedException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    
                    runOnUiThread(new Runnable() {
                        
                        @Override
                        public void run() {
                            
                            isAutoStop = true;
                            stopLabaStick();
                            
                        }
                    });
                }else if(i==2){
                    
                    try {
                        Thread.sleep(secondStopTimeMs);
                    } catch (InterruptedException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    
                    runOnUiThread(new Runnable() {
                        
                        @Override
                        public void run() {
                            
                            isAutoStop = true;
                            stopLabaStick();
                            
                        }
                    });
                    
                    timer.purge();
                    timer.cancel();
                }
            }
        }
    }, AUTO_STOP_TIME_MS);
}
*/
/*
-(void)stopLabaStick{
    if(isCanPressStartBtn || !isCanPressStopBtn)
        return;
    
    timer.purge();
    timer.cancel();
    
    doAutoStopLabaStick();
    
    if(lineCount==3){
        mHandler.removeCallbacks(ScrollRunnable);
        position = Math.round((float)scrollCount*(eachFrameheight/5) / eachFrameheight) ;
        
        sc.scrollBy(0, (int)(position*eachFrameheight-sc.getScrollY()));
    }else if(lineCount==2){
        mHandler.removeCallbacks(ScrollRunnable2);
        position2 = Math.round((float)scrollCount2*(eachFrameheight/5) / eachFrameheight) ;
        
        sc2.scrollBy(0, (int)(position2*eachFrameheight-sc2.getScrollY()));
    }else if(lineCount==1){
        mHandler.removeCallbacks(ScrollRunnable3);
        position3 = Math.round((float)scrollCount3*(eachFrameheight/5) / eachFrameheight) ;
        
        sc3.scrollBy(0, (int)(position3*eachFrameheight-sc3.getScrollY()));
        
    }
    lineCount--;
    
    if(position==-1 || position2==-1 || position3==-1){
        return;
    }
    
    if(TEST_LABA_PRIZE)
        test();
    
    boolean big_win = false;
    boolean iswin = false;
    int win_money = 0;
	
    if( !(position==position2&&position2==position3) && !(position-1==position2&&position2-1==position3)
       && !(position+1==position2&&position2+1==position3) ){
        
        if(position==0 || position==1)
            position += 12;
        if(position2==0 || position2==1)
            position2 += 12;
        if(position3==0 || position3==1)
            position3 += 12;
        
    }
    
    if(position==position2&&position2==position3){
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundColor(Color.RED);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(LayoutParams.MATCH_PARENT, 20);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winLineView = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView1 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView3 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy3Connect(position2, currentMoneyLevel);
        big_win = RuleUtil.isBigWin(position2);
        if(big_win){
            AES aes = new AES("infinitegame");
            //?��?定義?��??��?
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd!HH:mm:ss");
            //?��??�在?��?
            Date dt = new Date();
            //?��?SimpleDateFormat?�format?��?將Date轉為字串
            String dts=sdf.format(dt);
            Log.e("date", dts);
            encryptStr = aes.encrypt(dts);
            Log.e("date encryptStr", encryptStr);
            
            winDialog.show();
        }
        //			big_win = true;
        iswin = true;
    }else if(position-1==position2&&position2-1==position3){
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundColor(Color.RED);
        //			Matrix matrix = new Matrix();
        //			matrix.postRotate(45);
        //			imageView.setImageMatrix(matrix);
        //			imageView.setScaleType(ScaleType.MATRIX);
        imageView.setRotation(45);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(LayoutParams.MATCH_PARENT, 20);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winLineView = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView1 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView3 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy3Connect(position2, currentMoneyLevel);
        big_win = RuleUtil.isBigWin(position2);
        if(big_win)
            winDialog.show();
        //			big_win = true;
        iswin = true;
    }else if(position+1==position2&&position2+1==position3){
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundColor(Color.RED);
        
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(LayoutParams.MATCH_PARENT, 20);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        //			Matrix matrix = new Matrix();
        //			matrix.postRotate(45, 0, 0);
        //			imageView.setImageMatrix(matrix);
        imageView.setRotation(-45);
        //			imageView.setScaleType(ScaleType.MATRIX);
        laba_main_layout.addView(imageView);
        winLineView = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView1 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView3 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy3Connect(position2, currentMoneyLevel);
        big_win = RuleUtil.isBigWin(position2);
        if(big_win)
            winDialog.show();
        //			big_win = true;
        iswin = true;
    }else if((position==position2 && position2!=position3)){
        
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView1 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy2Connect(currentMoneyLevel);
        iswin = true;
    }else if((position2==position3 && position!=position2)){
        
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView3 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy2Connect(currentMoneyLevel);
        iswin = true;
    }else if((position-1==position2 && position2-1!=position3)){
        
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView1 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy2Connect(currentMoneyLevel);
        iswin = true;
    }else if((position2-1==position3 && position-1!=position2)){
        
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView3 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy2Connect(currentMoneyLevel);
        iswin = true;
    }else if((position+1==position2 && position2+1!=position3)){
        
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView1 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy2Connect(currentMoneyLevel);
        iswin = true;
    }else if((position2+1==position3 && position+1!=position2)){
        
        ImageView imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.CENTER_IN_PARENT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView2 = imageView;
        
        imageView = new ImageView(MainActivity.this);
        imageView.setBackgroundResource(R.drawable.win_frame);
        layoutParams = new RelativeLayout.LayoutParams(CommonUtil.labaStickWidth, CommonUtil.labaStickBlockHeight);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
        imageView.setLayoutParams(layoutParams);
        laba_main_layout.addView(imageView);
        winFrameView3 = imageView;
        
        win_money = RuleUtil.getPrizeFactorBy2Connect(currentMoneyLevel);
        iswin = true;
    }
    
    anim.start();
    //        checkIfAnimationDone(anim, imageView2);
    anim.setVisible(true, true);
    
    currentMoney += win_money;
    textViewCurrentMoney.setText(currentMoney+"");
    
    saveMoney(MainActivity.this);
    
    int delayTime = 0;
    if(iswin){
        delayTime = 3500;
        winWithFallCoins();
    }else{
        delayTime = 500;
    }
    
    if(isAutoStop && !big_win){
        handler.postDelayed(new Runnable() {
            
            @Override
            public void run() {
                // TODO Auto-generated method stub
                button.performClick();
            }
        } , delayTime);
    }
    
    timer.purge();
    timer.cancel();
    
    isCanPressStartBtn = true;
    isCanPressStopBtn = false;
    
}
*/
-(int) getDelayTimePerLabaStick{
//    Random * random = new Random();
    int speed = arc4random_uniform(DELAY_TIME_PER_LABA_STICK_MAX_MS - DELAY_TIME_PER_LABA_STICK_MIN_MS + 1) + DELAY_TIME_PER_LABA_STICK_MIN_MS;
    return speed;
}


//UIImageView * fallWithCoins[fallWithCoinsNumber];


-(void)initFallWithCoins{
    
    fallWithCoins = [NSMutableArray array];
    
    //fallWithCoins[0] = @"1";
    
    
    //NSArray *sfallWithCoins = [[NSArray alloc] ini
    
    int r = arc4random_uniform(10);
    //fallWithCoins[0] = [NSArray new];
    //int a = fallWithCoins[0].count;
    
    fallWithCoinsY = [[NSMutableArray alloc]initWithCapacity:fallWithCoinsNumber];
    
    for (int i = 0; i < fallWithCoinsNumber; i++) {
        SKSpriteNode * fallWithCoin = [SKSpriteNode spriteNodeWithTexture:nil];
        fallWithCoin.anchorPoint = CGPointMake(0.5, 0.5);
        if(i%3==0){
            fallWithCoin.texture = [SKTexture textureWithImageNamed:@"coin_50_btn01"];
            //				x = CommonUtil.screenWidth/6/2*(i%6)+(i/6%2);
        }else if(i%3==1){
            fallWithCoin.texture = [SKTexture textureWithImageNamed:@"coin_30_btn01"];
            //				x = CommonUtil.screenWidth/6/2*(i%6+1)+(i/6%2);
        }else{
            fallWithCoin.texture = [SKTexture textureWithImageNamed:@"coin_10_btn01"];
            //				x = CommonUtil.screenWidth/6/2*(i%6+2)+(i/6%2);
        }
        
        fallWithCoin.size = CGSizeMake(self.frame.size.width/6, self.frame.size.width/6);
        //			fallWithCoin.getLayoutParams().height = CommonUtil.screenWidth/6;
        //			fallWithCoin.getLayoutParams().width = CommonUtil.screenWidth/6;
        
        //			if(CommonUtil.screenWidth/6*(i*2+1) > CommonUtil.screenWidth-CommonUtil.screenWidth/6){
        //				x = CommonUtil.screenWidth/6*(i*2+1)/(CommonUtil.screenWidth/6);
        //				x = (x%6)*CommonUtil.screenWidth/6;
        //			}else{
        //				x = CommonUtil.screenWidth/6*(i+1);
        //			}
        fallWithCoin.position = CGPointMake(arc4random_uniform(self.frame.size.width-self.frame.size.width/6)+fallWithCoin.size.width/2, self.frame.size.width/6.0f/2.0f*(i+2) + self.frame.size.height);
        
        fallWithCoinsY[i] = [NSNumber numberWithFloat:fallWithCoin.position.y];
        
        //			fallWithCoin.setY(-CommonUtil.screenWidth/6.0f/2.0f*(i+2));
//        fallWithCoin.setY(-CommonUtil.screenWidth/6.0f/2.0f*(i+2));
        //			fallWithCoin.setVisibility(View.INVISIBLE);
        
        CGSize coinMaskDisplaySise = CGSizeMake(fallWithCoin.size.width, self.size.height/2 + (fallWithCoin.position.y-self.size.height));
        
        SKSpriteNode *coinMask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:coinMaskDisplaySise];
        
        coinMask.anchorPoint = CGPointMake(0.5, 1.0);
        
        coinMask.position = fallWithCoin.position;
        
        SKCropNode * coinCropNode = [SKCropNode node];
        
        [coinCropNode addChild:fallWithCoin];
        
        coinCropNode.maskNode = coinMask;
        
        [self addChild:coinCropNode];
        
        fallWithCoins[i] = fallWithCoin;
//        [self addChild:coinCropNode];
    }
    
}

-(void) winWithFallCoins{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            bool isfallWithCoinsRun = true;
            isFocusStopFallWithCoinsRun = false;
            
//            alldistanceXForPerMove = 0;
        
        const int coinFallDisapearY = self.frame.size.height/2;
        
        float distanceYWithCoinWithFormScreenTop = self.frame.size.height/2;
        const float distanceYForPerMove = -distanceYWithCoinWithFormScreenTop / 20.0f;
        
        isfallWithCoinsRun = false;
        
//            fallWithCoinsY = [[NSMutableArray alloc]initWithCapacity:fallWithCoins.count];
        
        [self runAction:[SKAction playSoundFileNamed:@"money.wav" waitForCompletion:NO] withKey:@"fallCoinSound"];
        
            for(int j=0;j<fallWithCoins.count;j++){
                float coin1Y = ((SKSpriteNode*)fallWithCoins[j]).position.y;
                const float coinY = coin1Y;
//                fallWithCoinsY[j] = [NSNumber numberWithFloat:coinY];
                
                SKAction * rotation = [SKAction repeatAction:[SKAction rotateByAngle:10 duration:2.5] count:3];
                SKAction * move = [SKAction repeatAction:[SKAction moveByX:0 y:distanceYForPerMove*3 duration:0.22] count:32];
                SKAction * end = [SKAction runBlock:^{
                    
                    SKSpriteNode * selectCoinImageView = fallWithCoins[j];
                    selectCoinImageView.hidden = true;
                    isFocusStopFallWithCoinsRun = false;
                    
                    selectCoinImageView.position = CGPointMake(selectCoinImageView.position.x, [fallWithCoinsY[j]  floatValue]);
                    
                }];
                
                [fallWithCoins[j] runAction:[SKAction sequence:@[[SKAction group:@[rotation, move]], end]]];
            }
        
        if(isfallWithCoinsRun && !isFocusStopFallWithCoinsRun){
            
        }
        
    });
}

-(void)focusStopFallWithCoinsRun{
    
    [self removeActionForKey:@"fallCoinSound"];
    
    for(int j=0;j<fallWithCoins.count;j++){
        SKAction * end = [SKAction runBlock:^{
            SKSpriteNode * selectCoinImageView = fallWithCoins[j];
            selectCoinImageView.hidden = false;
            isFocusStopFallWithCoinsRun = false;
            selectCoinImageView.position = CGPointMake(selectCoinImageView.position.x, [fallWithCoinsY[j]  floatValue]);
            
        }];
        
        [fallWithCoins[j] removeAllActions];
        [fallWithCoins[j] runAction:end];
    }
}

-(void)costMoneyWithCurrentMoneyLevel{
    currentMoney -= currentMoneyLevel;
    textViewCurrentMoney.text = [NSString stringWithFormat:@"%d", currentMoney];
    
    [MyScene saveMoney];
}

-(void)addMoney:(int)money{
    currentMoney += money;
    textViewCurrentMoney.text = [NSString stringWithFormat:@"%d", currentMoney];
    
    [MyScene saveMoney];
}

-(void)displayAD{
    self.showAdmob();
}

-(void)displayBuyView{
    self.showBuyViewController();
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //    if(!isGameRun)
    //        return;
    
    /* Called before each frame is rendered */
    // 获取时间增量
    // 如果我们运行的每秒帧数低于60，我们依然希望一切和每秒60帧移动的位移相同
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // 如果上次更新后得时间增量大于1秒
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    
    if (self.lastSpawnTimeInterval > 0.5) {
        self.lastSpawnTimeInterval = 0;
        
        ccount++;
        
        if(ccount==10)    {
            
            
            int continueAttackCounter = 0;
            
            int r = arc4random_uniform(40);
            
            
        }
        
    }else if(self.lastSpawnTimeInterval > 0.3){
        
    }
    
    
}

    
-(void)test{
    position = 0;
    position2 = 11;
    position3 = 10;
    
//    sc.scrollBy(0, (int)(position*eachFrameheight-sc.getScrollY()));
//    sc2.scrollBy(0, (int)(position2*eachFrameheight-sc2.getScrollY()));
//    sc3.scrollBy(0, (int)(position3*eachFrameheight-sc3.getScrollY()));
    
    labaStickNode.position = CGPointMake(labaStickNode.position.x, position*eachFrameheight+labaStickCropNodeMaskY);
    labaStickNode2.position = CGPointMake(labaStickNode2.position.x, position2*eachFrameheight+labaStickCropNodeMaskY);
    labaStickNode3.position = CGPointMake(labaStickNode3.position.x, position3*eachFrameheight+labaStickCropNodeMaskY);
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch * touch = [touches anyObject];
//    CGPoint location = [touch locationInNode:self];
//    
//    if (CGRectContainsPoint(continueBtn.calculateAccumulatedFrame, location))
//    {
//        [self.view presentScene:self.periousScene];
//    }
//}

@end
