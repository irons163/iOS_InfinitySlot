//
//  BuyViewController.h
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/30.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "ViewController.h"

@interface BuyViewController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>{
    BOOL areAdsRemoved;
}

@property ViewController * viewController;
@property (strong, nonatomic) IBOutlet UIButton *restoreBtn;
@property (strong, nonatomic) IBOutlet UIButton *buy5000Btn;
- (IBAction)buy5000Click:(id)sender;
- (IBAction)buy30000Click:(id)sender;
- (IBAction)buy65000Click:(id)sender;
- (IBAction)buy175000Click:(id)sender;
- (IBAction)buy375000Click:(id)sender;
- (IBAction)buy850000Click:(id)sender;

- (IBAction)purchase;
- (IBAction)restore;
- (IBAction)tapsRemoveAdsButton;
- (IBAction)backBtn:(id)sender;

@end
