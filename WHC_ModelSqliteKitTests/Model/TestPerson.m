//
//  TestPerson.m
//  WHC_ModelSqliteKit
//
//  Created by 柯磊 on 2017/5/21.
//  Copyright © 2017年 WHC. All rights reserved.
//

#import "TestPerson.h"

@implementation TestPerson

+ (NSString *)whc_SqliteTableName {
    return @"Persons";
}

+ (NSArray *)whc_IgnorePropertys {
    return @[@"ignoreAttr1",
             @"ignoreAttr2",
             @"ignoreAttr3"];
}

@end
