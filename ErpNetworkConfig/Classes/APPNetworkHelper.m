//
//  APPNetworkHelper.m
//  Erp4iOS
//  控制请求域名
//  Created by fakepinge on 17/5/23.
//  Copyright © 2017年 成都好房通科技股份有限公司. All rights reserved.
//

#import "APPNetworkHelper.h"
#import <HFTCommonDefinition/HFTCommonDefinition.h>
#import <ErpCommon/ErpCommonDefinition.h>
#import <HFTTools/HFTDeviceIdHeader.h>
#import <MJExtension/MJExtension.h>
#import <HFTCategroy/NSString+Utils.h>
#import <HFTCategroy/NSDate+Format.h>
#import <HFTCategroy/NSDate+Ticks.h>

#ifdef DEBUG

#if DEBUG
#define TEST_ENV_QA          1
#define TEST_ENV_PRODUCTION  0
#else
#define TEST_ENV_QA          0
#define TEST_ENV_PRODUCTION  1
#endif

#else

#define TEST_ENV_QA          0
#define TEST_ENV_PRODUCTION  1

#endif

typedef NS_ENUM(NSInteger, NetWorkEnvironmentStatus) {
    NetWorkEnvironmentReleaseProduct            = 0, // 正式生产环境
//    NetWorkEnvironmentDevTest                   = 1, // dev测试环境
//    NetWorkEnvironmentCompanyAppTest            = 2, // app测试环境
//    NetWorkEnvironmentCompanyErpTest            = 3, // erp测试环境
//    NetWorkEnvironmentCompanyBackUpTest         = 4, // 备用测试环境
//    NetWorkEnvironmentAppVerify                 = 5, // app验收环境
//    NetWorkEnvironmentErpVerify                 = 6, // erp验收环境
//    NetWorkEnvironmentTS                        = 7, // ts环境
//    NetWorkEnvironmentGray                      = 8, // 本地灰度环境
//    NetWorkEnvironmentReleaseGray               = 9, // 线上灰度环境
    NetWorkEnvironmentHftGray                   = 10, // hft灰度环境
    NetWorkEnvironmentMLUat                     = 1, // 美联uat环境
    NetWorkEnvironmentML_RECMS_TEST             = 2, // 美联本地测试环境
    NetWorkEnvironmentMLTEST                    = 3, // 美联测试环境
    NetWorkEnvironmentMLDEMO                    = 4, // 美联demo环境
    NetWorkEnvironmentMLDEV                     = 5, // 美联开发环境
    NetWorkEnvironmentML_MLDEV                  = 6, // 美联mldev环境
    NetWorkEnvironmentML_SIT                    = 7, // 美联sit环境
    NetWorkEnvironmentML_MLSIT                  = 8, // 美联mlsit环境
    NetWorkEnvironmentML_guocai                 = 9, // 美联国才环境
    NetWorkEnvironmentML_fujianyong             = 10, // 美联国才环境
    NetWorkEnvironmentGray                      = 11, // 本地灰度环境
};

NSNotificationName const ErpNetworkCinfigDidFinishDynamicDomainNotification = @"ErpNetworkCinfigDidFinishDynamicDomainNotification";

#define ErpNetworkKitDeveloperDebugModeKey @"ErpNetworkKitDeveloperDebugModeKey"
#define ErpNetworkKitRequestAesKey @"ErpNetworkKitRequestAesKey"


/*
 * 控制请求域名
 */
/********************************* 配置开关 **********************************/

#if TEST_ENV_QA

/*===============================*/
/*        DEBUG(开发环境)         */
/*===============================*/

// ⚠️⚠️⚠️⚠️⚠️服务器默认环境配置：0-正式生产环境 1-dev测试环境 2-app测试环境 3-erp测试环境 4-备用测试环境 5-app验收环境 6-erp验收环境 7-ts环境 8-本地灰度环境 9-线上灰度环境 10-hft灰度环境
#define kDEBUGMODE 2

// ⚠️⚠️⚠️⚠️⚠️动态域名开关：0-不使用 1-使用
#define kDYNAMIC_DOMAIN_MODE 0

// ⚠️⚠️⚠️⚠️⚠️测试环境网络请求参数加密开关：0-不使用 1-使用  动态域名下默认是1
#define kREQUEST_AES 0

#endif


#if TEST_ENV_PRODUCTION
/*===============================*/
/*     RELEASE(生产环境 勿动)      */
/*===============================*/

// ⚠️⚠️⚠️⚠️⚠️服务器默认环境配置：0-正式生产环境 1-dev测试环境 2-app测试环境 3-erp测试环境 4-备用测试环境 5-app验收环境 6-erp验收环境 7-ts环境 8-本地灰度环境 9-线上灰度环境 10-hft灰度环境 11-美联uat环境 12-美联本地环境
#define kDEBUGMODE 0
// ⚠️⚠️⚠️⚠️⚠️动态域名开关：0-不使用 1-使用
#define kDYNAMIC_DOMAIN_MODE 1
// ⚠️⚠️⚠️⚠️⚠️测试环境网络请求参数加密开关：0-不使用 1-使用  动态域名下默认是1
#define kREQUEST_AES 1

#endif


/******************************* 美丽的分割线 *********************************/


/*===============================*/
/*        DEBUG(开发环境)         */
/*===============================*/

