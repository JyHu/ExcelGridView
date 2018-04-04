//
//  NSDate+Helper.m
//  GridView
//
//  Created by 胡金友 on 2018/3/28.
//  Copyright © 2018年 胡金友. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

- (NSString *)dateString {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyy/MM/dd";
    return [fmt stringFromDate:self];
}

@end
