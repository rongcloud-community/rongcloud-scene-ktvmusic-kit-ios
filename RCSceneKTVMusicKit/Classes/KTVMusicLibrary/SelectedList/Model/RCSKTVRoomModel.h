//
//  RCSKTVRoomModel.h
//  RCSceneBaseKit
//
//  Created by 彭蕾 on 2022/7/13.
//

#import <Foundation/Foundation.h>
#import "RCSKTVMusicSelectedDataProtocol.h"
#import "RCSKTVRoomMusicProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@class RCSKTVMusicSelectedModel;
@interface RCSKTVRoomModel : NSObject

@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, assign) NSInteger seat;
@property(nonatomic, assign) BOOL seatFlag;
@property(nonatomic, assign) NSInteger songPickAuth;
@property(nonatomic, assign) NSInteger songTotal;
@property(nonatomic, copy) NSString *updateTime;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userPortrait;
@property(nonatomic, assign) NSInteger userSongTotal;
@property(nonatomic, strong) NSArray<RCSKTVMusicSelectedModel *> *songQueue;

@end

@interface RCSKTVRoomMusicModel: NSObject<RCSKTVRoomMusicProtocol>

@property(nonatomic, copy) NSString *artistName;
@property(nonatomic, copy) NSString *musicId;
@property(nonatomic, copy) NSString *musicName;
@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, assign) int solo;
@property(nonatomic, copy) NSString *songId;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userPortrait;

@end

@interface RCSKTVMusicSelectedModel: RCSKTVRoomMusicModel<RCSKTVMusicSelectedDataProtocol>

@property(nonatomic, assign) BOOL isMicControl;
@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, assign) BOOL allowDelete;
@property(nonatomic, assign) NSInteger pinPermission;

@end


NS_ASSUME_NONNULL_END