////1 dev测试服务器
//#define kDYNAMIC_DOMAIN_LOCAL_DEV_STR                   @"http://mldev.51vfang.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_LOCAL_DEV_SERVICE_BASE_STR                @"http://mldev.51vfang.cn/"
//#define kMOBILE_LOCAL_DEV_SERVICE_BASE_STR              @"http://mldev.51vfang.cn/mobileWeb/"
//#define kHOUSE_LOCAL_DEV_SERVICE_BASE_STR               @"http://mldev.51vfang.cn/houseWeb/"
//
////2 app测试服务器
//#define kDYNAMIC_DOMAIN_COMPANY_APP_TEST_STR            @"http://recapis-uat.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_COMPANY_APP_TEST_SERVICE_BASE_STR         @"http://recapis-uat.midlandmap.cn/"
//#define kMOBILE_COMPANY_APP_TEST_SERVICE_BASE_STR       @"http://recapis-uat.midlandmap.cn/mobileWeb/"
//#define kHOUSE_COMPANY_APP_TEST_SERVICE_BASE_STR        @"http://recapis-uat.midlandmap.cn/houseWeb/"
//
////3 erp测试服务器 /
//#define kDYNAMIC_DOMAIN_COMPANY_ERP_TEST_STR            @"http://recapis-uat.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_COMPANY_ERP_TEST_SERVICE_BASE_STR         @"http://recapis-uat.midlandmap.cn/"
//#define kMOBILE_COMPANY_ERP_TEST_SERVICE_BASE_STR       @"http://recapis-uat.midlandmap.cn/mobileWeb/"
//#define kHOUSE_COMPANY_ERP_TEST_SERVICE_BASE_STR        @"http://recapis-uat.midlandmap.cn/houseWeb/"
//
////4 备用测试环境
//#define kDYNAMIC_DOMAIN_COMPANY_BACKUP_TEST_STR          @"http://testbackup.51vfang.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_COMPANY_BACKUP_TEST_SERVICE_BASE_STR       @"http://testbackup.51vfang.cn/"
//#define kMOBILE_COMPANY_BACKUP_TEST_SERVICE_BASE_STR     @"http://testbackup.51vfang.cn/mobileWeb/"
//#define kHOUSE_COMPANY_BACKUP_TEST_SERVICE_BASE_STR      @"http://testbackup.51vfang.cn/houseWeb/"
//
////5 app验收环境
//#define kDYNAMIC_DOMAIN_APPGRAY_STR                      @"http://appverify.51vfang.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_APPGRAY_SERVICE_BASE_STR                   @"http://appverify.51vfang.cn/"
//#define kMOBILE_APPGRAY_SERVICE_BASE_STR                 @"http://appverify.51vfang.cn/mobileWeb/"
//#define kHOUSE_APPGRAY_SERVICE_BASE_STR                  @"http://appverify.51vfang.cn/houseWeb/"
//
////6 erp验收环境
//#define kDYNAMIC_DOMAIN_ERPGRAY_STR                      @"http://erpverify.51vfang.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_ERPGRAY_SERVICE_BASE_STR                   @"http://erpverify.51vfang.cn/"
//#define kMOBILE_ERPGRAY_SERVICE_BASE_STR                 @"http://erpverify.51vfang.cn/mobileWeb/"
//#define kHOUSE_ERPGRAY_SERVICE_BASE_STR                  @"http://erpverify.51vfang.cn/houseWeb/"
//
////7 ts环境
//#define kDYNAMIC_DOMAIN_TSGRAY_STR                       @"http://ts.51vfang.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_TSGRAY_SERVICE_BASE_STR                    @"http://ts.51vfang.cn/"
//#define kMOBILE_TSGRAY_SERVICE_BASE_STR                  @"http://ts.51vfang.cn/mobileWeb/"
//#define kHOUSE_TSGRAY_SERVICE_BASE_STR                   @"http://ts.51vfang.cn/houseWeb/"
//
////8 本地灰度环境
#define kDYNAMIC_DOMAIN_GRAY_STR                         @"http://gray.51vfang.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_GRAY_SERVICE_BASE_STR                      @"http://gray.51vfang.cn/"
#define kMOBILE_GRAY_SERVICE_BASE_STR                    @"http://gray.51vfang.cn/mobileWeb/"
#define kHOUSE_GRAY_SERVICE_BASE_STR                     @"http://gray.51vfang.cn/houseWeb/"
//
////9 线上灰度环境
//#define kDYNAMIC_DOMAIN_RELEASE_GRAY_STR                 @"http://gray.myfun7.com/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_RELEASE_GRAY_SERVICE_BASE_STR              @"http://gray.myfun7.com/"
//#define kMOBILE_RELEASE_GRAY_SERVICE_BASE_STR            @"http://gray.myfun7.com/mobileWeb/"
//#define kHOUSE_RELEASE_GRAY_SERVICE_BASE_STR             @"http://gray.myfun7.com/houseWeb/"
//
//// 10 51vf灰度
//#define kDYNAMIC_DOMAIN_HftVfangGRAY_STR                 @"http://hft.51vfang.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
//#define kMAIN_HftVfangGRAY_SERVICE_BASE_STR              @"http://hft.51vfang.cn/"
//#define kMOBILE_HftVfangGRAY_SERVICE_BASE_STR            @"http://hft.51vfang.cn/mobileWeb/"
//#define kHOUSE_HftVfangGRAY_SERVICE_BASE_STR             @"http://hft.51vfang.cn/houseWeb/"

// 11 美联uat环境
#define kDYNAMIC_DOMAIN_ML_UAT   @"http://recapis-uat.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_UAT             @"http://recapis-uat.midlandmap.cn/"
#define kMOBILE_ML_UAT           @"http://recapis-uat.midlandmap.cn/mobileWeb/"
#define kHOUSE_ML_UAT            @"http://recapis-uat.midlandmap.cn/houseWeb/"

