//
//  CourseModel.h
//  GridView
//
//  Created by 胡金友 on 2018/3/28.
//  Copyright © 2018年 胡金友. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *class1;
@property (nonatomic, copy) NSString *class2;
@property (nonatomic, copy) NSString *class3;
@property (nonatomic, copy) NSString *class4;
@property (nonatomic, copy) NSString *class5;
@property (nonatomic, copy) NSString *class6;
@property (nonatomic, copy) NSString *class7;
@property (nonatomic, copy) NSString *class8;
@property (nonatomic, copy) NSString *class9;
@property (nonatomic, copy) NSString *class10;

- (NSString *)courseAt:(NSInteger)index;

@end
