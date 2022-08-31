//
//  RCSLyricParser.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSLyricParser.h"
#import "RCSSimpleLrcModel.h"
#import "RCSEnhancedLrcModel.h"
#import "NSData+RCSCompression.h"

NSString * const RCSLrcParseErrorDomain = @"com.rongcloudscene.error.lyric.parse";
NSString * const RCSLrcParseDataErrorKey = @"com.rongcloudscene.lyric.parse.error.data";

NSTimeInterval RCSLyricParserGetTime(NSString *timeStr) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.SS"];
    NSDate *currentDate = [dateFormatter dateFromString:timeStr];
    NSDate *initDate = [dateFormatter dateFromString:@"00:00.00"];
    return [currentDate timeIntervalSinceDate:initDate];
}

@implementation RCSLyricParser

+ (instancetype)parser {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.acceptableEncodingType = NSUTF8StringEncoding;
    }
    return self;
}

- (BOOL)validateData:(nullable NSData *)data
              lyrics:(NSArray *  _Nullable __autoreleasing *)lyrics
               error:(NSError *  _Nullable __autoreleasing *)error {
    if (!data) {
        *error = [NSError errorWithDomain:RCSLrcParseErrorDomain
                                    code:-70000
                                userInfo:@{RCSLrcParseDataErrorKey:@"传入的data不能为空"}];
        return NO;
    }
    
    /// 1.  检测是否为UTF-8编码
    NSString *encodeString = [[NSString alloc] initWithData:data encoding:self.acceptableEncodingType];
    if (encodeString.length == 0) {
        *error = [NSError errorWithDomain:RCSLrcParseErrorDomain
                                    code:-self.acceptableEncodingType
                                userInfo:@{RCSLrcParseDataErrorKey:@"仅支持UTF-8编码文件"}];
        return NO;
    }
    
    NSArray *lyricArr = [encodeString componentsSeparatedByString:@"\n"];
    if (self.sentenceRegex.length == 0) {
        *lyrics = lyricArr;
        return YES;
    }
    
    /// 2.  检测正则匹配是否包含时间前缀
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.sentenceRegex];
    NSArray *filterArr = [lyricArr filteredArrayUsingPredicate:
                          [NSPredicate predicateWithBlock:^BOOL(NSString *line, NSDictionary *bindings) {
        NSString *content = [line stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        return [predicate evaluateWithObject:content];
    }]];
    
    if (filterArr.count > 0 ) {
        *lyrics = filterArr;
        return YES;
    }
    
    *error = [NSError errorWithDomain:RCSLrcParseErrorDomain
                                 code:-70001
                             userInfo:@{RCSLrcParseDataErrorKey:@"单句歌词格式不匹配"}];
    return NO;
}

- (nullable RCSLyricModel *)lyricObjectForData:(nullable NSData *)data
                                         error:(NSError *  _Nullable __autoreleasing *)error;{
    NSArray<NSString *> *matchedArr = @[];
    if (![self validateData:data lyrics:&matchedArr error:error]) {
        return nil;
    }
    
    RCSLyricModel *model = [RCSLyricModel new];
    model.lines = matchedArr;
    return model;
}

@end

@implementation RCSEnhancedLrcParser
+ (instancetype)parser {
    return [RCSEnhancedLrcParser new];
}

- (instancetype)init {
    if (self = [super init]) {
        self.acceptableEncodingType = NSUTF8StringEncoding;
        self.sentenceRegex = @"^\\[([0-9]+):([0-9]+)\\.([0-9]+)\\](.*)\\<([0-9]+):([0-9]+)\\.([0-9]+)\\>(.*)\\<([0-9]+):([0-9]+)\\.([0-9]+)\\>$";
    }
    return self;
}

