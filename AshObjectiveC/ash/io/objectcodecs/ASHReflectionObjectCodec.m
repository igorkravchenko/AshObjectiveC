
#import "ASHReflectionObjectCodec.h"
#import "ASHObjectReflection.h"
#import "ASHObjectReflectionFactory.h"
#import "ASHCodecManager.h"

static NSString * const typeKey = @"type";
static NSString * const propertiesKey = @"properties";

@implementation ASHReflectionObjectCodec
{

}

- (NSDictionary *)encode:(NSObject *)object
            codecManager:(ASHCodecManager *)codecManager
{
    ASHObjectReflection * reflection = [[ASHObjectReflectionFactory sharedFactory] reflection:object];
    NSMutableDictionary * properties = [NSMutableDictionary dictionary];
    for (NSString * name in reflection.propertyTypes)
    {
        properties[name] = [codecManager encodeObject:[object valueForKey:name]];
    }

    return @{typeKey : reflection.type, propertiesKey : properties};

}

- (NSObject *)decode:(NSDictionary *)object
        codecManager:(ASHCodecManager *)codecManager
{
    Class type = NSClassFromString(object[typeKey]);
    NSObject * decoded = [[type alloc] init];
    NSDictionary * properties = object[propertiesKey];
    for (NSString * name in properties)
    {
        if([decoded respondsToSelector:@selector(name)])
        {
            [decoded setValue:[codecManager decodeObject:object[propertiesKey][name]] forKey:name];
        }
    }
    return decoded;
}

- (void)decodeIntoObject:(NSObject *)target
                  object:(NSDictionary *)object
            codecManager:(ASHCodecManager *)codecManager
{
    NSDictionary * properties = object[propertiesKey];
    for (NSString * name in properties)
    {
        if([target respondsToSelector:@selector(name)])
        {
            if([target valueForKey:name])
            {
                [codecManager decodeIntoProperty:target
                                        property:name
                                          object:properties[name]];
            }
            else
            {
                [target setValue:[codecManager decodeObject:object[properties][name]] forKey:name];
            }
        }
    }
}

- (void)decodeIntoProperty:(NSObject *)parent
                  property:(NSString *)property
                    object:(NSDictionary *)object
              codecManager:(ASHCodecManager *)codecManager
{
    [self decodeIntoObject:[parent valueForKey:property]
                    object:object
              codecManager:codecManager];

}


@end