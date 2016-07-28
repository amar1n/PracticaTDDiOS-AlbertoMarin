//
//  BrokerTest.m
//  MyWallet
//
//  Created by Alberto Marín García on 25/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Broker.h"
#import "Money.h"
#import <XCTest/XCTest.h>

@interface BrokerTest : XCTestCase

@property (strong, nonatomic) Broker* emptyBroker;
@property (strong, nonatomic) Money* oneDollar;

@end

@implementation BrokerTest

- (void)setUp
{
    [super setUp];
    self.emptyBroker = [Broker new];
    self.oneDollar = [Money dollarWithAmount:[NSNumber numberWithDouble:1.0]];
}

- (void)tearDown
{
    [super tearDown];
    self.emptyBroker = nil;
    self.oneDollar = nil;
}

- (void)testSimpleReduction
{
    Money* sum = [[Money dollarWithAmount:[NSNumber numberWithDouble:5.0]] plus:[Money dollarWithAmount:[NSNumber numberWithDouble:5.0]]];
    Money* reduced = [self.emptyBroker reduce:sum toCurrency:@"USD"];
    XCTAssertEqualObjects(sum, reduced,
        @"Conversion to same currency should be a NOP");
}

// 10$ = 5€ 2:1
- (void)testReduction
{
    [self.emptyBroker addRate:[NSNumber numberWithDouble:2.0] fromCurrency:@"EUR" toCurrency:@"USD"];

    Money* dollars = [Money dollarWithAmount:[NSNumber numberWithDouble:10.0]];
    Money* euros = [Money euroWithAmount:[NSNumber numberWithDouble:5.0]];

    Money* converted = [self.emptyBroker reduce:dollars toCurrency:@"EUR"];

    XCTAssertEqualObjects(converted, euros, @"10$ = 5€ 2:1");
}

- (void)testThatNoRateRaisesException
{
    XCTAssertThrows([self.emptyBroker reduce:self.oneDollar toCurrency:@"EUR"],
        @"No rates should cause exception");
}

- (void)testThatNilConversionDoesNotChangeMoney
{
    XCTAssertEqualObjects(self.oneDollar, [self.emptyBroker reduce:self.oneDollar toCurrency:@"USD"],
        @"A nil conversion should have no effect");
}

@end
