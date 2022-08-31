//
//  RCSKTVSongModel.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/12.
//

#import "RCSKTVSongModel.h"

@implementation RCSKTVMusicListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"record" : [RCSKTVSongModel class],
        @"meta" : [RCSKTVSongMetaModel class]
    };
}

@end

@implementation RCSKTVSongMetaModel

@end

@implementation RCSKTVSongModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"cover" : [RCSKTVCoverModel class],
        @"artist" : [RCSKTVArtistModel class],
        @"author" : [RCSKTVArtistModel class],
        @"composer" : [RCSKTVArtistModel class],
        @"arranger" : [RCSKTVArtistModel class],
    };
}

- (NSString *)coverUrl {
    if (!_coverUrl) {
        if (self.cover.count > 0) {
            _coverUrl = self.cover[0].url;
        } else {
            _coverUrl = @"";
        }
    }
    return _coverUrl;
}

- (NSString *)artistName {
    if (!_artistName) {
        if (self.artist.count > 0) {
            _artistName = self.artist[0].name;
        } else if (self.author.count > 0) {
            _artistName = self.author[0].name;
        } else if (self.composer.count > 0) {
            _artistName = self.composer[0].name;
        } else if (self.arranger.count > 0) {
            _artistName = self.arranger[0].name;
        } else {
            _artistName = @"";
        }
    }
    return _artistName;
}


@end

@implementation RCSKTVCoverModel

@end

@implementation RCSKTVArtistModel

@end
