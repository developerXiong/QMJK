//
//  HeartRateWaveView.m
//  心率波形demo
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/5/24.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "HeartRateWaveView.h"

#import "UIColor+Hex.h"
#import "HRTools.h"

/**
 
 y值数组：unsigned long bmp[]={
 3000, 3005, 3015, 3030, 3050, 3075, 3105, 3135, 3160, 3180,
 3200, 3220, 3240, 3260, 3280, 3300, 3320, 3340, 3360, 3380,
 3405, 3430, 3460, 3500, 3525, 3545, 3560, 3570, 3575, 3580,
 3575, 3570, 3560, 3540, 3510, 3470, 3440, 3420, 3410, 3400,
 3405, 3415, 3425, 3435, 3436, 3433, 3425, 3415, 3410, 3400,
 3390, 3370, 3350, 3330, 3310, 3290, 3270, 3250, 3230, 3210,
 3190, 3170, 3150, 3130, 3110, 3090, 3070, 3050, 3030, 3020,
 3010, 3005,
 };
 
 一个pointsArray的点数(p) = 7200 / 心率(a)
 
 */

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kWaveWidth 1.3                  // 波形的宽度
#define kHeightToBottom 5              // 波形距离底部的距离

@interface HeartRateWaveView () {
    CGContextRef context;
    NSMutableArray *pointArray;  // 一条心率数据对应的坐标点数组
    CGFloat startX;        // 当前坐标点的起始x值
    NSTimer *timer;
    int index;             // 取pointArray中第几条数据
    CGPoint drawPoints[PointCountInScreen];  // 所有坐标点
    int pointIndex;        // 当前正在改变drawPoints中第几个坐标点
    int showPointCount;    // 用content连成几条线
    int times;             // 这个参数没用过，但是！！！！！去掉了程序会崩溃！！！！！！！！！！！！！
    UIView *maskView;
    BOOL isFirst;          // 是否为第一次心率有正常值
    int lastRate;          // 记录上一次的rate值
}


@end

@implementation HeartRateWaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        showPointCount = 0;
        
        self.backgroundColor = [UIColor clearColor];
        [self initDrawPoints];
        
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, frame.size.height)];
//        maskView.backgroundColor = [UIColor colorWithHexString:@"#f0f3f8"];
        maskView.backgroundColor = [UIColor colorWithRed:37/255.0 green:153/255.0 blue:237/255.0 alpha:1];
        [self addSubview:maskView];
        
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

/**
 初始化绘制波形的点集合
 */
- (void)initDrawPoints {
    for (int j = 0; j < PointCountInScreen; j ++) {
        drawPoints[j] = CGPointMake(0, self.frame.size.height - kHeightToBottom);
    }
}

- (void)drawRect:(CGRect)rect {
    
    // 获取图形上下文
    context = UIGraphicsGetCurrentContext();
    [self drawLine];
    
}

- (void)drawLine {
    
    CGContextSetLineWidth(context, kWaveWidth);//设置波形的宽
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"ffc000"].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // 每次setNeedsDisplay，showPointCount都会++：代表多绘制一个点出来，这样就会出现波形绘制的效果
    // drawPoints的个数不变，坐标会根据pointArray发生变化
    CGContextAddLines(context, drawPoints, showPointCount);
    CGContextStrokePath(context);
}


- (void)setRate:(int)rate {
    _rate = rate;
    
#pragma mark - 处理传过来的心率
    // 心率小于30或者大于300的都变成100 ，200-300之间的变成200
    if (rate <= 30 || rate >= 300) {
        // 心率值不正常
        rate = 100;
    } else if (rate > 200 && rate < 300) {
        // 心率大于200之后波形会变形，控制在200
        rate = 200;
        
    }
    
    // 心率波动太大会导致 波形变形，做处理
    if (lastRate > 0) {
        int storeValue = lastRate - rate;
        // 让心率变化值变为1
        int margin = 1;
        if (storeValue > margin) {
            rate = lastRate - margin;
        } else if (storeValue < -margin) {
            rate = lastRate + margin;
        }
    }
    lastRate = rate;
    
    // 根据心率值获取绘制波形的y值数据
    pointArray = [HRTools pointsArrayWithHeartRate:rate];
    
#pragma mark - 开始绘制波形
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / (7200/rate) target:self selector:@selector(beforeDraw) userInfo:nil repeats:YES];
    [timer fire];
}

/**
 准备绘制
 */
- (void)beforeDraw {

    if (index >= pointArray.count) {
        [timer invalidate];
        timer = nil;
        index = 0;
        return;
    }
    
    // 要移向的点的坐标
    drawPoints[pointIndex] = CGPointMake(startX, self.frame.size.height - [pointArray[index] floatValue] - kHeightToBottom);
    pointIndex ++;
    
    if (startX >= kScreenW) {
        startX = 0;
        pointIndex = 0;
    } else {
        // 每一次绘制的偏移量
        CGFloat offsetX = (kScreenW / PointCountInScreen);
        startX += offsetX;
    }
    
    
    maskView.frame = CGRectMake(startX - 2, 0, 30, self.frame.size.height);
    showPointCount ++;
    if (showPointCount >= PointCountInScreen) {
        showPointCount = PointCountInScreen - 1;
    }
    
    [self setNeedsDisplay];
    
    index ++;
    
}


/**
 初始化波形点 数据
 */
- (void)initPointArray {
    pointArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 73; i ++) {
        [pointArray addObject:[NSNumber numberWithFloat:0.0]];
    }
}


/**
 重新绘制波形
 */
- (void)reset {
//    [self initDrawPoints];
    showPointCount = 0;
    index = 0;
    startX = 0;
    pointIndex = 0;
    if (timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
    // 用y=0初始化pointArray
//    [self initPointArray];
    
}



@end
