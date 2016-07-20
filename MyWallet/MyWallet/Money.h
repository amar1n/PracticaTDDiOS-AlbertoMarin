//
//  Money.h
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Money : NSObject

- (id)initWithAmount:(NSInteger)amount;
- (Money*)times:(NSInteger)multiplier;

@end