// 12 美联本地环境
#define kDYNAMIC_ML_RECMS_TEST     @"https://recms-test.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_RECMS_TEST        @"https://recms-test.midlandmap.cn/"
#define kMOBILE_ML_RECMS_TEST      @"https://recms-test.midlandmap.cn/mobileWeb/"
#define kHOUSE_ML_RECMS_TEST       @"https://recms-test.midlandmap.cn/houseWeb/"

// 13 美联测试环境
#define kDYNAMIC_ML_TEST    @"http://recapis-test.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_TEST        @"http://recapis-test.midlandmap.cn/"
#define kMOBILE_ML_TEST      @"http://recapis-test.midlandmap.cn/mobileWeb/"
#define kHOUSE_ML_TEST       @"http://recapis-test.midlandmap.cn/houseWeb/"

// 14 美联demo环境
#define kDYNAMIC_ML_DEMO    @"http://recms-demo.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_DEMO        @"http://recms-demo.midlandmap.cn/"
#define kMOBILE_ML_DEMO      @"http://recms-demo.midlandmap.cn/mobileWeb/"
#define kHOUSE_ML_DEMO       @"http://recms-demo.midlandmap.cn/houseWeb/"

// 15 美联开发环境
#define kDYNAMIC_ML_DEV    @"https://recms-dev.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_DEV        @"https://recms-dev.midlandmap.cn/"
#define kMOBILE_ML_DEV      @"https://recms-dev.midlandmap.cn/mobileWeb/"
#define kHOUSE_ML_DEV       @"https://recms-dev.midlandmap.cn/houseWeb/"

// 16 美联mldev环境
#define kDYNAMIC_ML_MLDEV    @"http://recapis-mldev.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_MLDEV        @"http://recapis-mldev.midlandmap.cn/"
#define kMOBILE_ML_MLDEV      @"http://recapis-mldev.midlandmap.cn/mobileWeb/"
#define kHOUSE_ML_MLDEV       @"http://recapis-mldev.midlandmap.cn/houseWeb/"

// 17 美联Sit环境
#define kDYNAMIC_ML_SIT    @"https://recms-sit.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_SIT        @"https://recms-sit.midlandmap.cn/"
#define kMOBILE_ML_SIT      @"https://recms-sit.midlandmap.cn/mobileWeb/"
#define kHOUSE_ML_SIT       @"https://recms-sit.midlandmap.cn/houseWeb/"

// 18 美联MLSit环境
#define kDYNAMIC_ML_MLSIT    @"https://recms-mlsit.midlandmap.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_MLSIT        @"https://recms-mlsit.midlandmap.cn/"
#define kMOBILE_ML_MLSIT      @"https://recms-mlsit.midlandmap.cn/mobileWeb/"
#define kHOUSE_ML_MLSIT       @"https://recms-mlsit.midlandmap.cn/houseWeb/"

// 19 国才本地环境
#define kDYNAMIC_ML_guocai    @"http://10.1.129.65:8080/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_guocai        @"http://10.1.129.65:8080/"
#define kMOBILE_ML_guocai      @"http://10.1.129.65:8080/mobileWeb/"
#define kHOUSE_ML_guocai       @"http://10.1.129.65:8080/houseWeb/"

// 19 符健永本地环境
#define kDYNAMIC_ML_fujianyong    @"http://10.1.129.68:8080/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_ML_fujianyong        @"http://10.1.129.68:8080/"
#define kMOBILE_ML_fujianyong      @"http://10.1.129.68:8080/mobileWeb/"
#define kHOUSE_ML_fujianyong       @"http://10.1.129.68:8080/houseWeb/"

/*===============================*/
/*     RELEASE(生产环境 勿动)      */
/*===============================*/

#define kDYNAMIC_DOMAIN_RELEASE_STR                     @"https://recms.midland.com.cn/mobileWeb/approveOpenApi/appDomain/getDynamicDomain"
#define kMAIN_RELEASE_SERVICE_BASE_STR                  @"https://recms.midland.com.cn/"
#define kMOBILE_RELEASE_SERVICE_BASE_STR                @"https://recms.midland.com.cn/mobileWeb/"
#define kHOUSE_RELEASE_SERVICE_BASE_STR                 @"https://recms.midland.com.cn/houseWeb/"


#if TEST_ENV_PRODUCTION

// 生产环境
#define kDYNAMIC_DOMAIN_MAIN_STR     kDYNAMIC_DOMAIN_RELEASE_STR
#define kMAIN_SERVICE_BASE_STR       kMAIN_RELEASE_SERVICE_BASE_STR
#define kMOBILE_SERVICE_BASE_STR     kMOBILE_RELEASE_SERVICE_BASE_STR
#define kHOUSE_SERVICE_BASE_STR      kHOUSE_RELEASE_SERVICE_BASE_STR

#elif TEST_ENV_QA

// 开发环境
#define kDYNAMIC_DOMAIN_MAIN_STR     [APPNetworkHelper getDebugDynamicDomainIosConfigUrl]
#define kMAIN_SERVICE_BASE_STR       [APPNetworkHelper getDebugMainBaseUrl]
#define kMOBILE_SERVICE_BASE_STR     [APPNetworkHelper getDebugMobileBaseUrl]
#define kHOUSE_SERVICE_BASE_STR      [APPNetworkHelper getDebugHouseBaseUrl]

#endif


#if (kDYNAMIC_DOMAIN_MODE)
#undef kMAIN_SERVICE_BASE_STR
#undef kMOBILE_SERVICE_BASE_STR
#undef kHOUSE_SERVICE_BASE_STR
#undef kREQUEST_AES

