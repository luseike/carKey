//
//  LoginViewController.m
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "DriverModel.h"
#import "DriverInfoController.h"
#import "UIButton+Extension.h"
#import "AFNetworking.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (nonatomic,strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"292A49"];
    
    self.pwdField.delegate = self;
    self.phoneField.delegate = self;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGFloat x = 20;
    CGFloat height = 46;
    //CGFloat y =
    CGFloat width = kScreenW - 2 * x;
    CGFloat height_ = kScreenH;
    
    UIButton *loginBtn = [UIButton buttonWithTitle:@"立即登录" size:CGSizeMake(width, height) target:self action:@selector(loginClick:)];
    loginBtn.x = x;
    loginBtn.y = kScreenH - 100 - height;
#warning remember to chang NO
    loginBtn.enabled = YES;
    self.loginBtn = loginBtn;
    [self.view addSubview:loginBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    if (height_ <= 480) {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbfWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    
    
}

#pragma mark - 文本框发出通知时调用的方法
-(void)textFieldChanged:(NSNotification *)ntf{
        if (self.phoneField.text.length>0 && self.pwdField.text.length>0) {
            self.loginBtn.enabled = YES;
        }else{
            self.loginBtn.enabled = NO;
        }
}
-(void)kbfWillChange:(NSNotification *)notifi{
    JYLLog(@"%@",notifi.userInfo);
    CGRect beginFrame = [[notifi.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if (beginFrame.origin.y == kScreenH) {
        self.loginViewTopConstraint.constant += 50;
    }else
        self.loginViewTopConstraint.constant -= 50;
    
}
- (void)loginClick:(id)sender {
    
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[DriverInfoController alloc] init]];
    DriverInfoController *driverVc  = [[DriverInfoController alloc] init];
    driverVc.sid = @"uhfuiua3r2uiu9";
    [self presentViewController:driverVc animated:YES completion:nil];
    
//    NSDictionary *driverDict = @{@"driverMobile":@"13888889999",
//                                 @"driverName":@"刘强军",
//                                 @"driverLevel":@4,
//                                 @"driverOrderCount":@516,
//                                 @"driverAcount":@1200,
//                                 @"driverStatus":@1,
//                                 @"headUrl":@"http://www.uimaker.com/uploads/allimg/121112/1_121112112013_5.png"};
//    DriverModel *loginDriver = [DriverModel objectWithKeyValues:driverDict];
//    
//    DriverInfoController *driverInfo = [[DriverInfoController alloc] init];
//    driverInfo.driver = loginDriver;
//    [self presentViewController:driverInfo animated:YES completion:nil];
    
    
    /**
    NSString *phone = self.phoneField.text;
    NSString *pwd = self.pwdField.text;
    
    
    NSString *mobileRegex = @"^((13[0-9])|(147)|(170)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobileRegex];
    
    BOOL n = [mobileTest evaluateWithObject:self.phoneField.text];
    
    if (n == NO) {
        [MBProgressHUD showMessageWith3Second:@"您输入的手机号格式不对哦！"];
    }
    
    NSDictionary *dict = @{@"driverMobile":phone,@"driverPwd":pwd};

    [[RequestManager manager] driverLoginWithServicePara:dict success:^(NSDictionary *dictResult) {
        
        NSString *code = [dictResult valueForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            //登录成功
            NSDictionary *data = [dictResult valueForKey:@"data"];
            JYLLog(@"%@",data);
        }
        
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD showError:errorMessage];
    }];
    */
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField==self.phoneField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength-selectedLength+replaceLength>11) {
            return NO;
        }
    }
    
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:nil];
}

@end
