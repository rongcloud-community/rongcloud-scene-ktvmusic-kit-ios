//
//  RCSLyricParser.h
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import <Foundation/Foundation.h>
#import "RCSLyricModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RCSLyricParseProtocol <NSObject>

/**
 歌词解析
 @param data 歌词文件数据
 @param error 解析出错
 @return nil / @[RCSStaticLyricModel] / @[RCSEnhancedLrcModel] / @[RCSSimpleLrcModel]
 */
- (nullable RCSLyricModel *)lyricObjectForData:(nullable NSData *)data
                                         error:(NSError *  _Nullable __autoreleasing *)error;

@end

/// 歌曲数据解析器
///         RCSLyricParser 静态歌词
///         RCSEnhancedLrcParser 增强lrc歌词
///         RCSSimpleLrcParser 普通lrc歌词
///         RCSKrcParser krc歌词，内置解码器，直接传入原始数据即可
/// @code
///     RCSEnhancedLrcParser *parser = [RCSEnhancedLrcParser parser];
///     NSURL *url = [[NSBundle mainBundle] URLForResource:@"15966" withExtension:@"lrc"];
///     NSData *data = [NSData dataWithContentsOfURL:url];
///     RCSLyricModel *lyric = [parser lyricObjectForData:data error:&error];
/// @endcode
@interface RCSLyricParser : NSObject<RCSLyricParseProtocol>

@property (nonatomic, assign) NSStringEncoding acceptableEncodingType; /// 默认匹配UTF-8
@property (nonatomic, copy) NSString *sentenceRegex; /// 单句歌词的正则匹配
/**
 文本歌词，逐行
 我一个人生活
 还执着什么
 我懂得有些人是路过
 */
+ (instancetype)parser;


/// 验证歌词文件格式
/// @param data  The data associated with the lrc file.
/// @param lyrics UTF-8 解析单句string
/// @param error  The error that occurred while attempting to validate the data.
/// @return `YES` if the data is valid, otherwise `NO`.
- (BOOL)validateData:(nullable NSData *)data
              lyrics:(NSArray *  _Nullable __autoreleasing *_Nullable)lyrics
               error:(NSError *  _Nullable __autoreleasing *)error;


@end

/**
 lrc歌词，逐字
 [00:23.60]{W}<00:23.60>当<00:23.83>我<00:24.10>一<00:24.39>个<00:24.66>人<00:25.03>走<00:25.33>在<00:25.57>
 [00:25.76]{W}<00:25.76>黑<00:26.05>夜<00:26.35>的<00:26.67>雨<00:27.01>中<00:27.44>
 */
@interface RCSEnhancedLrcParser : RCSLyricParser

+ (instancetype)parser;

@end

/**
 lrc歌词，逐句
 [00:20.26]终结了 没得硝烟的战火
 [00:24.23]经历了 山高路远的战果
 [00:25.17]追梦路上还剩几个人在探索
 */
@interface RCSSimpleLrcParser : RCSLyricParser

+ (instancetype)parser;

@end

/**
 加密后的krc歌词，逐字
 解密后的文本为：
 [233566,5999]<0,787,0>也<787,413,0>想<1200,509,0>和<1709,679,0>大<2388,822,0>树<3210,477,0>一<3687,450,0>样<4137,492,0>的<4629,395,0>长<5024,975,0>高
 */
@interface RCSKrcParser : RCSLyricParser

+ (instancetype)parser;

@end

/**
 HiFive的Krc歌词，未加密
 [101668,1600]斩(101668,200)断(101868,200)情(102068,150)丝(102218,400)痛(102618,250)就(102868,200)断(103068,200)
 [103418,1600]别(103418,200)了(103618,200)爱(103818,200)恨(104018,400)就(104418,200)无(104618,200)憾(104818,200)
 [105218,1650]再(105218,200)看(105418,200)天(105618,200)涯(105818,450)清(106268,200)风(106468,200)暖(106668,200)
 [107068,2550]扬(107068,250)起(107318,150)头(107468,300)该(107768,550)是(108318,350)笑(108668,300)颜(108968,650)
 */

@interface RCSHFKrcParser : RCSLyricParser

+ (instancetype)parser;

@end

NS_ASSUME_NONNULL_END
