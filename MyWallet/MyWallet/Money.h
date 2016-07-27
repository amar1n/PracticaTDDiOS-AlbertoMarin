//
//  Money.h
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Money;
@class Broker;

@protocol Money <NSObject>

- (id)initWithAmount:(NSNumber*)amount currency:(NSString*)currency;
- (id<Money>)times:(NSInteger)multiplier;
- (id<Money>)plus:(Money*)other;
- (id<Money>)reduceToCurrency:(NSString*)currency withBroker:(Broker*)broker;

@end

@interface Money : NSObject <Money>

@property (readonly, nonatomic) NSString* currency;
@property (readonly, nonatomic, strong) NSNumber* amount;

+ (id)euroWithAmount:(NSNumber*)amount;
+ (id)dollarWithAmount:(NSNumber*)amount;

@end
