//
//  APPNetworkConfig.h
//  Erp4iOS
//	域名网络接口
//  Created by fakepinge on 17/5/23.
//  Copyright © 2017年 成都好房通科技股份有限公司. All rights reserved.
//

#ifndef APPNetworkConfig_h
#define APPNetworkConfig_h

#import "APPNetworkHelper.h"

/* --------------------------------- 域名配置 ----------------------------------*/
/**
 服务器环境模式：0-线上模式(生产和线上灰度) 1-开发模式 2-测试模式(包含各种测试环境) 3-灰度模式(包含各种本地灰度模式)
 对DEBUGMODE进行分类 主要处理各种key的配置
 */
#define SERVER_MODE_TYPE [APPNetworkHelper getServerModeType]

/**
 DEBUGMODE
 服务器默认环境配置：0-正式生产环境 1-dev测试环境 2-app测试环境 3-erp测试环境 4-备用测试环境 5-app验收环境 6-erp验收环境 7-ts环境 8-本地灰度环境 9-线上灰度环境 10-hft灰度环境
 */
extern NSInteger DEBUGMODE;
/* --------------------------- 请求域名(默认的主域名) ----------------------------*/
/**
 主域名-项目名自己拼接
 */
#define MAIN_SERVICE_BASE_STR               [APPNetworkHelper getDynamicMainBaseUrlStr]
/* -------------------------- 请求域名定义(包含项目名) ----------------------------*/
/**
 mobileWeb
 */
#define ERP_SERVICE_BASE_STR				[APPNetworkHelper getDynamicMobileWebBaseUrlStr]
/**
 houseWeb
 */
#define HOUSE_SERVICE_BASE_STR				[APPNetworkHelper getDynamicHouseWebBaseUrlStr]
/* ----------------------------- 请求域名拼接path -------------------------------*/
/**
 主域名-path
 */
#define MAIN_SERVICE(path)                  [APPNetworkHelper getDynamicMainBaseUrlWithPath:(path)]
/**
 mobileWeb-path
 */
#define MOBILE_SERVICE(path)                [APPNetworkHelper getDynamicMobileWebBaseUrlWithPath:(path)]
/**
 houseWeb-path
 */
#define HOUSE_SERVICE(path)                 [APPNetworkHelper getDynamicHouseWebBaseUrlWithPath:(path)]

/* ------------------------------- 请求参数加密 ---------------------------------*/
/**
 请求参数是否加密
 */
#define REQUEST_AES							[APPNetworkHelper getRequstParamsAES]
/* -------------------------------- 服务器时间 ----------------------------------*/
/**
 获取服务器时间 服务器与本地时间处理后的时间date errorTimeInterval最大的误差秒数
 */
#define kServerTimeDate(errorTimeInterval)   [APPNetworkHelper getTimeWithErrorTimeInterval:errorTimeInterval]
/**
 获取服务器时间 服务器与本地时间处理后的时间date 默认误差10分钟
 */
#define kServerTimeDefaultDate                kServerTimeDate(600)

/**
 保存服务器时间的key NSUserDefault 这个只是纯粹的服务器的时间
 */
#define kServerTimeStrKey                    @"kServerTimeStrKey"

#endif /* APPNetworkConfig_h */
