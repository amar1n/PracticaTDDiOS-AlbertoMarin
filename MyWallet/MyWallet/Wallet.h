//
//  Wallet.h
//  MyWallet
//
//  Created by Alberto Marín García on 26/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Money.h"
#import <Foundation/Foundation.h>

@interface Wallet : NSObject <Money>

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSUInteger countCurrencies;
@property (nonatomic, readonly) NSArray* currencies;

- (Money*)moneyAtIndex:(int)index;
- (void)subscribeToMemoryWarning:(NSNotificationCenter*)nc;
- (void)addMoney:(Money*)money;
- (void)takeMoney:(Money*)money;
- (NSArray*)moneysByCurrency:(NSString*)currency;

@end
