//
//  WalletTableViewController.h
//  MyWallet
//
//  Created by Alberto Marín García on 27/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "AddMoneyViewControllerDelegate.h"
#import <UIKit/UIKit.h>

@interface WalletTableViewController : UITableViewController <AddMoneyViewControllerDelegate>

@property (nonatomic, strong) Wallet* model;
@property (nonatomic, strong) Broker* broker;

- (id)initWithModel:(Wallet*)model broker:(Broker*)broker;

@end
