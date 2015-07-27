//
// Created by Igor Kravchenko on 7/20/15.
// Copyright (c) 2015 Igor Kravchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const ExplodeAsteroid = @"asteroid.wav";
static NSString * const ExplodeShip = @"ship.wav";
static NSString * const ShootGun = @"shoot.wav";

@interface Audio : NSObject

@property (nonatomic, strong) NSMutableArray * toPlay;

- (void)play:(NSString *)sound;

@end