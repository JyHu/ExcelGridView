//
//  TestContentItemCollectionViewCell.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/11.
//

#import "TestContentItemCollectionViewCell.h"
#import "UIColor+Helper.h"
#import <Masonry/Masonry.h>

@interface TestContentItemCollectionViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TestContentItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(10, 10)]);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.left.equalTo(self.imageView.mas_right).offset(5);
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor randomColor];
    }
    return _imageView;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor redColor] set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    CGContextMoveToPoint(context, 0, CGRectGetHeight(self.frame));
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    CGContextMoveToPoint(context, 0, 5);
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.frame) - 5);
    
    CGContextStrokePath(context);
}

@end
