//
//  DollarTest.m
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Dollar.h"
#import <XCTest/XCTest.h>

@interface DollarTest : XCTestCase

@end

@implementation DollarTest

- (void)testMultiplication
{
    Dollar* dollar = [[Dollar alloc] initWithAmount:5];
    Dollar* ten = [[Dollar alloc] initWithAmount:10];
    Dollar* total = [dollar times:2];

    XCTAssertEqualObjects(total, ten, @"$5 * 2 should be $10!");
}

- (void)testEquality
{
    Dollar* five = [[Dollar alloc] initWithAmount:5];
    Dollar* total = [five times:2];
    Dollar* ten = [[Dollar alloc] initWithAmount:10];

    XCTAssertEqualObjects(ten, total, @"Equivalent object should be equal!");
}

- (void)testHash
{
    Dollar* a = [[Dollar alloc] initWithAmount:2];
    Dollar* b = [[Dollar alloc] initWithAmount:2];

    XCTAssertEqual([a hash], [b hash], @"Equal objects must have same hash");
}

- (void)testAmountStorage
{
    Dollar* dollar = [[Dollar alloc] initWithAmount:2];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    XCTAssertEqual(2, [[dollar performSelector:@selector(amount)] integerValue], @"The value retrived should be the same as the stored");
#pragma clang diagnostic pop
}

@end
