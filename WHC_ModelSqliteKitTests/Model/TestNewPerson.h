//
//  TestNewPerson.h
//  WHC_ModelSqliteKit
//
//  Created by 柯磊 on 2017/5/24.
//  Copyright © 2017年 WHC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestSchool.h"

@interface TestNewPerson : NSObject
/// 主键
@property (nonatomic, assign) NSInteger whcId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long age;
@property (nonatomic, assign) float weight;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) BOOL isDeveloper;
@property (nonatomic, assign) char sex;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) TestSchool *school;

@property (nonatomic, strong) NSString *ignoreAttr1;
@property (nonatomic, strong) NSString *ignoreAttr2;
@property (nonatomic, strong) NSString *ignoreAttr3;

@property (nonatomic, copy) NSString *nickname;
@end
