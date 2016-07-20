//
//  Dollar.m
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Dollar.h"

@interface Dollar ()

@end

@implementation Dollar

- (Dollar*)times:(NSInteger)multiplier
{
    Dollar* newDollar = [[Dollar alloc] initWithAmount:self.amount * multiplier];
    return newDollar;
}

@end
