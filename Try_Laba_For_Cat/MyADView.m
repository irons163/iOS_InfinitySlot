//
//  MyADView.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/12.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MyADView.h"

@implementation MyADView{
//    SKTexture * ad1, * ad2, *ad3;
    NSArray* ads, *adsUrl;
    int adIndex;
    NSTimer * timer;
//    SKSpriteNode* button;
}

//+(instancetype)spriteNodeWithTexture:(SKTexture *)texture{
//    
//}

-(void)startAd{
    
    NSString* catAdImageName;
    int randomCatAd = arc4random_uniform(2);
    if(randomCatAd==0){
        catAdImageName = @"unlimited_cat_world_ad";
    }else{
        catAdImageName = @"UnlimitedCatWorld_ad";
    }
    
    ads = [NSArray arrayWithObjects:[SKTexture textureWithImageNamed:@"ad1.jpg"],
           [SKTexture textureWithImageNamed:@"en_attack_on_gaint_cat_ad.jpg"],
           [SKTexture textureWithImageNamed:@"2048_ad"],
           [SKTexture textureWithImageNamed:@"Shoot_Learning_ad"],
           [SKTexture textureWithImageNamed:@"cute_dudge_ad"],
           [SKTexture textureWithImageNamed:catAdImageName],
           [SKTexture textureWithImageNamed:@"crazy_split_ad"],
           [SKTexture textureWithImageNamed:@"HappyDownStages_AD"],nil];
    
    adsUrl = [NSArray arrayWithObjects:@"http://itunes.apple.com/us/app/good-sleeper-counting-sheep/id998186214?l=zh&ls=1&mt=8", @"http://itunes.apple.com/us/app/attack-on-giant-cat/id1000152033?l=zh&ls=1&mt=8", @"https://itunes.apple.com/us/app/2048-chinese-zodiac/id1024333772?l=zh&ls=1&mt=8",@"https://itunes.apple.com/us/app/shoot-learning-math/id1025414483?l=zh&ls=1&mt=8",@"https://itunes.apple.com/us/app/cute-dodge/id1018590182?l=zh&ls=1&mt=8",@"https://itunes.apple.com/us/app/unlimited-cat-world/id1000573724?l=zh&ls=1&mt=8",@"https://itunes.apple.com/us/app/crazy-split/id1038958249?l=zh&ls=1&mt=8",@"https://itunes.apple.com/us/app/adventure-happy-down-stages/id1035092790?l=zh&ls=1&mt=8", nil];
    
    adIndex = 0;
    self.texture = ads[adIndex];
    
    timer =  [NSTimer scheduledTimerWithTimeInterval:2.0
                                                        target:self
                                                      selector:@selector(changeAd)
                                                      userInfo:nil
                                                       repeats:YES];
    
}

-(void)changeAd{
//    if(adIndex==1){
//        self.texture = ad2;
//        adIndex = 2;
//    }else if(adIndex==2){
//        self.texture = ad3;
//        adIndex = 3;
//    }else if(adIndex==3){
//        self.texture = ad1;
//        adIndex = 1;
//    }

    adIndex++;
    if(adIndex < ads.count){
        self.texture = ads[adIndex];
    }else{
        adIndex = 0;
        self.texture = ads[adIndex];
    }
}

-(void)doClick{
//    if(adIndex==1){
//        [];
//    }else if(adIndex==2){
//        
//    }else if(adIndex==3){
//        
//    }
    
    NSString* url = adsUrl[adIndex];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.hidden)
        return;
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if(location.y < self.size.height){
        [self doClick];
    }
}

-(void)close{
    if(timer){
        [timer invalidate];
        timer = nil;
    }
}


//-(void)init{
//    MyADView ad = [MyADView spriteNodeWithColor:[UIColor redColor] size:{10,10}];
//    
//    [ad childFunction];
//}
//
//+ (id)spriteNodeWithColor:(UIColor*)color size:(CGSize)size {
//    return [[SKSpriteNode init] autorelease];
//}

@end
