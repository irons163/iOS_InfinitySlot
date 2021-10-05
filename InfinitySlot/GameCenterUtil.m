//
//  GameCenterUtil.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/6/12.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameCenterUtil.h"
//#import "CommonUtil.h"

static GameCenterUtil* instance;

@implementation GameCenterUtil{
    BOOL gameCenterAvailable;
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

//是否支持GameCenter
- (BOOL) isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

//身份验证
- (void)authenticateLocalUser:(UIViewController*)m_viewController{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if(error){
            NSLog(@"%@", error.description);
        }
        if (viewController != nil) {
            [m_viewController presentViewController:viewController animated:YES completion:^{
//                if(self.delegate!=nil){
//                    [self.delegate pauseGame];
//                }
            }];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                // Get the default leaderboard identifier.
                
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        NSLog(@"%@", @"authenticated no error");
                    }
                }];
            }
            
            else{
                NSLog(@"%@", @"authenticated not");
                [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
            }
        }
    };
}

//用户变更检测
- (void)registerFoeAuthenticationNotification{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
}

- (void)authenticationChanged{
    if([GKLocalPlayer localPlayer].isAuthenticated ){
        NSLog(@"Authentication changed: player authenticated.");
//        userAuthenticated = TRUE;
    }else{
        NSLog(@"Authentication changed: player not authenticated");
//        userAuthenticated = FALSE;
    }
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    
    scoreReporter.value = score;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil){
            NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
            
            //未能提交得分，需要保存下来后继续提交
            [self storeScoreForLater:saveSocreData];
        }else{
            NSLog(@"提交成功");
        }
//        [CommonUtil resetGameRecoder:[CommonUtil sharedInstance]];
    }];
}

- (void)storeScoreForLater:(NSData *)scoreData{
    NSMutableArray *savedScoresArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [savedScoresArray addObject:scoreData];
    [[NSUserDefaults standardUserDefaults] setObject:savedScoresArray forKey:@"savedScores"];
}

//重新提交分数
- (void)submitAllSavedScores{
    NSMutableArray *savedScoreArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"savedScores"]];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedScores"];
    
    for(NSData *scoreData in savedScoreArray){
        GKScore *scoreReporter = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if(error != nil){
                NSData *saveSocreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
                //未能提交得分，需要保存下来后继续提交
                [self storeScoreForLater:saveSocreData];
            }else{
                NSLog(@"提交成功");
                
                
            }
        }];
    }
}

- (void)showGameCenter:(UIViewController*)viewController{
    GKGameCenterViewController *gameView = [[GKGameCenterViewController alloc] init];
    if(gameView != nil){
        gameView.gameCenterDelegate = self;
        
        [gameView setLeaderboardCategory:@"com.xxxx.test"];
        [gameView setLeaderboardTimeScope:GKLeaderboardTimeScopeAllTime];
        
        [viewController presentViewController:gameView animated:YES completion:^{
//            if(self.delegate!=nil){
//                [self.delegate pauseGame];
//            }
        }];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
