#import <objc/message.h>
#import "ASHValueObjectCodec.h"
#import "ASHCodecManager.h"
#import "ASHTypeAssociations.h"
#import <QuartzCore/QuartzCore.h>

static inline NSString * ASH_NSStringFromCGPoint(CGPoint aPoint)
{
#if TARGET_OS_IPHONE
    return NSStringFromCGPoint(aPoint);
#else
    return NSStringFromPoint(NSPointFromCGPoint(aPoint));
#endif
}

static inline CGPoint ASH_CGPointFromString(NSString * stringPoint)
{
#if TARGET_OS_IPHONE
    return CGPointFromString(stringPoint);
#else
    return NSPointFromCGPoint(NSPointFromString(stringPoint));
#endif
}

@implementation ASHValueObjectCodec
{
    NSMutableDictionary *_encodeBlocks;
    NSMutableDictionary *_decodeBlocks;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _encodeBlocks = [NSMutableDictionary dictionary];
        _decodeBlocks = [NSMutableDictionary dictionary];

        NSString * cgPointObjCType = @(@encode(CGPoint));
        NSString * cgRectObjCType = @(@encode(CGRect));
        NSString * cgSizeObjCType = @(@encode(CGSize));
        NSString * cgAffineTransformObjCType = @(@encode(CGAffineTransform));
        NSString * caTransform3DObjCType = @(@encode(CATransform3D));
        NSString * nsRangeObjCType = @(@encode(NSRange));

#ifdef CGVECTOR_DEFINED

        NSString * cgVectorObjCType = @(@encode(CGVector));
        [self addEncodeBlock:^NSString *(NSValue *value)
        {
            CGVector v;
            [value getValue:&v];
            return ASH_NSStringFromCGPoint(CGPointMake(v.dx, v.dy));
        } forObjCType:cgVectorObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
            CGPoint p = ASH_CGPointFromString(encodedValue[valueKey]);
            CGVector v = CGVectorMake(p.x, p.y);
            return [NSValue value:&v
                     withObjCType:@encode(CGVector)];
        } forObjCType:cgVectorObjCType];

#endif

        [self addEncodeBlock:^NSString *(NSValue *value)
        {
#if TARGET_OS_IPHONE
            return NSStringFromCGPoint(value.CGPointValue);
#else
            return NSStringFromPoint(value.pointValue);
#endif
        }
                forObjCType:cgPointObjCType];


        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
#if TARGET_OS_IPHONE
            return [NSValue valueWithCGPoint:CGPointFromString(encodedValue[valueKey])];
#else
            return [NSValue valueWithPoint:NSPointFromString(encodedValue[valueKey])];
