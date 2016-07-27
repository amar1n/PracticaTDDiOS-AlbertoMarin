//
//  WalletTableViewController.h
//  MyWallet
//
//  Created by Alberto Marín García on 27/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Wallet;

@interface WalletTableViewController : UITableViewController

- (id)initWithModel:(Wallet*)model;

@end