- (nullable RCSLyricModel *)lyricObjectForData:(nullable NSData *)data
                                         error:(NSError * _Nullable __autoreleasing *)error {
    NSArray<NSString *> *matchedArr = @[];
    if (![self validateData:data lyrics:&matchedArr error:error]) {
        return nil;
    }
    
    RCSEnhancedLrcModel *model = [RCSEnhancedLrcModel new];
    NSMutableArray<NSString *> *lines = [NSMutableArray array];
    
    NSMutableArray *sentences = [NSMutableArray array];
    for (NSString *line in matchedArr) {
        NSArray *lineArray = [line componentsSeparatedByString:@"]"];
        NSString *content = [lineArray.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (content.length == 0) {
            continue ;
        }
        
        NSMutableArray<RCSELrcWordModel *> *words = [NSMutableArray array];
        NSMutableString *sentence = [NSMutableString string];
        
        NSString *pattern = @"<([0-9]+):([0-9]+)\\.([0-9]+)\\>";
        NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:error];
        NSArray<NSTextCheckingResult *> *textArr = [regx matchesInString:content
                                                                 options:NSMatchingReportProgress
                                                                   range:NSMakeRange(0, content.length)];
        
        for (int i = 0; i<textArr.count-1; i++) {
            NSTextCheckingResult *result = textArr[i];
            NSString *timeStr = [content substringWithRange:NSMakeRange(result.range.location+1,
                                                                        result.range.length-2)];
            RCSELrcWordModel *word = [RCSELrcWordModel new];
            word.startTime = RCSLyricParserGetTime(timeStr);
            
            NSTextCheckingResult *nextResult = textArr[i+1];
            NSString *endTimeStr = [content substringWithRange:NSMakeRange(nextResult.range.location+1,
                                                                           nextResult.range.length-2)];
            word.endTime = RCSLyricParserGetTime(endTimeStr);
            
            NSUInteger wordLocation = result.range.location+result.range.length;
            NSUInteger wordLength = nextResult.range.location-wordLocation;
            word.word = [content substringWithRange:NSMakeRange(wordLocation, wordLength)];
            
            [words addObject:word];
            [sentence appendString:word.word];
        }
        
        
        RCSELrcSentenceModel *sentenceModel = [RCSELrcSentenceModel new];
        sentenceModel.content = sentence;
        sentenceModel.words = words;
        NSString *timeStr = [lineArray.firstObject substringFromIndex:1];
        sentenceModel.startTime = RCSLyricParserGetTime(timeStr);
        
        [sentences addObject:sentenceModel];
        [lines addObject:sentence];
    }
    
    model.sentences = sentences;
    model.lines = lines;
    return model;
}

@end

@implementation RCSSimpleLrcParser

+ (instancetype)parser {
    return [RCSSimpleLrcParser new];
}

- (instancetype)init {
    if (self = [super init]) {
        self.acceptableEncodingType = NSUTF8StringEncoding;
        self.sentenceRegex = @"^\\[([0-9]+):([0-9]+)\\.([0-9]+)\\](.*)$";
    }
    return self;
}

