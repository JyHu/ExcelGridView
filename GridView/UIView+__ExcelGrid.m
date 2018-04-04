//
//  UIView+__ExcelGrid.m
//  GridView
//
//  Created by 胡金友 on 2018/4/3.
//

#import "UIView+__ExcelGrid.h"

@implementation UIView (__ExcelGrid)

- (CGFloat)grid_x {
    return self.frame.origin.x;
}

- (void)setGrid_x:(CGFloat)grid_x {
    CGRect frame = self.frame;
    frame.origin.x = grid_x;
    self.frame = frame;
}

- (CGFloat)grid_y {
    return self.frame.origin.y;
}

- (void)setGrid_y:(CGFloat)grid_y {
    CGRect frame = self.frame;
    frame.origin.y = grid_y;
    self.frame = frame;
}

- (CGFloat)grid_width {
    return self.frame.size.width;
}

- (void)setGrid_width:(CGFloat)grid_width {
    CGRect frame = self.frame;
    frame.size.width = grid_width;
    self.frame = frame;
}

- (CGFloat)grid_height {
    return self.frame.size.height;
}

- (void)setGrid_height:(CGFloat)grid_height {
    CGRect frame = self.frame;
    frame.size.height = grid_height;
    self.frame = frame;
}

- (CGFloat)grid_maxX {
    return self.grid_x + self.grid_width;
}

- (void)setGrid_maxX:(CGFloat)grid_maxX {
    self.grid_x = grid_maxX - self.grid_width;
}

- (CGFloat)grid_maxY {
    return self.grid_y + self.grid_height;
}

- (void)setGrid_maxY:(CGFloat)grid_maxY {
    self.grid_y = grid_maxY - self.grid_height;
}

@end
