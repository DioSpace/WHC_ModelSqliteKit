//
//  WHC_ModelSqliteKitTests.m
//  WHC_ModelSqliteKitTests
//
//  Created by 柯磊 on 2017/5/21.
//  Copyright © 2017年 WHC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WHC_ModelSqlite.h"
#import "TestPerson.h"
#import "TestNewPerson.h"
#import "TestSchool.h"

@interface WHC_ModelSqliteKitTests : XCTestCase
@property (nonatomic, strong) WHC_ModelSqlite *db;
@end

@implementation WHC_ModelSqliteKitTests

- (void)setUp {
    [super setUp];
    //
}

- (void)tearDown {
    //
    [super tearDown];
}

- (void)testDB {
    // -------------- 创建数据库
    TestSchool *school = [TestSchool new];
    school.name = @"大学";
    school.personCount = 5;
    XCTAssertTrue([self.db insert:school], @"创建数据库或插入数据失败");
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:self.db.filePath], @"创建数据库失败");
    
    // -------------- InsertPerson
    TestPerson *person = [self createPerson];
    person.whcId = 200;
    
    XCTAssertTrue([self.db insert:person], @"插入数据失败");
    
    NSArray<TestPerson *> *items = [self.db query:TestPerson.self];
    NSInteger count = items.count;
    XCTAssertTrue(count == 1, @"应该只有1条数据才对，返回了%@条", @(count));
    
    TestPerson *dbPerson = items.firstObject;
    XCTAssertTrue(dbPerson.whcId == 1, @"返回的主键值%@错误", @(items.firstObject.whcId));
    [self checkEqualWithPerson1:dbPerson person2:person];
    
    // -------------- InsertPersons
    TestPerson *person1 = [self createPerson];
    TestPerson *person2 = [self createPerson];
    TestPerson *person3 = [self createPerson];
    
    person1.name = @"name1";
    person2.name = @"name2";
    person3.name = @"name3";
    
    items = @[person1, person2, person3];
    XCTAssertTrue([self.db inserts:items], @"批量插入数据失败");
    
    NSArray<TestPerson *> *dbItems = [self.db query:TestPerson.self where:@"_id > 1"];
    XCTAssertTrue(dbItems.count == items.count, @"应返回%@条数据，实际返回了%@条", @(items.count), @(dbItems.count));
    
    for (NSInteger i = 0; (i < items.count) && (i < dbItems.count); i++) {
        NSLog(@"check index %lld", (long long)i);
        [self checkEqualWithPerson1:dbItems[i] person2:items[i]];
    }
    
    // -------------- UpdatePerson
    person = [self createPerson];
    person.name = @"柯磊";
    
    [[self.db query:TestPerson.self] enumerateObjectsUsingBlock:^(TestPerson * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%lld", (long long)obj.whcId);
    }];
    
    XCTAssertTrue([self.db update:person where:@"_id = 1"], @"更新数据失败");
    dbPerson = [self.db query:TestPerson.self where:@"_id = 1"].firstObject;
    XCTAssertTrue(dbPerson, @"查询数据失败");
    [self checkEqualWithPerson1:dbPerson person2:person];
    
    // -------------- Person Count
    count = [self.db count:TestPerson.self];
    XCTAssertTrue(count == 4, @"数据库里应该有4条数据才对，返回的%@条", @(count));
    
    // -------------- Delete Person
    XCTAssertTrue([self.db delete:TestPerson.self where:@"_id = 2"], @"删除记录失败");
    count = [self.db count:TestPerson.self];
    XCTAssertTrue(count == 3, @"数据库里应该有3条数据才对，返回的%@条", @(count));
    
    // -------------- Upgrade Person
    TestNewPerson *newPerson = [TestNewPerson new];
    newPerson.nickname = @"欧阳";
    newPerson.name = @"";
    newPerson.school = [TestSchool new];
    newPerson.school.name = @"大学";
    newPerson.school.personCount = 4;
    XCTAssertTrue([self.db insert:newPerson], @"升级 插入数据失败");
    
    NSArray<TestNewPerson *> *newPersonItems = [self.db query:TestNewPerson.self];
    count = newPersonItems.count;
    XCTAssertTrue(count == 4, @"应该有4条数据才对，返回了%@条", @(count));
    [self checkEqualWithNewPerson1:newPersonItems.lastObject newPerson2:newPerson];
    
    // -------------- RemoveDBFile
    [self.db removeAllModel];
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:self.db.filePath], @"删除数据库失败");
}

#pragma mark - private methods

- (WHC_ModelSqlite *)db {
    if (!_db) {
        NSString *dbFilePath = [NSString stringWithFormat:@"%@/Library/Caches/DB/testDB.sqlite", NSHomeDirectory()];
        if ([[NSFileManager defaultManager] fileExistsAtPath:dbFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:dbFilePath error:nil];
        }
        _db = [[WHC_ModelSqlite alloc] initWithFilePath:dbFilePath];
    }
    return _db;
}

