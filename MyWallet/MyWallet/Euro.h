//
//  Euro.h
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Money.h"
#import <Foundation/Foundation.h>

@interface Euro : Money

- (Euro*)times:(NSInteger)multiplier;

@end
