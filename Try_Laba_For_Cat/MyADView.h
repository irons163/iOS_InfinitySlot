//
//  MyADView.h
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/12.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyADView : SKSpriteNode

+(MyADView *) createMyADView;

-(void)startAd;

-(void)changeAd;

-(void)doClick;

@end

/*
@interface MyAdView : NSObject {
    SKSpriteNode *node;
}

@end

@implementation MyADView

- (id)init {
    node = [SKSpriteNode new];
    /// edit default
}

- (void)doSomething {
    
}

- (void)runAction {
    [node runAction];
}

@end
*/