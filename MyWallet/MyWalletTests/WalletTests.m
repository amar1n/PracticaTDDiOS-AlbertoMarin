//
//  WalletTest.m
//  MyWallet
//
//  Created by Alberto Marín García on 26/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Broker.h"
#import "Money.h"
#import "Wallet.h"
#import <XCTest/XCTest.h>

@interface WalletTest : XCTestCase

@end

@implementation WalletTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each
    // test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each
    // test method in the class.
    [super tearDown];
}

// €40 + $20 = $100 2:1
- (void)testAdditionWithReduction
{
    Broker* broker = [Broker new];
    [broker addRate:2 fromCurrency:@"EUR" toCurrency:@"USD"];
    Wallet* wallet = [[Wallet alloc] initWithAmount:[NSNumber numberWithDouble:40.0] currency:@"EUR"];
    [wallet plus:[Money dollarWithAmount:[NSNumber numberWithDouble:20.0]]];

    Money* reduced = [broker reduce:wallet toCurrency:@"USD"];

    XCTAssertEqualObjects(reduced, [Money dollarWithAmount:[NSNumber numberWithDouble:100.0]],
        @"€40 + $20 = $100 2:1");
}

@end
