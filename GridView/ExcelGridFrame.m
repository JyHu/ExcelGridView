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

- (void)setupContentWidth:(CGFloat)width {
    self.containerScrollView.contentSize = CGSizeMake(width, self.grid_height);
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.verticalHeaderScrollView || !self.contentScrollView) {
        return;
    }
    
    // 左边标题的宽度
    CGFloat vertHeaderWidth = 120;
    if (self.gridFrameDelegate && [self.gridFrameDelegate respondsToSelector:@selector(widthForVerticalHeaderInGridFrame:)]) {
        vertHeaderWidth = [self.gridFrameDelegate widthForVerticalHeaderInGridFrame:self];
    }
    
    // 顶部标题的高度
    CGFloat horiHeaderHeight = 0;
    if (self.horizontalHeaderScrollView || self.cornerView) {
        self.horizontalHeaderContainerView.hidden = NO;
        
        horiHeaderHeight = (self.horizontalHeaderScrollView ?: self.cornerView).grid_height;
        
        if (self.gridFrameDelegate && [self.gridFrameDelegate respondsToSelector:@selector(heightForHorizontalHeaderInGridFrame:)]) {
            horiHeaderHeight = [self.gridFrameDelegate heightForHorizontalHeaderInGridFrame:self];
        }
        
        self.horizontalHeaderContainerView.frame = CGRectMake(0, 0, self.grid_width, horiHeaderHeight);
        
        if (self.horizontalHeaderScrollView) {
            self.horizontalHeaderScrollView.frame = CGRectMake(vertHeaderWidth, 0, self.grid_width - vertHeaderWidth, horiHeaderHeight);
        }
        
        if (self.cornerView) {
            self.cornerView.frame = CGRectMake(0, 0, vertHeaderWidth, horiHeaderHeight);
        }
    } else {
        self.horizontalHeaderContainerView.hidden = YES;
    }
    
    // 左侧标题的frame
    self.verticalHeaderScrollView.frame = CGRectMake(0, horiHeaderHeight, vertHeaderWidth, self.grid_height - horiHeaderHeight);
    
    self.containerScrollView.frame = CGRectMake(vertHeaderWidth, horiHeaderHeight, self.grid_width - vertHeaderWidth, self.grid_height - horiHeaderHeight);
    
    // 右侧容器视图的容器内容大小
    if (self.gridFrameDelegate && [self.gridFrameDelegate respondsToSelector:@selector(contentWidthInGridFrame:)]) {
        self.containerScrollView.contentSize = CGSizeMake([self.gridFrameDelegate contentWidthInGridFrame:self], self.containerScrollView.grid_height);
    } else {
        self.containerScrollView.contentSize = self.containerScrollView.frame.size;
    }
    
    // 右侧容器视图的frame
    self.contentScrollView.frame = CGRectMake(0, 0, self.containerScrollView.contentSize.width, self.containerScrollView.contentSize.height);
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
    if ([scrollView isEqual:self.verticalHeaderScrollView]) {
        destScroll = self.contentScrollView;
    } else if ([scrollView isEqual:self.contentScrollView]) {
        destScroll = self.verticalHeaderScrollView;
    } else if ([scrollView isEqual:self.containerScrollView]) {
        if (self.horizontalHeaderScrollView) {
            destScroll = self.horizontalHeaderScrollView;
        }
    } else if (self.horizontalHeaderScrollView && [scrollView isEqual:self.horizontalHeaderScrollView]) {
        destScroll = self.containerScrollView;
    }
    
    if (destScroll) {
        destScroll.contentOffset = scrollView.contentOffset;
    }
}

#pragma mark - Getter setter

- (UIScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[UIScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _containerScrollView;
}

- (UIView *)horizontalHeaderContainerView {
    if (!_horizontalHeaderContainerView) {
        _horizontalHeaderContainerView = [[UIView alloc] init];
        _horizontalHeaderContainerView.hidden = YES;
    }
    return _horizontalHeaderContainerView;
}

- (void)setVerticalHeaderScrollView:(UIScrollView *)verticalHeaderScrollView {
    if (_verticalHeaderScrollView) {
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

@end