- (nullable RCSLyricModel *)lyricObjectForData:(nullable NSData *)data
                                         error:(NSError * _Nullable __autoreleasing *)error {
    NSArray<NSString *> *matchedArr = @[];
    if (![self validateData:data lyrics:&matchedArr error:error]) {
        return nil;
    }
    
    RCSSimpleLrcModel *model = [RCSSimpleLrcModel new];
    NSMutableArray<NSString *> *lines = [NSMutableArray array];
    
    NSMutableArray *sentences = [NSMutableArray array];
    for (NSString *line in matchedArr) {
        NSArray<NSString *> *lineArray = [line componentsSeparatedByString:@"]"];
        NSString *content = [lineArray.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (content.length == 0) {
            continue ;
        }
        
        RCSSentenceModel *sentence = [RCSSentenceModel new];
        sentence.content = content;
        NSString *timeStr = [lineArray.firstObject substringFromIndex:1];
        sentence.startTime = RCSLyricParserGetTime(timeStr);
        
        [sentences addObject:sentence];
        [lines addObject:content];
    }
    
    model.sentences = sentences;
    model.lines = lines;
    return model;
}

@end

/**
 
 */

@implementation RCSKrcParser

+ (instancetype)parser {
    return [RCSKrcParser new];
}

- (instancetype)init {
    if (self = [super init]) {
        self.acceptableEncodingType = NSUTF8StringEncoding;
        self.sentenceRegex = @"^\\[([0-9]+),([0-9]+)](.*)<([0-9]+),([0-9]+),0\\>(.*)$";
    }
    return self;
}

- (nullable RCSLyricModel *)lyricObjectForData:(nullable NSData *)data
                                         error:(NSError * _Nullable __autoreleasing *)error {
    NSData *decodeData = [self decodeKrcData:data];
    NSArray<NSString *> *matchedArr = @[];
    if (![self validateData:decodeData lyrics:&matchedArr error:error]) {
        return nil;
    }
    
    RCSEnhancedLrcModel *model = [RCSEnhancedLrcModel new];
    NSMutableArray<NSString *> *lines = [NSMutableArray array];
    
    NSMutableArray *sentences = [NSMutableArray array];
    for (NSString *line in matchedArr) {
        NSArray *lineArray = [line componentsSeparatedByString:@"]"];
        NSString *content = [lineArray.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (content.length == 0) {
            continue ;
        }
        
        RCSELrcSentenceModel *sentenceModel = [RCSELrcSentenceModel new];
        NSArray<NSString *> *sentenceTimeArray = [lineArray.firstObject componentsSeparatedByString:@","];
        sentenceModel.startTime = [sentenceTimeArray.firstObject substringFromIndex:1].integerValue / 1000.0 ;
        
        NSMutableArray<RCSELrcWordModel *> *words = [NSMutableArray array];
        NSMutableString *sentence = [NSMutableString string];
        
        NSString *pattern = @"<([0-9]+),([0-9]+),0\\>";
        NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:error];
        NSArray<NSTextCheckingResult *> *textArr = [regx matchesInString:content
                                                                 options:NSMatchingReportProgress
                                                                   range:NSMakeRange(0, content.length)];
        
        for (int i = 0; i<textArr.count; i++) {
            NSTextCheckingResult *result = textArr[i];
            NSString *timeStr = [content substringWithRange:NSMakeRange(result.range.location+1,
                                                                        result.range.length-2)];
            NSArray *timeArray = [timeStr componentsSeparatedByString:@","];
            NSString *startTime = (NSString *)timeArray.firstObject;
            NSString *durationTime = (NSString *)timeArray[1];
            
            RCSELrcWordModel *word = [RCSELrcWordModel new];
            word.startTime = startTime.integerValue / 1000.0 + sentenceModel.startTime;
            word.endTime = durationTime.integerValue / 1000.0 + word.startTime;
            
            if (i < textArr.count-1) {
                NSTextCheckingResult *nextResult = textArr[i+1];
                NSUInteger wordLocation = result.range.location+result.range.length;
                NSUInteger wordLength = nextResult.range.location-wordLocation;
                word.word = [content substringWithRange:NSMakeRange(wordLocation, wordLength)];
            } else {
                NSUInteger wordLocation = result.range.location+result.range.length;
                word.word = [content substringFromIndex:wordLocation];
            }
            
            [words addObject:word];
            [sentence appendString:word.word];
        }
        
        sentenceModel.content = sentence;
        sentenceModel.words = words;
        
        [sentences addObject:sentenceModel];
        [lines addObject:sentence];
    }
    
    model.sentences = sentences;
    model.lines = lines;
    return model;
}

//异或加密 密钥
- (NSData *)decodeKrcData:(NSData *)encodeData {
    NSString *encKey = @"@Gaw^2tGQ61-ÎÒni";
    
    NSData *totalBytes = encodeData;
    NSData *usefulBytes = [totalBytes subdataWithRange:NSMakeRange(4, totalBytes.length - 4)];
    NSData *excpetheadBytes = [[NSData alloc] initWithData:usefulBytes];
    NSMutableData *EncodedBytes = [[NSMutableData alloc] initWithData:excpetheadBytes];
    
    NSMutableData *zipBytes = [[NSMutableData alloc] initWithCapacity:EncodedBytes.length];
    Byte *encodedBytes = EncodedBytes.mutableBytes;
    
    long encodedBytesLength = EncodedBytes.length;
    for (int i = 0; i < encodedBytesLength; i++) {
        int l = i % 16;
        char c = [encKey characterAtIndex:l];
        Byte b = (Byte)((encodedBytes[i]) ^ c);
        [zipBytes appendBytes:&b length:1];
    }
    
    NSData *unZipBytes = [zipBytes zlibInflate];
    return unZipBytes;
}
@end

@implementation RCSHFKrcParser

+ (instancetype)parser {
    return [RCSHFKrcParser new];
}

- (instancetype)init {
    if (self = [super init]) {
        self.acceptableEncodingType = NSUTF8StringEncoding;
        self.sentenceRegex = @"^\\[([0-9]+),([0-9]+)](.*)\\(([0-9]+),([0-9]+)\\)(.*)$";
    }
    return self;
}

- (nullable RCSLyricModel *)lyricObjectForData:(nullable NSData *)data
                                         error:(NSError * _Nullable __autoreleasing *)error {
    NSArray<NSString *> *matchedArr = @[];
    if (![self validateData:data lyrics:&matchedArr error:error]) {
        return nil;
    }
    
    RCSEnhancedLrcModel *model = [RCSEnhancedLrcModel new];
    NSMutableArray<NSString *> *lines = [NSMutableArray array];
    
    NSMutableArray *sentences = [NSMutableArray array];
    for (NSString *line in matchedArr) {
        NSArray *lineArray = [line componentsSeparatedByString:@"]"];
        NSString *content = [lineArray.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (content.length == 0) {
            continue ;
        }
        
        RCSELrcSentenceModel *sentenceModel = [RCSELrcSentenceModel new];
        NSArray<NSString *> *sentenceTimeArray = [lineArray.firstObject componentsSeparatedByString:@","];
        sentenceModel.startTime = [sentenceTimeArray.firstObject substringFromIndex:1].integerValue / 1000.0 ;
        
        NSMutableArray<RCSELrcWordModel *> *words = [NSMutableArray array];
        NSMutableString *sentence = [NSMutableString string];
        
        NSString *pattern = @"\\(([0-9]+),([0-9]+)\\)";
        NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:error];
        NSArray<NSTextCheckingResult *> *textArr = [regx matchesInString:content
                                                                 options:NSMatchingReportProgress
                                                                   range:NSMakeRange(0, content.length)];
        
        for (int i = 0; i<textArr.count; i++) {
            NSTextCheckingResult *result = textArr[i];
            NSString *timeStr = [content substringWithRange:NSMakeRange(result.range.location+1,
                                                                        result.range.length-2)];
            NSArray *timeArray = [timeStr componentsSeparatedByString:@","];
            NSString *startTime = (NSString *)timeArray.firstObject;
            NSString *durationTime = (NSString *)timeArray[1];
            
            RCSELrcWordModel *word = [RCSELrcWordModel new];
            word.startTime = startTime.integerValue / 1000.0;
            word.endTime = durationTime.integerValue / 1000.0 + word.startTime;
            
            if (i == 0) {
                NSUInteger wordLocation = result.range.location;
                word.word = [content substringToIndex:wordLocation];
            } else {
                NSTextCheckingResult *beforeResult = textArr[i-1];
                NSUInteger wordLocation = beforeResult.range.location+beforeResult.range.length;
                NSUInteger wordLength = result.range.location-wordLocation;
                word.word = [content substringWithRange:NSMakeRange(wordLocation, wordLength)];
            }
            
            [words addObject:word];
            [sentence appendString:word.word];
        }
        
        sentenceModel.content = sentence;
        sentenceModel.words = words;
        
        [sentences addObject:sentenceModel];
        [lines addObject:sentence];
    }
    
    model.sentences = sentences;
    model.lines = lines;
    return model;
}

@end

