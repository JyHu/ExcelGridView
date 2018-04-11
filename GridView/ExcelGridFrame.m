//
//  ExcelGridFrame.m
//  GridView
//
//  Created by 胡金友 on 2018/4/3.
//

#import "ExcelGridFrame.h"
#import <objc/runtime.h>
#import "UIView+__ExcelGrid.h"

@interface ExcelGridFrame ()  <UIScrollViewDelegate, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *horizontalHeaderContainerView;

@property (nonatomic, strong) UIScrollView *containerScrollView;

@end

@implementation ExcelGridFrame


- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.containerScrollView];
        [self addSubview:self.horizontalHeaderContainerView];
        
        self.backgroundColor = [UIColor whiteColor];
        
        _horizontalHeaderHeight = 0;
        _verticalHeaderWidth = 120;
        _contentWidth = CGRectGetWidth(frame) - 120;
    }
    return self;
}

#pragma mark - forwarding

- (BOOL)shouldForwardSelector:(SEL)selector {
    if ([self shouldForwardSelector:selector ofProtocol:@protocol(UITableViewDelegate)] ||
        [self shouldForwardSelector:selector ofProtocol:@protocol(UICollectionViewDelegate)] ||
        [self shouldForwardSelector:selector ofProtocol:@protocol(UIScrollViewDelegate)] ||
        [self shouldForwardSelector:selector ofProtocol:@protocol(UICollectionViewDelegateFlowLayout)]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)shouldForwardSelector:(SEL)selector ofProtocol:(Protocol *)protocol {
    struct objc_method_description description;
    description = protocol_getMethodDescription(protocol, selector, NO, YES);
    return (description.name != NULL && description.types != NULL);
}

- (BOOL)respondsToSelector:(SEL)selector {
    // 如果是自己的子类添加了自己的代理，那么就不转发
    if (self.gridFrameDelegate && [self.gridFrameDelegate isKindOfClass:[self class]]) {
        return [super respondsToSelector:selector];
    }
    
    if ([super respondsToSelector:selector]) {
        return YES;
    } else if ([self shouldForwardSelector:selector]) {
        if ([self.gridFrameDelegate respondsToSelector:selector]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    BOOL didForward = NO;
    if ([self shouldForwardSelector:invocation.selector]) {
        if ([self.gridFrameDelegate respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:self.gridFrameDelegate];
            didForward = YES;
        }
    }
    
    if (!didForward) {
        [super forwardInvocation:invocation];
    }
}

#pragma handler

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.verticalHeaderScrollView || !self.contentScrollView) {
        return;
    }
    
    // 上部分容器视图，用于放角标视图和横向标题
    self.horizontalHeaderContainerView.frame = CGRectMake(0, 0, self.grid_width, self.horizontalHeaderHeight);
    
    // 左上角的角标题视图
    if (self.cornerView) {
        self.cornerView.frame = CGRectMake(0, 0, self.verticalHeaderWidth, self.horizontalHeaderHeight);
    }
    
    // 右上角滚动的标题视图
    if (self.horizontalHeaderScrollView) {
        self.horizontalHeaderScrollView.frame = CGRectMake(self.verticalHeaderWidth, 0, self.grid_width - self.verticalHeaderWidth, self.horizontalHeaderHeight);
    }
    
    // 左下角的竖向标题视图
    self.verticalHeaderScrollView.frame = CGRectMake(0, self.horizontalHeaderHeight, self.verticalHeaderWidth, self.grid_height - self.horizontalHeaderHeight);
    
    // 右下的容器scroll，用于滚动上面的展示内容
    self.containerScrollView.frame = CGRectMake(self.verticalHeaderWidth, self.horizontalHeaderHeight, self.grid_width - self.verticalHeaderWidth, self.grid_height - self.horizontalHeaderHeight);
    self.containerScrollView.contentSize = CGSizeMake(self.contentWidth, self.containerScrollView.grid_height);
    
    // 右下的内容scroll，用于展示滚动的显示内容
    self.contentScrollView.frame = CGRectMake(0, 0, self.contentWidth, self.containerScrollView.grid_height);
}

- (void)setScrollerView:(UIScrollView *)scrollView backgroundColor:(UIColor *)backgroundColor {
    if (scrollView && backgroundColor) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            scrollView.backgroundColor = backgroundColor;
        } else if ([scrollView isKindOfClass:[UITableView class]]) {
            ((UITableView *)scrollView).backgroundColor = backgroundColor;
        } else if ([scrollView isKindOfClass:[UICollectionView class]]) {
            ((UICollectionView *)scrollView).backgroundColor = backgroundColor;
        }
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *destScroll = nil;
    CGPoint contentOffset = scrollView.contentOffset;
    
    if ([scrollView isEqual:self.verticalHeaderScrollView]) {
        destScroll = self.contentScrollView;
    } else if ([scrollView isEqual:self.contentScrollView]) {
        destScroll = self.verticalHeaderScrollView;
        // 纵向标题不可以横向滚动
        contentOffset.x = 0;
    } else if ([scrollView isEqual:self.containerScrollView]) {
        if (self.horizontalHeaderScrollView) {
            destScroll = self.horizontalHeaderScrollView;
            // 横向标题不可以纵向滚动
            contentOffset.y = 0;
        }
    } else if (self.horizontalHeaderScrollView && [scrollView isEqual:self.horizontalHeaderScrollView]) {
        destScroll = self.containerScrollView;
    }
    
    if (destScroll) {
        destScroll.contentOffset = contentOffset;
    }
}

