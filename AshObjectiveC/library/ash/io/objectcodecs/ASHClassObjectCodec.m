
#import "ASHClassObjectCodec.h"
#import "ASHCodecManager.h"
#import "ASHTypeAssociations.h"

@implementation ASHClassObjectCodec
{

}

- (NSDictionary *)encode:(id)object
            codecManager:(ASHCodecManager *)codecManager
{
    return @{typeKey:classKey, valueKey: [[ASHTypeAssociations instance] associationForType:[object class]]};
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