//
//  CourseModel.m
//  GridView
//
//  Created by 胡金友 on 2018/3/28.
//  Copyright © 2018年 胡金友. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel

- (instancetype)init {
    if (self = [super init]) {
        NSArray *classes = @[@"语文", @"数学", @"英语", @"历史", @"政治", @"化学", @"生物", @"物理", @"地理"];
        
        self.class1 = classes[arc4random()%classes.count];
        self.class2 = classes[arc4random()%classes.count];
        self.class3 = classes[arc4random()%classes.count];
        self.class4 = classes[arc4random()%classes.count];
        self.class5 = classes[arc4random()%classes.count];
        self.class6 = classes[arc4random()%classes.count];
        self.class7 = classes[arc4random()%classes.count];
        self.class8 = classes[arc4random()%classes.count];
        self.class9 = classes[arc4random()%classes.count];
        self.class10 = classes[arc4random()%classes.count];
    }
    return self;
}

- (NSString *)courseAt:(NSInteger)index {
    return [self valueForKey:[NSString stringWithFormat:@"class%@", @(index + 1)]];
}

@end
