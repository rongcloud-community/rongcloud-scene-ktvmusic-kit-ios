//
//  RCSKTVMusicLibraryConfig.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSKTVMusicLibraryConfig : NSObject

/// 网络请求 host
@property (nonatomic, copy) NSString *netBaseUrl;

/// 网络请求 header  bussinessToken
@property (nonatomic, copy) NSString *netBusinessToken;

/// 网络请求 header 用户登录后返回的 auth
@property (nonatomic, copy) NSString *netAuth;

/// 是否有房间， 默认为YES
@property (nonatomic, assign) BOOL hadCreateRoom;

/// 房间id，语聊房为唯一标识
@property (nonatomic, copy) NSString *roomId;

/// 当前登录id
@property (nonatomic, copy) NSString *currentUserId;

/// 当前登录用户名称
@property (nonatomic, copy) NSString *currentUserName;

/// 当前登录头像
@property (nonatomic, copy) NSString *currentUserPortrait;

+ (void)configWithBaseUrl:(NSString *)baseUrl
            businessToken:(nullable NSString *)bussinessToken
                     auth:(nullable NSString *)auth;

+ (NSString *)baseUrl;
+ (NSString *)businessToken;
+ (NSString *)auth;

@end


NS_ASSUME_NONNULL_END
