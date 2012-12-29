
#import "MockHelpers.h"
#import "ASHSystem.h"


@implementation PointComponent
@end


@implementation MatrixComponent
@end


@implementation MockNode
@end


@implementation MockNode2
@end


@implementation MockFamily

static NSMutableArray * _instances = nil;

+ (NSArray *)instances
{
    if (_instances == nil)
    {
        _instances = [NSMutableArray array];
    }
    
    return _instances;
}

+ (void)reset
{
    if (_instances != nil)
    {
        [_instances removeAllObjects];
    }
}

- (id)initWithNodeClass:(Class)nodeClass
                 engine:(ASHEngine *)engine
{
    self = [super init];
    
    if (self != nil)
    {
        if (_instances == nil)
        {
            _instances = [NSMutableArray array];
        }
        _newEntityCalls = 0;
        _removeEntityCalls = 0;
        _componentAddedCalls = 0;
        _componentRemovedCalls = 0;
        _cleanUpCalls = 0;
        
        [_instances addObject:self];
    }
    
    return self;
}

- (ASHNodeList *)nodeList
{
    return nil;
}

- (void)newEntity:(ASHEntity *)entity
{
    _newEntityCalls++;
}

- (void)removeEntity:(ASHEntity *)entity
{
    _removeEntityCalls++;
}

- (void)componentAddedToEntity:(ASHEntity *)entity
                componentClass:(Class)componentClass
{
    _componentAddedCalls++;
}

- (void)componentRemovedFromEntity:(ASHEntity *)entity
                    componentClass:(Class)componentClass
{
    _componentRemovedCalls++;
}

- (void)cleanUp
{
    _cleanUpCalls++;
}

@end


@implementation MockComponent
@end


@implementation MockComponent2
@end


@implementation MockComponentExtended
@end

@implementation MockNodePoinMatrix
@end
