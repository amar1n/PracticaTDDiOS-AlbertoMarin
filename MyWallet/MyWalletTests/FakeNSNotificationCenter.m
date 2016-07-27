//
//  FakeNSNotificationCenter.m
//  MyWallet
//
//  Created by Alberto Marín García on 27/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "FakeNSNotificationCenter.h"

@implementation FakeNSNotificationCenter

- (id)init
{
    if (self = [super init]) {
        _observers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addObserver:(id)notificationObserver
           selector:(SEL)notificationSelector
               name:(NSString*)notificationName
             object:(id)notificationSender
{
    [self.observers setObject:notificationObserver forKey:notificationName];
}

@end