#endif
        } forObjCType:cgPointObjCType];

        [self addEncodeBlock:^NSString *(NSValue *value)
        {
#if TARGET_OS_IPHONE
            return NSStringFromCGRect(value.CGRectValue);
#else
            return NSStringFromRect(value.rectValue);
#endif
        } forObjCType:cgRectObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
#if TARGET_OS_IPHONE
            return [NSValue valueWithCGRect:CGRectFromString(encodedValue[valueKey])];
#else
            return [NSValue valueWithRect:NSRectFromString(encodedValue[valueKey])];
#endif
        } forObjCType:cgRectObjCType];

        [self addEncodeBlock:^NSString *(NSValue *value)
        {
#if TARGET_OS_IPHONE
            return NSStringFromCGSize(value.CGSizeValue);
#else
            return NSStringFromSize(value.sizeValue);
#endif

        } forObjCType:cgSizeObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
#if TARGET_OS_IPHONE
            return [NSValue valueWithCGSize:CGSizeFromString(encodedValue[valueKey])];
#else
            return [NSValue valueWithSize:NSSizeFromString(encodedValue[valueKey])];
#endif
        } forObjCType:cgSizeObjCType];

        [self addEncodeBlock:^NSString *(NSValue *value)
        {
#if TARGET_OS_IPHONE
            return NSStringFromCGAffineTransform(value.CGAffineTransformValue);
#else
            CGAffineTransform transform;
            [value getValue:&transform];
            return [NSString stringWithFormat:@"[%g, %g, %g, %g, %g, %g]",
                            transform.a,
                            transform.b,
                            transform.c,
                            transform.d,
                            transform.tx,
                            transform.ty];
#endif
        } forObjCType:cgAffineTransformObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
#if TARGET_OS_IPHONE
            return [NSValue valueWithCGAffineTransform:CGAffineTransformFromString(encodedValue[valueKey])];
#else
            NSString * string = [encodedValue[valueKey] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[ ]"]];
            NSArray * components = [string componentsSeparatedByString:@","];
            CGAffineTransform transform;
            transform.a = [components[0] floatValue];
            transform.b = [components[1] floatValue];
            transform.c = [components[2] floatValue];
            transform.d = [components[3] floatValue];
            transform.tx = [components[4] floatValue];
            transform.ty = [components[5] floatValue];
            return [NSValue valueWithBytes:&transform
                                  objCType:@encode(CGAffineTransform)];
#endif
        } forObjCType:cgAffineTransformObjCType];

        [self addEncodeBlock:^NSString *(NSValue *value)
        {
            CATransform3D transform3D = value.CATransform3DValue;
            NSString *encoded =
                    [NSString stringWithFormat:@"{%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g,%g}",
                                               transform3D.m11,
                                               transform3D.m12,
                                               transform3D.m13,
                                               transform3D.m14,
                                               transform3D.m21,
                                               transform3D.m22,
                                               transform3D.m23,
                                               transform3D.m24,
                                               transform3D.m31,
                                               transform3D.m32,
                                               transform3D.m33,
                                               transform3D.m34,
                                               transform3D.m41,
                                               transform3D.m42,
                                               transform3D.m43,
                                               transform3D.m44];
            return encoded;
        }        forObjCType:caTransform3DObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
            NSString *encoded = encodedValue[valueKey];
            encoded = [encoded stringByReplacingOccurrencesOfString:@"{"
                                                         withString:@""];
            encoded = [encoded stringByReplacingOccurrencesOfString:@"}"
                                                         withString:@""];
            NSArray *values = [encoded componentsSeparatedByString:@","];
            CATransform3D transform3D = CATransform3DIdentity;
            transform3D.m11 = [values[0] floatValue];
            transform3D.m12 = [values[1] floatValue];
            transform3D.m13 = [values[2] floatValue];
            transform3D.m14 = [values[3] floatValue];
            transform3D.m21 = [values[4] floatValue];
            transform3D.m22 = [values[5] floatValue];
            transform3D.m23 = [values[6] floatValue];
            transform3D.m24 = [values[7] floatValue];
            transform3D.m31 = [values[8] floatValue];
            transform3D.m32 = [values[9] floatValue];
            transform3D.m33 = [values[10] floatValue];
            transform3D.m34 = [values[11] floatValue];
            transform3D.m41 = [values[12] floatValue];
            transform3D.m42 = [values[13] floatValue];
            transform3D.m43 = [values[14] floatValue];
            transform3D.m44 = [values[15] floatValue];

            return [NSValue valueWithCATransform3D:transform3D];
        }        forObjCType:caTransform3DObjCType];

        #if TARGET_OS_IPHONE
        NSString * uiOffsetObjCType = @(@encode(UIOffset));
        [self addEncodeBlock:^NSString *(NSValue *value)
        {
            return NSStringFromUIOffset(value.UIOffsetValue);
        } forObjCType:uiOffsetObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
            return [NSValue valueWithUIOffset:UIOffsetFromString(encodedValue[valueKey])];
        } forObjCType:uiOffsetObjCType];
        #endif

        [self addEncodeBlock:^NSString *(NSValue *value)
        {
            return NSStringFromRange(value.rangeValue);
        } forObjCType:nsRangeObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
            return [NSValue valueWithRange:NSRangeFromString(encodedValue[valueKey])];
        } forObjCType:nsRangeObjCType];

        #if TARGET_OS_IPHONE
        NSString * uiEdgeInsetsObjCType = @(@encode(UIEdgeInsets));
        [self addEncodeBlock:^NSString *(NSValue *value)
        {
            return NSStringFromUIEdgeInsets(value.UIEdgeInsetsValue);
        } forObjCType:uiEdgeInsetsObjCType];

        [self addDecodeBlock:^NSValue *(NSDictionary *encodedValue)
        {
            return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsFromString(encodedValue[valueKey])];
        } forObjCType:uiEdgeInsetsObjCType];
        #endif

    }

    return self;
}

- (void)addEncodeBlock:(ASHValueEncodeBlock)encodeBlock
           forObjCType:(NSString *)objCType
{
    _encodeBlocks[objCType] = [encodeBlock copy];
}

- (void)addDecodeBlock:(ASHValueDecodeBlock)decodeBlock
           forObjCType:(NSString *)objCType
{
    _decodeBlocks[objCType] = [decodeBlock copy];
}

- (NSDictionary *)encode:(id)object
            codecManager:(ASHCodecManager *)codecManager
{
    NSValue * value = object;
    NSString * objCType = @(value.objCType);
    ASHTypeAssociations * associations = [ASHTypeAssociations instance];

    ASHValueEncodeBlock encodeBlock = _encodeBlocks[objCType];
    if(encodeBlock)
    {
        NSDictionary * encoded = @{typeKey: [associations associationForType:value.class], objCTypeKey : objCType, valueKey: encodeBlock(value)};
        return encoded;
    }

    return @{typeKey: [associations associationForType:value.class], objCTypeKey : objCType, valueKey: [NSNull null]};
}

- (id)decode:(NSDictionary *)object
codecManager:(ASHCodecManager *)codecManager
{
    NSString * objCType = object[objCTypeKey];

    ASHValueDecodeBlock decodeBlock = _decodeBlocks[objCType];

    if(decodeBlock)
    {
        return decodeBlock(object);
    }

    return nil;
}

- (void)decodeIntoObject:(NSObject *)target
                  object:(NSDictionary *)object
            codecManager:(ASHCodecManager *)codecManager
{
    
}

- (void)decodeIntoProperty:(NSObject *)parent property:(NSString *)property object:(NSDictionary *)object codecManager:(ASHCodecManager *)codecManager
{
    [parent setValue:[self decode:object
                     codecManager:codecManager]
              forKey:property];
}


@end