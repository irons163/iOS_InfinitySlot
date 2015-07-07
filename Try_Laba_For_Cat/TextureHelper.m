//
//  TextureHelper.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/3/23.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "TextureHelper.h"

static NSArray * hand1Textures,  * hand2Textures, * hand3Textures;
static NSArray * cat1Textures,  * cat2Textures, * cat3Textures, * cat4Textures, * cat5Textures;
static SKTexture * hamster_injure;
static SKTexture * bg01, *bg02, *bg03, *bg04, *bg05, *bg06, *bg07, *bg08, *bg09, *bg10, *bg11,*bg12,*bg13,*bg14,*bg15;
static NSArray * bgs;
static SKTexture * time01, *time02, *time03, *time04, *time05, *time06, *time07, *time08, *time09, *time00, *timeQ;
static NSArray * timeScores, * timeScoresImages;

@implementation TextureHelper

//@synthesize hand2Textures;

SKTexture *temp;
//KVC key-value coding

- (void)setHand2Textures:(NSArray *)hand2Textures {
    
}

+ (NSArray *)hand3Textures {
    return hand3Textures;
}

+ (NSArray *)hand2Textures {
    return hand2Textures;
}

+ (NSArray *)hand1Textures {
    return hand1Textures;
}

+(NSArray *)cat1Textures{
    return cat1Textures;
}

+(NSArray *)cat2Textures{
    return cat2Textures;
}

+(NSArray *)cat3Textures{
    return cat3Textures;
}

+(NSArray *)cat4Textures{
    return cat4Textures;
}

+(NSArray *)cat5Textures{
    return cat5Textures;
}

+(NSArray *)bgTextures{
    return bgs;
}

+(SKTexture *)hamsterInjureTexture{
    return hamster_injure;
}

+(NSArray *)timeTextures{
    return timeScores;
}

+(NSArray *)timeImages{
    return timeScoresImages;
}

+(id) getTexturesWithSpriteSheetNamed: (NSString *) spriteSheet withinNode: (SKSpriteNode *) scene sourceRect: (CGRect) source andRowNumberOfSprites: (int) rowNumberOfSprites andColNumberOfSprites: (int) colNumberOfSprites{
    
    // @param numberOfSprites - the number of sprite images to the left
    // @param scene - I add my sprite to a map node. Change it to a SKScene
    // if [self addChild:] is used.
    
    NSMutableArray *mAnimatingFrames = [NSMutableArray array];
    
        SKTexture  *ssTexture = [SKTexture textureWithImageNamed:spriteSheet];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"hand1"
//                                                     ofType:@"png"];
//    UIImage *myImage = [UIImage imageWithContentsOfFile:path];
    
//    SKTexture  *ssTexture = [SKTexture textureWithImage:myImage];
    
    // Makes the sprite (ssTexture) stay pixelated:
    ssTexture.filteringMode = SKTextureFilteringNearest;
    
    float sx = source.origin.x;
    float sy = source.origin.y;
    float sWidth = source.size.width;
    float sHeight = source.size.height;
    
    // IMPORTANT: textureWithRect: uses 1 as 100% of the sprite.
    // This is why division from the original sprite is necessary.
    // Also why sx is incremented by a fraction.
    
    for (int i = 0; i < rowNumberOfSprites*colNumberOfSprites; i++) {
        CGRect cutter = CGRectMake(sx, sy, sWidth/ssTexture.size.width, sHeight/ssTexture.size.height);
        temp = [SKTexture textureWithRect:cutter inTexture:ssTexture];
        [mAnimatingFrames addObject:temp];
        
//        if(i < colNumberOfSprites){
            sx+=sWidth/ssTexture.size.width;
//        }else{
        if ((i+1)%colNumberOfSprites == 0) {
            sx=source.origin.x;
            sy+=sHeight/ssTexture.size.height;
        }
        
    }
    
//    self = [Monster spriteNodeWithTexture:mAnimatingFrames[0]];
    
//    animatingFrames = mAnimatingFrames;
    
//    [scene addChild:self];
    
    return mAnimatingFrames;
}

