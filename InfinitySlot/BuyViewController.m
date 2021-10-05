//
//  BuyViewController.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/5/30.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "BuyViewController.h"
#import "CommonUtil.h"

@interface BuyViewController ()

@end

@implementation BuyViewController{
    int currentClick;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!((CommonUtil*)[CommonUtil sharedInstance]).isFreeVersion){
        self.item5000Label.text = NSLocalizedString(@"get6000Coin", @"");
        self.item30000Label.text = NSLocalizedString(@"get35000Coin", @"");
        self.item65000Label.text = NSLocalizedString(@"get85000Coin", @"");
        self.item175000Label.text = NSLocalizedString(@"get225000Coin", @"");
        self.item375000Label.text = NSLocalizedString(@"get500000Coin", @"");
        self.item850000Label.hidden = true;
        self.item850000RemoveAdLabel.hidden = true;
        self.buy850000Btn.hidden = true;
        self.restoreBtn.hidden = true;
    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#define kFirst5000RemoveAdsProductIdentifier @"com.irons.infinity.Firstcoin5000AndRemoveAds"
#define kFirst30000RemoveAdsProductIdentifier @"com.irons.infinity.Firstcoin30000AndRemoveAds"
#define kFirst65000RemoveAdsProductIdentifier @"com.irons.infinity.Firstcoin65000AndRemoveAds"
#define kFirst175000RemoveAdsProductIdentifier @"com.irons.infinity.Firstcoin175000AndRemoveAds"
#define kFirst375000RemoveAdsProductIdentifier @"com.irons.infinity.Firstcoin375000AndRemoveAds"
#define kFirst850000RemoveAdsProductIdentifier @"com.irons.infinity.Firstcoin850000AndRemoveAds"

#define k5000RemoveAdsProductIdentifier @"com.irons.infinity.coin5000AndRemoveAds"
#define k30000RemoveAdsProductIdentifier @"com.irons.infinity.coin30000AndRemoveAds"
#define k65000RemoveAdsProductIdentifier @"com.irons.infinity.coin65000AndRemoveAds"
#define k175000RemoveAdsProductIdentifier @"com.irons.infinity.coin175000AndRemoveAds"
#define k375000RemoveAdsProductIdentifier @"com.irons.infinity.coin375000AndRemoveAds"
#define k850000RemoveAdsProductIdentifier @"com.irons.infinity.coin850000AndRemoveAds"

#define k6000RemoveAdsProductIdentifier @"com.irons.infinity.coin6000"
#define k35000RemoveAdsProductIdentifier @"com.irons.infinity.coin35000"
#define k85000RemoveAdsProductIdentifier @"com.irons.infinity.coin85000"
#define k225000RemoveAdsProductIdentifier @"com.irons.infinity.coin225000"
#define k500000RemoveAdsProductIdentifier @"com.irons.infinity.coin500000"

const int clickRestorebtn = -1;
const int click5000btn = 0;
const int click30000btn = 1;
const int click65000btn = 2;
const int click175000btn = 3;
const int click375000btn = 4;
const int click850000btn = 5;





- (IBAction)tapsRemoveAdsButton{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        if(((CommonUtil*)[CommonUtil sharedInstance]).isFreeVersion){
            [self doRestore];
        }else{
            
            NSString * str = nil;
            if (currentClick==click5000btn) {
                str = k6000RemoveAdsProductIdentifier;
            }else if(currentClick==click30000btn){
                str = k35000RemoveAdsProductIdentifier;
            }else if(currentClick==click65000btn){
                str = k85000RemoveAdsProductIdentifier;
            }else if(currentClick==click175000btn){
                str = k225000RemoveAdsProductIdentifier;
            }else if(currentClick==click375000btn){
                str = k500000RemoveAdsProductIdentifier;
            }else{
                return;
            }
            
            SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:str]];
            productsRequest.delegate = self;
            [productsRequest start];
        }
//        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        
        /*
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:k5000RemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
        */
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:false
                             completion:^{
                                 
                             }];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (IBAction)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    currentClick = clickRestorebtn;
    [self doRestore];
    
}

