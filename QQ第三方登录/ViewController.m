//
//  ViewController.m
//  QQ第三方登录
//
//  Created by mac on 15/5/27.
//  Copyright (c) 2015年 BSY. All rights reserved.
//

#import "ViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
@interface ViewController ()<TencentSessionDelegate,TencentLoginDelegate>
{
    TencentOAuth * _tencentOAuth;
    UIImageView * headImage ;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button  = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setFrame:CGRectMake(30, 100, 100, 100)];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
       headImage  = [[UIImageView alloc] initWithFrame:CGRectMake(30, 200, [UIScreen mainScreen].bounds.size.width-60, [UIScreen mainScreen].bounds.size.height-150)];
    [self.view addSubview:headImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo_my:) name:@"getUserInfoResponse" object:nil];
}
- (void)getUserInfo_my:(NSNotification *)notify
{
    if (notify)
    {
        APIResponse *response = [[notify userInfo] objectForKey:@"kResponse"];
        if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode)
        {
            NSDictionary * dict = (NSDictionary *)response.jsonResponse; // 登录成功后返回的用户信息
            NSLog(@"%@",dict);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"figureurl_qq_2"]]];
            
            NSLog(@"   %@",data);
            UIImage *image = [UIImage imageWithData:data];
            [headImage setImage:image];
        }
        else
        {
            NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@", response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:errMsg delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
            [alert show];
        }
    }
}
- (void)getUserInfoResponse:(APIResponse*) response
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserInfoResponse" object:self  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response, @"kResponse", nil]];
}

-(void)buttonClick
{
    NSArray* permissions = [NSArray arrayWithObjects: // 可以配置你想要的用户信息
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_IDOL,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_DEL_IDOL,
                            kOPEN_PERMISSION_DEL_T,
                            kOPEN_PERMISSION_GET_FANSLIST,
                            kOPEN_PERMISSION_GET_IDOLLIST,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_GET_REPOST_LIST,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                            nil];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104625474"   andDelegate:self];
    [_tencentOAuth authorize:permissions inSafari:NO];
    
}
- (void)tencentDidLogin
{
    //    登录完成
    
    if ([_tencentOAuth getUserInfo]) { // 判断是否获取用户信息
        
        NSLog(@"获取用户信息成功");
    }
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"登录成功%@",_tencentOAuth.accessToken);
    }
    else
    {
        //        "登录不成功 没有获取accesstoken";
    }
}

//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        //        用户取消登录
    }
    else
    {
        //        登录失败
    }
}
//网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    //	无网络连接，请设置网络
}
@end