+(id) getTexturesWithSpriteSheetNamed: (NSString *) spriteSheet withinNode: (SKSpriteNode *) scene sourceRect: (CGRect) source andRowNumberOfSprites: (int) rowNumberOfSprites andColNumberOfSprites: (int) colNumberOfSprites sequence: (NSArray*) positions{
    
    // @param numberOfSprites - the number of sprite images to the left
    // @param scene - I add my sprite to a map node. Change it to a SKScene
    // if [self addChild:] is used.
    
    NSMutableArray *mAnimatingFrames = [NSMutableArray array];
    
//    SKTexture  *ssTexture = [SKTexture textureWithImageNamed:spriteSheet];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:spriteSheet
                                                     ofType:@"png"];
    UIImage *myImage = [UIImage imageWithContentsOfFile:path];
    
    SKTexture  *ssTexture = [SKTexture textureWithImage:myImage];
    
    // Makes the sprite (ssTexture) stay pixelated:
    ssTexture.filteringMode = SKTextureFilteringNearest;
    
    float sx = source.origin.x;
    float sy = source.origin.y;
    float sWidth = source.size.width;
    float sHeight = source.size.height;
    
    // IMPORTANT: textureWithRect: uses 1 as 100% of the sprite.
    // This is why division from the original sprite is necessary.
    // Also why sx is incremented by a fraction.
    
    for (int i = 0; i < rowNumberOfSprites*colNumberOfSprites; i++) {
        CGRect cutter = CGRectMake(sx, sy, sWidth/ssTexture.size.width, sHeight/ssTexture.size.height);
        SKTexture *temp = [SKTexture textureWithRect:cutter inTexture:ssTexture];
        [mAnimatingFrames addObject:temp];
        
        //        if(i < colNumberOfSprites){
        sx+=sWidth/ssTexture.size.width;
        //        }else{
        if ((i+1)%colNumberOfSprites == 0) {
            sx=source.origin.x;
            sy+=sHeight/ssTexture.size.height;
        }
        
    }
    
    //    self = [Monster spriteNodeWithTexture:mAnimatingFrames[0]];
    
    //    animatingFrames = mAnimatingFrames;
    
    //    [scene addChild:self];
    
    NSMutableArray * array = [NSMutableArray array];
    
    for (int i = 0; i < positions.count; i++) {
        int sequencePosition = [positions[i] intValue];
        [array addObject: mAnimatingFrames[sequencePosition]];
    }
    
    return array;
}

+(void) initHandTexturesSourceRect: (CGRect) source andRowNumberOfSprites: (int) rowNumberOfSprites andColNumberOfSprites: (int) colNumberOfSprites{
    hand1Textures = [self getTexturesWithSpriteSheetNamed:@"hand1" withinNode:nil sourceRect:source andRowNumberOfSprites:rowNumberOfSprites andColNumberOfSprites:colNumberOfSprites];
    hand2Textures = [self getTexturesWithSpriteSheetNamed:@"hand2" withinNode:nil sourceRect:source andRowNumberOfSprites:rowNumberOfSprites andColNumberOfSprites:colNumberOfSprites];
    hand3Textures = [self getTexturesWithSpriteSheetNamed:@"hand3" withinNode:nil sourceRect:source andRowNumberOfSprites:rowNumberOfSprites andColNumberOfSprites:colNumberOfSprites];
}

+(void) initCatTextures{
    cat1Textures = @[[SKTexture textureWithImageNamed:@"cat01_1"], [SKTexture textureWithImageNamed:@"cat01_2"], [SKTexture textureWithImageNamed:@"cat01_3"], [SKTexture textureWithImageNamed:@"cat01_4"]];
    cat2Textures = @[[SKTexture textureWithImageNamed:@"cat02_1"], [SKTexture textureWithImageNamed:@"cat02_2"], [SKTexture textureWithImageNamed:@"cat02_3"], [SKTexture textureWithImageNamed:@"cat02_4"]];
    cat3Textures = @[[SKTexture textureWithImageNamed:@"cat03_1"], [SKTexture textureWithImageNamed:@"cat03_2"], [SKTexture textureWithImageNamed:@"cat03_3"], [SKTexture textureWithImageNamed:@"cat03_4"]];
    cat4Textures = @[[SKTexture textureWithImageNamed:@"cat04_1"], [SKTexture textureWithImageNamed:@"cat04_2"], [SKTexture textureWithImageNamed:@"cat04_3"], [SKTexture textureWithImageNamed:@"cat04_4"]];
    cat5Textures = @[[SKTexture textureWithImageNamed:@"cat05_1"], [SKTexture textureWithImageNamed:@"cat05_2"], [SKTexture textureWithImageNamed:@"cat05_3"], [SKTexture textureWithImageNamed:@"cat05_4"]];
}

