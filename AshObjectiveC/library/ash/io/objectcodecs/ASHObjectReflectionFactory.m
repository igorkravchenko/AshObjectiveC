
#import "ASHObjectReflectionFactory.h"
#import "ASHObjectReflection.h"

@implementation ASHObjectReflectionFactory
{
    NSMutableDictionary * _reflections;
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
        _reflections = [NSMutableDictionary dictionary];
    }

    return self;
}

- (ASHObjectReflection *)reflection:(NSObject *)component
{
    NSString * type = NSStringFromClass(component.class);

    if(_reflections[type] == nil)
    {
        _reflections[type] = [[ASHObjectReflection alloc] initWithComponent:component];
    }

    return _reflections[type];
}

@end