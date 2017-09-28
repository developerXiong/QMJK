//
//  HRTools.m
//  心率波形demo
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/5/24.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import "HRTools.h"

#define kPointCountWhenHeartIs100 72    // 当心率=100时坐标点的数量
#define kScreenW [UIScreen mainScreen].bounds.size.width

@implementation HRTools

+ (NSMutableArray *)pointsArrayWithHeartRate:(int)rate {
    NSMutableArray *points = [NSMutableArray array];
    
    // 1. 获取标准数组，（心率为100的时候的波形图坐标点数组 72个坐标点）
    NSMutableArray *basicArray = [self getBasicArray];
    
    // 2. 获取坐标点的数量 (7200 / 心率)
    int pointCount = 7200 / rate;
    
    // 3. 根据坐标点数量，决定是往标准数组中添加或者移除坐标点，具体位置
    if (pointCount == kPointCountWhenHeartIs100) {
        // 3.1. 如果坐标点的数量=72，直接返回标准数组
        points = basicArray;
    } else if (pointCount > kPointCountWhenHeartIs100) {
        // 3.2. 如果坐标点的数量>72，往标准数组中添加坐标点
        points = [self joinPoint:(pointCount - kPointCountWhenHeartIs100) toBasicArray:basicArray];
    } else if (pointCount > 0 && pointCount < kPointCountWhenHeartIs100) {
        // 3.3. 如果坐标点的数量<72，从标准数组中移除坐标点
        points = [self removePoint:(kPointCountWhenHeartIs100 - pointCount) fromBasicArray:basicArray];
    }
    
    //    points = [self justYArrayWithArray:points];
    
    // 4. 返回新的坐标点数组
    return points;
}

#pragma mark - private method

/**
 获取标准数组，（心率为100的时候的波形图坐标点数组）
 
 @return 心率为100的时候的波形图坐标点数组
 */
+ (NSMutableArray *)getBasicArray {
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@0, @5, @15, @30, @50, @75, @105, @135, @160, @180, @200, @220, @240, @260, @280, @300, @320, @340, @360, @380, @405, @430, @460, @500, @525, @545, @560, @570, @575, @580, @575, @570, @560, @540, @510, @470, @440, @420, @410, @400, @405, @415, @425, @435, @436, @433, @425, @415, @410, @400, @390, @370, @350, @330, @310, @290, @270, @250, @230, @210, @190, @170, @150, @130, @110, @90,  @70,  @50, @30, @20,  @10, @0]];
    NSMutableArray *newArr = [NSMutableArray array];
    for (NSNumber *num in array) {
        CGFloat y = [num floatValue];
        y /= 13;         // 比给的y值小8倍
        [newArr addObject:[NSNumber numberWithFloat:y]];
    }
    
    return newArr;
}


/**
 往标准数组中添加坐标点
 
 @param count 添加多少个
 */
+ (NSMutableArray *)joinPoint:(int)count toBasicArray:(NSMutableArray *)basicArray {
    if (basicArray.count == 0 || basicArray == nil) {
        return basicArray;
    }
    
    NSMutableArray *newArr = [NSMutableArray array];
    
    // 数组的数量
    int basicArrCount = (int)basicArray.count;
    // 有多少可以插入的空间
    int space = basicArrCount - 1;
    // 每个空间插入多少个
    int insertCount = count / space;
    
    if (insertCount > 0) {
        // 如果平均每个可以插入1个以上的值
        
        // 遍历标准数组，插值
        for (int i = 0; i < basicArrCount; i ++) {
            CGFloat y, nextY;
            y = [basicArray[i] floatValue];
            // 遍历到最后一个的时候处理，防止数组越界
            if (i == basicArrCount - 1) {
                nextY = [basicArray[i-1] floatValue];
            } else {
                nextY = [basicArray[i+1] floatValue];
            }
            
            // 先将原来的值添加到数组
            [newArr addObject:basicArray[i]];
            // 添加新的值
            for (int j = 0; j < insertCount; j ++) {
                // 处理要插入的y值 （为 y +（下个坐标的y值-当前坐标的y值 / 插入的数量+1） ）
                CGFloat newY = y + (nextY - y) / (insertCount + 1);
                if (newY < 0) {
                    newY = fabs(newY); // 取绝对值
                } else if (newY == 0) {
                    newY = y;
                }
                [newArr addObject: [NSNumber numberWithFloat:newY]];
            }
            
        }
        
        // 将所有可插入的值插完之后 把剩下的值插进去
        newArr = [self insertNotNeatValueToArr:newArr count:count % space];
        
    } else {
        newArr = [self insertNotNeatValueToArr:basicArray count:count];
    }
    
    
    return newArr;
}



