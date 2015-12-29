
#import "ASHObjectReflectionFactory.h"
#import "ASHObjectReflection.h"

@implementation ASHObjectReflectionFactory
{
    NSMapTable * _reflections;
}

+ (instancetype)sharedFactory
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _reflections = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaquePersonality valueOptions:NSPointerFunctionsStrongMemory];
    }

    return self;
}

- (ASHObjectReflection *)reflection:(NSObject *)component
{
    Class type = component.class;

    ASHObjectReflection * reflection = [_reflections objectForKey:type];

    if(reflection == nil)
    {
        reflection = [[ASHObjectReflection alloc] initWithComponent:component];
        [_reflections setObject:reflection forKey:type];
    }

    return reflection;
}

@end