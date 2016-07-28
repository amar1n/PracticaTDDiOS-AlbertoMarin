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

- (void)initRates
{
    //    NSURL* url = [NSURL URLWithString:@"http://www.floatrates.com/daily/eur.json"];
    //    NSData* jsonData = [NSData dataWithContentsOfURL:url];
    //    [self parseJSONRates:jsonData];

    dispatch_queue_t cola_x = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(cola_x,
        ^{
            NSURL* url = [NSURL URLWithString:@"http://www.floatrates.com/daily/eur.json"];
            NSData* jsonData = [NSData dataWithContentsOfURL:url];
            if (jsonData != nil) {
                [self parseJSONRates:jsonData];
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                NSNotification* notif = [[NSNotification alloc] initWithName:RATES_AVAILABLE_NOTIFICATION_NAME object:self userInfo:nil];
                [nc postNotification:notif];
            }
        });
}

- (Money*)reduce:(id<Money>)money toCurrency:(NSString*)currency
{
    // Double dispatch
    return [money reduceToCurrency:currency withBroker:self];
}

- (void)addRate:(NSNumber*)rate
   fromCurrency:(NSString*)fromCurrency
     toCurrency:(NSString*)toCurrency
{
    [self.rates setObject:rate forKey:[self keyFromCurrency:fromCurrency toCurrency:toCurrency]];

    [self.rates setObject:@(1.0 / [rate doubleValue]) forKey:[self keyFromCurrency:toCurrency toCurrency:fromCurrency]];
}

#pragma mark - utils
- (NSString*)keyFromCurrency:(NSString*)fromCurrency toCurrency:(NSString*)toCurrency
{
    return [NSString stringWithFormat:@"%@-%@", fromCurrency, toCurrency];
}

#pragma mark - Rates
- (void)parseJSONRates:(NSData*)jsonData
{
    if (jsonData == nil) {
        [NSException raise:@"NoRatesInJSONException" format:@"JSON cannot be nil"];
    }
    NSError* err = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingAllowFragments
                                               error:&err];
    if (obj != nil) {
        // Añadimos los rates al broker
        for (NSObject* item in obj) {
            NSDictionary* rate = [obj objectForKey:item];
            [self addRate:[rate objectForKey:@"rate"] fromCurrency:@"EUR" toCurrency:[rate objectForKey:@"alphaCode"]];
        }
    }
    else {
        [NSException raise:@"NoRatesInJSONException" format:@"JSON must carry some data"];
    }
}

@end
