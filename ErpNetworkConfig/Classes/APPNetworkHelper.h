//
//  APPNetworkHelper.h
//  Erp4iOS
//	控制请求域名
//  Created by fakepinge on 17/5/23.
//  Copyright © 2017年 成都好房通科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFTConfigParams.h"

NS_ASSUME_NONNULL_BEGIN

// 动态域名获取完成的通知key
FOUNDATION_EXTERN NSNotificationName const ErpNetworkCinfigDidFinishDynamicDomainNotification;


@interface APPNetworkHelper : NSObject

/**
 获取服务器地址
 */
+ (void)getServerBaseUrl;

/**
 获取官网域名
 
 @return 官网域名
 */
+ (NSString *)getOrgBaseUrl;

/**
 获取香港互通域名
 */
+ (NSString *)getHKBaseUrl;

/**
 获取主域名
 
 @return 主域名
 */
+ (NSString *)getDynamicMainBaseUrlStr;
+ (NSString *)getDynamicMainBaseUrlWithPath:(NSString *)path;

/**
 获取mobileWeb域名

 @return mobileWeb域名
 */
+ (NSString *)getDynamicMobileWebBaseUrlStr;
+ (NSString *)getDynamicMobileWebBaseUrlWithPath:(NSString *)path;

/**
 获取houseWeb域名
 
 @return houseWeb域名
 */
+ (NSString *)getDynamicHouseWebBaseUrlStr;
+ (NSString *)getDynamicHouseWebBaseUrlWithPath:(NSString *)path;

/**
 服务器环境模式
 */
+ (NSInteger)getServerModeType;

/**
 获取是否参数加密
 
 @return  获取是否参数加密
 */
+ (BOOL)getRequstParamsAES;

/**
 获取是否使用动态域名
 
 @return  获取是否使用动态域名
 */
+ (BOOL)getUserDynamicDomainMode;

/**
 获取配置参数
 */
+ (HFTConfigParams *)getConfigParams;

/**
 获取服务器时间

 @param errorTimeInterval 服务器与本地时间的误差最大值
 @return 当前时间的date
 */
+ (NSDate *)getTimeWithErrorTimeInterval:(long long)errorTimeInterval;

@end

@interface ServerBaseUrlModel : NSObject

/**defaultDomain域名*/
@property (nonatomic, copy) NSString *defaultDomain;
/**mobileWeb域名*/
@property (nonatomic, copy) NSString *mobileWebDomain;
/**houseWeb域名*/
@property (nonatomic, copy) NSString *houseWebDomain;
/**域名模式*/
@property (nonatomic, assign) NSInteger domainMode;
/**是否开启听云*/
@property (nonatomic, assign) BOOL openTingyun;

@end



@interface APPDebug:NSObject

/**
 保存运行环境
 */
+ (void)saveDebugModeStatus:(NSInteger)status;
    
/**
 获取运行模式
 */
+ (NSInteger)getDebugModeStatus;

/**
 保存加密模式
 */
+ (void)saveRequestAesStatus:(NSInteger)status;

/**
 保存加密模式
 */
+ (NSInteger)getRequestAesStatus;

@end

NS_ASSUME_NONNULL_END


