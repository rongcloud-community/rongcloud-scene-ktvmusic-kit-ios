//
//  RCSKTVGroupListPresenter.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/7/12.
//

#import "RCSKTVGroupListPresenter.h"
#import "RCSNetworkDataHandler+KTVMusicLibrary.h"
#import "RCSKTVMusicGroupCategoryModel.h"

@interface RCSKTVGroupListPresenter ()

@property (nonatomic, copy, readwrite) NSArray<id<RCSKTVMusicGroupCategoryProtocol>> *dataModels;
@property (nonatomic, strong) RCSNetworkDataHandler *dataHandler;

@end

@implementation RCSKTVGroupListPresenter

- (void)fetchGroupListWithCompletionBlock:(void(^)(BOOL success))completionBlock {
    WeakSelf(self);
    [self.dataHandler musicChannelWithParams:@{}
                             completionBlock:^(RCSResponseModel * _Nonnull model) {
        if (model.code != RCSResponseStatusCodeSuccess) {
            [self handlerDataErrorWithCompletionBlock:completionBlock];
            return ;
        }
        
        if (![model.data isKindOfClass:[NSArray class]]) {
            [self handlerDataErrorWithCompletionBlock:completionBlock];
            return ;
        }
        
        NSArray *dataArr = (NSArray *)model.data;
        if (dataArr.count == 0) {
            [self handlerDataErrorWithCompletionBlock:completionBlock];
            return ;
        }
        
        StrongSelf(weakSelf);
        NSString *groupId = model.data[0][@"groupId"];
        if (groupId.length == 0) {
            [self handlerDataErrorWithCompletionBlock:completionBlock];
            return ;
        }
        [strongSelf fetchChannelSheetWithGroupId:groupId completionBlock:completionBlock];
    }];
}

#pragma mark - private method
- (void)fetchChannelSheetWithGroupId:(NSString *)groupId completionBlock:(void(^)(BOOL success))completionBlock {
    WeakSelf(self);
    [self.dataHandler musicChannelSheetWithParams:@{@"groupId" : groupId}
                                  completionBlock:^(RCSResponseModel * _Nonnull model) {
        StrongSelf(weakSelf);
        if (model.code != RCSResponseStatusCodeSuccess) {
            [self handlerDataErrorWithCompletionBlock:completionBlock];
            return ;
        }
        RCSKTVChannelSheetModel *channelSheet = (RCSKTVChannelSheetModel *)model.data;
        strongSelf.dataModels = channelSheet.record;
        !completionBlock ?: completionBlock(YES);
    }];
}

- (void)handlerDataErrorWithCompletionBlock:(void(^)(BOOL success))completionBlock {
    [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
    !completionBlock ?: completionBlock(NO);
}

- (RCSNetworkDataHandler *)dataHandler {
    if (!_dataHandler) {
        _dataHandler = [RCSNetworkDataHandler new];
    }
    return _dataHandler;
}

@end
