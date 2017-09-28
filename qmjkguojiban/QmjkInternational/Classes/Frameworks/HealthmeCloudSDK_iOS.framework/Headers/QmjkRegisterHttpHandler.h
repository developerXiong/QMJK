//
//  RegisterHttpHandler.h
//  TestiOSHealthmeSDK
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/7/19.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QmjkRegisterHttpHandler : NSObject

/**
 登录
 
 @param account 账号
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)loginWithAccount:(NSString *)account success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 注册:
    参数格式：（修改资料参数类似）
         userAccount:String, //账号
         birth:String, //生日(例：1980-01-01)
         sex:int, //1男2女
         height:int, //身高
         weight:float,  //体重
         infoLow:int, //低压(非必填)
         infoHigh:int //高压(非必填)
         infoBPSituation:int, //血压区间(1高压2正常3低压4不知道)
 
 @param params 参数
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)addUserInfo:(id)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 修改用户信息  (类似注册的参数,不要账号)
 
 @param params 参数
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)updateUserInfo:(id)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
    
/**
 获取登录成功返回的userId

 @return userId
 */
+ (NSString *)getUserId;

/**
 是否登录
 */
+ (BOOL)isLogin;

/**
 退出登录
 */
+ (void)logout;

/**
 是否注册过App
 */
+ (BOOL)isRegistedApp;

@end
