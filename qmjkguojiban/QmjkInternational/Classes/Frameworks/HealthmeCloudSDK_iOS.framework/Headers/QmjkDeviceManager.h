//
//  QmjkDeviceManager.h
//  iOSHealthme
//
//  Created by 深圳前海全民健康科技股份有限公司 on 2017/7/6.
//  Copyright © 2017年 深圳前海全民健康科技股份有限公司. All rights reserved.
//
//  使用前需要在info.plist文件中配置 App Transport Security Settings参数

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


// 蓝牙连接状态
typedef enum : NSUInteger {
    BleConnectStateTimeout,         // 连接超时
    BleConnectStateDisconnected,    // 失去连接
    BleConnectStateConnecting,      // 连接中
    BleConnectStateConnected,       // 连接成功
    BleConnectStateDisconnecting    // 断开连接中
} BleConnectState;

#pragma mark - 设备管理代理(蓝牙设备)

@class QmjkDeviceManager;
@protocol QmjkDeviceManagerDelegate <NSObject>

@optional

/**
 监测手机蓝牙的开关状态

 @param manager 实例
 @param isOpen 是否打开
 */
- (void)manager:(QmjkDeviceManager *)manager bluetoothState:(BOOL)isOpen;

/**
 发现蓝牙设备调用（实时）

 @param manager 实例
 @param peripherals 设备列表
 */
- (void)manager:(QmjkDeviceManager *)manager discoverPeripherals:(NSArray<CBPeripheral *> *)peripherals;

/**
 连接蓝牙设备是否成功

 @param manager 实例
 @param isSuccess 是否成功
 */
- (void)manager:(QmjkDeviceManager *)manager connectPeripheralIsSuccess:(BOOL)isSuccess;

/**
 连接蓝牙设备状态
 
 @param manager 实例
 @param state 连接状态
 */
- (void)manager:(QmjkDeviceManager *)manager connectPeripheralState:(BleConnectState)state;

/**
 意外断开蓝牙连接，非手动断开

 @param manager 实例
 */
- (void)manager:(QmjkDeviceManager *)manager disconnectedPeripheral:(CBPeripheral *)peripheral;

#pragma mark - 蓝牙OTA相关代理

/**
 OTA升级和下载固件包过程

 @param manager 实例
 @param progress 进程 0-100
 @param code 
             0 - 下载成功
             1 - 下载中
             2 - 下载失败
             3 - 升级成功
             4 - 升级中
             5 - 升级失败
             6 - 当前设备已是最新版本
             7 - 未连接蓝牙设备
 */
- (void)manager:(QmjkDeviceManager *)manager progress:(int)progress message:(NSString *)msg code:(int)code;

@end

#pragma mark - 数据源

@protocol QmjkDataSource <NSObject>

@optional

/**
 获取夹子传过来的数据
 
 @param manager 实例
 @param dataArray 数据类型 [红外，红光]
 @param errMsg 接收数据的时候会因为设备未插入或者手指未插入而失败！errMsg中会打印出失败原因。
 errMsg.length = 0 代表接收数据成功
 */
- (void)manager:(QmjkDeviceManager *)manager receiveData:(NSArray *)dataArray error:(NSString *)errMsg;

@end

#pragma mark - log 代理

@protocol QmjkLogDelegate <NSObject>

@optional

/**
 打印信息

 @param manager 实例
 @param info    {@"message":@"", @"code":0}
 */
- (void)manager:(QmjkDeviceManager *)manager logInfo:(NSDictionary *)info;

@end


@interface QmjkDeviceManager : NSObject

/**
 delegate
 */
@property (nonatomic, weak) id<QmjkDeviceManagerDelegate>delegate;
@property (nonatomic, weak) id<QmjkDataSource>dataSource;
@property (nonatomic, weak) id<QmjkLogDelegate>logDelegate;

/**
 是否自动连接蓝牙设备 - 默认为YES
 */
@property (nonatomic, assign) BOOL isAutoConnectPeripheral;

/**
 当前连接的蓝牙设备
 */
@property (nonatomic, strong, readonly) CBPeripheral *peripheral;

/**
 设置蓝牙搜索名称
 */
@property (nonatomic, copy) NSString *BleSearchName;

/**
 设置连接是否闪光 0:不闪 1:闪一下 2:长亮
 */
@property (nonatomic, assign) int flashlight;

/**
 创建单例
 */
+ (instancetype)manager;

/**
 通过appid和appkey注册， 在appDelegate.m中调用
 */
- (void)registAppWithAppID:(NSString *)appID appKey:(NSString *)appKey;

- (void)setUserInfo:(int)age sex:(int)sex weight:(int)weight height:(int)height low:(int)low high:(int)high;

/**
 开始接收数据
 link - manager:receiveData:error:
 失败原因：
    未插入音频设备或未连接蓝牙设备
 */
- (BOOL)startTest;

/**
 停止接收数据 断开设备
 */
- (void)stopTest;

/**
 扫描蓝牙设备
 */
- (void)startScan;

/**
 停止扫描
 */
- (void)stopScan;

/**
 设置蓝牙搜索名称
 */
- (void)setBleSearchname:(NSString *)name;

/**
 连接蓝牙设备
 link - manager:connectPeripheralIsSuccess:
 */
- (void)connectBleDevice:(CBPeripheral *)peripheral;

/**
 断开蓝牙设备 - 默认一次只能连接一个蓝牙设备，所以这里不需要提供设备信息
 */
- (void)disconnectBleDevice;

/**
 重启蓝牙设备
 */
- (void)rebootBle;

/**
 获取设备id
 */
- (NSString *)getDeviceId;

/**
 检测手指是否插入

 @return 0未启动 1已插入 2未插入
 */
- (int)getFingerSence;

/**
 检测设备是否插入
 */
- (BOOL)getDeviceSence;

/**
 获取心率
 */
- (double)getMonitorRate;

/**
 获取血氧
 */
- (double)getMonitorOxygen;

/**
 获取低压
 */
- (double)getMonitorLow;

/**
 获取高压
 */
- (double)getMonitorHigh;

/**
 获取PI
 */
- (double)getMonitorPI;

/**
 获取呼吸频率
 */
- (double)getMonitorBreath;

/**
 获取蓝牙设备电量
 */
- (int)readBattery;

/**
 获取蓝牙设备版本号
 */
- (NSString *)getBLEDeviceVersion;

/**
 获取SDK版本号
 */
- (NSString *)getSDKVersionCode;

/**
 检查蓝牙设备版本
 */
- (void)examineFirmwareVersion;

/**
 蓝牙是否连接
 */
- (BOOL)isBleconnected;

/**
 程序销毁调用
 */
- (void)quit;

#pragma mark - 蓝牙OTA相关

/**
 执行行固件升级
 
 @link - manager:progress:message:code
 return NO 代表当前已经是最新版本
 */
- (BOOL)firmwareUpdateByUrl;

/*****  新增独立的固件下载. 固件升级方法  *****/
- (void)firmwareUpdateDownloadFirmwareSuccess:(void (^)(NSURL *filePath))success failure:(void (^)(NSError *error))failure;

/**
 根据固件的url地址升级蓝牙设备
 
 @param filePath 固件的url地址
 */
- (void)firmwareUpdateByFile:(NSURL *)filePath;


@end
