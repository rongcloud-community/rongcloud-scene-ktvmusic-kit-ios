//
//  RCSKTVMusicLibraryConfig.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/15.
//

#import "RCSKTVMusicLibraryConfig.h"

@interface RCSKTVMusicLibraryNetConfig : NSObject

/// 网络请求 host
@property (nonatomic, copy) NSString *baseUrl;

/// 网络请求 header  bussinessToken
@property (nonatomic, copy) NSString *businessToken;

/// 网络请求 header 用户登录后返回的 auth
@property (nonatomic, copy) NSString *auth;

@end

@implementation RCSKTVMusicLibraryNetConfig

+ (instancetype)shared {
    static RCSKTVMusicLibraryNetConfig *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[RCSKTVMusicLibraryNetConfig alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    if (self = [super init]) {
        self.baseUrl = @"";
        self.businessToken = @"";
        self.auth = @"";
    }
    return self;
}

@end

@implementation RCSKTVMusicLibraryConfig

- (instancetype)init {
    if (self = [super init]) {
        self.hadCreateRoom = YES;
        self.roomId = @"";
        self.currentUserId = @"";
        self.currentUserName = @"";
        self.currentUserPortrait = @"";
        self.netBaseUrl = @"";
        self.netBusinessToken = @"";
        self.netAuth = @"";
    }
    return self;
}

+ (void)configWithBaseUrl:(NSString *)baseUrl
            businessToken:(nullable NSString *)businessToken
                     auth:(nullable NSString *)auth {
    [RCSKTVMusicLibraryNetConfig shared].baseUrl = baseUrl;
    [RCSKTVMusicLibraryNetConfig shared].businessToken = businessToken;
    [RCSKTVMusicLibraryNetConfig shared].auth = auth;
}

+ (NSString *)baseUrl {
    return [RCSKTVMusicLibraryNetConfig shared].baseUrl;
}

+ (NSString *)businessToken {
    return [RCSKTVMusicLibraryNetConfig shared].businessToken;
}

+ (NSString *)auth {
    return [RCSKTVMusicLibraryNetConfig shared].auth;
}

@end
