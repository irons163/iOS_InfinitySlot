//
//  CommondUtil.h
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/15.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

@property (atomic, assign) int screenWidth;
@property (atomic, assign) int screenHeight;
@property (atomic, assign) int statusBarHeight;
@property (atomic, assign) int adBarHeight;
@property (atomic, assign) int labaStickWidth;
@property (atomic, assign) int labaStickHeight;
@property (atomic, assign) int labaStickBlockHeight;
@property (atomic, assign) int labaViewMarginWidth;
@property (atomic, assign) int labaViewWidth;
@property (atomic, assign) int labaViewHeight;
@property (atomic, assign) int labaOffsetX;
@property (atomic, assign) bool isPurchased;
@property (atomic, assign) bool isBillDebug;

+ (id)sharedInstance;

@end
