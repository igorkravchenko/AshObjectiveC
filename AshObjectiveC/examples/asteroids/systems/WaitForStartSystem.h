//
// Created by Igor Kravchenko on 7/22/15.
// Copyright (c) 2015 Igor Kravchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASHSystem.h"

@class EntityCreator;


@interface WaitForStartSystem : ASHSystem

- (instancetype)initWithCreator:(EntityCreator *)aCreator;

@end