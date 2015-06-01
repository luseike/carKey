//
//  playSound.h
//  CarKey
//
//  Created by jiangyuanlu on 15/5/30.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface playSound : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}
- (id)initSystemShake;//系统 震动
- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
- (void)play;//播放
@end
