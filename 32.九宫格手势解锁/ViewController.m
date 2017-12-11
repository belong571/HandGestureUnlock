//
//  ViewController.m
//  32.九宫格手势解锁
//
//  Created by zyj on 2017/12/7.
//  Copyright © 2017年 ittest. All rights reserved.
//

#import "ViewController.h"
#import "PassWordView.h"
#import "MBProgressHUD+Ex.h"
#import "HomeViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet PassWordView *passwordView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    NSString *password=@"123456";
    self.passwordView.passwordBlock=^(NSString *pwd){
        NSLog(@"pwd=%@",pwd);
        [self renderImageView];
        if([pwd isEqualToString:password]){
            NSLog(@"密码正确");
            [MBProgressHUD showSuccess:@"密码正确"];
            HomeViewController *homeViewController=[[HomeViewController alloc] init];
            [self presentViewController:homeViewController animated:YES completion:^{
                //
            }];
            return YES;
        }else{
            NSLog(@"密码错误");
            [MBProgressHUD showError:@"密码错误"];
            return NO;
        }
    };
    
    [self renderImageView];
}


-(void)renderImageView{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.passwordView.frame.size, NO, 0);
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.passwordView.layer renderInContext:context];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    self.imageView.image=image;
    //关闭图形上下文
    UIGraphicsEndImageContext();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
