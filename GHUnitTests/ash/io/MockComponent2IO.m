//
// Created by igman on 3/5/14.
// Copyright (c) 2014 Igor Kravchenko. All rights reserved.
//

#import "MockComponent2IO.h"


@implementation MockComponent2IO
{

}

- (instancetype)initWithX:(NSInteger)x
                        y:(NSInteger)y
{
    self = [super init];
    if (self)
    {
        _x = x;
        _y = y;
    }

    return self;
}

@end