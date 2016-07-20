//
//  NSObject+GNUStepsAddons.m
//  Wallet
//
//  Created by Alberto Marín García on 20/7/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

#import "NSObject+GNUStepsAddons.h"
#import <objc/runtime.h>

@implementation NSObject (GNUStepsAddons)

- (id)subclassResponsability:(SEL)aSel
{
    char prefix = class_isMetaClass(object_getClass(self)) ? '+' : '-';

    [NSException raise:NSInvalidArgumentException
                format:@"%@%c%@ should be overriden by its subclass",
                NSStringFromClass([self class]),
                prefix,
                NSStringFromSelector(aSel)];
    return self; // Not reached!!!
}

@end
