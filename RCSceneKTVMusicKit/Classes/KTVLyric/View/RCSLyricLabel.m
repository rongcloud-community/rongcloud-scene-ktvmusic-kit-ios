//
//  RCSLyricLabel.m
//  RCSceneKTVMusicKit
//
//  Created by 彭蕾 on 2022/6/20.
//

#import "RCSLyricLabel.h"

@interface RCSLyricLabel ()

@property (nonatomic, assign) BOOL style;
@property (nonatomic, strong) UIColor *playingColor;

@end

@implementation RCSLyricLabel
- (instancetype)init {
    if (self = [super init]) {
        self.style = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.playingColor = [UIColor whiteColor];
    }
    return self;
}

- (void)shouldLoadMask:(BOOL)mask {
    self.playingColor = mask ? RCSKTVMusicMainColor : [UIColor whiteColor];
    self.style = mask;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.progress <= 0) {
        return;
    }
    int lines = (int)(self.bounds.size.height / self.font.lineHeight);
    CGFloat paddingTop = (self.bounds.size.height - (CGFloat)lines * self.font.lineHeight) / lines;
    CGFloat maxWidth = [self sizeThatFits:CGSizeMake(MAXFLOAT, self.font.lineHeight * lines)].width;
    CGFloat oneLineProgress = maxWidth <= self.bounds.size.width ? 1 : self.bounds.size.width / maxWidth;
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (int index = 0; index < lines; index++) {
        CGFloat leftProgress = MIN(self.progress, 1) - (CGFloat)index * oneLineProgress;
        CGRect fillRect;
        if (leftProgress >= oneLineProgress) {
            fillRect = CGRectMake(0,
                                  paddingTop + (CGFloat)index * self.font.lineHeight,
                                  self.bounds.size.width,
                                  self.font.lineHeight);
            CGPathAddRect(path, nil, fillRect);
        } else if (leftProgress > 0) {
            if ((index != lines -1) || (maxWidth <= self.bounds.size.width)) {
                fillRect = CGRectMake(0,
                                      paddingTop + (CGFloat)index * self.font.lineHeight,
                                      maxWidth *leftProgress,
                                      self.font.lineHeight);
            } else {
                NSInteger newMaxWidth = maxWidth *1000000;
                NSInteger newSizeWidth = self.bounds.size.width *1000000;
                NSInteger z = newMaxWidth % newSizeWidth;
                CGFloat width = z / 1000000.0;
                CGFloat dw = (self.bounds.size.width - width) / lines + maxWidth * leftProgress;
                fillRect = CGRectMake(0,
                                      paddingTop + (CGFloat)index * self.font.lineHeight,
                                      dw,
                                      self.font.lineHeight);
            }
            CGPathAddRect(path, nil, fillRect);
            break;
        }
    }
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (!CGPathIsEmpty(path)) {
        CGContextAddPath(contextRef, path);
        CGContextClip(contextRef);
        UIColor *lastTextColor = self.textColor;
        self.textColor = self.playingColor;
        if (self.style) {
            CGSize shadowOffset = self.shadowOffset;
            UIColor * shadowColor = self.shadowColor;
            self.shadowOffset = CGSizeMake(0, 1);
            [super drawRect:rect];
            self.shadowOffset = shadowOffset;
            self.shadowColor = shadowColor;
        } else {
            [super drawRect:rect];
        }
        self.textColor = lastTextColor;
    }
    CGPathRelease(path);
}

- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        [self setNeedsDisplay];
    }
    _progress = progress;
}


@end
