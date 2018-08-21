//
//  AppDelegate.m
//  Try_Laba_For_Cat
//
//  Created by irons on 2015/4/18.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "appirater-master/Appirater.h"
#import "CommonUtil.h"
#import "MyScene.h"

@implementation AppDelegate{
//    NSDate *date;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Appirater setAppId:@"770699556"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
//    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
    }
    
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSString *itemName = [localNotif.userInfo objectForKey:@"coin"];
        //        [viewController displayItem:itemName];  // custom method
        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
    }
    //    [window addSubview:viewController.view];
    //    [self.window makeKeyAndVisible];
    
    if([AppDelegate isFirstLaunch]){
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:MyScene.MONEY_INIT forKey:MyScene.moneyField];
        [userDefaults synchronize];
        
        NSDate* date = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        //正規化的格式設定
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        //正規化取得的系統時間並顯示
        NSString* DateStr = [formatter stringFromDate:date];
        
        [[NSUserDefaults standardUserDefaults] setObject:DateStr forKey:@"date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:0];
        [components setMinute:0];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *fireDate = [calendar dateFromComponents:components];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
//        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:20];
                localNotification.fireDate = fireDate;
        localNotification.repeatInterval = NSCalendarUnitDay;
        localNotification.alertBody = @"Make up money to 5000.";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //正規化的格式設定
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //正規化取得的系統時間並顯示
    NSString* DateStr = [formatter stringFromDate:currentDate];
    
    if(![DateStr isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"date"]]){
        [[NSUserDefaults standardUserDefaults] setObject:DateStr forKey:@"date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((CommonUtil*)[CommonUtil sharedInstance]).isDuringOneDay = true;
        NSLog(@"get from launch");
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{

    NSString *itemName = [notification.userInfo objectForKey:@"coin"];
//    [viewController displayItem:itemName];  // custom method
    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //正規化的格式設定
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //正規化取得的系統時間並顯示
    NSString* DateStr = [formatter stringFromDate:currentDate];
    
    if(![DateStr isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"date"]]){
        [[NSUserDefaults standardUserDefaults] setObject:DateStr forKey:@"date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ((CommonUtil*)[CommonUtil sharedInstance]).isDuringOneDay = true;

        NSLog(@"get");
    }
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    UIUserNotificationSettings* settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    int i = settings.hash;
    
    if(settings.types == UIUserNotificationTypeNone){
        NSURL* url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if(url)
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (BOOL)isFirstLaunch {
    static BOOL result;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedOnce"]) {
        result = NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:@"hasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        result = YES;
    }
    return result;
}

@end
