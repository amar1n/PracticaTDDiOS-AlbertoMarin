//
//  Money.h
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Money : NSObject

@property(readonly, nonatomic) NSString *currency;

+ (id)euroWithAmount:(NSInteger)amount;
+ (id)dollarWithAmount:(NSInteger)amount;
- (id)initWithAmount:(NSInteger)amount currency:(NSString *)currency;
- (id)times:(NSInteger)multiplier;
- (Money *)plus:(Money *)other;

@end
