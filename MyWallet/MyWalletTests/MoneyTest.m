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

- (void)testMultiplication {
  Money *euro = [Money euroWithAmount:5];
  Money *tenEuros = [Money euroWithAmount:10];
  Money *totalEuros = [euro times:2];
  XCTAssertEqualObjects(totalEuros, tenEuros, @"€5 * 2 should be €10!");

  Money *dollar = [Money dollarWithAmount:5];
  Money *tenDollars = [Money dollarWithAmount:10];
  Money *totalDollars = [dollar times:2];
  XCTAssertEqualObjects(totalDollars, tenDollars, @"$5 * 2 should be $10!");
}

- (void)testEquality {
  Money *five = [Money euroWithAmount:5];
  Money *total = [five times:2];
  Money *ten = [Money euroWithAmount:10];
  XCTAssertEqualObjects(ten, total, @"Equivalent object should be equal!");
  XCTAssertFalse([total isEqual:five],
                 @"Non equivalent object should not be equal!");

  Money *fiveDollars = [Money dollarWithAmount:5];
  Money *totalDollars = [fiveDollars times:2];
  Money *tenDollars = [Money dollarWithAmount:10];
  XCTAssertEqualObjects(tenDollars, totalDollars,
                        @"Equivalent object should be equal!");
}

- (void)testHash {
  Money *a = [Money euroWithAmount:2];
  Money *b = [Money euroWithAmount:2];
  XCTAssertEqual([a hash], [b hash], @"Equal objects must have same hash");

  Money *aDollar = [Money dollarWithAmount:2];
  Money *bDollar = [Money dollarWithAmount:2];
  XCTAssertEqual([aDollar hash], [bDollar hash],
                 @"Equal objects must have same hash");
}

- (void)testAmountStorage {
  Money *euro = [Money euroWithAmount:2];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  XCTAssertEqual(2, [[euro performSelector:@selector(amount)] integerValue],
                 @"The value retrived should be the same as the stored");
#pragma clang diagnostic pop

  Money *dollar = [Money dollarWithAmount:2];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  XCTAssertEqual(2, [[dollar performSelector:@selector(amount)] integerValue],
                 @"The value retrived should be the same as the stored");
#pragma clang diagnostic pop
}

- (void)testCurrencies {
  XCTAssertEqualObjects(@"EUR", [[Money euroWithAmount:5] currency],
                        @"The currency of euros should be EUR");

  XCTAssertEqualObjects(@"USD", [[Money dollarWithAmount:5] currency],
                        @"The currency of dollars should be USD");
}

- (void)testDifferentCurrencies {
  Money *euro = [Money euroWithAmount:1];
  Money *dollar = [Money dollarWithAmount:1];
  XCTAssertNotEqualObjects(euro, dollar,
                           @"Different currencies should be not equal");
}

- (void)testSimpleAddition {
  XCTAssertEqualObjects(
      [[Money dollarWithAmount:5] plus:[Money dollarWithAmount:5]],
      [Money dollarWithAmount:10], @"$5 + $5 = $10");
}

@end
