//
//  Wallet.m
//  MyWallet
//
//  Created by Alberto Marín García on 26/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Wallet.h"

@interface Wallet ()

@property(strong, nonatomic) NSMutableArray *moneys;

@end

@implementation Wallet

- (NSUInteger)count {
  return [self.moneys count];
}

- (id)initWithAmount:(NSInteger)amount currency:(NSString *)currency {
  if (self = [super init]) {
    Money *money = [[Money alloc] initWithAmount:amount currency:currency];
    _moneys = [NSMutableArray array];
    [_moneys addObject:money];
  }
  return self;
}

- (id<Money>)plus:(Money *)other {
  [self.moneys addObject:other];
  return self;
}

- (id<Money>)times:(NSInteger)multiplier {
  NSMutableArray *newMoneys =
      [NSMutableArray arrayWithCapacity:self.moneys.count];
  for (Money *item in self.moneys) {
    Money *newMoney = [item times:multiplier];
    [newMoneys addObject:newMoney];
  }
  self.moneys = newMoneys;
  return self;
}

- (id<Money>)reduceToCurrency:(NSString *)currency withBroker:(Broker *)broker {
  Money *result = [[Money alloc] initWithAmount:0 currency:currency];

  for (Money *item in self.moneys) {
    result = [result plus:[item reduceToCurrency:currency withBroker:broker]];
  }
  return result;
}

@end
