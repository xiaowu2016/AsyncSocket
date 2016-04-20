//
//  ViewController.m
//  Socket004
//
//  Created by zhangchao on 16/4/20.
//  Copyright © 2016年 zhangchao. All rights reserved.
//

#import "ViewController.h"
#import "FirstView.h"
#import "AppDelegate.h"
#import "SocketServer.h"

#define kLOGIN @"login"
#define kERROR @"error"
#define kIP @"192.168.31.128"
#define kPORT 8080


@interface ViewController ()
@property (nonatomic,strong) UITextField *userNameTF;
@property (nonatomic,strong) UITextField *userPWDTF;
@property (nonatomic,strong) UIButton *loginBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:kLOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(error:) name:kERROR object:nil];
    [self addViews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UITextField *)userNameTF
{
    if(!_userNameTF)
    {
        _userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 100, 40)];
        _userNameTF.placeholder = @"请输入用户名";
        _userNameTF.backgroundColor = [UIColor blueColor];
    }
    return _userNameTF;
}

- (UITextField *)userPWDTF
{
    if(!_userPWDTF)
    {
        _userPWDTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 180, 100, 40)];
        _userPWDTF.placeholder = @"请输入密码";
        _userPWDTF.backgroundColor = [UIColor blueColor];
    }
    return _userPWDTF;
}

- (UIButton *)loginBtn
{
    if(!_loginBtn)
    {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(50, 260, 100, 40);
        _loginBtn.backgroundColor = [UIColor redColor];
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(didClickLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

//页面布局
- (void)addViews
{
    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:self];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController = NC;
    [self.view addSubview:self.userNameTF];
    [self.view addSubview:self.userPWDTF];
    [self.view addSubview:self.loginBtn];
}

//屏幕触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userNameTF resignFirstResponder];
    [self.userPWDTF resignFirstResponder];
}

//登陆按钮点击事件
- (void)didClickLogin
{
    NSString *aString = [self.userNameTF.text stringByAppendingString:[NSString stringWithFormat:@"/%@",self.userPWDTF.text]];
    NSData *data = [aString dataUsingEncoding:NSUTF8StringEncoding];
    SocketServer *sock = [[SocketServer alloc] init];
    [sock connect:kIP port:kPORT timeOut:30 block:^(BOOL success) {
       if(success)
       {
           [sock writeData:data];
       }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kERROR object:@"链接出错"];
        }
    }];
}

//通知回传方法
- (void)login:(NSNotification *)notification
{
    FirstView *first = [[FirstView alloc] init];
    [self.navigationController pushViewController:first animated:YES];
}


- (void)error:(NSNotification *)notification
{
    NSString *aString = [notification object];
    NSLog(@"%@",aString);
}

@end
