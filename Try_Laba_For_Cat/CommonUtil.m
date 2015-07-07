//
//  CommondUtil.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/15.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "CommonUtil.h"
#import "Reachability.h"

static CommonUtil* instance;

@implementation CommonUtil

- (id)init {
    if (self=[super init]) {
//        self.screenWidth;
//        int screenHeight;
//        int statusBarHeight;
//        int adBarHeight;
//        int labaStickWidth;
//        int labaStickHeight;
//        int labaStickBlockHeight;
//        int labaViewMarginWidth;
//        int labaViewWidth;
//        int labaViewHeight;
//        int labaOffsetX;
        self.isPurchased = false;
        self.isBillDebug = true;
    }
    return self;
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

//+(int) getStatusBarHeight{
//    int result = 0;
//    int resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android");
//    if(resourceId > 0){
//        result = activity.getResources().getDimensionPixelSize(resourceId);
//    }
//    return result;
//}

+(bool) isConnected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        return false;
    }else{
        return true;
    }

}

@end
