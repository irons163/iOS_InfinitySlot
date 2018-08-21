//
//  GameOverViewController.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/11.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameOverViewController.h"
#import "ViewController.h"
#import "TextureHelper.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface GameOverViewController ()<BviewControllerDelegate>

@end

@implementation GameOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.gameLevelTensDigitalLabel.image = [TextureHelper timeTextures][0];
    
    self.gameLevelTensDigitalLabel.image = [self getNumberImage:(self.gameLevel+1)/10];
    
    self.gameLevelSingleDigital.image = [self getNumberImage:(self.gameLevel+1)%10];
    
    self.gameTimeMinuteTensDIgitalLabel.image = [self getNumberImage:self.gameTime/60/10];
    self.gameTimeMinuteSingleDigitalLabel.image = [self getNumberImage:self.gameTime/60%10];
    self.gameTimeSecondTensDigitalLabel.image = [self getNumberImage:self.gameTime%60/10];
    self.gameTimeSecondSingleDigitalLabel.image = [self getNumberImage:self.gameTime%60%10];
    
    UIImage * m01 = [UIImage imageNamed:@"m01"];
    UIImage * m02 = [UIImage imageNamed:@"m02"];
    UIImage * m03 = [UIImage imageNamed:@"m03"];
    UIImage * m04 = [UIImage imageNamed:@"m04"];
    UIImage * m05 = [UIImage imageNamed:@"m05"];
    UIImage * m06 = [UIImage imageNamed:@"m06"];
    UIImage * m07 = [UIImage imageNamed:@"m07"];
    UIImage * m08 = [UIImage imageNamed:@"m08"];
    UIImage * m09 = [UIImage imageNamed:@"m09"];
    UIImage * m10 = [UIImage imageNamed:@"m10"];
    UIImage * m11 = [UIImage imageNamed:@"m11"];
    UIImage * m12 = [UIImage imageNamed:@"m12"];
    UIImage * m13 = [UIImage imageNamed:@"m13"];
    UIImage * m14 = [UIImage imageNamed:@"m14"];
    UIImage * m15 = [UIImage imageNamed:@"m15"];
    UIImage * m16 = [UIImage imageNamed:@"m16"];
    UIImage * m17 = [UIImage imageNamed:@"m17"];
    UIImage * m18 = [UIImage imageNamed:@"m18"];
    UIImage * m19 = [UIImage imageNamed:@"m19"];
    UIImage * m20 = [UIImage imageNamed:@"m20"];
    UIImage * m21 = [UIImage imageNamed:@"m21"];
    
//    NSArray * frames = @[m01,m02,m03,m04,m05,m06,m07,m08,m09,m10,m11,m12,m13,m14,m15,m16,m17,m18,m19,m20,m21];
    
    NSArray * frames = @[[self prerender:m01],[self prerender:m02],[self prerender:m03],[self prerender:m04],[self prerender:m05],[self prerender:m06],[self prerender:m07],[self prerender:m08],[self prerender:m09],[self prerender:m10],[self prerender:m11],[self prerender:m12],[self prerender:m13],[self prerender:m14],[self prerender:m15],[self prerender:m16],[self prerender:m17],[self prerender:m18],[self prerender:m19],[self prerender:m20],[self prerender:m21]];
    
    [self.animationImageView setAnimationImages:frames];//设置动画图片数组  数组中存放的是一组UIImage图片（帐动画图片）

    [self.animationImageView setAnimationDuration:2.0];//设置动画持续时间
    
    self.animationImageView.animationRepeatCount = 1;//设置动画重复次数
    
}

-(UIImage*)prerender:(UIImage*)frameImage{
    UIGraphicsBeginImageContext(frameImage.size);
    CGRect rect = CGRectMake(0, 0, frameImage.size.width, frameImage.size.height);
    [frameImage drawInRect:rect];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.view setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3f]];
    
    self.animationImageView.image = [self.animationImageView.animationImages lastObject];
    
    [self.animationImageView startAnimating];//开始动画
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)restartGameClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
//        [self ];
//        [self.delegate BviewcontrollerDidTapButton];
        [self.delegate BviewcontrollerDidTapButton];
    }];
}

- (IBAction)backToMainMenuClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        //        [self ];
        //        [self.delegate BviewcontrollerDidTapButton];
        [self.delegate BviewcontrollerDidTapBackToMenuButton];
    }];
}

- (IBAction)giftClick:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"Info.plist"];
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        NSString *version = [plistData objectForKey:@"CFBundleVersion"];
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setToRecipients:[NSArray arrayWithObject:@"app@engeniuscloud.com"]];
        [picker setSubject:@"Feedback to EnGenius EnShare APP"];
        
//        NSString *body = [NSString stringWithFormat:_(@"ABOUT_MAIL"), [[NSUserDefaults standardUserDefaults] stringForKey:MODEL_NAME_KEY], [[NSUserDefaults standardUserDefaults] stringForKey:FIRWARE_VERSION_KEY], version, [UIDevice currentDevice].model, [[UIDevice currentDevice] systemVersion] ];

        NSString *body = @"hello";
        
        [picker setMessageBody:body isHTML:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"no mail");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet. Make sure you set up an account for send email.Be  careful, Do Not close the  prize page after you send  the email. Otherwise, you  lost the prize."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:false
                             completion:^{
                                 
                             }];
}

-(UIImage*)getNumberImage:(int)number{
    UIImage* image;
    switch (number) {
        case 0:
            image = [TextureHelper timeImages][0];
            break;
        case 1:
            image = [TextureHelper timeImages][1];
            break;
        case 2:
            image = [TextureHelper timeImages][2];
            break;
        case 3:
            image = [TextureHelper timeImages][3];
            break;
        case 4:
            image = [TextureHelper timeImages][4];
            break;
        case 5:
            image = [TextureHelper timeImages][5];
            break;
        case 6:
            image = [TextureHelper timeImages][6];
            break;
        case 7:
            image = [TextureHelper timeImages][7];
            break;
        case 8:
            image = [TextureHelper timeImages][8];
            break;
        case 9:
            image = [TextureHelper timeImages][9];
            break;
    }
    return image;
}

- (IBAction)mailClk:(id)sender{

}



@end
