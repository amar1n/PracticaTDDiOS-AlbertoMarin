//
//  Euro.m
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Euro.h"
#import "Money-Private.h"

@interface Euro ()

@end

@implementation Euro

- (Euro*)times:(NSInteger)multiplier
{
    Euro* newEuro = [[Euro alloc] initWithAmount:[self.amount integerValue] * multiplier];
    return newEuro;
}

@end
