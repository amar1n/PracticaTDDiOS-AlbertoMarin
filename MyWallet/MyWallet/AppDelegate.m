//
//  AppDelegate.m
//  MyWallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "AppDelegate.h"
#import "Broker.h"
#import "Wallet.h"
#import "WalletTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application
    didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Creamos el modelo
    Wallet* wallet = [[Wallet alloc] initWithAmount:[NSNumber numberWithDouble:1.0] currency:@"USD"];
    [wallet addMoney:[Money euroWithAmount:[NSNumber numberWithDouble:10.0]]];
    [wallet addMoney:[Money euroWithAmount:[NSNumber numberWithDouble:5.0]]];
    [wallet addMoney:[Money euroWithAmount:[NSNumber numberWithDouble:1.0]]];

    Broker* broker = [Broker new];
    [broker addRate:2 fromCurrency:@"EUR" toCurrency:@"USD"];

    WalletTableViewController* walletVC = [[WalletTableViewController alloc] initWithModel:wallet broker:broker];
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:walletVC];
    self.window.rootViewController = navVC;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end
