//
//  AddMoneyViewController.h
//  MyWallet
//
//  Created by Alberto Marín García on 29/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "AddMoneyViewControllerDelegate.h"
#import <UIKit/UIKit.h>
@class Wallet;
@class Broker;
@class Money;

@interface AddMoneyViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<AddMoneyViewControllerDelegate> delegate;
@property (nonatomic, strong) Broker* broker;

@property (weak, nonatomic) IBOutlet UIPickerView* ratesPickerView;
@property (weak, nonatomic) IBOutlet UITextField* amountFieldView;
@property (weak, nonatomic) IBOutlet UIToolbar* keyboardToolbar;

- (id)initWithBroker:(Broker*)broker;
- (IBAction)ok:(id)sender;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;

@end