#pragma mark - Getter setter

- (UIScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[UIScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.backgroundColor = [UIColor clearColor];
        _containerScrollView.alwaysBounceVertical = NO;
    }
    return _containerScrollView;
}

- (UIView *)horizontalHeaderContainerView {
    if (!_horizontalHeaderContainerView) {
        _horizontalHeaderContainerView = [[UIView alloc] init];
        _horizontalHeaderContainerView.backgroundColor = [UIColor clearColor];
    }
    return _horizontalHeaderContainerView;
}

- (void)setVerticalHeaderScrollView:(UIScrollView *)verticalHeaderScrollView {
    if (_verticalHeaderScrollView) {
        _verticalHeaderScrollView.delegate = nil;
        [_verticalHeaderScrollView removeFromSuperview];
    }
    
    _verticalHeaderScrollView = verticalHeaderScrollView;
    
    if (_verticalHeaderScrollView) {
        _verticalHeaderScrollView.delegate = self;
        [self addSubview:_verticalHeaderScrollView];
    }
    
    [self layoutSubviews];
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView {
    if (_contentScrollView) {
        _contentScrollView.delegate = nil;
        [_contentScrollView removeFromSuperview];
    }
    
    _contentScrollView = contentScrollView;
    
    if (contentScrollView) {
        _contentScrollView.delegate = self;
        [self.containerScrollView addSubview:contentScrollView];
    }
    
    [self layoutSubviews];
}

- (void)setHorizontalHeaderScrollView:(UIScrollView *)horizontalHeaderScrollView {
    if (_horizontalHeaderScrollView) {
        _horizontalHeaderScrollView.delegate = nil;
        [_horizontalHeaderScrollView removeFromSuperview];
    }
    
    _horizontalHeaderScrollView = horizontalHeaderScrollView;
    
    if (horizontalHeaderScrollView) {
        _horizontalHeaderScrollView.delegate = self;
        [self.horizontalHeaderContainerView addSubview:horizontalHeaderScrollView];
    }
    
    [self layoutSubviews];
}

- (void)setCornerView:(UIView *)cornerView {
    if (_cornerView) {
        [_cornerView removeFromSuperview];
    }
    
    _cornerView = cornerView;
    
    if (cornerView) {
        [self.horizontalHeaderContainerView addSubview:cornerView];
    }
    
    [self layoutSubviews];
}

- (void)setGridFrameDelegate:(id<ExcelGridFrameDelegate>)gridFrameDelegate {
    _gridFrameDelegate = gridFrameDelegate;
    
    [self layoutSubviews];
}

- (void)setContentWidth:(CGFloat)contentWidth {
    _contentWidth = contentWidth;
    [self layoutSubviews];
}

- (void)setHorizontalHeaderHeight:(CGFloat)horizontalHeaderHeight {
    _horizontalHeaderHeight = horizontalHeaderHeight;
    self.horizontalHeaderContainerView.hidden = horizontalHeaderHeight == 0;
    [self layoutSubviews];
}

- (void)setVerticalHeaderWidth:(CGFloat)verticalHeaderWidth {
    _verticalHeaderWidth = verticalHeaderWidth;
    [self layoutSubviews];
}

- (void)setCornerTitle:(NSString *)cornerTitle {
    _cornerTitle = cornerTitle;
    
    if (self.cornerView && [self.cornerView isKindOfClass:[UILabel class]]) {
        ((UILabel *)self.cornerView).text = cornerTitle;
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.text = cornerTitle;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        self.cornerView = label;
    }
}

@end
