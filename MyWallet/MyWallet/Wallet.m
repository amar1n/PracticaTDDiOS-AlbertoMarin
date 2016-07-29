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

@property (strong, nonatomic) NSMutableArray* moneys;
@property (strong, nonatomic) NSMutableDictionary* moneysByCurrency;

@end

@implementation Wallet

- (NSUInteger)count
{
    return [self.moneys count];
}

- (NSUInteger)countCurrencies
{
    return [self.moneysByCurrency count];
}

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
        _moneys = [NSMutableArray array];
        [_moneys addObject:money];

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
    NSMutableArray* newMoneys = [NSMutableArray arrayWithCapacity:self.moneys.count];
    for (Money* item in self.moneys) {
        Money* newMoney = [item times:multiplier];
        [newMoneys addObject:newMoney];
    }
    self.moneys = newMoneys;
    return self;
}

- (id<Money>)reduceToCurrency:(NSString*)currency withBroker:(Broker*)broker
{
    Money* result = [[Money alloc] initWithAmount:0 currency:currency];

    for (Money* item in self.moneys) {
        result = [result plus:[item reduceToCurrency:currency withBroker:broker]];
    }
    return result;
}

- (Money*)moneyAtIndex:(int)index
{
    return [self.moneys objectAtIndex:index];
}

- (void)addMoney:(Money*)money
{
    [self.moneys addObject:money];

    NSMutableArray* moneysOfOneCurrency = [self.moneysByCurrency objectForKey:[money currency]];
    if (moneysOfOneCurrency == nil) {
        moneysOfOneCurrency = [NSMutableArray array];
        [self.moneysByCurrency setObject:moneysOfOneCurrency forKey:[money currency]];
    }
    [moneysOfOneCurrency addObject:money];
}

- (void)takeMoney:(Money*)money
{
    [self.moneys removeObject:money];

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

@end
