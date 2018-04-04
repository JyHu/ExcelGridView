//
//  CourseCollectionViewCell.m
//  GridView
//
//  Created by 胡金友 on 2018/3/28.
//  Copyright © 2018年 胡金友. All rights reserved.
//

#import "CourseCollectionViewCell.h"

@implementation CourseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

@end
