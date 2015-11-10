
#import "ASHTypeAssociations.h"

@implementation ASHTypeAssociations
{

    NSMutableDictionary *_typeAssociations;
}
+ (ASHTypeAssociations *)instance
{
    static ASHTypeAssociations *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _typeAssociations = [NSMutableDictionary dictionary];

        NSString * immutableArray = @"__NSArrayI";
        NSString * immutableArray0 = @"__NSArray0";
        NSString * mutableArray = @"__NSArrayM";
        NSString * number = @"__NSCFNumber";
        NSString * immutableString = @"__NSCFConstantString";
        NSString * mutableString = @"__NSCFString";
        NSString * value = @"NSConcreteValue";
        NSString * boolean = @"__NSCFBoolean";


        [self addTypeAssociation:[NSArray class] association:immutableArray];
        [self addTypeAssociation:NSClassFromString(immutableArray) association:NSStringFromClass([NSArray class])];
        [self addTypeAssociation:NSClassFromString(immutableArray0) association:NSStringFromClass([NSArray class])];

        [self addTypeAssociation:[NSMutableArray class] association:mutableArray];
        [self addTypeAssociation:NSClassFromString(mutableArray) association:NSStringFromClass([NSMutableArray class])];

        [self addTypeAssociation:[NSNumber class] association:number];
        [self addTypeAssociation:NSClassFromString(number) association:NSStringFromClass([NSNumber class])];
        [self addTypeAssociation:NSClassFromString(boolean) association:NSStringFromClass([NSNumber class])];

        [self addTypeAssociation:[NSString class] association:immutableString];
        [self addTypeAssociation:NSClassFromString(immutableString) association:NSStringFromClass([NSString class])];

        [self addTypeAssociation:[NSMutableString class] association:mutableString];
        [self addTypeAssociation:NSClassFromString(mutableString) association:NSStringFromClass([NSMutableString class])];

        [self addTypeAssociation:[NSValue class] association:value];
        [self addTypeAssociation:NSClassFromString(value) association:NSStringFromClass([NSValue class])];
    }

    return self;
}

- (void)addTypeAssociation:(Class)type association:(NSString *)association
{
    _typeAssociations[NSStringFromClass([type class])] = association;
}

- (NSString *)associationForType:(Class)type
{
    NSString * typeString = NSStringFromClass(type);
    return _typeAssociations[typeString] == nil ? typeString : _typeAssociations[typeString];
}

@end