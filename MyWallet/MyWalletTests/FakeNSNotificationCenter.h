//
//  FakeNSNotificationCenter.h
//  MyWallet
//
//  Created by Alberto Marín García on 27/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FakeNSNotificationCenter : NSObject

@property (strong, nonatomic) NSMutableDictionary* observers;

- (void)addObserver:(id)notificationObserver
           selector:(SEL)notificationSelector
               name:(NSString*)notificationName
             object:(id)notificationSender;

@end
