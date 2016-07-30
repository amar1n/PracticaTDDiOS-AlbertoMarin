//
//  AddMoneyViewControllerDelegate.h
//  MyWallet
//
//  Created by Alberto Marín García on 30/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Money.h"
#import <Foundation/Foundation.h>

@protocol AddMoneyViewControllerDelegate <NSObject>

- (void)addMoneyViewControllerDidDismisWithNewMoney:(Money*)money;

@end
