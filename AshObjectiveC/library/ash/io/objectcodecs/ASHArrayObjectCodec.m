
#import "ASHArrayObjectCodec.h"
#import "ASHCodecManager.h"
#import "ASHTypeAssociations.h"

@implementation ASHArrayObjectCodec
{

}

- (NSDictionary *)encode:(id)object
            codecManager:(ASHCodecManager *)codecManager
{
    NSString * type = [[ASHTypeAssociations instance] associationForType:[object class]];
    NSMutableArray * values = [NSMutableArray array];
    for (id obj in (NSArray *)object)
    {
        [values addObject:[codecManager encodeObject:obj]];
    }

    return @{typeKey : type, valuesKey : values};
}

- (NSObject *)decode:(NSDictionary *)object
        codecManager:(ASHCodecManager *)codecManager
{
    Class type = NSClassFromString(object[typeKey]);
    NSMutableArray * decoded = [[[type alloc] init] mutableCopy];
    NSArray * values = object[valuesKey];

    for (id obj in values)
    {
        [decoded addObject:[codecManager decodeObject:obj]];
    }

    return [type isEqual:[NSMutableArray class]] ? decoded : [NSArray arrayWithArray:decoded];
}

- (void)decodeIntoObject:(NSObject *)target
                  object:(NSDictionary *)object
            codecManager:(ASHCodecManager *)codecManager
{
    NSArray * values = object[valuesKey];
    NSMutableArray * targetArray = (NSMutableArray *) target;
    for (id obj in values)
    {
        [targetArray addObject:[codecManager decodeObject:obj]];
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