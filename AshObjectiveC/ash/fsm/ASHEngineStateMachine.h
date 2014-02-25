//
// Created by Igor Kravchenko on 2/21/14.
// Copyright (c) 2014 Igor Kravchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASHEngine;
@class ASHEngineState;


@interface ASHEngineStateMachine : NSObject

@property (nonatomic, strong) ASHEngine * engine;

- (instancetype)initWithEngine:(ASHEngine *)engine;
- (ASHEngineStateMachine *)addState:(NSString *)name
                              state:(ASHEngineState *)state;
- (ASHEngineState *)createState:(NSString *)name;
- (void)changeState:(NSString *)name;

@end