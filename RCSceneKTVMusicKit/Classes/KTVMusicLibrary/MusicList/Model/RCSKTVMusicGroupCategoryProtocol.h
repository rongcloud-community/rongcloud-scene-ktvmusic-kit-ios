//
//  RCSKTVMusicGroupCategoryProtocol.h
//  Pods
//
//  Created by 彭蕾 on 2022/7/11.
//

@protocol RCSKTVMusicGroupCategoryProtocol<NSObject>

// 资源id
@property(nonatomic, copy) NSString *categoryId;
// 歌单名称
@property(nonatomic, copy) NSString *name;
// 当前歌单的选中状态
@property(nonatomic, assign) BOOL selected;

@end
