//
//  NSNotificationCenterTest.m
//  MyWallet
//
//  Created by Alberto Marín García on 27/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "FakeNSNotificationCenter.h"
#import "Wallet.h"
#import <XCTest/XCTest.h>

@interface NSNotificationCenterTest : XCTestCase

@end

@implementation NSNotificationCenterTest

- (void)testThatSubscribesToMemoryWarning
{
    FakeNSNotificationCenter* fake = [FakeNSNotificationCenter new];

    Wallet* wallet = [Wallet new];
    [wallet subscribeToMemoryWarning:(NSNotificationCenter*)fake];

    NSDictionary* obs = [fake observers];
    id observer = [obs objectForKey:UIApplicationDidReceiveMemoryWarningNotification];

    XCTAssertEqualObjects(observer, wallet, @"Fat object must subscribe to UIApplicationDidReceiveMemoryWarningNotification");
}

@end
