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

@property (strong, nonatomic) NSMutableDictionary* moneysByCurrency;

@property (nonatomic, readonly) NSArray* currencies;

- (void)subscribeToMemoryWarning:(NSNotificationCenter*)nc;
- (void)addMoney:(Money*)money;
- (void)takeMoney:(Money*)money;
- (NSArray*)moneysByCurrency:(NSString*)currency;

@end
