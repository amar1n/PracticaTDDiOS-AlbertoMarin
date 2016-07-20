//
//  EuroTest.m
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Euro.h"
#import <XCTest/XCTest.h>

@interface EuroTest : XCTestCase

@end

@implementation EuroTest

- (void)testMultiplication
{
    Euro* euro = [[Euro alloc] initWithAmount:5];
    Euro* ten = [[Euro alloc] initWithAmount:10];
    Euro* total = [euro times:2];

    XCTAssertEqualObjects(total, ten, @"€5 * 2 should be €10!");
}

- (void)testEquality
{
    Euro* five = [[Euro alloc] initWithAmount:5];
    Euro* total = [five times:2];
    Euro* ten = [[Euro alloc] initWithAmount:10];

    XCTAssertEqualObjects(ten, total, @"Equivalent object should be equal!");
    XCTAssertFalse([total isEqual:five], @"Non equivalent object should not be equal!");
}

- (void)testHash
{
    Euro* a = [[Euro alloc] initWithAmount:2];
    Euro* b = [[Euro alloc] initWithAmount:2];

    XCTAssertEqual([a hash], [b hash], @"Equal objects must have same hash");
}

@end