#define kMAIN_SERVICE_BASE_STR       [APPNetworkHelper getMainBaseUrl]
#define kMOBILE_SERVICE_BASE_STR     [APPNetworkHelper getMobileBaseUrl]
#define kHOUSE_SERVICE_BASE_STR      [APPNetworkHelper getHouseBaseUrl]
#define kREQUEST_AES                 1
#endif

NSInteger DEBUGMODE = kDEBUGMODE;

@implementation APPNetworkHelper

static ServerBaseUrlModel *baseUrlModel = nil;

+ (void)load {
    kSaveDeviceIdentifierIdString;
#if TEST_ENV_QA
//    UserDefaultRemoveObjectForKey(ErpNetworkKitDeveloperDebugModeKey);
    // 设置默认网络运行环境
    [APPDebug saveDebugModeStatus:[APPDebug getDebugModeStatus]];
    [APPDebug saveRequestAesStatus:kREQUEST_AES];
#endif
    // 开启了动态域名才获取动态域名
//    if (kDYNAMIC_DOMAIN_MODE) {
//        [self getServerBaseUrl];
//    }
}

+ (void)getServerBaseUrl {
    NSString *requestUrl = kDYNAMIC_DOMAIN_MAIN_STR;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"2" forKey:@"deviceType"];
    [dict setObject:APP_VERSION forKey:@"versionNo"];
    [dict setObject:kDeviceIdentifierIdString forKey:@"identifier"];
    if ([APP_BUNDLE_ID isEqualToString:kBundleIdForErpApp]) {
        [dict setObject:@"4" forKey:@"appSource"];
    } else if ([APP_BUNDLE_ID isEqualToString:kBundleIdForFkdApp]) {
        [dict setObject:@"8" forKey:@"appSource"];
    } else if ([APP_BUNDLE_ID isEqualToString:kBundleIdForYltApp]) {
        [dict setObject:@"10" forKey:@"appSource"];
    }
    if (kAppProjectType || kAppProjectType.length > 0) {
        [dict setObject:kAppProjectType forKey:@"projectType"];
    } else {
        [dict setObject:@"1" forKey:@"projectType"];
    }
    requestUrl = [NSString getParamsStringWithParamsDict:dict andUrlString:requestUrl];
    NSURL *URL = [NSURL URLWithString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    for (NSString *key in dict.allKeys) {
        [mutableRequest addValue:dict[key] forHTTPHeaderField:key];
    }
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [mutableRequest setHTTPBody:dictData];
    [mutableRequest setHTTPMethod:@"POST"];
    request = [mutableRequest copy];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) { // 发生错误
            baseUrlModel = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:ErpNetworkCinfigDidFinishDynamicDomainNotification object:nil];
            return;
        }
        // 正常请求
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!resultDict || !resultDict[@"data"] || ![resultDict[@"data"] isKindOfClass:[NSDictionary class]]) {
            baseUrlModel = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:ErpNetworkCinfigDidFinishDynamicDomainNotification object:nil];
            return;
        }
        ServerBaseUrlModel *model = [ServerBaseUrlModel mj_objectWithKeyValues:resultDict[@"data"]];
        if (!model) {
            baseUrlModel = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:ErpNetworkCinfigDidFinishDynamicDomainNotification object:nil];
            return;
        }
        baseUrlModel = model;
        UserDefaultSetObjectForKey(resultDict[@"serverTime"], @"kServerTimeStrKey");
        NSDictionary *dataDict = resultDict[@"data"];
        if (![dataDict.allKeys containsObject:@"domainMode"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ErpNetworkCinfigDidFinishDynamicDomainNotification object:nil];
            return;
        }
        if (baseUrlModel.defaultDomain.length > 0) {
            DEBUGMODE = [self getNetWorkEnvironmentStatus:baseUrlModel.defaultDomain];
        } else {
            DEBUGMODE = baseUrlModel.domainMode;
        }
        if ([[NSClassFromString(@"ErpVendoredConfig") class] respondsToSelector:NSSelectorFromString(@"vendoredKeyConfig")]) {
            [[NSClassFromString(@"ErpVendoredConfig") class] performSelector:NSSelectorFromString(@"vendoredKeyConfig") withObject:nil];
        }
#if TEST_ENV_QA
        // 设置默认网络运行环境
        [APPDebug saveDebugModeStatus:DEBUGMODE];
#endif
        [[NSNotificationCenter defaultCenter] postNotificationName:ErpNetworkCinfigDidFinishDynamicDomainNotification object:nil];
    }] resume];
}

+ (NSString *)getOrgBaseUrl {
    return @"https://recms.midland.com.cn";
}

+ (NSString *)getHKBaseUrl {
    NSInteger status = [APPDebug getDebugModeStatus];
    if (status == NetWorkEnvironmentMLUat) {
        return @"https://recms-uat.midlandmap.cn/";
    }
    return MAIN_SERVICE_BASE_STR;
}

