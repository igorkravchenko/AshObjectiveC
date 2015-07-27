//
// Created by Igor Kravchenko on 7/20/15.
// Copyright (c) 2015 Igor Kravchenko. All rights reserved.
//

#import "Audio.h"


@implementation Audio

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _toPlay = [NSMutableArray array];
    }

    return self;
}


- (void)play:(NSString *)sound
{
    [_toPlay addObject:sound];
}

@end