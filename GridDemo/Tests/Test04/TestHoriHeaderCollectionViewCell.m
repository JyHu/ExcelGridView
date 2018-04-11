//
//  TestHoriHeaderCollectionViewCell.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/11.
//

#import "TestHoriHeaderCollectionViewCell.h"
#import "UIColor+Helper.h"
#import <Masonry/Masonry.h>

@interface TestHoriHeaderCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *blockView;

@end

@implementation TestHoriHeaderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.blockView];
    [self addSubview:self.titleLabel];
    
    [self.blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self);
        make.height.equalTo(@5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.blockView.mas_bottom);
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (UIView *)blockView {
    if (!_blockView) {
        _blockView = [[UIView alloc] init];
        _blockView.backgroundColor = [UIColor randomColor];
    }
    return _blockView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
