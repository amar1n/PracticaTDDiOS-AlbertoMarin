//
//  Wallet.m
//  MyWallet
//
//  Created by Alberto Marín García on 26/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Wallet.h"
#import <UIKit/UIKit.h>

@interface Wallet ()

@end

@implementation Wallet

// Retorna un arreglo de Strings que representan a las currencies, ordenadas alfabeticamente
- (NSArray*)currencies
{
    NSArray* currencies = [self.moneysByCurrency allKeys];
    return [currencies sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (id)initWithAmount:(NSNumber*)amount currency:(NSString*)currency
{
    if (self = [super init]) {
        Money* money = [[Money alloc] initWithAmount:amount currency:currency];

        _moneysByCurrency = [NSMutableDictionary dictionary];
        NSMutableArray* moneysOfOneCurrency = [NSMutableArray array];
        [moneysOfOneCurrency addObject:money];
        [_moneysByCurrency setObject:moneysOfOneCurrency forKey:[money currency]];
    }
    return self;
}

- (id<Money>)plus:(Money*)other
{
    [self addMoney:other];

    return self;
}

- (id<Money>)times:(NSNumber*)multiplier
{
    NSMutableDictionary* moneysByCurrencyAUX = [NSMutableDictionary dictionary];
    for (NSString* currency in [[self moneysByCurrency] allKeys]) {
        NSMutableArray* moneysOfOneCurrencyAUX = [NSMutableArray array];
        [moneysByCurrencyAUX setObject:moneysOfOneCurrencyAUX forKey:currency];

        for (Money* money in [self.moneysByCurrency objectForKey:currency]) {
            Money* newMoney = [money times:multiplier];
            [moneysOfOneCurrencyAUX addObject:newMoney];
        }
    }
    self.moneysByCurrency = moneysByCurrencyAUX;

    return self;
}

- (id<Money>)reduceToCurrency:(NSString*)currency withBroker:(Broker*)broker
{
    Money* result = [[Money alloc] initWithAmount:0 currency:currency];

    for (Money* item in [self allMoneys]) {
        result = [result plus:[item reduceToCurrency:currency withBroker:broker]];
    }
    return result;
}

- (void)addMoney:(Money*)money
{
    NSMutableArray* moneysOfOneCurrency = [self.moneysByCurrency objectForKey:[money currency]];
    if (moneysOfOneCurrency == nil) {
        moneysOfOneCurrency = [NSMutableArray array];
        [self.moneysByCurrency setObject:moneysOfOneCurrency forKey:[money currency]];
    }
    [moneysOfOneCurrency addObject:money];
}

- (void)takeMoney:(Money*)money
{
    NSMutableArray* moneysOfOneCurrency = [self.moneysByCurrency objectForKey:[money currency]];
    [moneysOfOneCurrency removeObject:money];
    if ([moneysOfOneCurrency count] == 0) {
        [self.moneysByCurrency removeObjectForKey:[money currency]];
    }
}

// Retorna un arreglo de Money ordenados por su cantidad de manera ascendente
- (NSArray*)moneysByCurrency:(NSString*)currency
{
    NSMutableArray* moneysOfOneCurrency = [self.moneysByCurrency objectForKey:currency];
    if (moneysOfOneCurrency == nil) {
        return [NSArray array];
    }

    NSArray* result = [moneysOfOneCurrency copy];
    return [result sortedArrayUsingComparator:^(Money* m1, Money* m2) {
        return [[m1 amount] compare:[m2 amount]];
    }];
}

#pragma mark - Notifications
- (void)subscribeToMemoryWarning:(NSNotificationCenter*)nc
{
    [nc addObserver:self selector:@selector(dumpToDisk:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)dumpToDisk:(NSNotification*)notification
{
}

#pragma mark - Utils
- (NSArray*)allMoneys
{
    NSMutableArray* result = [@[] mutableCopy];

    for (NSArray* a in [self.moneysByCurrency allValues]) {
        for (Money* m in a) {
            [result addObject:m];
        }
    }
    return result;
}

@end
