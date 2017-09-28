//
//  HeartRateWaveView.h
//  心率波形demo
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/5/24.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//
//  这个类是用来画波形的
//  根据一个一个的点来绘制波形，PointCountInScreen代表一屏最多绘制多少个点
//  将这些点连起来便是一个个波形，波形的x值是根据点的index动态变化，共同的x值为startX(增量为kScreenWith / PointCountInScreen)，
//  y值从pointArray中取放入drawPoints中，将这些点通过context连起来就是波形
//  pointArray是根据rate（心率）从 HRTools 类中转换过来的.
//  实现从头开始绘制波形的效果： 每次刷新drawPoints中的坐标点的时候，用一个蒙板盖在上面让蒙板的x值始终等于startX。
//  目前将画波形与HRTools类绑定，如果想用这个类画其他的波形，需要把pointArray暴露出来，轮询传入数据。通过改变
//  PointCountInScreen值来改变波形的宽度，pointArray中的值决定y值。

#import <UIKit/UIKit.h>
#import "HRTools.h"

#define PointCountInScreen 800  // 一屏绘制的点数

@interface HeartRateWaveView : UIView

/**
 心率 根据心率来绘制波形
 */
@property (nonatomic, assign) int rate;

/**
 重置绘制
 */
- (void)reset;

@end