- (TestPerson *)createPerson {
    TestPerson *person = [TestPerson new];
    person.whcId = 200;
    person.name = @"kelei";
    person.age = 30;
    person.weight = 150;
    person.height = 175.2;
    person.isDeveloper = YES;
    person.sex = 'l';
    person.number = @(222);
    person.date = [NSDate dateWithTimeIntervalSince1970:1495591413];
    person.data = UIImagePNGRepresentation([UIImage imageNamed:@"image"]);
    person.array = @[@"1", @(3)];
    person.dict = @{@"k1": @"v1", @"k2": @(4)};
    person.school = [TestSchool new];
    person.school.name = @"小学";
    person.school.personCount = 3;
    person.ignoreAttr1 = @"1";
    person.ignoreAttr2 = @"2";
    person.ignoreAttr3 = @"3";
    return person;
}

- (void)checkEqualWithNewPerson1:(TestNewPerson *)person1 newPerson2:(TestNewPerson *)person2 {
    XCTAssertTrue([person1.nickname isEqualToString:person2.nickname], @"%@ != %@", person1.nickname, person2.nickname);
    
    XCTAssertTrue([person1.name isEqualToString:person2.name], @"%@ != %@", person1.name, person2.name);
    XCTAssertTrue(person1.age == person2.age, @"%ld != %ld", person1.age, person2.age);
    XCTAssertTrue(person1.weight == person2.weight, @"");
    XCTAssertTrue(person1.height == person2.height, @"");
    XCTAssertTrue(person1.isDeveloper == person2.isDeveloper, @"");
    XCTAssertTrue(person1.sex == person2.sex, @"");
    XCTAssertTrue(person1.number.integerValue == person2.number.integerValue, @"");
    XCTAssertTrue([person1.date timeIntervalSince1970] == [person2.date timeIntervalSince1970], @"");
    XCTAssertTrue(person1.data.length == person2.data.length, @"");
    
    XCTAssertTrue(person1.array.count == person2.array.count, @"");
    if (person1.array.count) {
        XCTAssertTrue([person1.array[0] isEqual:person2.array[0]], @"");
        XCTAssertTrue([person1.array[1] integerValue] == [person2.array[1] integerValue], @"");
    }
    
    XCTAssertTrue(person1.dict.allKeys.count == person2.dict.allKeys.count, @"");
    if (person1.dict.allKeys.count) {
        XCTAssertTrue([person1.dict[@"k1"] isEqual:person2.dict[@"k1"]], @"");
        XCTAssertTrue([person1.dict[@"k2"] integerValue] == [person2.dict[@"k2"] integerValue], @"");
    }
    
    XCTAssertTrue(person1.school, @"");
    XCTAssertTrue([person1.school.name isEqualToString:person2.school.name], @"");
    XCTAssertTrue(person1.school.personCount == person2.school.personCount, @"");
    
    XCTAssertFalse(person1.ignoreAttr1, @"");
    XCTAssertFalse(person1.ignoreAttr2, @"");
    XCTAssertFalse(person1.ignoreAttr3, @"");
}

- (void)checkEqualWithPerson1:(TestPerson *)person1 person2:(TestPerson *)person2 {
    XCTAssertTrue([person1.name isEqualToString:person2.name], @"");
    XCTAssertTrue(person1.age == person2.age, @"");
    XCTAssertTrue(person1.weight == person2.weight, @"");
    XCTAssertTrue(person1.height == person2.height, @"");
    XCTAssertTrue(person1.isDeveloper == person2.isDeveloper, @"");
    XCTAssertTrue(person1.sex == person2.sex, @"");
    XCTAssertTrue(person1.number.integerValue == person2.number.integerValue, @"");
    XCTAssertTrue([person1.date timeIntervalSince1970] == [person2.date timeIntervalSince1970], @"");
    XCTAssertTrue(person1.data.length == person2.data.length, @"");
    
    XCTAssertTrue(person1.array.count == person2.array.count, @"");
    XCTAssertTrue([person1.array[0] isEqual:person2.array[0]], @"");
    XCTAssertTrue([person1.array[1] integerValue] == [person2.array[1] integerValue], @"");
    
    XCTAssertTrue(person1.dict.allKeys.count == person2.dict.allKeys.count, @"");
    XCTAssertTrue([person1.dict[@"k1"] isEqual:person2.dict[@"k1"]], @"");
    XCTAssertTrue([person1.dict[@"k2"] integerValue] == [person2.dict[@"k2"] integerValue], @"");
    
    XCTAssertTrue(person1.school, @"");
    XCTAssertTrue([person1.school.name isEqualToString:person2.school.name], @"");
    XCTAssertTrue(person1.school.personCount == person2.school.personCount, @"");
    
    XCTAssertFalse(person1.ignoreAttr1, @"");
    XCTAssertFalse(person1.ignoreAttr2, @"");
    XCTAssertFalse(person1.ignoreAttr3, @"");
}

@end
