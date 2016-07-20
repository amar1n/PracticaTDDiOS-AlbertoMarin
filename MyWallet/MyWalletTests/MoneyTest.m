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

- (void)testThatTimesRaisesException
{
    Money* money = [[Money alloc] initWithAmount:1];
    XCTAssertThrows([money times:2], @"Sould raise an exception!");
}

@end
