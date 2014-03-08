#import <objc/message.h>
#import "ASHValueCodec.h"
#import "ASHCodecManager.h"
#import "ASHTypeAssociations.h"

typedef NSString * (^valueToStringBlock)(NSValue * value);

@implementation ASHValueCodec
{
    NSMutableDictionary * _blocks;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _blocks = [NSMutableDictionary dictionary];
        NSString * cgPointObjCType = @"{CGPoint=ff}";
        [self addConversionBlock:^NSString *(NSValue *value)
        {
            return NSStringFromCGPoint([value CGPointValue]);
        } forObjCType:cgPointObjCType];




    }

    return self;
}

- (void)addConversionBlock:(valueToStringBlock)convertionBlock
               forObjCType:(NSString *)objCType
{
    _blocks[objCType] = [convertionBlock copy];
}


- (NSDictionary *)encode:(id)object
            codecManager:(ASHCodecManager *)codecManager
{
    NSValue * value = object;
    NSString * objCType = @(value.objCType);
    ASHTypeAssociations * associations = [ASHTypeAssociations instance];

    valueToStringBlock conversionBlock = _blocks[objCType];
    if(conversionBlock)
    {

        NSDictionary * dictionary = @{typeKey: [associations associationForType:value.class], objCTypeKey : objCType, valueKey:conversionBlock(value)};
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