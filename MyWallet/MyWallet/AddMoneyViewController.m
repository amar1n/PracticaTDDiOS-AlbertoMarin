//
//  AddMoneyViewController.m
//  MyWallet
//
//  Created by Alberto Marín García on 29/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "AddMoneyViewController.h"
#import "Broker.h"
#import "Constants.h"
#import "Wallet.h"

@interface AddMoneyViewController ()

@end

@implementation AddMoneyViewController

#pragma mark - Initialization
- (id)initWithBroker:(Broker*)broker;
{
    if (self = [super init]) {
        _broker = broker;
        self.title = @"Add money!!!";
    }
    return self;
}

#pragma mark - Actions
- (IBAction)ok:(id)sender
{
    [self.amountFieldView resignFirstResponder];

    if ([self.broker.currenciesNames count] > 0) {
        NSInteger currencySelected = [self.currenciesPickerView selectedRowInComponent:0];
        Money* money = [[Money alloc] initWithAmount:[NSNumber numberWithDouble:[self.amountFieldView.text doubleValue]]
                                            currency:[self.broker.currenciesNames objectAtIndex:currencySelected]];

        if ([[money amount] compare:[NSNumber numberWithDouble:0.0]] != NSOrderedSame) {
            if (_delegate && [_delegate respondsToSelector:@selector(addMoneyViewControllerDidDismisWithNewMoney:)]) {
                [_delegate addMoneyViewControllerDidDismisWithNewMoney:money];
            }

            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currenciesPickerView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.broker.currenciesNames count];
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.broker.currenciesNames objectAtIndex:row];
}

#pragma mark - Utils
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self.keyboardToolbar setHidden:NO];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];

    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self.keyboardToolbar.frame = frame;

    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];

    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height;
    self.keyboardToolbar.frame = frame;

    [UIView commitAnimations];
    [self.keyboardToolbar setHidden:YES];
}

@end
