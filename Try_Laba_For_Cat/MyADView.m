//
//  MyADView.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/12.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MyADView.h"

@implementation MyADView{
    SKTexture * ad1, * ad2, *ad3;
    int adIndex;
}

//+(instancetype)spriteNodeWithTexture:(SKTexture *)texture{
//    
//}

-(void)startAd{
    ad1 = [SKTexture textureWithImageNamed:@"ad1.jpg"];
    ad2 = [SKTexture textureWithImageNamed:@"ad2.jpg"];
    ad3 = [SKTexture textureWithImageNamed:@"ad3.jpg"];
    
    self.texture = ad1;
    adIndex = 1;
    
    NSTimer * timer =  [NSTimer scheduledTimerWithTimeInterval:2.0
                                                        target:self
                                                      selector:@selector(changeAd)
                                                      userInfo:nil
                                                       repeats:YES];
    
}

-(void)changeAd{
    if(adIndex==1){
        self.texture = ad2;
        adIndex = 2;
    }else if(adIndex==2){
        self.texture = ad3;
        adIndex = 3;
    }else if(adIndex==3){
        self.texture = ad1;
        adIndex = 1;
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
