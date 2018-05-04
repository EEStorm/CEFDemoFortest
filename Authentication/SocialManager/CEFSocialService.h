//
//  CEFSocialService.h
//  Authentication
//
//  Created by zhangDongdong on 2018/1/10.
//  Copyright © 2018年 micorosoft. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WechatManager.h"
#import "WeiboManager.h"
#import "QQManager.h"
#import "CEFResponse.h"

//#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


typedef enum {
    
    wechat = 0,
    
    QQ = 1,
    
    weibo = 2
    
} Platform;

enum  CEFErrCode {
    CEFSuccess           = 0,    //成功
    CEFErrCodeCommon     = -1,  //普通错误类型
    CEFErrCodeUserCancel = -2,    //用户点击取消并返回
    CEFErrCodeSentFail   = -3,   //发送失败
    CEFErrCodeAuthDeny   = -4,    //授权失败
    CEFErrCodeUnsupport  = -5,   //微信不支持
};


//@interface CEFResponse : NSObject
///** 错误码 */
//@property (nonatomic, assign) int errCode;
///** 错误提示字符串 */
//@property (nonatomic, retain) NSString *errStr;
///** 响应类型 */
//@property (nonatomic, assign) int type;
///** 平台类型 */
//@property (nonatomic, assign) int channel;
//
//@end


@protocol CEFApiDelegate <NSObject>

@optional
- (void)onResopnse:(CEFResponse*) CEFResponse;
@end


typedef void(^SocialCompletion)(NSDictionary *result, NSInteger *error);



@interface CEFSocialService : NSObject<WXApiDelegate,CEFApiDelegate>


@property(copy,nonatomic)SocialCompletion completion;


#pragma mark - 微信

@property(strong,nonatomic)WechatManager * wechatmanager;
@property(assign,nonatomic)NSString* wechatAppkey;
@property(assign,nonatomic)NSString* wechatSecret;


#pragma mark - 微博
@property(strong,nonatomic)WeiboManager *weiboManager;
@property(assign,nonatomic)NSString * weiboAppkey;
@property(assign,nonatomic)NSString * weiboSecret;
@property(assign,nonatomic)NSString * weiboRedirectURL;

#pragma mark - QQ
@property(strong,nonatomic)QQManager * qqManager;
@property(assign,nonatomic)NSString * qqAppkey;
@property(assign,nonatomic)NSString * qqSecret;
@property(assign,nonatomic)NSString * qqRedirectURL;
@property(nonatomic,weak)id<CEFApiDelegate> CEFApiDel;


+(instancetype)defaultManager;

-(void)setPlaform:(Platform)platform appkey:(NSString *)appkey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL withEID:(NSString *)EID;

-(void)loginWithPlatform:(Platform)platform completion:(SocialCompletion)completion;

-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

-(void)registerAuthenticationWithEID:(NSString *)EID delegate:(id<CEFApiDelegate>) delegate;

-(void)initWithWeChatKey:(NSString *)wechatAppkey wechatSecret:(NSString*)wechatSecret wechatRedictUrl:(NSString*)wechatRedictUrl QQKey:(NSString *)QQAppkey QQSecret:(NSString*)QQSecret QQRedictUrl:(NSString*)QQRedictUrl WeiBoKey:(NSString *)WeiBoAppkey WeiBoSecret:(NSString*)WeiBoSecret WeiBoRedictUrl:(NSString*)WeiBoRedictUrl;

@end








