//
//  TestVertHeaderTableViewCell.m
//  GridDemo
//
//  Created by 胡金友 on 2018/4/11.
//

#import "TestVertHeaderTableViewCell.h"
#import "UIColor+Helper.h"
#import <Masonry/Masonry.h>

@interface TestVertHeaderTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation TestVertHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self addSubview:self.blockView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.indexLabel];
    
    [self.blockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@5);
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.blockView.mas_right).offset(10);
        make.bottom.equalTo(self.indexLabel.mas_top);
    }];
    
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_left);
        make.height.equalTo(self.titleLabel).multipliedBy(0.75);
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    self.indexLabel.text = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
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
    }
    return _titleLabel;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:12];
        _indexLabel.textColor = [UIColor grayColor];
    }
    return _indexLabel;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor redColor] set];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    CGContextMoveToPoint(context, 0, CGRectGetHeight(self.frame));
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    CGContextStrokePath(context);
}

@end
