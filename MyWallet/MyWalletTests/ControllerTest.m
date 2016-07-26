//
//  ControllerTest.m
//  MyWallet
//
//  Created by Alberto Marín García on 26/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "SimpleViewController.h"
#import <XCTest/XCTest.h>

@interface ControllerTest : XCTestCase

@property(strong, nonatomic) SimpleViewController *simpleVC;
@property(strong, nonatomic) UIButton *button;
@property(strong, nonatomic) UILabel *label;

@end

@implementation ControllerTest

- (void)setUp {
  [super setUp];
  // Creamos el entorno de laboratorio
  self.simpleVC = [[SimpleViewController alloc] initWithNibName:nil bundle:nil];
  self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.button setTitle:@"Hola" forState:UIControlStateNormal];
  self.label = [[UILabel alloc] initWithFrame:CGRectZero];
  self.simpleVC.displayLabel = self.label;
}

- (void)tearDown {
  [super tearDown];
  // Destruimos el entorno de laboratorio
  self.simpleVC = nil;
  self.button = nil;
  self.label = nil;
}

- (void)testThatTextOnLabelIsEqualToTextOnButton {

  // Mandamos el mensaje
  [self.simpleVC displayText:self.button];

  // Comprobamos que la etiqueta y el botón tienen el mismo texto
  XCTAssertEqualObjects(self.button.titleLabel.text, self.label.text,
                        @"Button and label should have the same text");
}

@end
