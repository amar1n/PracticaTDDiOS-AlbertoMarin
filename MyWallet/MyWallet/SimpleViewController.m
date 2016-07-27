//
//  SimpleViewController.m
//  MyWallet
//
//  Created by Alberto Marín García on 26/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "SimpleViewController.h"

@interface SimpleViewController ()

@end

@implementation SimpleViewController

- (IBAction)displayText:(id)sender
{
    UIButton* btn = sender;
    self.displayLabel.text = btn.titleLabel.text;
}
@end
