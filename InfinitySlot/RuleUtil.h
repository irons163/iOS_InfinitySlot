//
//  RuleUtil.h
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/15.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuleUtil : NSObject

+(int)getPrizeFactorBy3Connect:(int)winPosition money:(int)currentMoneyLevel;
+(int) getPrizeFactorBy3Connect:(int) winPosition;
+(int) getPrizeFactorBy2Connect:(int) currentMoneyLevel;
+(int) getPrizeFactorBy2Connect;
+(bool)isBigWin:(int) winPosition;
@end
