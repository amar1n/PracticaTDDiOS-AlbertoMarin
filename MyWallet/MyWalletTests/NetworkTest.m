//
//  NetworkTest.m
//  MyWallet
//
//  Created by Alberto Marín García on 27/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Broker.h"
#import <XCTest/XCTest.h>

@interface NetworkTest : XCTestCase

@end

@implementation NetworkTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testThatEmptyRatesRaisesException
{
    Broker* broker = [Broker new];

    NSData* jsonData = nil;

    XCTAssertThrows([broker parseJSONRates:jsonData], @"An empty JSON should raises an exception");
}

@end
