//
//  RCSKTVMusicModel.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/12.
//

#import "RCSKTVMusicModel.h"

@interface RCSKTVMusicModel ()

/// left and right channel 左右声道_128_mp3 歌曲资源地址
@property(nonatomic, copy) NSString *lrChannelFileUrl;

@end

@implementation RCSKTVMusicModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"subVersions" : [RCSKTVMusicSubVersionModel class],
    };
}

- (NSString *)dynamicLyricUrl {
    if (self.kugouLyricUrl.length != 0) {
        return _kugouLyricUrl;
    }
    return _dynamicLyricUrl;
}

- (NSString *)fileUrl {
    if (self.lrChannelFileUrl.length != 0) {
        return _lrChannelFileUrl;
    }
    return _fileUrl;
}

- (NSString *)lrChannelFileUrl {
    if (!_lrChannelFileUrl) {
        NSArray *filterArr = [self.subVersions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(RCSKTVMusicSubVersionModel *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject.versionName isEqualToString:@"左右声道_128_mp3"];;
        }]];
        if (filterArr.count > 0) {
            RCSKTVMusicSubVersionModel *subVersion = filterArr[0];
            _lrChannelFileUrl = subVersion.path;
        } else {
            _lrChannelFileUrl = @"";
        }
    }
    return _lrChannelFileUrl;
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end

@implementation RCSKTVMusicSubVersionModel

@end