+ (NSInteger)getServerModeType {
#if TEST_ENV_QA
    NSInteger status = [APPDebug getDebugModeStatus];
#elif TEST_ENV_PRODUCTION
    NSInteger status = DEBUGMODE;
#endif
    NSInteger serverModeType = 0;
    switch (status) {
        case NetWorkEnvironmentReleaseProduct:      // 生产环境
//        case NetWorkEnvironmentReleaseGray:         // 线上灰度环境
            serverModeType = 0;
            break;
//        case NetWorkEnvironmentDevTest:             // dev测试环境
//        case NetWorkEnvironmentCompanyAppTest:      // app测试环境
//        case NetWorkEnvironmentCompanyErpTest:      // erp测试环境
//        case NetWorkEnvironmentCompanyBackUpTest:   // 备用测试环境
        case NetWorkEnvironmentML_RECMS_TEST:       // 美联recms测试
        case NetWorkEnvironmentMLUat:               // 美联uat环境
        case NetWorkEnvironmentMLTEST:              // 美联测试环境
        case NetWorkEnvironmentMLDEMO:              // 美联demo环境
        case NetWorkEnvironmentMLDEV:               // 美联dev环境
        case NetWorkEnvironmentML_MLDEV:            // 美联mldev环境
        case NetWorkEnvironmentML_SIT:
        case NetWorkEnvironmentML_MLSIT:
            serverModeType = 2;
            break;
//        case NetWorkEnvironmentAppVerify:           // app验收环境
//        case NetWorkEnvironmentErpVerify:           // erp验收环境
//        case NetWorkEnvironmentTS:                  // ts环境
        case NetWorkEnvironmentGray:                // 本地灰度环境
//        case NetWorkEnvironmentHftGray:             // hft灰度环境
            serverModeType = 2;
            break;
        default:
            break;
    }
    return serverModeType;
}

+ (BOOL)getRequstParamsAES {
    return [APPDebug getRequestAesStatus];
}

+ (BOOL)getUserDynamicDomainMode {
    return [@(kDYNAMIC_DOMAIN_MODE) boolValue];
}

+ (HFTConfigParams *)getConfigParams {
    HFTConfigParams *params = [HFTConfigParams new];
    if (baseUrlModel) {
        params.openTingyun = baseUrlModel.openTingyun;
    }
    return params;
}

+ (NSString *)getDynamicMainBaseUrlStr {
    return kMAIN_SERVICE_BASE_STR;
}

+ (NSString *)getDynamicMainBaseUrlWithPath:(NSString *)path {
    if (!path.isExist) {
        return [self getDynamicMainBaseUrlStr];
    }
    NSString *pathStr = path;
    while ([pathStr hasPrefix:@"/"]) {
        pathStr = [pathStr substringFromIndex:1];
    }
    path = pathStr;
    return [NSString stringWithFormat:@"%@%@", [self getDynamicMainBaseUrlStr], path];
}

+ (NSString *)getDynamicMobileWebBaseUrlStr {
    return kMOBILE_SERVICE_BASE_STR;
}

+ (NSString *)getDynamicMobileWebBaseUrlWithPath:(NSString *)path {
    if (!path.isExist) {
        return [self getDynamicMobileWebBaseUrlStr];
    }
    NSString *pathStr = path;
    while ([pathStr hasPrefix:@"/"]) {
        pathStr = [pathStr substringFromIndex:1];
    }
    path = pathStr;
    return [NSString stringWithFormat:@"%@%@", [self getDynamicMobileWebBaseUrlStr], path];
}

+ (NSString *)getDynamicHouseWebBaseUrlStr {
    return kHOUSE_SERVICE_BASE_STR;
}

+ (NSString *)getDynamicHouseWebBaseUrlWithPath:(NSString *)path {
    if (!path.isExist) {
        return [self getDynamicHouseWebBaseUrlStr];
    }
    NSString *pathStr = path;
    while ([pathStr hasPrefix:@"/"]) {
        pathStr = [pathStr substringFromIndex:1];
    }
    path = pathStr;
    return [NSString stringWithFormat:@"%@%@", [self getDynamicHouseWebBaseUrlStr], path];
}

