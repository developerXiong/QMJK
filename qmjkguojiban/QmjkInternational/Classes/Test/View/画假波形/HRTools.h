//
//  HRTools.h
//  心率波形demo
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/5/24.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 基本的数据数组，心率为100的时候  数量 = 7200 / 心率
// xMargin = kScreenW / 720

@interface HRTools : NSObject


/**
 
 根据心率获取坐标点数组
 
 @param rate 心率
 @return 显示在屏幕上的坐标点的数组  @[@[], @[]]
 */
+ (NSMutableArray *)pointsArrayWithHeartRate:(int)rate;


@end
