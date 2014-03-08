
#import "ASHCodecManager.h"
#import "ASHNativeObjectCodec.h"
#import "ASHReflectionObjectCodec.h"
#import "ASHArrayObjectCodec.h"
#import "ASHClassObjectCodec.h"
#import "ASHTypeAssociations.h"

@interface ASHClass : NSObject

@end;

@implementation ASHClass

@end;

@implementation ASHCodecManager
{
    NSMutableDictionary * _codecs;
    ASHReflectionObjectCodec * _reflectionCodec;
    ASHArrayObjectCodec * _arrayCodec;

}

- (id)init
{
    self = [super init];

    if (self)
    {
        _codecs = [NSMutableDictionary dictionary];
        ASHNativeObjectCodec * nativeCodec = [[ASHNativeObjectCodec alloc] init];

        [self addCustomCodec:nativeCodec type:[NSNumber class]];
        [self addCustomCodec:nativeCodec type:[NSString class]];
        [self addCustomCodec:nativeCodec type:[NSMutableString class]];
        _reflectionCodec = [[ASHReflectionObjectCodec alloc] init];
        _arrayCodec = [[ASHArrayObjectCodec alloc] init];
        [self addCustomCodec:_arrayCodec type:[NSArray class]];
        [self addCustomCodec:_arrayCodec type:[NSMutableArray class]];
        [self addCustomCodec:[[ASHClassObjectCodec alloc] init]
                        type:[ASHClass class]];

    }

    return self;
}



- (id <ASHObjectCodec>) getCodecForObject:(id)object
{
    Class type = [object class];
    ASHTypeAssociations * associations = [ASHTypeAssociations instance];
    NSString * typeString = [associations associationForType:type];
    return  _codecs[typeString];
}

- (id <ASHObjectCodec>)getCodecForType:(Class)type
{
    ASHTypeAssociations * associations = [ASHTypeAssociations instance];
    NSString * typeString = [associations associationForType:type];
    return  _codecs[typeString];
}

- (id <ASHObjectCodec>)getCodecForComponent:(NSObject *)component
{
    id <ASHObjectCodec> codec = [self getCodecForObject:component];
    if(codec == nil)
    {
        return _reflectionCodec;
    }

    return codec;
}

- (id <ASHObjectCodec>)getCodecForComponentType:(Class)type
{
    id <ASHObjectCodec> codec = [self getCodecForType:type];
    if (codec == nil)
    {
        return _reflectionCodec;
    }
    return codec;
}

- (void)addCustomCodec:(id <ASHObjectCodec>)codec
                  type:(Class)type
{
    ASHTypeAssociations * associations = [ASHTypeAssociations instance];

    if([associations associationForType:type])
    {
        _codecs[[associations associationForType:type]] = codec;
    }
    NSString * typeString = NSStringFromClass(type);
    _codecs[typeString] = codec;
}

- (NSDictionary *)encodeComponent:(NSObject *)object
{
    if(object == nil)
    {
        return @{valueKey : [NSNull null]};
    }

    id <ASHObjectCodec> codec = [self getCodecForComponent:object];
    if(codec)
    {
        return [codec encode:object
                codecManager:self];
    }

    return @{valueKey : [NSNull null]};
}

- (NSDictionary *)encodeObject:(NSObject *)object
{


    if(object == nil)
    {
        return @{valueKey:[NSNull null]};
    }

    id <ASHObjectCodec> codec = [self getCodecForComponent:object];
    if(codec)
    {
        return [codec encode:object
                codecManager:self];
    }

    return @{valueKey : [NSNull null]};
}

- (NSObject *)decodeComponent:(NSDictionary *)object
{
    if(!object[typeKey] || (object[valueKey] && object[valueKey] == [NSNull null]))
    {
        return nil;
    }

    id <ASHObjectCodec> codec = [self getCodecForComponentType:NSClassFromString(object[typeKey])];

    if(codec)
    {
        return [codec decode:object
                codecManager:self];
    }

    return nil;
}

- (NSObject *)decodeObject:(NSDictionary *)object
{
    if (!object[typeKey] || (object[valueKey] && object[valueKey] == [NSNull null]))
    {
        return nil;
    }

    id <ASHObjectCodec> codec = [self getCodecForType:NSClassFromString(object[typeKey])];

    if(codec)
    {
        return [codec decode:object
                codecManager:self];
    }

    return nil;
}

- (void)decodeIntoComponent:(NSObject *)target
                     object:(NSDictionary *)encoded
{
    if(!encoded[typeKey] || (encoded[valueKey] && encoded[valueKey] == [NSNull null]))
    {
        return;
    }

    id <ASHObjectCodec> codec = [self getCodecForComponentType:NSClassFromString(encoded[typeKey])];

    if(codec)
    {
        [codec decodeIntoObject:target
                         object:encoded
                   codecManager:self];
    }
}

- (void)decodeIntoProperty:(NSObject *)parent
                  property:(NSString *)property
                    object:(NSDictionary *)encoded
{
    if(!encoded[typeKey] || (encoded[valueKey] && encoded[valueKey] == [NSNull null]))
    {
        return;
    }

    id <ASHObjectCodec> codec = [self getCodecForType:NSClassFromString(encoded[typeKey])];

    if(codec)
    {
        [codec decodeIntoProperty:parent
                         property:property
                           object:encoded
                     codecManager:self];
    }
}

@end