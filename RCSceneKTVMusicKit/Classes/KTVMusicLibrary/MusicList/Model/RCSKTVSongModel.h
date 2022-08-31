//
//  RCSKTVSongModel.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/12.
//

#import <Foundation/Foundation.h>
#import "RCSKTVSongProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@class RCSKTVSongModel, RCSKTVSongMetaModel;
@interface RCSKTVMusicListModel : NSObject

@property(nonatomic, strong) NSArray<RCSKTVSongModel *> *record;
@property(nonatomic, strong) RCSKTVSongMetaModel *meta;

@end

@interface RCSKTVSongMetaModel : NSObject

@property(nonatomic, assign) int totalCount;
@property(nonatomic, assign) int currentPage;

@end

@class RCSKTVCoverModel, RCSKTVArtistModel;
@interface RCSKTVSongModel : NSObject<RCSKTVSongProtocol>

@property(nonatomic, copy) NSString *musicId;
@property(nonatomic, copy) NSString *musicName;
@property(nonatomic, copy) NSString *artistName;
@property(nonatomic, copy) NSString *coverUrl;

@property(nonatomic, strong) NSArray<RCSKTVCoverModel *> *cover;
@property(nonatomic, strong) NSArray<RCSKTVArtistModel *> *artist;
@property(nonatomic, strong) NSArray<RCSKTVArtistModel *> *author;
@property(nonatomic, strong) NSArray<RCSKTVArtistModel *> *composer;
@property(nonatomic, strong) NSArray<RCSKTVArtistModel *> *arranger;

@end

@interface RCSKTVCoverModel : NSObject

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *size;

@end

@interface RCSKTVArtistModel : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
