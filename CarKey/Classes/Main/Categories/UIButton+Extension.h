//
//  UIButton+Extension.h
//  CarKey
//
//  Created by jiangyuanlu on 15/5/28.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
+(instancetype)buttonWithTitle:(NSString *)title size:(CGSize)size target:(id)target action:(SEL)action;
@end
