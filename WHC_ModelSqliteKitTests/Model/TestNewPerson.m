//
//  TestNewPerson.m
//  WHC_ModelSqliteKit
//
//  Created by 柯磊 on 2017/5/24.
//  Copyright © 2017年 WHC. All rights reserved.
//

#import "TestNewPerson.h"

@implementation TestNewPerson

+ (NSString *)whc_SqliteTableName {
    return @"Persons";
}

+ (NSArray *)whc_IgnorePropertys {
    return @[@"ignoreAttr1",
             @"ignoreAttr2",
             @"ignoreAttr3"];
}

+ (NSString *)whc_SqliteVersion {
    return @"1.0.1";
}

@end
