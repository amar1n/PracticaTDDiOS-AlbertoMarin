//
//  Broker.m
//  MyWallet
//
//  Created by Alberto Marín García on 25/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Broker.h"
#import "Money.h"

@interface Broker ()

@end

@implementation Broker

- (id)init
{
    if (self = [super init]) {
        _rates = [@{} mutableCopy];
    }
    return self;
}

- (Money*)reduce:(id<Money>)money toCurrency:(NSString*)currency
{
    // Double dispatch
    return [money reduceToCurrency:currency withBroker:self];
}

- (void)addRate:(NSInteger)rate
   fromCurrency:(NSString*)fromCurrency
     toCurrency:(NSString*)toCurrency
{
    [self.rates
        setObject:@(rate)
           forKey:[self keyFromCurrency:fromCurrency toCurrency:toCurrency]];

    [self.rates
        setObject:@(1.0 / rate)
           forKey:[self keyFromCurrency:toCurrency toCurrency:fromCurrency]];
}

#pragma mark - utils
- (NSString*)keyFromCurrency:(NSString*)fromCurrency
                  toCurrency:(NSString*)toCurrency
{
    return [NSString stringWithFormat:@"%@-%@", fromCurrency, toCurrency];
}

#pragma mark - Rates
- (void)parseJSONRates:(NSData*)jsonData
{
    NSError* err = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingAllowFragments
                                               error:&err];
    if (obj != nil) {
        // Añadimos los rates al broker
    }
    else {
        [NSException raise:@"NoRatesInJSONException" format:@"JSON must carry some data"];
    }
}

@end
