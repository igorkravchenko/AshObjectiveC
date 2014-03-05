
#import "ASHClassObjectCodec.h"

static NSString * const typeKey = @"type";
static NSString * const valueKey = @"value";

@implementation ASHClassObjectCodec
{

}

- (NSDictionary *)encode:(NSObject *)object
            codecManager:(ASHCodecManager *)codecManager
{
    return @{typeKey:@"Class", valueKey:NSStringFromClass(object.class)};
}

- (NSObject *)decode:(NSDictionary *)object
        codecManager:(ASHCodecManager *)codecManager
{
    return (id)NSClassFromString(object[valueKey]);
}

- (void)decodeIntoObject:(NSObject *)target
                  object:(NSDictionary *)object
            codecManager:(ASHCodecManager *)codecManager
{
    target = (id)NSClassFromString(object[valueKey]);   //
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