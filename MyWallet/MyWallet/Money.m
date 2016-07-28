//
//  Money.m
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Broker.h"
#import "Money.h"
#import "NSObject+GNUStepsAddons.h"

@interface Money ()

@property (nonatomic, strong) NSNumber* amount;

@end

@implementation Money

+ (id)euroWithAmount:(NSNumber*)amount
{
    return [[Money alloc] initWithAmount:amount currency:@"EUR"];
}

+ (id)dollarWithAmount:(NSNumber*)amount
{
    return [[Money alloc] initWithAmount:amount currency:@"USD"];
}

- (id)initWithAmount:(NSNumber*)amount currency:(NSString*)currency
{
    if (self = [super init]) {
        _amount = amount;
        _currency = currency;
    }
    return self;
}

- (id<Money>)times:(NSNumber*)multiplier
{
    Money* newMoney = [[Money alloc] initWithAmount:[NSNumber numberWithDouble:[self.amount doubleValue] * [multiplier doubleValue]]
                                           currency:self.currency];
    return newMoney;
}

- (id<Money>)plus:(Money*)other
{
    NSNumber* totalAmount = [NSNumber numberWithDouble:[self.amount doubleValue] + [other.amount doubleValue]];
    Money* total = [[Money alloc] initWithAmount:totalAmount currency:self.currency];
    return total;
}

- (id<Money>)reduceToCurrency:(NSString*)currency withBroker:(Broker*)broker
{
    // Comprobamos que la divisas de origen y destino son las mismas
    if ([self.currency isEqual:currency])
        return self;

    // Comprobamos que hay tasa de cambio
    double rate = [[broker.rates objectForKey:[broker keyFromCurrency:self.currency toCurrency:currency]]
        doubleValue];
    if (rate == 0) {
        [NSException raise:@"NoConversionRateException"
                    format:@"Must have a conversion rate from %@ to %@",
                    self.currency, currency];
    }

    NSNumber* newAmount = [NSNumber numberWithDouble:[self.amount doubleValue] * rate];
    Money* newMoney = [[Money alloc] initWithAmount:newAmount currency:currency];
    return newMoney;
}

#pragma mark - Overwritten
- (BOOL)isEqual:(id)object
{
    if ([self.currency isEqual:[object currency]]) {
        return self.amount == [object amount];
    }
    return NO;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@: %@ %@>", [self class], self.currency, self.amount];
}

- (NSUInteger)hash
{
    return [self.amount integerValue];
}

@end
