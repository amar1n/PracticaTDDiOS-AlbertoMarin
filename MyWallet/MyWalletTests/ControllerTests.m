//
//  ControllerTest.m
//  MyWallet
//
//  Created by Alberto Marín García on 26/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "SimpleViewController.h"
#import "Wallet.h"
#import "WalletTableViewController.h"
#import <XCTest/XCTest.h>

@interface ControllerTest : XCTestCase

@property (strong, nonatomic) SimpleViewController* simpleVC;
@property (strong, nonatomic) UIButton* button;
@property (strong, nonatomic) UILabel* label;

@property (strong, nonatomic) Wallet* wallet;
@property (strong, nonatomic) WalletTableViewController* walletVC;

@end

@implementation ControllerTest

- (void)setUp
{
    [super setUp];
    // Creamos el entorno de laboratorio
    self.simpleVC = [[SimpleViewController alloc] initWithNibName:nil bundle:nil];
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setTitle:@"Hola" forState:UIControlStateNormal];
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.simpleVC.displayLabel = self.label;

    self.wallet = [[Wallet alloc] initWithAmount:[NSNumber numberWithDouble:1.0] currency:@"USD"];
    [self.wallet addMoney:[Money euroWithAmount:[NSNumber numberWithDouble:1.0]]];
    self.walletVC = [[WalletTableViewController alloc] initWithModel:self.wallet broker:nil];
}

- (void)tearDown
{
    [super tearDown];
    // Destruimos el entorno de laboratorio
    self.simpleVC = nil;
    self.button = nil;
    self.label = nil;

    self.wallet = nil;
    self.walletVC = nil;
}

- (void)testThatTextOnLabelIsEqualToTextOnButton
{

    // Mandamos el mensaje
    [self.simpleVC displayText:self.button];

    // Comprobamos que la etiqueta y el botón tienen el mismo texto
    XCTAssertEqualObjects(self.button.titleLabel.text, self.label.text,
        @"Button and label should have the same text");
}

- (void)testThatNumberOfSectionsIsNumberOfCurrenciesPlusOne
{
    NSInteger sections = [self.walletVC numberOfSectionsInTableView:nil];
    XCTAssertEqual(sections, 3, @"There can only be one!");
}

- (void)testThatNumberOfCellsIsNumberOfMoneysPlusOne
{
    NSArray* currencies = [self.wallet currencies];
    NSInteger section = 0;

    for (NSString* currency in currencies) {
        XCTAssertEqual([[self.wallet moneysByCurrency:currency] count] + 1, [self.walletVC tableView:nil numberOfRowsInSection:section],
            @"Number of cells is the number of moneys plus one (the total)");
        section = section + 1;
    }
}

@end
