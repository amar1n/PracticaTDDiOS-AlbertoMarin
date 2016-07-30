//
//  WalletTableViewController.m
//  MyWallet
//
//  Created by Alberto Marín García on 27/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "AddMoneyViewController.h"
#import "Broker.h"
#import "Constants.h"
#import "SubtotalViewCell.h"
#import "TotalViewCell.h"
#import "Wallet.h"
#import "WalletTableViewController.h"

@interface WalletTableViewController ()

@end

@implementation WalletTableViewController

#pragma mark - Initialization
- (id)initWithModel:(Wallet*)model broker:(Broker*)broker
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _model = model;
        _broker = broker;
        self.title = APP_NAME;
    }
    return self;
}

//MARK: - Syncing
- (void)syncModelWithView
{
    [self.tableView reloadData];
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SubtotalViewCell" bundle:nil] forCellReuseIdentifier:SUBTOTAL_CELL_ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"TotalViewCell" bundle:nil] forCellReuseIdentifier:TOTAL_CELL_ID];

    if ([[self.model.moneysByCurrency allKeys] count] > 0) {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Alta en notificacion
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(ratesAvailable:) name:RATES_AVAILABLE_NOTIFICATION_NAME object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [[self.model.moneysByCurrency allKeys] count] + 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* currency = [self getCurrencyForSection:section];
    if (currency != nil) {
        return [[self.model moneysByCurrency:currency] count] + 1;
    }
    else {
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* currency = [self getCurrencyForSection:indexPath.section];

    if (currency == nil) {
        return [self getTotalCell:tableView];
    }
    else {
        NSArray* moneysByCurrency = [self.model moneysByCurrency:currency];
        if (indexPath.row < [moneysByCurrency count]) {
            return [self getMoneyCell:tableView money:[moneysByCurrency objectAtIndex:indexPath.row]];
        }
        else {
            return [self getSubTotalCell:tableView currency:currency];
        }
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title = [self getCurrencyForSection:section];

    if (title != nil) {
        return title;
    }
    else {
        return @"Total";
    }
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* currency = [self getCurrencyForSection:indexPath.section];

    if (currency == nil) {
        return NO;
    }
    else {
        NSArray* moneysByCurrency = [self.model moneysByCurrency:currency];
        if (indexPath.row < [moneysByCurrency count]) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString* currency = [self getCurrencyForSection:indexPath.section];
        NSArray* moneysByCurrency = [self.model moneysByCurrency:currency];
        Money* money = [moneysByCurrency objectAtIndex:indexPath.row];
        [self.model takeMoney:money];

        [self syncModelWithView];
    }
}

#pragma mark - Utilities
- (NSString*)formatNumber:(Money*)number
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:4];
    [formatter setRoundingMode:NSNumberFormatterRoundUp];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:[[number amount] doubleValue]]];
}

- (UITableViewCell*)getTotalCell:(UITableView*)tableView
{
    TotalViewCell* cell = (TotalViewCell*)[tableView dequeueReusableCellWithIdentifier:TOTAL_CELL_ID];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TotalViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    @try {
        Money* total = [self.model reduceToCurrency:[self getDefaultCurrency] withBroker:self.broker];
        cell.totalLabel.text = [NSString stringWithFormat:@"%@ %@", [total currency], [self formatNumber:total]];
    }
    @catch (NSException* e) {
        cell.totalLabel.text = @"---";
    }

    return cell;
}

- (UITableViewCell*)getSubTotalCell:(UITableView*)tableView currency:(NSString*)currency
{
    SubtotalViewCell* cell = (SubtotalViewCell*)[tableView dequeueReusableCellWithIdentifier:SUBTOTAL_CELL_ID];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"SubtotalViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    NSArray* moneysByCurrency = [self.model moneysByCurrency:currency];

    Money* subTotal = [[Money alloc] initWithAmount:0 currency:currency];
    for (Money* item in moneysByCurrency) {
        subTotal = [subTotal plus:item];
    }

    @try {
        Money* subTotalReduced = [self.broker reduce:subTotal toCurrency:[self getDefaultCurrency]];
        cell.subTotalLabel.text = [NSString stringWithFormat:@"%@ :(%@)Subtotal", [self formatNumber:subTotalReduced], [self getDefaultCurrency]];
    }
    @catch (NSException* e) {
        cell.subTotalLabel.text = @"---";
    }

    return cell;
}

- (UITableViewCell*)getMoneyCell:(UITableView*)tableView money:(Money*)money
{
    static NSString* CellIdentifier = @"Cell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [money amount]];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;

    return cell;
}

- (NSString*)getCurrencyForSection:(NSInteger)section
{
    if (section >= [[self.model currencies] count]) {
        return nil;
    }
    return [[self.model currencies] objectAtIndex:section];
}

- (NSString*)getDefaultCurrency
{
    return DEFAULT_CURRENCY;
}

- (void)ratesAvailable:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(),
        ^{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(gotoAddMoney:)];
            [self syncModelWithView];
        });
}

- (void)moneyAdded:(NSNotification*)notification
{
    [self syncModelWithView];
}

- (void)gotoAddMoney:(id)sender
{
    AddMoneyViewController* moneyVC = [[AddMoneyViewController alloc] initWithBroker:self.broker];
    moneyVC.delegate = self;
    [self.navigationController pushViewController:moneyVC animated:YES];
}

#pragma mark - AddMoneyViewControllerDelegate
- (void)addMoneyViewControllerDidDismisWithNewMoney:(Money*)money
{
    [self.model addMoney:money];
    [self syncModelWithView];
}

@end
