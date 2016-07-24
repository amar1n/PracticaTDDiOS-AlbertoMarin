//
//  Money.m
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Money-Private.h"
#import "Money.h"
#import "NSObject+GNUStepsAddons.h"

@implementation Money

- (id)initWithAmount:(NSInteger)amount
{
    if (self = [super init]) {
        _amount = @(amount);
    }
    return self;
}

- (Money*)times:(NSInteger)multiplier
{
    // No se debería llamar. Se debería usar el de cualquier subclase
    return [self subclassResponsability:_cmd];
}

#pragma mark - Overwritten
- (BOOL)isEqual:(id)object
{
    return self.amount == [object amount];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@ %ld>", [self class], (long)[self amount]];
}

- (NSUInteger)hash
{
    return (NSUInteger)self.amount;
}

@end
