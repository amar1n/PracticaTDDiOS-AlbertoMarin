//
//  Broker.h
//  MyWallet
//
//  Created by Alberto Marín García on 25/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Money.h"
#import <Foundation/Foundation.h>

@interface Broker : NSObject

@property (strong, nonatomic) NSMutableDictionary* rates;
@property (strong, nonatomic) NSMutableArray* currenciesNames;

- (void)initRates;
- (Money*)reduce:(id<Money>)money toCurrency:(NSString*)currency;
- (void)addRate:(NSNumber*)rate fromCurrency:(NSString*)fromCurrency toCurrency:(NSString*)toCurrency;
- (NSString*)keyFromCurrency:(NSString*)fromCurrency toCurrency:(NSString*)toCurrency;
- (void)parseJSONRates:(NSData*)jsonData;

@end
