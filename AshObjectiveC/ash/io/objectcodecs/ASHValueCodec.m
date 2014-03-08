
#import "ASHValueCodec.h"
#import "ASHCodecManager.h"
#import "ASHTypeAssociations.h"

@implementation ASHValueCodec
{

}

- (NSDictionary *)encode:(id)object
            codecManager:(ASHCodecManager *)codecManager
{
    NSValue * value = object;
    NSString * structTypeString = @(value.objCType);
    NSString * cgPointStructType = @"{CGPoint=ff}";
    ASHTypeAssociations * associations = [ASHTypeAssociations instance];
    if([structTypeString isEqual:cgPointStructType])
    {

        NSDictionary * dictionary = @{typeKey: [associations associationForType:value.class], structKey:structTypeString, structValueKey:NSStringFromCGPoint([value CGPointValue])};
        NSLog(@"%@", dictionary);
    }



    return nil;
}

- (NSObject *)decode:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{
    return nil;
}

- (void)decodeIntoObject:(NSObject *)target object:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{

}

- (void)decodeIntoProperty:(NSObject *)parent property:(NSString *)property object:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{

}


@end