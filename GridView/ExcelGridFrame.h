//
//  ExcelGridFrame.h
//  GridView
//
//  Created by 胡金友 on 2018/4/3.
//

#import <UIKit/UIKit.h>

#define kGRID_DOUBLE_ZERO 10e-10

@class ExcelGridFrame;

@protocol ExcelGridFrameDelegate <NSObject>

@end

@interface ExcelGridFrame : UIView

/**
 当前表格视图的代理方法
 
 !!! 注意
 这里的代理重点是为了实现下图的2、3、4三个可滚动的视图协议方法的转发，
 即可以在使用的时候实现他们的协议(delegate)方法，但是不能添加其代理，否则当前表格视图就无法控
 制联动和其他效果
 */
@property (nonatomic, weak) id <ExcelGridFrameDelegate> gridFrameDelegate;


//  _________________________________
//  |        |                      |
//  |  01    |          02          |
//  |________|______________________|
//  |        |                      |
//  |        |                      |
//  |        |                      |
//  |        |                      |
//  |        |                      |
//  |        |                      |
//  |   03   |          04          |
//  |        |                      |
//  |        |                      |
//  |        |                      |
//  |        |                      |
//  |        |                      |
//  |________|______________________|
//

/**
 01 角标视图，一般不会滚动
 */
@property (nonatomic, weak) UIView *cornerView;

/**
 02 横向的标题视图，必须是UIScrollView或者其子类，可用于实现内容视图滚动时的联动
 */
@property (nonatomic, weak) UIScrollView *horizontalHeaderScrollView;

/**
 03 纵向的标题视图，必须是UIScrollView或者其子类，可用于实现内容视图滚动时的联动
 */
@property (nonatomic, weak) UIScrollView *verticalHeaderScrollView;

/**
 04 展示的内容视图，必须是UIScrollView或者其子类，用于展示可滚动的多行列内容
 */
@property (nonatomic, weak) UIScrollView *contentScrollView;

/**
 横向标题的高度
 */
@property (nonatomic, assign) CGFloat horizontalHeaderHeight;

/**
 纵向标题的宽度
 */
@property (nonatomic, assign) CGFloat verticalHeaderWidth;

/**
 右下展示具体内容的容器的内容宽度
 */
@property (nonatomic, assign) CGFloat contentWidth;

/**
 角标题，如果设置了角标题，那么cornerView就是一个label
 */
@property (nonatomic, copy) NSString *cornerTitle;

@end