/**
 插入不整齐的值
 
 @param basicArray 往这个数组中插
 @param count 插入的数量（不得大于数组本身的count-1）
 @return 插入新值的数组
 */
+ (NSMutableArray *)insertNotNeatValueToArr:(NSMutableArray *)basicArray count:(int)count {
    if (count <= 0) {
        return basicArray;
    }
    
    NSMutableArray *newArr = [NSMutableArray array];
    
    // 每个空间插入数量不足一个时从第一个位置开始顺序插入，插完为止
    int insertIndex = 0;
    // 插入的间隔
    int insertMargin = (int)basicArray.count / count;
    
    for (int i = 0; i < basicArray.count; i ++) {
        
        CGFloat y, nextY;
        y = [basicArray[i] floatValue];
        // 遍历到最后一个的时候处理，防止数组越界
        if (i == basicArray.count - 1) {
            nextY = [basicArray[i-1] floatValue];
        } else {
            nextY = [basicArray[i+1] floatValue];
        }
        
        // 先将原来的值添加到数组
        [newArr addObject:basicArray[i]];
        // 插入的数量不足规定的数量才能继续插入
        if (insertIndex == i) {
            // 处理要插入的y值 （为 y +（下个坐标的y值-当前坐标的y值 / 插入的数量+1） ）
            CGFloat newY = y + (nextY - y) / 2;
            if (newY < 0) {
                newY = fabs(newY);
            } else if (newY == 0) {
                newY = y;
            }
            [newArr addObject:[NSNumber numberWithFloat:newY]];
            insertIndex += insertMargin;
        }
        
    }
    
    
    return newArr;
}

/**
 从标准数组中移除坐标点
 
 @param count 移除多少个
 */
+ (NSMutableArray *)removePoint:(int)count fromBasicArray:(NSMutableArray *)basicArray {
    if (basicArray.count == 0 || basicArray == nil) {
        return basicArray;
    }
    NSMutableArray *newArr = [NSMutableArray array];
    
    // 隔多少移除一个点
    int margin = (int)basicArray.count / count;
    // 移除的起始位置 从第1个开始 （0...1...3...4...5）
    int start = 1;
    // 已经移除的点数
    int removed = 0;
    
    // 要移除的点不加入新数组就行了 (index = 29 | 39 | 44 | 0 | lastIndex 这些点不能移除，这些是关键点)
    for (int i = 0; i < basicArray.count; i ++) {
        if (removed <= count) {
            if (i == start) {
                if (i == 29 || i == 39 || i == 44 || i == basicArray.count-1) {
                    // 用最后一个元素替代
                    [newArr removeLastObject];
                    [newArr addObject:basicArray[i]];
                }
                
                start += margin;
                removed ++;
                
            } else {
                [newArr addObject:basicArray[i]];
            }
            
        } else {
            [newArr addObject:basicArray[i]];
        }
    }
    
    return newArr;
}

/*
 + (NSMutableArray *)justYArrayWithArray:(NSMutableArray *)array {
 NSMutableArray *newArr = [NSMutableArray array];
 
 for (NSArray *arr in array) {
 [newArr addObject:arr[1]];
 }
 
 return newArr;
 }
 */

@end
