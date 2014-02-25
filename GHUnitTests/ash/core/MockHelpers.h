
#import <Foundation/Foundation.h>
#import "ASHNode.h"
#import "ASHNodeList.h"
#import "ASHEngine.h"
#import "ASHFamily.h"
#import "ASHSystem.h"

#define kCallbackTimout (.01)

@interface PointComponent : NSObject
@end


@interface MatrixComponent : NSObject
@end


@interface MockNode : ASHNode

@property (nonatomic, strong) PointComponent * point;

@end


@interface MockNode2 : ASHNode

@property (nonatomic, strong) MatrixComponent * matrix;

@end


@interface MockNodePointMatrix : ASHNode

@property (nonatomic, strong) PointComponent * point;
@property (nonatomic, strong) MatrixComponent * matrix;

@end


@interface MockFamily : NSObject <ASHFamily>

@property (nonatomic, assign) NSInteger newEntityCalls;
@property (nonatomic, assign) NSInteger removeEntityCalls;
@property (nonatomic, assign) NSInteger componentAddedCalls;
@property (nonatomic, assign) NSInteger componentRemovedCalls;
@property (nonatomic, assign) NSInteger cleanUpCalls;

+ (NSArray *)instances;
+ (void)reset;
- (id)initWithNodeClass:(Class)nodeClass
                 engine:(ASHEngine *)engine;

@end


@interface MockComponent : NSObject

@property (nonatomic, assign) NSInteger value;

@end


@interface MockComponent2 : NSObject

@property (nonatomic, strong) NSString * value;

@end


@interface MockComponentExtended : MockComponent

@property (nonatomic, assign) NSInteger other;

@end

@interface MockNodeSort : ASHNode

@property (nonatomic, assign) NSInteger pos;

@end

@interface MockSystem : ASHSystem

@property (nonatomic, assign) BOOL wasRemoved;

@end

@interface MockSystem2 : ASHSystem

@property (nonatomic, strong) NSString * value;

@end