+ (NSDate *)getTimeWithErrorTimeInterval:(long long)errorTimeInterval {
    NSString *serverStr = UserDefaultObjectForKey(@"kServerTimeStrKey");
    NSDate *serverDate = [serverStr getDateWithFormatStr:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [NSDate date];
    NSDate *currentDate;
    // 本地时间和服务器时间误差在10分钟之内 就用本地时间
    errorTimeInterval = (errorTimeInterval == 0) ? 600 : errorTimeInterval;
    if (![serverStr isExist] || !serverDate || llabs([serverDate ticksTime] - [nowDate ticksTime]) < (errorTimeInterval) * 1000.0) {
        currentDate = nowDate;
    } else {
        currentDate = serverDate;
    }
    return currentDate;
}

#pragma mark ----------------------------- 私有方法 ------------------------------
+ (NSString *)getMainBaseUrl {
    NSString *url = (baseUrlModel && [baseUrlModel.defaultDomain isExist]) ? baseUrlModel.defaultDomain : @"https://recms.midland.com.cn/";
    return url;
}

+ (NSString *)getMobileBaseUrl {
    NSString *url = (baseUrlModel && [baseUrlModel.mobileWebDomain isExist]) ? baseUrlModel.mobileWebDomain : @"https://recms.midland.com.cn/mobileWeb/";
    return url;
}

+ (NSString *)getHouseBaseUrl {
    NSString *url = (baseUrlModel && [baseUrlModel.houseWebDomain isExist]) ? baseUrlModel.houseWebDomain : @"https://recms.midland.com.cn/houseWeb/";
    return url;
}

#pragma mark - debug环境下选择不同的运行环境
+ (NSString *)getDebugDynamicDomainIosConfigUrl {
#if TEST_ENV_QA
    // 开发环境
    NSInteger status = [APPDebug getDebugModeStatus];
    NSString *url = nil;
    switch (status) {
        case NetWorkEnvironmentReleaseProduct:      // 生产环境
            url = kDYNAMIC_DOMAIN_RELEASE_STR;
            break;
//        case NetWorkEnvironmentDevTest:             // dev测试环境
//            url = kDYNAMIC_DOMAIN_LOCAL_DEV_STR;
//            break;
//        case NetWorkEnvironmentCompanyAppTest:      // app测试环境
//            url = kDYNAMIC_DOMAIN_COMPANY_APP_TEST_STR;
//            break;
//        case NetWorkEnvironmentCompanyErpTest:      // erp测试环境
//            url = kDYNAMIC_DOMAIN_COMPANY_ERP_TEST_STR;
//            break;
//        case NetWorkEnvironmentCompanyBackUpTest:   // 备用测试环境
//            url = kDYNAMIC_DOMAIN_COMPANY_BACKUP_TEST_STR;
//            break;
//        case NetWorkEnvironmentAppVerify:           // app验收环境
//            url = kDYNAMIC_DOMAIN_APPGRAY_STR;
//            break;
//        case NetWorkEnvironmentTS:                  // ts环境
//            url = kDYNAMIC_DOMAIN_TSGRAY_STR;
//            break;
//        case NetWorkEnvironmentErpVerify:           // erp验收环境
//            url = kDYNAMIC_DOMAIN_ERPGRAY_STR;
//            break;
        case NetWorkEnvironmentGray:                // 本地灰度环境
            url = kDYNAMIC_DOMAIN_GRAY_STR;
            break;
//        case NetWorkEnvironmentReleaseGray:         // 线上灰度环境
//            url = kDYNAMIC_DOMAIN_RELEASE_GRAY_STR;
//            break;
//        case NetWorkEnvironmentHftGray:             // hft灰度环境
//            url = kDYNAMIC_DOMAIN_HftVfangGRAY_STR;
//            break;
        case NetWorkEnvironmentMLUat:               // 美联uat环境
            url = kDYNAMIC_DOMAIN_ML_UAT;
            break;
        case NetWorkEnvironmentML_RECMS_TEST:       // 美联recms测试
            url = kDYNAMIC_ML_RECMS_TEST;
            break;
        case NetWorkEnvironmentMLTEST:              // 美联测试环境
            url = kDYNAMIC_ML_TEST;
            break;
        case NetWorkEnvironmentMLDEMO:              // 美联demo环境
            url = kDYNAMIC_ML_DEMO;
            break;
        case NetWorkEnvironmentMLDEV:               // 美联dev环境
            url = kDYNAMIC_ML_DEV;
            break;
        case NetWorkEnvironmentML_MLDEV:            // 美联mldev环境
            url = kDYNAMIC_ML_MLDEV;
            break;
        case NetWorkEnvironmentML_SIT:
            url = kDYNAMIC_ML_SIT;
            break;
        case NetWorkEnvironmentML_MLSIT:
            url = kDYNAMIC_ML_MLSIT;
            break;
        case NetWorkEnvironmentML_guocai:
            url = kDYNAMIC_ML_guocai;
            break;
        case NetWorkEnvironmentML_fujianyong:
            url = kDYNAMIC_ML_fujianyong;
            break;
        default:
            url = kDYNAMIC_DOMAIN_RELEASE_STR;
            break;
    }
    return url;
#elif TEST_ENV_PRODUCTION
    // 生成环境
    return kDYNAMIC_DOMAIN_RELEASE_STR;
#endif
}

+ (NSString *)getDebugMainBaseUrl {
#if TEST_ENV_QA
    // 开发环境
    NSInteger status = [APPDebug getDebugModeStatus];
    NSString *url = nil;
    switch (status) {
        case NetWorkEnvironmentReleaseProduct:      // 生产环境
            url = kMAIN_RELEASE_SERVICE_BASE_STR;
            break;
//        case NetWorkEnvironmentDevTest:             // dev测试环境
//            url = kMAIN_LOCAL_DEV_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyAppTest:      // app测试环境
//            url = kMAIN_COMPANY_APP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyErpTest:      // erp测试环境
//            url = kMAIN_COMPANY_ERP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyBackUpTest:   // 备用测试环境
//            url = kMAIN_COMPANY_BACKUP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentAppVerify:           // app验收环境
//            url = kMAIN_APPGRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentTS:                  // ts环境
//            url = kMAIN_TSGRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentErpVerify:           // erp验收环境
//            url = kMAIN_ERPGRAY_SERVICE_BASE_STR;
//            break;
        case NetWorkEnvironmentGray:                // 本地灰度环境
            url = kMAIN_GRAY_SERVICE_BASE_STR;
            break;
//        case NetWorkEnvironmentReleaseGray:         // 线上灰度环境
//            url = kMAIN_RELEASE_GRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentHftGray:             // hft灰度环境
//            url = kMAIN_HftVfangGRAY_SERVICE_BASE_STR;
//            break;
        case NetWorkEnvironmentMLUat:               // 美联uat环境
            url = kMAIN_ML_UAT;
            break;
        case NetWorkEnvironmentML_RECMS_TEST:       // 美联recms测试
            url = kMAIN_ML_RECMS_TEST;
            break;
        case NetWorkEnvironmentMLTEST:              // 美联测试环境
            url = kMAIN_ML_TEST;
            break;
        case NetWorkEnvironmentMLDEMO:
            url = kMAIN_ML_DEMO;
            break;
        case NetWorkEnvironmentMLDEV:
            url = kMAIN_ML_DEV;
            break;
        case NetWorkEnvironmentML_MLDEV:
            url = kMAIN_ML_MLDEV;
            break;
        case NetWorkEnvironmentML_SIT:
            url = kMAIN_ML_SIT;
            break;
        case NetWorkEnvironmentML_MLSIT:
            url = kMAIN_ML_MLSIT;
            break;
        case NetWorkEnvironmentML_guocai:
            url = kMAIN_ML_guocai;
            break;
        case NetWorkEnvironmentML_fujianyong:
            url = kMAIN_ML_fujianyong;
            break;
        default:
            url = kMAIN_RELEASE_SERVICE_BASE_STR;
            break;
    }
    return url;
#elif TEST_ENV_PRODUCTION
    // 生成环境
    return kMAIN_RELEASE_SERVICE_BASE_STR;
#endif
}

+ (NSString *)getDebugMobileBaseUrl {
#if TEST_ENV_QA
    // 开发环境
    NSInteger status = [APPDebug getDebugModeStatus];
    NSString *url = nil;
    switch (status) {
        case NetWorkEnvironmentReleaseProduct:      // 生产环境
            url = kMOBILE_RELEASE_SERVICE_BASE_STR;
            break;
//        case NetWorkEnvironmentDevTest:             // dev测试环境
//            url = kMOBILE_LOCAL_DEV_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyAppTest:      // app测试环境
//            url = kMOBILE_COMPANY_APP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyErpTest:      // erp测试环境
//            url = kMOBILE_COMPANY_ERP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyBackUpTest:   // 备用测试环境
//            url = kMOBILE_COMPANY_BACKUP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentAppVerify:           // app验收环境
//            url = kMOBILE_APPGRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentTS:                  // ts环境
//            url = kMOBILE_TSGRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentErpVerify:           // erp验收环境
//            url = kMOBILE_ERPGRAY_SERVICE_BASE_STR;
//            break;
        case NetWorkEnvironmentGray:                // 本地灰度环境
            url = kMOBILE_GRAY_SERVICE_BASE_STR;
            break;
//        case NetWorkEnvironmentReleaseGray:         // 线上灰度环境
//            url = kMOBILE_RELEASE_GRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentHftGray:             // hft灰度环境
//            url = kMOBILE_HftVfangGRAY_SERVICE_BASE_STR;
//            break;
        case NetWorkEnvironmentMLUat:               // 美联uat环境
            url = kMOBILE_ML_UAT;
            break;
        case NetWorkEnvironmentML_RECMS_TEST:       // 美联recms测试
            url = kMOBILE_ML_RECMS_TEST;
            break;
        case NetWorkEnvironmentMLTEST:              // 美联测试环境
            url = kMOBILE_ML_TEST;
            break;
        case NetWorkEnvironmentMLDEMO:              // 美联demo环境
            url = kMOBILE_ML_DEMO;
            break;
        case NetWorkEnvironmentMLDEV:               // 美联dev环境
            url = kMOBILE_ML_DEV;
            break;
        case NetWorkEnvironmentML_MLDEV:            // 美联mldev环境
            url = kMOBILE_ML_MLDEV;
            break;
        case NetWorkEnvironmentML_SIT:
            url = kMOBILE_ML_SIT;
            break;
        case NetWorkEnvironmentML_MLSIT:
            url = kMOBILE_ML_MLSIT;
            break;
        case NetWorkEnvironmentML_guocai:
            url = kMOBILE_ML_guocai;
            break;
        case NetWorkEnvironmentML_fujianyong:
            url = kMOBILE_ML_fujianyong;
            break;
        default:
            url = kMOBILE_RELEASE_SERVICE_BASE_STR;
            break;
    }
    return url;
#elif TEST_ENV_PRODUCTION
    // 生成环境
    return kMOBILE_RELEASE_SERVICE_BASE_STR;
#endif
}

+ (NSString *)getDebugHouseBaseUrl {
#if TEST_ENV_QA
    // 开发环境
    NSInteger status = [APPDebug getDebugModeStatus];
    NSString *url = nil;
    switch (status) {
        case NetWorkEnvironmentReleaseProduct:      // 生产环境
            url = kHOUSE_RELEASE_SERVICE_BASE_STR;
            break;
//        case NetWorkEnvironmentDevTest:             // dev测试环境
//            url = kHOUSE_LOCAL_DEV_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyAppTest:      // app测试环境
//            url = kHOUSE_COMPANY_APP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyErpTest:      // erp测试环境
//            url = kHOUSE_COMPANY_ERP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentCompanyBackUpTest:   // 备用测试环境
//            url = kHOUSE_COMPANY_BACKUP_TEST_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentAppVerify:           // app验收环境
//            url = kHOUSE_APPGRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentTS:                  // ts环境
//            url = kHOUSE_TSGRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentErpVerify:           // erp验收环境
//            url = kHOUSE_ERPGRAY_SERVICE_BASE_STR;
//            break;
        case NetWorkEnvironmentGray:                // 本地灰度环境
            url = kHOUSE_GRAY_SERVICE_BASE_STR;
            break;
//        case NetWorkEnvironmentReleaseGray:         // 线上灰度环境
//            url = kHOUSE_RELEASE_GRAY_SERVICE_BASE_STR;
//            break;
//        case NetWorkEnvironmentHftGray:             // hft灰度环境
//            url = kHOUSE_HftVfangGRAY_SERVICE_BASE_STR;
//            break;
        case NetWorkEnvironmentMLUat:               // 美联uat环境
            url = kHOUSE_ML_UAT;
            break;
        case NetWorkEnvironmentML_RECMS_TEST:      // 美联recms测试
            url = kHOUSE_ML_RECMS_TEST;
            break;
        case NetWorkEnvironmentMLTEST:              // 美联测试环境
            url = kHOUSE_ML_TEST;
            break;
        case NetWorkEnvironmentMLDEMO:              // 美联demo环境
            url = kHOUSE_ML_DEMO;
            break;
        case NetWorkEnvironmentMLDEV:              // 美联dev环境
            url = kHOUSE_ML_DEV;
            break;
        case NetWorkEnvironmentML_MLDEV:           // 美联mldev环境
            url = kHOUSE_ML_MLDEV;
            break;
        case NetWorkEnvironmentML_SIT:             // 美联sit环境
            url = kHOUSE_ML_SIT;
            break;
        case NetWorkEnvironmentML_MLSIT:             // 美联sit环境
            url = kHOUSE_ML_MLSIT;
            break;
        case NetWorkEnvironmentML_guocai:
            url = kHOUSE_ML_guocai;
            break;
        case NetWorkEnvironmentML_fujianyong:
            url = kHOUSE_ML_fujianyong;
            break;
        default:
            url = kHOUSE_RELEASE_SERVICE_BASE_STR;
            break;
    }
    return url;
#elif TEST_ENV_PRODUCTION
    // 生成环境
    return kHOUSE_RELEASE_SERVICE_BASE_STR;
#endif
}

+ (NetWorkEnvironmentStatus)getNetWorkEnvironmentStatus:(NSString *)mainUrl {
    NetWorkEnvironmentStatus status = NetWorkEnvironmentReleaseProduct;
    NSString *url = [mainUrl componentsSeparatedByString:@"//"].lastObject;
    if ([kMAIN_RELEASE_SERVICE_BASE_STR containsString:url]) {
        status = NetWorkEnvironmentReleaseProduct;
//    else if ([kMAIN_LOCAL_DEV_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentDevTest;
//    } else if ([kMAIN_COMPANY_APP_TEST_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentCompanyAppTest;
//    } else if ([kMAIN_COMPANY_ERP_TEST_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentCompanyErpTest;
//    } else if ([kMAIN_COMPANY_BACKUP_TEST_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentCompanyBackUpTest;
//    } else if ([kMAIN_APPGRAY_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentAppVerify;
//    } else if ([kMAIN_ERPGRAY_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentErpVerify;
//    } else if ([kMAIN_TSGRAY_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentTS;
    } else if ([kMAIN_GRAY_SERVICE_BASE_STR containsString:url]) {
        status = NetWorkEnvironmentGray;
//    } else if ([kMAIN_RELEASE_GRAY_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentReleaseGray;
//    } else if ([kMAIN_HftVfangGRAY_SERVICE_BASE_STR containsString:url]) {
//        status = NetWorkEnvironmentHftGray;
//    }
    } else if ([kMAIN_ML_UAT containsString:url]) {
        status = NetWorkEnvironmentMLUat;
    } else if ([kMAIN_ML_RECMS_TEST containsString:url]) {
        status = NetWorkEnvironmentML_RECMS_TEST;
    } else if ([kMAIN_ML_TEST containsString:url]) {
        status = NetWorkEnvironmentMLTEST;
    } else if ([kMAIN_ML_DEMO containsString:url]) {
        status = NetWorkEnvironmentMLDEMO;
    } else if ([kMAIN_ML_DEV containsString:url]) {
        status = NetWorkEnvironmentMLDEV;
    } else if ([kMAIN_ML_MLDEV containsString:url]) {
        status = NetWorkEnvironmentML_MLDEV;
    }else if ([kMAIN_ML_SIT containsString:url]) {
        status = NetWorkEnvironmentML_SIT;
    }else if ([kMAIN_ML_MLSIT containsString:url]) {
        status = NetWorkEnvironmentML_MLSIT;
    }else if ([kMAIN_ML_guocai containsString:url]) {
        status = NetWorkEnvironmentML_guocai;
    }else if ([kMAIN_ML_fujianyong containsString:url]) {
        status = NetWorkEnvironmentML_fujianyong;
    }
        
    return status;
}

@end


@implementation APPDebug

+ (void)saveDebugModeStatus:(NSInteger)status {
#if TEST_ENV_QA
    //  0-正式生产环境 1-dev测试环境 2-app测试环境 3-erp测试环境 4-app灰度环境 5-ts灰度环境 6-erp灰度环境 7-线上灰度环境 8-备用测试环境 9-线上灰度环境 10-hft灰度环境 11-美联uat环境 12-美联本地环境
    UserDefaultSetObjectForKey(@(status), ErpNetworkKitDeveloperDebugModeKey);
    DEBUGMODE = status;
    if ([[NSClassFromString(@"ErpVendoredConfig") class] respondsToSelector:NSSelectorFromString(@"vendoredKeyConfig")]) {
        [[NSClassFromString(@"ErpVendoredConfig") class] performSelector:NSSelectorFromString(@"vendoredKeyConfig") withObject:nil];
    }
#endif
}

+ (NSInteger)getDebugModeStatus {
#if TEST_ENV_QA
    //  0-正式生产环境 1-dev测试环境 2-app测试环境 3-erp测试环境 4-app灰度环境 5-ts灰度环境 6-erp灰度环境 7-线上灰度环境 8-备用测试环境 9-线上灰度环境 10-hft灰度环境
    NSNumber *num = UserDefaultObjectForKey(ErpNetworkKitDeveloperDebugModeKey);
    if (num) {
        return [num integerValue];
    } else {
        return kDEBUGMODE;
    }
#endif
    
#if TEST_ENV_PRODUCTION
    return 0;
#endif
}

+ (void)saveRequestAesStatus:(NSInteger)status {
#if TEST_ENV_QA
    UserDefaultSetObjectForKey(@(status), ErpNetworkKitRequestAesKey);
#endif
}

+ (NSInteger)getRequestAesStatus {
#if TEST_ENV_QA
    NSNumber *num = UserDefaultObjectForKey(ErpNetworkKitRequestAesKey);
    if (num) {
        return [num integerValue];
    } else {
        return kREQUEST_AES;
    }
#endif
    
#if TEST_ENV_PRODUCTION
    return 1;
#endif
}

@end

@implementation ServerBaseUrlModel

@end


