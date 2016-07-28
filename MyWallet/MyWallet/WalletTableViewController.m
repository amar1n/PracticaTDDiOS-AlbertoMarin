//
//  WalletTableViewController.m
//  MyWallet
//
//  Created by Alberto Marín García on 27/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "Broker.h"
#import "SubtotalViewCell.h"
#import "TotalViewCell.h"
#import "Wallet.h"
#import "WalletTableViewController.h"

#define SUBTOTAL_CELL_ID @"SubTotalCell"
#define TOTAL_CELL_ID @"TotalCell"

@interface WalletTableViewController ()

@property (nonatomic, strong) Wallet* model;
@property (nonatomic, strong) Broker* broker;

@end

@implementation WalletTableViewController

- (id)initWithModel:(Wallet*)model broker:(Broker*)broker
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _model = model;
        _broker = broker;
        self.title = @"My Wallet";
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [self.tableView registerNib:[UINib nibWithNibName:@"SubtotalViewCell" bundle:nil] forCellReuseIdentifier:SUBTOTAL_CELL_ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"TotalViewCell" bundle:nil] forCellReuseIdentifier:TOTAL_CELL_ID];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return [self.model countCurrencies] + 1;
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
    if ([self.model count] == 0)
        return nil;

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

#pragma mark - Utilities
- (UITableViewCell*)getTotalCell:(UITableView*)tableView
{
    TotalViewCell* cell = (TotalViewCell*)[tableView dequeueReusableCellWithIdentifier:TOTAL_CELL_ID];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"TotalViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    Money* total = [self.model reduceToCurrency:[self getDefaultCurrency] withBroker:self.broker];
    cell.totalLabel.text = [NSString stringWithFormat:@"%@ %@", [total currency], [total amount]];

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

    Money* subTotalReduced = [self.broker reduce:subTotal toCurrency:[self getDefaultCurrency]];

    cell.subTotalLabel.text = [NSString stringWithFormat:@"%@ :(%@)Subtotal", [subTotalReduced amount], [self getDefaultCurrency]];

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
    return @"EUR";
}

@end
