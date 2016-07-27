//
//  MoneyTest.m
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Money.h"
#import <XCTest/XCTest.h>

@interface MoneyTest : XCTestCase

@end

@implementation MoneyTest

- (void)testMultiplication
{
    Money* euro = [Money euroWithAmount:[NSNumber numberWithDouble:5.0]];
    Money* tenEuros = [Money euroWithAmount:[NSNumber numberWithDouble:10.0]];
    Money* totalEuros = [euro times:2];
    XCTAssertEqualObjects(totalEuros, tenEuros, @"€5 * 2 should be €10!");

    Money* dollar = [Money dollarWithAmount:[NSNumber numberWithDouble:5.0]];
    Money* tenDollars = [Money dollarWithAmount:[NSNumber numberWithDouble:10.0]];
    Money* totalDollars = [dollar times:2];
    XCTAssertEqualObjects(totalDollars, tenDollars, @"$5 * 2 should be $10!");
}

- (void)testEquality
{
    Money* five = [Money euroWithAmount:[NSNumber numberWithDouble:5.0]];
    Money* total = [five times:2];
    Money* ten = [Money euroWithAmount:[NSNumber numberWithDouble:10.0]];
    XCTAssertEqualObjects(ten, total, @"Equivalent object should be equal!");
    XCTAssertFalse([total isEqual:five],
        @"Non equivalent object should not be equal!");

    Money* fiveDollars = [Money dollarWithAmount:[NSNumber numberWithDouble:5.0]];
    Money* totalDollars = [fiveDollars times:2];
    Money* tenDollars = [Money dollarWithAmount:[NSNumber numberWithDouble:10.0]];
    XCTAssertEqualObjects(tenDollars, totalDollars,
        @"Equivalent object should be equal!");
}

- (void)testHash
{
    Money* a = [Money euroWithAmount:[NSNumber numberWithDouble:2.0]];
    Money* b = [Money euroWithAmount:[NSNumber numberWithDouble:2.0]];
    XCTAssertEqual([a hash], [b hash], @"Equal objects must have same hash");

    Money* aDollar = [Money dollarWithAmount:[NSNumber numberWithDouble:2.0]];
    Money* bDollar = [Money dollarWithAmount:[NSNumber numberWithDouble:2.0]];
    XCTAssertEqual([aDollar hash], [bDollar hash],
        @"Equal objects must have same hash");
}

- (void)testAmountStorage
{
    Money* euro = [Money euroWithAmount:[NSNumber numberWithDouble:2.0]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    XCTAssertEqual(2, [[euro performSelector:@selector(amount)] integerValue],
        @"The value retrived should be the same as the stored");
#pragma clang diagnostic pop

    Money* dollar = [Money dollarWithAmount:[NSNumber numberWithDouble:2.0]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    XCTAssertEqual(2, [[dollar performSelector:@selector(amount)] integerValue],
        @"The value retrived should be the same as the stored");
#pragma clang diagnostic pop
}

- (void)testCurrencies
{
    XCTAssertEqualObjects(@"EUR", [[Money euroWithAmount:[NSNumber numberWithDouble:5.0]] currency],
        @"The currency of euros should be EUR");

    XCTAssertEqualObjects(@"USD", [[Money dollarWithAmount:[NSNumber numberWithDouble:5.0]] currency],
        @"The currency of dollars should be USD");
}

- (void)testDifferentCurrencies
{
    Money* euro = [Money euroWithAmount:[NSNumber numberWithDouble:1.0]];
    Money* dollar = [Money dollarWithAmount:[NSNumber numberWithDouble:1.0]];
    XCTAssertNotEqualObjects(euro, dollar,
        @"Different currencies should be not equal");
}

- (void)testSimpleAddition
{
    XCTAssertEqualObjects([[Money dollarWithAmount:[NSNumber numberWithDouble:5.0]] plus:[Money dollarWithAmount:[NSNumber numberWithDouble:5.0]]], [Money dollarWithAmount:[NSNumber numberWithDouble:10.0]],
        @"$5 + $5 = $10");
}

- (void)testThatHashIsTheAmount
{
    Money* one = [Money dollarWithAmount:[NSNumber numberWithDouble:1.0]];
    XCTAssertEqual([one hash], 1, @"The hash must be the same as the amount");
}

- (void)testDescription
{
    Money* one = [Money dollarWithAmount:[NSNumber numberWithDouble:1.0]];
    NSString* desc = @"<Money: USD 1>";
    XCTAssertEqualObjects([one description], desc,
        @"The description must match with the template");
}

@end
