//
//  RuleUtil.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/15.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "RuleUtil.h"

@implementation RuleUtil
int PRIZE_FACTOR_1th = 200;
int PRIZE_FACTOR_2th = 100;
int PRIZE_FACTOR_3th = 50;
int PRIZE_FACTOR_4th = 30;
int PRIZE_FACTOR_5th = 20;
int PRIZE_FACTOR_6th = 15;
int PRIZE_FACTOR_7th = 13;
int PRIZE_FACTOR_8th = 11;
int PRIZE_FACTOR_9th = 10;
int PRIZE_FACTOR_10th = 8;
int PRIZE_FACTOR_11th = 5;
int PRIZE_FACTOR_12th = 2;
int PRIZE_FACTOR_13th = 1;

const int RatPosition = 14;
const int OxPosition = 0;
const int TigerPosition = 1;
const int RabbitPosition = 2;
const int DragonPosition = 3;
const int SnakePosition = 4;
const int HorsePosition = 5;
const int GoatPosition = 6;
const int MonkeyPosition = 7;
const int RoosterPosition = 8;
const int DogPosition = 9;
const int PigPosition = 10;
const int RatPosition2 = 11;
const int OxPosition2 = 12;
const int TigerPosition2 = 13;

+(int)getPrizeFactorBy3Connect:(int)winPosition money:(int)currentMoneyLevel{
    int prizeFactor = [self getPrizeFactorBy3Connect:winPosition];
    int winMoney = prizeFactor * currentMoneyLevel;
    return winMoney;
}

+(int) getPrizeFactorBy3Connect:(int) winPosition{
    
    int prizeFactor = 0;
    
    switch (winPosition) {
		case RatPosition:
			prizeFactor = PRIZE_FACTOR_12th;
			break;
		case OxPosition:
			prizeFactor = PRIZE_FACTOR_5th;
			break;
		case TigerPosition:
			prizeFactor = PRIZE_FACTOR_3th;
			break;
		case RabbitPosition:
			prizeFactor = PRIZE_FACTOR_9th;
			break;
		case DragonPosition:
			prizeFactor = PRIZE_FACTOR_2th;
			break;
		case SnakePosition:
			prizeFactor = PRIZE_FACTOR_4th;
			break;
		case HorsePosition:
			prizeFactor = PRIZE_FACTOR_10th;
			break;
		case GoatPosition:
			prizeFactor = PRIZE_FACTOR_1th;
			break;
		case MonkeyPosition:
			prizeFactor = PRIZE_FACTOR_11th;
			break;
		case RoosterPosition:
			prizeFactor = PRIZE_FACTOR_6th;
			break;
		case DogPosition:
			prizeFactor = PRIZE_FACTOR_7th;
			break;
		case PigPosition:
			prizeFactor = PRIZE_FACTOR_8th;
			break;
		case RatPosition2:
			prizeFactor = PRIZE_FACTOR_12th;
			break;
		case OxPosition2:
			prizeFactor = PRIZE_FACTOR_5th;
			break;
		case TigerPosition2:
			prizeFactor = PRIZE_FACTOR_3th;
			break;
    }
    
    return prizeFactor;
}

+(int) getPrizeFactorBy2Connect:(int) currentMoneyLevel{
    int prizeFactor = [self getPrizeFactorBy2Connect];
    int winMoney = prizeFactor * currentMoneyLevel;
    return winMoney;
}

+(int) getPrizeFactorBy2Connect{
    return PRIZE_FACTOR_13th;
}

+(bool)isBigWin:(int) winPosition{
    if(winPosition == GoatPosition)
        return true;
    return false;
}

@end
