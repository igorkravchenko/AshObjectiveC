
#import "ASHClassObjectCodec.h"
#import "ASHCodecManager.h"
#import "ASHValueObjectCodec.h"

@interface ValueObjectCodecTests : GHTestCase

@end

@implementation ValueObjectCodecTests
{
    ASHValueObjectCodec * _codec;
    ASHCodecManager * _codecManager;
}

- (void)setUp
{
    [self createCodec];
}

- (void)tearDown
{
    [self deleteCodec];
}

- (void)createCodec
{
    _codecManager = [[ASHCodecManager alloc] init];
    _codec = [[ASHValueObjectCodec alloc] init];
}

- (void)deleteCodec
{
    _codec = nil;
}

- (void)testEncodesValueWithCorrectType
{
    CGPoint point = CGPointMake(1, 1);
    NSValue * value = [NSValue valueWithCGPoint:point];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[typeKey], equalTo(NSStringFromClass([NSValue class])));

}

- (void)testEncodesAndDecodesValueWithCGPoint
{
    CGPoint point = CGPointMake(100, 200);
    NSValue * value = [NSValue valueWithCGPoint:point];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromCGPoint(point)));
}

- (void)testDecodesValueWithCGPoint
{
    CGPoint point = CGPointMake(100, 200);
    NSValue * value = [NSValue valueWithCGPoint:point];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                   codecManager:_codecManager];
    assertThatBool(CGPointEqualToPoint(point, decoded.CGPointValue), isTrue());
}

- (void)testEncodesAndDecodesValueWithCGRect
{
    CGRect rect = CGRectMake(100, 200, 300, 400);
    NSValue * value = [NSValue valueWithCGRect:rect];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromCGRect(rect)));
}

- (void)testDecodesValueWithCGRect
{
    CGRect rect = CGRectMake(100, 200, 300, 400);
    NSValue * value = [NSValue valueWithCGRect:rect];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                          codecManager:_codecManager];
    assertThatBool(CGRectEqualToRect(rect, decoded.CGRectValue), isTrue());
}

- (void)testEncodesAndDecodesValueWithCGSize
{
    CGSize size = CGSizeMake(100, 200);
    NSValue * value = [NSValue valueWithCGSize:size];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromCGSize(size)));
}

- (void)testDecodesValueWithCGSize
{
    CGSize point = CGSizeMake(100, 200);
    NSValue * value = [NSValue valueWithCGSize:point];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                          codecManager:_codecManager];
    assertThatBool(CGSizeEqualToSize(point, decoded.CGSizeValue), isTrue());
}

- (void)testEncodesAndDecodesValueWithCGAffineTransform
{
    CGAffineTransform transform = CGAffineTransformMake(1, 2, 3, 4, 5, 6);
    NSValue * value = [NSValue valueWithCGAffineTransform:transform];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromCGAffineTransform(transform)));
}

- (void)testDecodesValueWithCGAffineTransform
{
    CGAffineTransform transform = CGAffineTransformMake(1, 2, 3, 4, 5, 6);
    NSValue * value = [NSValue valueWithCGAffineTransform:transform];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                          codecManager:_codecManager];
    assertThatBool(CGAffineTransformEqualToTransform(transform, decoded.CGAffineTransformValue), isTrue());
}

- (void)testEncodesAndDecodesValueWithCATransform3D
{
    CGAffineTransform transform = CGAffineTransformMake(1.1, 2.02, 3.003, 4.0004, 5.00005, 6.000006);
    CATransform3D transform3D = CATransform3DMakeAffineTransform(transform);
    NSValue * value = [NSValue valueWithCATransform3D:transform3D];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];

    NSString * expectedResult =
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

    assertThat(encoded[valueKey], equalTo(expectedResult));
}

- (void)testDecodesValueWithCATransform3D
{
    CGAffineTransform transform = CGAffineTransformMake(1, 2, 3, 4, 5, 6);
    CATransform3D transform3D = CATransform3DMakeAffineTransform(transform);
    NSValue * value = [NSValue valueWithCATransform3D:transform3D];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                          codecManager:_codecManager];

    assertThatBool(CATransform3DEqualToTransform(transform3D, decoded.CATransform3DValue), isTrue());

}

- (void)testEncodesAndDecodesValueWithUIOffset
{
    UIOffset offset = UIOffsetMake(100, 200);
    NSValue * value = [NSValue valueWithUIOffset:offset];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromUIOffset(offset)));
}

- (void)testDecodesValueWithUIOffset
{
    UIOffset offset = UIOffsetMake(100, 200);
    NSValue * value = [NSValue valueWithUIOffset:offset];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                          codecManager:_codecManager];

    assertThatBool(UIOffsetEqualToOffset(offset, decoded.UIOffsetValue), isTrue());
}

- (void)testEncodesAndDecodesValueWithNSRange
{
    NSRange range = NSMakeRange(100, 200);
    NSValue * value = [NSValue valueWithRange:range];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromRange(range)));
}

- (void)testDecodesValueWithNSRange
{
    NSRange range = NSMakeRange(100, 200);
    NSValue * value = [NSValue valueWithRange:range];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                          codecManager:_codecManager];

    assertThatBool(NSEqualRanges(range, decoded.rangeValue), isTrue());
}

- (void)testEncodesAndDecodesValueWithUIEdgeInsets
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(100, 200, 300, 400);
    NSValue * value = [NSValue valueWithUIEdgeInsets:edgeInsets];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromUIEdgeInsets(edgeInsets)));
}

- (void)testDecodesValueWithUIEdgeInsets
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(100, 200, 300, 400);
    NSValue * value = [NSValue valueWithUIEdgeInsets:edgeInsets];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                          codecManager:_codecManager];
    assertThatBool(UIEdgeInsetsEqualToEdgeInsets(edgeInsets, decoded.UIEdgeInsetsValue), isTrue());
}

#ifdef CGVECTOR_DEFINED

- (void)testEncodesValueWithCGVector
{

    CGVector vector = CGVectorMake(100.14, 200.14);
    NSValue * value = [NSValue valueWithBytes:&vector
                                     objCType:@encode(CGVector)];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    assertThat(encoded[valueKey], equalTo(NSStringFromCGPoint(CGPointMake(vector.dx, vector.dy))));

}

- (void)testDecodesValueWithCGVector
{
    CGVector vector = CGVectorMake(10.01f, 20.999f);
    NSValue * value = [NSValue value:&vector
                        withObjCType:@encode(CGVector)];
    NSDictionary * encoded = [_codec encode:value
                               codecManager:_codecManager];
    NSValue * decoded = [_codec decode:encoded
                          codecManager:_codecManager];
    CGVector decodedVector;
    [decoded getValue:&decodedVector];
    assertThatBool(decodedVector.dx == vector.dx && decodedVector.dy == vector.dy, isTrue());
}

#endif



@end