-(void) doRestore{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"received fial restored transactions: %i", queue.transactions.count);
    
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    if(currentClick==clickRestorebtn){
        for(SKPaymentTransaction *transaction in queue.transactions){
            if(transaction.transactionState == SKPaymentTransactionStateRestored){
                //called when the user successfully restores a purchase
                NSLog(@"Transaction state -> Restored");
                
                [self doRemoveAds];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
        }
        return;
    }
    
    if(queue.transactions.count==0 && !((CommonUtil*)[CommonUtil sharedInstance]).isPurchased){
        NSString * str = nil;
        
        if (currentClick==click5000btn) {
            str = kFirst5000RemoveAdsProductIdentifier;
        }else if(currentClick==click30000btn){
            str = kFirst30000RemoveAdsProductIdentifier;
        }else if(currentClick==click65000btn){
            str = kFirst65000RemoveAdsProductIdentifier;
        }else if(currentClick==click175000btn){
            str = kFirst175000RemoveAdsProductIdentifier;
        }else if(currentClick==click375000btn){
            str = kFirst375000RemoveAdsProductIdentifier;
        }else if(currentClick==click850000btn){
            str = kFirst850000RemoveAdsProductIdentifier;
        }else {
            return;
        }
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:str]];
        productsRequest.delegate = self;
        [productsRequest start];
    }else{
    
        for(SKPaymentTransaction *transaction in queue.transactions){
            if(transaction.transactionState == SKPaymentTransactionStateRestored){
                //called when the user successfully restores a purchase
                NSLog(@"Transaction state -> Restored");
                
                [self doRemoveAds];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
        }
    
        NSString * str = nil;
        
        if(!((CommonUtil*)[CommonUtil sharedInstance]).isFreeVersion){
            if (currentClick==click5000btn) {
                str = k5000RemoveAdsProductIdentifier;
            }else if(currentClick==click30000btn){
                str = k30000RemoveAdsProductIdentifier;
            }else if(currentClick==click65000btn){
                str = k65000RemoveAdsProductIdentifier;
            }else if(currentClick==click175000btn){
                str = k175000RemoveAdsProductIdentifier;
            }else if(currentClick==click375000btn){
                str = k375000RemoveAdsProductIdentifier;
            }else if(currentClick==click850000btn){
                str = k850000RemoveAdsProductIdentifier;
            }else{
                return;
            }
        }
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:str]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                
                [self doRemoveAds];
                [self checkMoneyAndAdd:transaction];
                
                //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)doRemoveAds{
//    ADBannerView *banner;
//    [banner setAlpha:0];
    
    [self.viewController removeAd];
    
    areAdsRemoved = YES;
//    removeAdsButton.hidden = YES;
//    removeAdsButton.enabled = NO;
    self.restoreBtn.hidden = YES;
    self.restoreBtn.enabled = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load whether or not they bought it
    //it would be better to use KeyChain access, or something more secure
    //to store the user data, because NSUserDefaults can be changed.
    //You're average downloader won't be able to change it very easily, but
    //it's still best to use something more secure than NSUserDefaults.
    //For the purpose of this tutorial, though, we're going to use NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"isPurchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ((CommonUtil*)[CommonUtil sharedInstance]).isPurchased = true;
}

-(void)checkMoneyAndAdd:(SKPaymentTransaction*) transaction{
    if(!((CommonUtil*)[CommonUtil sharedInstance]).isFreeVersion){
        
        if([transaction.payment.productIdentifier isEqualToString:k6000RemoveAdsProductIdentifier]){
            
            [self addMoney:6000];
        }else if([transaction.payment.productIdentifier isEqualToString:k35000RemoveAdsProductIdentifier]){
            
            [self addMoney:35000];
        }else if([transaction.payment.productIdentifier isEqualToString:k85000RemoveAdsProductIdentifier]){
            
            [self addMoney:85000];
        }else if([transaction.payment.productIdentifier isEqualToString:k225000RemoveAdsProductIdentifier]){
            
            [self addMoney:225000];
        }else if([transaction.payment.productIdentifier isEqualToString:k500000RemoveAdsProductIdentifier]){
            
            [self addMoney:500000];
        }
    }else{
        if([transaction.payment.productIdentifier isEqualToString:kFirst5000RemoveAdsProductIdentifier] ||
           [transaction.payment.productIdentifier isEqualToString:k5000RemoveAdsProductIdentifier]){
            
            [self addMoney:6000];
        }else if([transaction.payment.productIdentifier isEqualToString:kFirst30000RemoveAdsProductIdentifier] ||
                 [transaction.payment.productIdentifier isEqualToString:k30000RemoveAdsProductIdentifier]){
            
            [self addMoney:35000];
        }else if([transaction.payment.productIdentifier isEqualToString:kFirst65000RemoveAdsProductIdentifier] ||
                 [transaction.payment.productIdentifier isEqualToString:k65000RemoveAdsProductIdentifier]){
            
            [self addMoney:85000];
        }else if([transaction.payment.productIdentifier isEqualToString:kFirst175000RemoveAdsProductIdentifier] ||
                 [transaction.payment.productIdentifier isEqualToString:k175000RemoveAdsProductIdentifier]){
            
            [self addMoney:225000];
        }else if([transaction.payment.productIdentifier isEqualToString:kFirst375000RemoveAdsProductIdentifier] ||
                 [transaction.payment.productIdentifier isEqualToString:k375000RemoveAdsProductIdentifier]){
            
            [self addMoney:500000];
        }
    }
}

-(void)addMoney:(int)money{
    [self.viewController addMoney:money];
}

- (IBAction)buy5000Click:(id)sender {
    currentClick = click5000btn;
    [self tapsRemoveAdsButton];
}

- (IBAction)buy30000Click:(id)sender {
    currentClick = click30000btn;
    [self tapsRemoveAdsButton];
}

- (IBAction)buy65000Click:(id)sender {
    currentClick = click65000btn;
    [self tapsRemoveAdsButton];
}

- (IBAction)buy175000Click:(id)sender {
    currentClick = click175000btn;
    [self tapsRemoveAdsButton];
}

- (IBAction)buy375000Click:(id)sender {
    currentClick = click375000btn;
    [self tapsRemoveAdsButton];
}

- (IBAction)buy850000Click:(id)sender {
    currentClick = click850000btn;
    [self tapsRemoveAdsButton];
}
@end