+(void) initTextures{
    
    hamster_injure = [SKTexture textureWithImageNamed:@"hamster_injure"];
    
    time01  = [SKTexture textureWithImageNamed:@"s1"];
    time02  = [SKTexture textureWithImageNamed:@"s2"];
    time03  = [SKTexture textureWithImageNamed:@"s3"];
    time04  = [SKTexture textureWithImageNamed:@"s4"];
    time05  = [SKTexture textureWithImageNamed:@"s5"];
    time06  = [SKTexture textureWithImageNamed:@"s6"];
    time07  = [SKTexture textureWithImageNamed:@"s7"];
    time08  = [SKTexture textureWithImageNamed:@"s8"];
    time09  = [SKTexture textureWithImageNamed:@"s9"];
    time00  = [SKTexture textureWithImageNamed:@"s0"];
    timeQ  = [SKTexture textureWithImageNamed:@"dot"];
    
    timeScores = @[time00, time01, time02, time03, time04, time05,time06, time07, time08, time09, timeQ];
    
    UIImage * image01 = [UIImage imageNamed:@"s1"];
    UIImage * image02 = [UIImage imageNamed:@"s2"];
    UIImage * image03 = [UIImage imageNamed:@"s3"];
    UIImage * image04 = [UIImage imageNamed:@"s4"];
    UIImage * image05 = [UIImage imageNamed:@"s5"];
    UIImage * image06 = [UIImage imageNamed:@"s6"];
    UIImage * image07 = [UIImage imageNamed:@"s7"];
    UIImage * image08 = [UIImage imageNamed:@"s8"];
    UIImage * image09 = [UIImage imageNamed:@"s9"];
    UIImage * image00 = [UIImage imageNamed:@"s0"];
    UIImage * imageQ = [UIImage imageNamed:@"dot"];
    timeScoresImages = @[image00, image01, image02, image03, image04, image05, image06, image07, image08, image09, imageQ];
    
    bg01 = [SKTexture textureWithImageNamed:@"bg01.jpg"];
    bg02 = [SKTexture textureWithImageNamed:@"bg02.jpg"];
    bg03 = [SKTexture textureWithImageNamed:@"bg03.jpg"];
    bg04 = [SKTexture textureWithImageNamed:@"bg04.jpg"];
    bg05 = [SKTexture textureWithImageNamed:@"bg05.jpg"];
    bg06 = [SKTexture textureWithImageNamed:@"bg06.jpg"];
    bg07 = [SKTexture textureWithImageNamed:@"bg07.jpg"];
    bg08 = [SKTexture textureWithImageNamed:@"bg08.jpg"];
    bg09 = [SKTexture textureWithImageNamed:@"bg09.jpg"];
    bg10 = [SKTexture textureWithImageNamed:@"bg10.jpg"];
    bg11 = [SKTexture textureWithImageNamed:@"bg11.jpg"];
    bg12 = [SKTexture textureWithImageNamed:@"bg12.jpg"];
    bg13 = [SKTexture textureWithImageNamed:@"bg13.jpg"];
    bg14 = [SKTexture textureWithImageNamed:@"bg14.jpg"];
    bg15 = [SKTexture textureWithImageNamed:@"bg15.jpg"];
    
    bgs = @[bg01, bg02, bg03 ,bg04, bg05, bg06,bg07, bg08, bg09, bg10, bg11, bg12, bg13, bg14, bg15];
}

@end
