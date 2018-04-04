//
//  ExcelGridItemCell.m
//  GridView
//
//  Created by 胡金友 on 2018/4/3.
//

#import "ExcelGridItemCell.h"

@implementation ExcelGridItemCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

@end
